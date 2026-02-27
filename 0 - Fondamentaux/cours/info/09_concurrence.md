# Chapitre 9 — Programmation concurrente

## Objectifs du chapitre

- Comprendre les processus (fork, exec, wait) et la communication inter-processus
- Maitriser les threads et leurs avantages par rapport aux processus
- Identifier les problemes de concurrence (race conditions, sections critiques)
- Connaitre les mecanismes de synchronisation (mutex, semaphores, moniteurs)
- Comprendre l'exclusion mutuelle (algorithme de Peterson, solutions materielles)
- Analyser les situations d'interblocage (conditions de Coffman, graphe d'attente)
- Resoudre les problemes classiques (producteur-consommateur, lecteurs-redacteurs, philosophes dineurs)
- Programmer avec pthread (C) et threading (Python)

---

## 1. Processus

### 1.1 Definition

Un **processus** est une instance d'un programme en cours d'execution. Chaque processus possede :

- Son propre espace d'adressage (code, donnees, pile, tas)
- Un identifiant unique (PID)
- Un etat (pret, en execution, bloque, zombie, etc.)
- Des descripteurs de fichiers, des signaux, des variables d'environnement

**Etats d'un processus** :

```text
                  +--------+
           fork   |        |  scheduler
     +----------->| PRET   |----------+
     |            |        |          |
     |            +--------+          v
+--------+                      +----------+
| CREE   |                      | EXECUTION|
+--------+                      +----------+
                                      |
                       I/O, wait      |  exit
                    +---------+       v
                    | BLOQUE  |   +--------+
                    +---------+   | ZOMBIE |
                    |         |   +--------+
                    +---------+
                    I/O terminee -> PRET
```

### 1.2 fork() — Creation de processus

L'appel systeme `fork()` cree un **clone** du processus appelant. Le processus fils est une copie quasi-identique du pere.

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(void) {
    printf("Processus parent, PID = %d\n", getpid());

    pid_t pid = fork();

    if (pid < 0) {
        perror("fork");
        exit(1);
    } else if (pid == 0) {
        // Code execute par le FILS
        printf("  Fils : PID = %d, pere = %d\n", getpid(), getppid());
        printf("  Fils : je fais mon travail...\n");
        sleep(1);
        printf("  Fils : termine\n");
        exit(42);  // code de retour
    } else {
        // Code execute par le PERE
        printf("Pere : fils cree avec PID = %d\n", pid);
        int status;
        waitpid(pid, &status, 0);  // attendre la fin du fils
        if (WIFEXITED(status)) {
            printf("Pere : fils termine avec code %d\n", WEXITSTATUS(status));
        }
    }

    return 0;
}
```

**Sortie** :

```text
Processus parent, PID = 12345
Pere : fils cree avec PID = 12346
  Fils : PID = 12346, pere = 12345
  Fils : je fais mon travail...
  Fils : termine
Pere : fils termine avec code 42
```

**Points cles** :

- `fork()` retourne 0 dans le fils, le PID du fils dans le pere
- Le fils herite d'une **copie** de la memoire du pere (copy-on-write en pratique)
- Sans `wait()`, le fils devient un processus **zombie** a sa terminaison
- Un processus orphelin (pere mort avant le fils) est adopte par init (PID 1)

### 1.3 exec() — Remplacement de programme

La famille `exec` remplace le programme en cours par un autre. Combinee avec `fork`, elle permet de lancer un programme different dans un nouveau processus.

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main(void) {
    pid_t pid = fork();

    if (pid == 0) {
        // Le fils execute la commande "ls -la /tmp"
        execlp("ls", "ls", "-la", "/tmp", NULL);
        // Si execlp retourne, c'est une erreur
        perror("execlp");
        exit(1);
    } else {
        wait(NULL);
        printf("Commande terminee.\n");
    }

    return 0;
}
```

**Variantes de exec** :

| Fonction | Arguments | Recherche PATH |
| -------- | --------- | -------------- |
| `execl` | Liste de chaines | Non |
| `execlp` | Liste de chaines | Oui |
| `execv` | Tableau de chaines | Non |
| `execvp` | Tableau de chaines | Oui |
| `execve` | Tableau + environnement | Non |

**Pattern fork + exec** : c'est le mecanisme fondamental de creation de processus sous Unix. Le shell l'utilise pour chaque commande executee.

### 1.4 Communication inter-processus (IPC)

#### Pipes (tuyaux)

Un pipe est un canal de communication unidirectionnel entre un processus pere et son fils.

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>

int main(void) {
    int pipefd[2];  // pipefd[0] = lecture, pipefd[1] = ecriture

    if (pipe(pipefd) == -1) {
        perror("pipe");
        exit(1);
    }

    pid_t pid = fork();

    if (pid == 0) {
        // Fils : ecrit dans le pipe
        close(pipefd[0]);  // fermer le cote lecture
        const char *msg = "Message du fils au pere";
        write(pipefd[1], msg, strlen(msg) + 1);
        close(pipefd[1]);
        exit(0);
    } else {
        // Pere : lit depuis le pipe
        close(pipefd[1]);  // fermer le cote ecriture
        char buffer[256];
        ssize_t n = read(pipefd[0], buffer, sizeof(buffer));
        if (n > 0) {
            printf("Pere a recu : \"%s\" (%zd octets)\n", buffer, n);
        }
        close(pipefd[0]);
        wait(NULL);
    }

    return 0;
}
// Sortie : Pere a recu : "Message du fils au pere" (24 octets)
```

#### Pipe bidirectionnel : deux pipes

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>

int main(void) {
    int pipe_pere_fils[2];  // pere -> fils
    int pipe_fils_pere[2];  // fils -> pere

    pipe(pipe_pere_fils);
    pipe(pipe_fils_pere);

    pid_t pid = fork();

    if (pid == 0) {
        // Fils
        close(pipe_pere_fils[1]);
        close(pipe_fils_pere[0]);

        // Lire le message du pere
        char buf[256];
        read(pipe_pere_fils[0], buf, sizeof(buf));
        printf("Fils a recu : %s\n", buf);

        // Repondre
        const char *reponse = "Bien recu, merci !";
        write(pipe_fils_pere[1], reponse, strlen(reponse) + 1);

        close(pipe_pere_fils[0]);
        close(pipe_fils_pere[1]);
        exit(0);
    } else {
        // Pere
        close(pipe_pere_fils[0]);
        close(pipe_fils_pere[1]);

        // Envoyer un message au fils
        const char *msg = "Bonjour fils";
        write(pipe_pere_fils[1], msg, strlen(msg) + 1);

        // Lire la reponse
        char buf[256];
        read(pipe_fils_pere[0], buf, sizeof(buf));
        printf("Pere a recu : %s\n", buf);

        close(pipe_pere_fils[1]);
        close(pipe_fils_pere[0]);
        wait(NULL);
    }

    return 0;
}
```

#### Signaux

Les signaux sont des notifications asynchrones envoyees a un processus.

```c
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

volatile sig_atomic_t signal_recu = 0;

void handler_sigusr1(int sig) {
    (void)sig;
    signal_recu = 1;
}

int main(void) {
    // Installer le handler pour SIGUSR1
    struct sigaction sa;
    sa.sa_handler = handler_sigusr1;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;
    sigaction(SIGUSR1, &sa, NULL);

    printf("PID = %d. En attente de SIGUSR1...\n", getpid());
    printf("Envoyez : kill -USR1 %d\n", getpid());

    while (!signal_recu) {
        pause();  // attend un signal
    }

    printf("Signal SIGUSR1 recu ! Fin du programme.\n");
    return 0;
}
```

**Signaux courants** :

| Signal | Numero | Action par defaut | Description |
| ------ | ------ | ----------------- | ----------- |
| SIGINT | 2 | Terminer | Ctrl+C |
| SIGKILL | 9 | Terminer (non interceptable) | Kill force |
| SIGSEGV | 11 | Core dump | Erreur de segmentation |
| SIGTERM | 15 | Terminer | Demande de terminaison |
| SIGCHLD | 17 | Ignorer | Fils termine |
| SIGUSR1 | 10 | Terminer | Signal utilisateur |
| SIGSTOP | 19 | Stopper (non interceptable) | Suspendre le processus |
| SIGCONT | 18 | Continuer | Reprendre un processus stoppe |

#### Memoire partagee

La memoire partagee (shared memory) permet a plusieurs processus d'acceder a la meme zone memoire.

```c
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/wait.h>
#include <unistd.h>

int main(void) {
    // Allouer une zone de memoire partagee entre pere et fils
    int *compteur = mmap(NULL, sizeof(int),
                         PROT_READ | PROT_WRITE,
                         MAP_SHARED | MAP_ANONYMOUS,
                         -1, 0);
    if (compteur == MAP_FAILED) {
        perror("mmap");
        exit(1);
    }

    *compteur = 0;

    pid_t pid = fork();

    if (pid == 0) {
        // Fils : incremente le compteur 100000 fois
        for (int i = 0; i < 100000; i++)
            (*compteur)++;
        exit(0);
    } else {
        // Pere : incremente aussi 100000 fois
        for (int i = 0; i < 100000; i++)
            (*compteur)++;
        wait(NULL);
        printf("Compteur = %d (attendu : 200000)\n", *compteur);
        // ATTENTION : le resultat sera souvent < 200000 (race condition !)
        munmap(compteur, sizeof(int));
    }

    return 0;
}
```

Ce programme illustre une **race condition** : sans synchronisation, les incrementations concurrentes perdent des mises a jour.

---

## 2. Threads

### 2.1 Threads vs processus

Un **thread** (fil d'execution) est une unite d'execution au sein d'un processus. Les threads d'un meme processus partagent :

- L'espace d'adressage (code, donnees, tas)
- Les descripteurs de fichiers
- Les variables globales

Chaque thread possede :

- Sa propre pile (stack)
- Son propre compteur ordinal (PC)
- Ses propres registres

| Critere | Processus | Thread |
| ------- | --------- | ------ |
| Espace memoire | Separe (isolation) | Partage |
| Creation | Lourd (fork = copie) | Leger (~10x plus rapide) |
| Communication | IPC (pipes, sockets, shm) | Variables partagees |
| Securite | Isolation forte | Pas d'isolation (un bug affecte tout) |
| Changement de contexte | Couteux | Moins couteux |

### 2.2 Threads POSIX (pthread) en C

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

typedef struct {
    int id;
    long debut;
    long fin;
} ThreadArg;

void *fonction_thread(void *arg) {
    ThreadArg *ta = (ThreadArg *)arg;
    printf("Thread %d : calcule la somme de %ld a %ld\n", ta->id, ta->debut, ta->fin);

    long somme = 0;
    for (long i = ta->debut; i <= ta->fin; i++)
        somme += i;

    printf("Thread %d : somme = %ld\n", ta->id, somme);

    long *resultat = malloc(sizeof(long));
    *resultat = somme;
    return resultat;  // retourner le resultat via pthread_join
}

int main(void) {
    const int NB_THREADS = 4;
    const long N = 10000000L;
    pthread_t threads[NB_THREADS];
    ThreadArg args[NB_THREADS];

    // Diviser le travail entre les threads
    long taille_bloc = N / NB_THREADS;
    for (int i = 0; i < NB_THREADS; i++) {
        args[i].id = i;
        args[i].debut = i * taille_bloc + 1;
        args[i].fin = (i == NB_THREADS - 1) ? N : (i + 1) * taille_bloc;

        if (pthread_create(&threads[i], NULL, fonction_thread, &args[i]) != 0) {
            perror("pthread_create");
            exit(1);
        }
    }

    // Recuperer les resultats
    long somme_totale = 0;
    for (int i = 0; i < NB_THREADS; i++) {
        void *retval;
        pthread_join(threads[i], &retval);
        long *partiel = (long *)retval;
        somme_totale += *partiel;
        free(partiel);
    }

    printf("Somme totale (threads) : %ld\n", somme_totale);
    printf("Verification           : %ld\n", N * (N + 1) / 2);
    return 0;
}
```

```bash
# Compilation : ajouter -pthread
gcc -Wall -pthread -o threads threads.c
./threads
```

### 2.3 Threads en Python (module threading)

```python
import threading
import time

def tache(id_thread, duree):
    print(f"Thread {id_thread} : demarre")
    time.sleep(duree)
    print(f"Thread {id_thread} : termine apres {duree}s")

# Creation et lancement de threads
threads = []
for i in range(4):
    t = threading.Thread(target=tache, args=(i, i + 1))
    threads.append(t)
    t.start()

# Attente de la fin de tous les threads
for t in threads:
    t.join()

print("Tous les threads sont termines.")
```

**Note importante** : En CPython, le **GIL** (Global Interpreter Lock) empeche l'execution reellement parallele de code Python pur. Les threads Python sont utiles pour les operations d'I/O (reseau, fichiers), mais pas pour le calcul CPU-intensif. Pour le parallelisme CPU en Python, utiliser le module `multiprocessing`.

```python
# multiprocessing : vrai parallelisme CPU
from multiprocessing import Process, Value
import os

def calculer(id_proc, compteur_partage):
    print(f"Processus {id_proc} (PID={os.getpid()}) : demarre")
    for _ in range(1_000_000):
        with compteur_partage.get_lock():
            compteur_partage.value += 1
    print(f"Processus {id_proc} : termine")

if __name__ == '__main__':
    compteur = Value('i', 0)

    procs = []
    for i in range(4):
        p = Process(target=calculer, args=(i, compteur))
        procs.append(p)
        p.start()

    for p in procs:
        p.join()

    print(f"Compteur final : {compteur.value}")
```

---

## 3. Problemes de concurrence

### 3.1 Race condition (condition de course)

Une **race condition** se produit lorsque le resultat d'un programme depend de l'ordre d'execution (non deterministe) des threads.

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

int compteur = 0;  // variable partagee

void *incrementer(void *arg) {
    (void)arg;
    for (int i = 0; i < 1000000; i++) {
        compteur++;  // NON atomique : lecture, incrementation, ecriture
    }
    return NULL;
}

int main(void) {
    pthread_t t1, t2;

    pthread_create(&t1, NULL, incrementer, NULL);
    pthread_create(&t2, NULL, incrementer, NULL);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    printf("Compteur = %d (attendu : 2000000)\n", compteur);
    // Resultat typique : entre 1000000 et 2000000, rarement 2000000
    return 0;
}
```

**Explication** : L'instruction `compteur++` n'est pas atomique. En assembleur, elle se decompose en :

```asm
mov eax, [compteur]    ; lecture
inc eax                ; incrementation
mov [compteur], eax    ; ecriture
```

Si deux threads executent ces instructions en parallele, certaines incrementations sont perdues :

```text
Thread A : lit compteur = 5
Thread B : lit compteur = 5
Thread A : ecrit compteur = 6
Thread B : ecrit compteur = 6    <-- une incrementation perdue
```

### 3.2 Section critique

Une **section critique** est une portion de code qui accede a des ressources partagees et qui ne doit etre executee que par un seul thread a la fois.

**Proprietes requises** :

1. **Exclusion mutuelle** : un seul thread dans la section critique a la fois
2. **Progression** : si aucun thread n'est dans la section critique, un thread qui veut y entrer peut le faire
3. **Attente bornee** : un thread qui attend d'entrer finira par y entrer (pas de famine)

### 3.3 TOCTOU (Time of Check to Time of Use)

Un cas particulier de race condition ou un etat est verifie puis utilise, mais il peut changer entre la verification et l'utilisation.

```c
// Vulnerable a TOCTOU
if (access("/tmp/fichier", W_OK) == 0) {
    // Un autre processus pourrait supprimer/modifier le fichier ici
    FILE *f = fopen("/tmp/fichier", "w");
    // ...
}
```

---

## 4. Mecanismes de synchronisation

### 4.1 Mutex (Mutual Exclusion)

Un **mutex** est un verrou binaire qui garantit l'exclusion mutuelle.

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

int compteur = 0;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

void *incrementer(void *arg) {
    (void)arg;
    for (int i = 0; i < 1000000; i++) {
        pthread_mutex_lock(&mutex);    // verrouiller
        compteur++;                     // section critique
        pthread_mutex_unlock(&mutex);  // deverrouiller
    }
    return NULL;
}

int main(void) {
    pthread_t t1, t2;

    pthread_create(&t1, NULL, incrementer, NULL);
    pthread_create(&t2, NULL, incrementer, NULL);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    printf("Compteur = %d (attendu : 2000000)\n", compteur);
    // Resultat : toujours 2000000
    pthread_mutex_destroy(&mutex);
    return 0;
}
```

**En Python** :

```python
import threading

compteur = 0
lock = threading.Lock()

def incrementer():
    global compteur
    for _ in range(1_000_000):
        with lock:  # context manager : acquire + release automatique
            compteur += 1

t1 = threading.Thread(target=incrementer)
t2 = threading.Thread(target=incrementer)
t1.start(); t2.start()
t1.join(); t2.join()

print(f"Compteur = {compteur}")  # 2000000
```

### 4.2 Semaphores

Un **semaphore** est un compteur entier non negatif avec deux operations atomiques :

- `P(s)` (ou `wait(s)`) : decremente `s`. Si `s == 0`, bloque le thread.
- `V(s)` (ou `signal(s)`, `post(s)`) : incremente `s`. Reveille un thread bloque s'il y en a.

Un semaphore binaire (valeur initiale 1) est equivalent a un mutex. Un semaphore de comptage permet de limiter le nombre d'acces simultanes.

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

#define NB_THREADS 10
#define MAX_CONCURRENT 3  // au plus 3 threads simultanes

sem_t semaphore;

void *tache(void *arg) {
    int id = *(int *)arg;

    sem_wait(&semaphore);  // P : decremente (ou attend)
    printf("Thread %d : ENTRE dans la section (max %d simultanes)\n", id, MAX_CONCURRENT);
    sleep(1);  // simule un travail
    printf("Thread %d : SORTI\n", id);
    sem_post(&semaphore);  // V : incremente

    return NULL;
}

int main(void) {
    pthread_t threads[NB_THREADS];
    int ids[NB_THREADS];

    sem_init(&semaphore, 0, MAX_CONCURRENT);  // valeur initiale = 3

    for (int i = 0; i < NB_THREADS; i++) {
        ids[i] = i;
        pthread_create(&threads[i], NULL, tache, &ids[i]);
    }

    for (int i = 0; i < NB_THREADS; i++)
        pthread_join(threads[i], NULL);

    sem_destroy(&semaphore);
    return 0;
}
```

### 4.3 Variables de condition (moniteurs)

Une **variable de condition** permet a un thread de se mettre en attente jusqu'a ce qu'une condition soit remplie, notifiee par un autre thread. Elle est toujours utilisee avec un mutex.

```c
#include <stdio.h>
#include <pthread.h>
#include <stdbool.h>

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
bool donnee_prete = false;
int donnee = 0;

void *producteur(void *arg) {
    (void)arg;
    pthread_mutex_lock(&mutex);

    donnee = 42;
    donnee_prete = true;
    printf("Producteur : donnee produite (%d)\n", donnee);

    pthread_cond_signal(&cond);  // reveiller un consommateur
    pthread_mutex_unlock(&mutex);

    return NULL;
}

void *consommateur(void *arg) {
    (void)arg;
    pthread_mutex_lock(&mutex);

    while (!donnee_prete) {  // boucle while (pas if) pour gerer les spurious wakeups
        printf("Consommateur : en attente...\n");
        pthread_cond_wait(&cond, &mutex);  // libere le mutex, attend, le reprend
    }

    printf("Consommateur : donnee recue = %d\n", donnee);
    pthread_mutex_unlock(&mutex);

    return NULL;
}

int main(void) {
    pthread_t tp, tc;

    pthread_create(&tc, NULL, consommateur, NULL);
    pthread_create(&tp, NULL, producteur, NULL);

    pthread_join(tp, NULL);
    pthread_join(tc, NULL);

    pthread_mutex_destroy(&mutex);
    pthread_cond_destroy(&cond);
    return 0;
}
```

**Point subtil** : `pthread_cond_wait` doit etre dans une boucle `while` et non un `if`, car des reveils intempestifs (spurious wakeups) peuvent se produire. La condition doit etre re-verifiee apres le reveil.

---

## 5. Exclusion mutuelle : solutions algorithmiques

### 5.1 Algorithme de Peterson (2 processus)

L'algorithme de Peterson resout l'exclusion mutuelle pour **deux** processus sans support materiel special (en theorie, sur un modele memoire sequentiellement coherent).

```c
#include <stdio.h>
#include <pthread.h>
#include <stdbool.h>

// Variables partagees
volatile bool drapeau[2] = {false, false};
volatile int tour = 0;

int compteur = 0;  // ressource partagee

void entrer_section_critique(int id) {
    int autre = 1 - id;
    drapeau[id] = true;       // je veux entrer
    tour = autre;              // je donne la priorite a l'autre
    // Attente active (busy wait)
    while (drapeau[autre] && tour == autre) {
        // spin
    }
}

void sortir_section_critique(int id) {
    drapeau[id] = false;      // je ne veux plus la section critique
}

void *incrementer(void *arg) {
    int id = *(int *)arg;
    for (int i = 0; i < 1000000; i++) {
        entrer_section_critique(id);
        compteur++;  // section critique
        sortir_section_critique(id);
    }
    return NULL;
}

int main(void) {
    pthread_t t0, t1;
    int id0 = 0, id1 = 1;

    pthread_create(&t0, NULL, incrementer, &id0);
    pthread_create(&t1, NULL, incrementer, &id1);

    pthread_join(t0, NULL);
    pthread_join(t1, NULL);

    printf("Compteur = %d (attendu : 2000000)\n", compteur);
    return 0;
}
```

**Remarque** : Sur les processeurs modernes (x86 avec reordonnancement memoire), cet algorithme necessite des barrieres memoire pour fonctionner correctement. En pratique, on utilise les mutex du systeme.

### 5.2 Solutions materielles

Les processeurs modernes fournissent des **instructions atomiques** :

- **Test-and-Set** : lit une valeur et la met a 1 de maniere atomique
- **Compare-and-Swap (CAS)** : compare une valeur et la remplace si elle correspond
- **Fetch-and-Add** : incremente atomiquement et retourne l'ancienne valeur

```c
#include <stdio.h>
#include <pthread.h>
#include <stdatomic.h>

atomic_int compteur = 0;

void *incrementer(void *arg) {
    (void)arg;
    for (int i = 0; i < 1000000; i++) {
        atomic_fetch_add(&compteur, 1);  // incrementation atomique
    }
    return NULL;
}

int main(void) {
    pthread_t t1, t2;
    pthread_create(&t1, NULL, incrementer, NULL);
    pthread_create(&t2, NULL, incrementer, NULL);
    pthread_join(t1, NULL);
    pthread_join(t2, NULL);
    printf("Compteur = %d\n", compteur);  // toujours 2000000
    return 0;
}
```

### 5.3 Spinlock vs Mutex

| Critere | Spinlock | Mutex |
| ------- | -------- | ----- |
| Attente | Active (boucle CPU) | Passive (le thread dort) |
| Overhead | Faible si section critique courte | Plus eleve (appel systeme) |
| Utilisation CPU | Gaspille du CPU pendant l'attente | Libere le CPU |
| Usage typique | Noyau, sections tres courtes | Applications, sections longues |

---

## 6. Interblocage (deadlock)

### 6.1 Definition

Un **interblocage** est une situation ou un ensemble de threads est bloque indefiniment, chacun attendant une ressource detenue par un autre thread de l'ensemble.

### 6.2 Conditions de Coffman (1971)

L'interblocage ne peut se produire que si les **quatre conditions** suivantes sont reunies simultanement :

1. **Exclusion mutuelle** : les ressources ne sont pas partageables
2. **Detention et attente** (hold and wait) : un thread detient une ressource et en attend une autre
3. **Non-preemption** : une ressource ne peut etre retiree de force a un thread
4. **Attente circulaire** : il existe un cycle dans le graphe d'attente

**Consequence** : pour prevenir le deadlock, il suffit de casser **une seule** de ces conditions.

### 6.3 Exemple de deadlock

```c
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

pthread_mutex_t mutex_A = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t mutex_B = PTHREAD_MUTEX_INITIALIZER;

void *thread_1(void *arg) {
    (void)arg;
    printf("T1 : verrouille A\n");
    pthread_mutex_lock(&mutex_A);
    sleep(1);  // augmente la probabilite de deadlock
    printf("T1 : tente de verrouiller B\n");
    pthread_mutex_lock(&mutex_B);    // BLOQUE : B est detenu par T2
    printf("T1 : a les deux verrous\n");
    pthread_mutex_unlock(&mutex_B);
    pthread_mutex_unlock(&mutex_A);
    return NULL;
}

void *thread_2(void *arg) {
    (void)arg;
    printf("T2 : verrouille B\n");
    pthread_mutex_lock(&mutex_B);
    sleep(1);
    printf("T2 : tente de verrouiller A\n");
    pthread_mutex_lock(&mutex_A);    // BLOQUE : A est detenu par T1
    printf("T2 : a les deux verrous\n");
    pthread_mutex_unlock(&mutex_A);
    pthread_mutex_unlock(&mutex_B);
    return NULL;
}

int main(void) {
    pthread_t t1, t2;
    pthread_create(&t1, NULL, thread_1, NULL);
    pthread_create(&t2, NULL, thread_2, NULL);

    // Ce programme se bloque indefiniment (deadlock)
    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    printf("Ce message ne sera jamais affiche.\n");
    return 0;
}
```

**Graphe d'attente** :

```text
T1 --detient--> A
T1 --attend---> B
T2 --detient--> B
T2 --attend---> A

Cycle : T1 -> B -> T2 -> A -> T1  =>  DEADLOCK
```

### 6.4 Prevention du deadlock

| Methode | Condition cassee | Principe |
| ------- | ---------------- | -------- |
| Ordonner les verrous | Attente circulaire | Toujours verrouiller dans le meme ordre global |
| Tout ou rien | Detention et attente | Acquerir toutes les ressources d'un coup ou aucune |
| Timeout (trylock) | Non-preemption | Abandonner si le verrou n'est pas obtenu a temps |
| Detection | Aucune | Construire le graphe d'attente, detecter les cycles |

**Solution : ordonner les verrous**

```c
// CORRECT : toujours verrouiller dans l'ordre A -> B
void *thread_1_corrige(void *arg) {
    (void)arg;
    pthread_mutex_lock(&mutex_A);  // toujours A en premier
    pthread_mutex_lock(&mutex_B);
    // section critique
    pthread_mutex_unlock(&mutex_B);
    pthread_mutex_unlock(&mutex_A);
    return NULL;
}

void *thread_2_corrige(void *arg) {
    (void)arg;
    pthread_mutex_lock(&mutex_A);  // meme ordre que thread_1
    pthread_mutex_lock(&mutex_B);
    // section critique
    pthread_mutex_unlock(&mutex_B);
    pthread_mutex_unlock(&mutex_A);
    return NULL;
}
```

**Solution : trylock avec timeout**

```c
void *thread_avec_trylock(void *arg) {
    (void)arg;
    while (1) {
        pthread_mutex_lock(&mutex_A);
        if (pthread_mutex_trylock(&mutex_B) == 0) {
            // Succes : les deux verrous acquis
            break;
        }
        // Echec : relacher A et reessayer
        pthread_mutex_unlock(&mutex_A);
        usleep(1000);  // petite pause avant retry
    }
    // section critique
    pthread_mutex_unlock(&mutex_B);
    pthread_mutex_unlock(&mutex_A);
    return NULL;
}
```

### 6.5 Livelock et famine

**Livelock** : les threads ne sont pas bloques mais ne font aucun progres (chacun relache et re-tente en permanence).

**Famine** (starvation) : un thread attend indefiniment car d'autres threads sont toujours prioritaires.

---

## 7. Problemes classiques de synchronisation

### 7.1 Producteur-consommateur (buffer borne)

Un **producteur** genere des elements et les place dans un buffer de taille fixe. Un **consommateur** les retire. Le buffer ne doit ni deborder ni etre lu a vide.

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

#define TAILLE_BUFFER 5
#define NB_ITEMS 20

int buffer[TAILLE_BUFFER];
int index_prod = 0, index_cons = 0;

sem_t places_libres;   // compte les places vides
sem_t items_presents;  // compte les items disponibles
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

void *producteur(void *arg) {
    (void)arg;
    for (int i = 0; i < NB_ITEMS; i++) {
        sem_wait(&places_libres);          // attendre une place libre
        pthread_mutex_lock(&mutex);

        buffer[index_prod] = i;
        printf("PROD : buffer[%d] = %d\n", index_prod, i);
        index_prod = (index_prod + 1) % TAILLE_BUFFER;

        pthread_mutex_unlock(&mutex);
        sem_post(&items_presents);         // signaler un item disponible
        usleep(100000);  // 100ms
    }
    return NULL;
}

void *consommateur(void *arg) {
    (void)arg;
    for (int i = 0; i < NB_ITEMS; i++) {
        sem_wait(&items_presents);         // attendre un item
        pthread_mutex_lock(&mutex);

        int val = buffer[index_cons];
        printf("         CONS : buffer[%d] = %d\n", index_cons, val);
        index_cons = (index_cons + 1) % TAILLE_BUFFER;

        pthread_mutex_unlock(&mutex);
        sem_post(&places_libres);          // liberer une place
        usleep(150000);  // 150ms (consomme plus lentement)
    }
    return NULL;
}

int main(void) {
    sem_init(&places_libres, 0, TAILLE_BUFFER);  // 5 places libres au debut
    sem_init(&items_presents, 0, 0);               // 0 items au debut

    pthread_t tp, tc;
    pthread_create(&tp, NULL, producteur, NULL);
    pthread_create(&tc, NULL, consommateur, NULL);

    pthread_join(tp, NULL);
    pthread_join(tc, NULL);

    sem_destroy(&places_libres);
    sem_destroy(&items_presents);
    pthread_mutex_destroy(&mutex);
    return 0;
}
```

### 7.2 Producteur-consommateur en Python (avec queue.Queue)

```python
import threading
import queue
import time
import random

def producteur(q, nb_items):
    for i in range(nb_items):
        item = random.randint(1, 100)
        q.put(item)  # bloque si la queue est pleine
        print(f"  PROD: produit {item} (taille queue: {q.qsize()})")
        time.sleep(random.uniform(0.05, 0.15))
    q.put(None)  # signal de fin

def consommateur(q):
    somme = 0
    while True:
        item = q.get()  # bloque si la queue est vide
        if item is None:
            break
        somme += item
        print(f"         CONS: consomme {item} (somme partielle: {somme})")
        time.sleep(random.uniform(0.1, 0.2))
        q.task_done()
    print(f"Consommateur : somme finale = {somme}")

q = queue.Queue(maxsize=5)  # buffer borne de taille 5

t_prod = threading.Thread(target=producteur, args=(q, 10))
t_cons = threading.Thread(target=consommateur, args=(q,))

t_prod.start()
t_cons.start()

t_prod.join()
t_cons.join()
```

### 7.3 Lecteurs-redacteurs

Plusieurs **lecteurs** peuvent acceder simultanement a une ressource, mais un **redacteur** doit avoir un acces exclusif.

```python
import threading
import time
import random

class LecteursRedacteurs:
    def __init__(self):
        self.donnee = 0
        self.nb_lecteurs = 0
        self.mutex_lecteurs = threading.Lock()      # protege nb_lecteurs
        self.acces_ressource = threading.Lock()       # acces exclusif pour ecriture

    def lire(self, id_lecteur):
        with self.mutex_lecteurs:
            self.nb_lecteurs += 1
            if self.nb_lecteurs == 1:
                self.acces_ressource.acquire()  # premier lecteur bloque les redacteurs

        # Section de lecture (plusieurs lecteurs simultanes)
        print(f"  Lecteur {id_lecteur} lit : {self.donnee}")
        time.sleep(random.uniform(0.1, 0.3))

        with self.mutex_lecteurs:
            self.nb_lecteurs -= 1
            if self.nb_lecteurs == 0:
                self.acces_ressource.release()  # dernier lecteur libere

    def ecrire(self, id_redacteur, valeur):
        self.acces_ressource.acquire()

        # Section d'ecriture (acces exclusif)
        self.donnee = valeur
        print(f"Redacteur {id_redacteur} ecrit : {self.donnee}")
        time.sleep(random.uniform(0.2, 0.5))

        self.acces_ressource.release()


lr = LecteursRedacteurs()

def lecteur(id_l):
    for _ in range(3):
        lr.lire(id_l)
        time.sleep(random.uniform(0.1, 0.2))

def redacteur(id_r):
    for i in range(3):
        lr.ecrire(id_r, (id_r + 1) * 100 + i)
        time.sleep(random.uniform(0.3, 0.5))

threads = []
for i in range(3):
    threads.append(threading.Thread(target=lecteur, args=(i,)))
for i in range(2):
    threads.append(threading.Thread(target=redacteur, args=(i,)))

for t in threads:
    t.start()
for t in threads:
    t.join()
```

**Attention** : cette solution favorise les lecteurs (famine possible des redacteurs si les lecteurs arrivent en continu). Pour une equite lecteurs/redacteurs, on peut utiliser un semaphore supplementaire.

### 7.4 Philosophes dineurs

Cinq philosophes sont assis autour d'une table ronde. Chacun a une assiette et il y a une fourchette entre chaque paire de philosophes. Pour manger, un philosophe doit prendre les deux fourchettes adjacentes.

```c
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

#define N 5
#define NB_REPAS 3

pthread_mutex_t fourchettes[N];

void *philosophe(void *arg) {
    int id = *(int *)arg;
    int gauche = id;
    int droite = (id + 1) % N;

    for (int repas = 0; repas < NB_REPAS; repas++) {
        printf("Philosophe %d : pense...\n", id);
        usleep(100000);

        // Pour eviter le deadlock : ordonner les verrous
        // Chaque philosophe prend d'abord la fourchette de plus petit numero
        int premiere = (gauche < droite) ? gauche : droite;
        int seconde = (gauche < droite) ? droite : gauche;

        pthread_mutex_lock(&fourchettes[premiere]);
        pthread_mutex_lock(&fourchettes[seconde]);

        printf("Philosophe %d : MANGE (repas %d)\n", id, repas + 1);
        usleep(200000);

        pthread_mutex_unlock(&fourchettes[seconde]);
        pthread_mutex_unlock(&fourchettes[premiere]);
    }

    printf("Philosophe %d : a fini tous ses repas.\n", id);
    return NULL;
}

int main(void) {
    pthread_t threads[N];
    int ids[N];

    for (int i = 0; i < N; i++)
        pthread_mutex_init(&fourchettes[i], NULL);

    for (int i = 0; i < N; i++) {
        ids[i] = i;
        pthread_create(&threads[i], NULL, philosophe, &ids[i]);
    }

    for (int i = 0; i < N; i++)
        pthread_join(threads[i], NULL);

    for (int i = 0; i < N; i++)
        pthread_mutex_destroy(&fourchettes[i]);

    return 0;
}
```

**Solutions au deadlock** :

1. **Ordre des ressources** : chaque philosophe prend toujours la fourchette de plus petit numero d'abord (c'est ce que fait le code ci-dessus)
2. **Limitation** : au plus N-1 philosophes autorises a table simultanement (semaphore)
3. **Tout ou rien** : prendre les deux fourchettes d'un coup ou aucune (trylock)

---

## 8. Applications

### 8.1 Serveur concurrent en C

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define PORT 8080
#define BUFFER_SIZE 1024

void *traiter_client(void *arg) {
    int client_fd = *(int *)arg;
    free(arg);

    char buffer[BUFFER_SIZE];
    ssize_t n = read(client_fd, buffer, sizeof(buffer) - 1);
    if (n > 0) {
        buffer[n] = '\0';
        printf("Thread %lu recu : %s\n", pthread_self(), buffer);

        const char *reponse = "HTTP/1.1 200 OK\r\nContent-Length: 13\r\n\r\nHello, World!";
        write(client_fd, reponse, strlen(reponse));
    }

    close(client_fd);
    return NULL;
}

int main(void) {
    int server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd < 0) { perror("socket"); exit(1); }

    int opt = 1;
    setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    struct sockaddr_in addr = {
        .sin_family = AF_INET,
        .sin_addr.s_addr = INADDR_ANY,
        .sin_port = htons(PORT)
    };

    if (bind(server_fd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
        perror("bind"); exit(1);
    }
    listen(server_fd, 128);
    printf("Serveur en ecoute sur le port %d\n", PORT);

    while (1) {
        int *client_fd = malloc(sizeof(int));
        *client_fd = accept(server_fd, NULL, NULL);
        if (*client_fd < 0) { perror("accept"); free(client_fd); continue; }

        pthread_t tid;
        pthread_create(&tid, NULL, traiter_client, client_fd);
        pthread_detach(tid);  // le thread se nettoie automatiquement
    }

    close(server_fd);
    return 0;
}
```

### 8.2 Scanner de ports concurrent en Python

Application directe en pentest : scanner plusieurs ports simultanement.

```python
import socket
import threading
from queue import Queue
import time

def scan_port(ip, port, resultats):
    """Tente de se connecter a ip:port"""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(1)
        result = sock.connect_ex((ip, port))
        if result == 0:
            try:
                banner = sock.recv(1024).decode('utf-8', errors='ignore').strip()
            except Exception:
                banner = ""
            resultats.append((port, banner))
        sock.close()
    except Exception:
        pass

def worker(ip, q, resultats):
    """Thread worker qui consomme des ports depuis la queue"""
    while True:
        port = q.get()
        if port is None:
            break
        scan_port(ip, port, resultats)
        q.task_done()

def scan_concurrent(ip, ports, nb_threads=100):
    """Scanner de ports multi-thread"""
    q = Queue()
    resultats = []

    # Creer les threads workers
    threads = []
    for _ in range(nb_threads):
        t = threading.Thread(target=worker, args=(ip, q, resultats))
        t.daemon = True
        t.start()
        threads.append(t)

    # Remplir la queue avec les ports
    for port in ports:
        q.put(port)

    # Attendre que tous les ports soient scannes
    q.join()

    # Arreter les workers
    for _ in range(nb_threads):
        q.put(None)
    for t in threads:
        t.join()

    return sorted(resultats)

if __name__ == '__main__':
    cible = "127.0.0.1"  # remplacer par l'IP cible
    ports = range(1, 1025)

    print(f"Scan de {cible} ({len(ports)} ports, 100 threads)...")
    t0 = time.time()

    resultats = scan_concurrent(cible, ports, nb_threads=100)

    duree = time.time() - t0
    print(f"\nScan termine en {duree:.2f}s")
    print(f"Ports ouverts :")
    for port, banner in resultats:
        print(f"  {port}/tcp  OPEN  {banner}")
```

**Comparaison** :

- Scan sequentiel de 1024 ports avec timeout 1s : ~1024 secondes (17 min)
- Scan concurrent avec 100 threads : ~10 secondes

### 8.3 Thread pool (pool de threads)

```python
from concurrent.futures import ThreadPoolExecutor, as_completed
import requests
import time

def telecharger(url):
    """Telecharge une URL et retourne le temps et la taille"""
    t0 = time.time()
    try:
        r = requests.get(url, timeout=10)
        duree = time.time() - t0
        return (url, r.status_code, len(r.content), duree)
    except Exception as e:
        return (url, -1, 0, time.time() - t0)

urls = [
    "https://www.python.org",
    "https://docs.python.org",
    "https://pypi.org",
    "https://www.sqlite.org",
    "https://ocaml.org",
]

# ThreadPoolExecutor gere un pool de threads reutilisables
with ThreadPoolExecutor(max_workers=5) as executor:
    futures = {executor.submit(telecharger, url): url for url in urls}

    for future in as_completed(futures):
        url, status, taille, duree = future.result()
        print(f"  {url}: status={status}, {taille} octets, {duree:.2f}s")
```

---

## 9. Exercices

### Exercice 1 -- fork et processus

Que produit le programme suivant ? Combien de processus sont crees au total ?

```c
#include <stdio.h>
#include <unistd.h>

int main(void) {
    fork();
    fork();
    fork();
    printf("PID = %d\n", getpid());
    return 0;
}
```

### Exercice 2 -- Race condition

Le programme suivant contient une race condition. L'identifier et la corriger avec un mutex.

```python
import threading

solde = 1000

def retirer(montant):
    global solde
    if solde >= montant:
        # Simuler un delai (augmente la probabilite de race condition)
        import time; time.sleep(0.001)
        solde -= montant
        print(f"Retrait de {montant}, solde = {solde}")
    else:
        print(f"Solde insuffisant pour retirer {montant}")

threads = [threading.Thread(target=retirer, args=(800,)) for _ in range(2)]
for t in threads:
    t.start()
for t in threads:
    t.join()

print(f"Solde final = {solde}")
```

### Exercice 3 -- Deadlock

Identifier la situation de deadlock dans le scenario suivant et proposer une solution.

Trois threads T1, T2, T3 et trois ressources R1, R2, R3 :

- T1 detient R1 et attend R2
- T2 detient R2 et attend R3
- T3 detient R3 et attend R1

Dessiner le graphe d'attente. Verifier les quatre conditions de Coffman. Proposer une solution par ordonnancement des ressources.

### Exercice 4 -- Producteur-consommateur en Python

Implementer le probleme du producteur-consommateur avec un buffer de taille 10 en Python, en utilisant `threading.Condition`. Le producteur genere des nombres aleatoires, le consommateur les somme.

### Exercice 5 -- Philosophes dineurs avec semaphore

Modifier le programme des philosophes dineurs pour utiliser un semaphore qui limite le nombre de philosophes mangeant simultanement a N-1. Verifier qu'il n'y a plus de deadlock.

### Exercice 6 -- Serveur de chat multi-thread

Ecrire un serveur de chat en Python (socket + threading) qui accepte plusieurs clients simultanes. Chaque message envoye par un client est diffuse a tous les autres (broadcast). Proteger la liste des clients avec un verrou.

### Exercice 7 -- Barriere de synchronisation

Implementer une barriere de synchronisation en C avec pthread : N threads doivent tous atteindre un point de rendez-vous avant de pouvoir continuer. Utiliser un mutex et une variable de condition.

### Exercice 8 -- Analyse de deadlock

Le programme suivant peut-il provoquer un deadlock ? Si oui, dans quelles conditions ? Proposer une correction.

```c
pthread_mutex_t m1, m2, m3;

void *tA(void *arg) {
    pthread_mutex_lock(&m1);
    pthread_mutex_lock(&m2);
    // travail
    pthread_mutex_unlock(&m2);
    pthread_mutex_unlock(&m1);
    return NULL;
}

void *tB(void *arg) {
    pthread_mutex_lock(&m2);
    pthread_mutex_lock(&m3);
    // travail
    pthread_mutex_unlock(&m3);
    pthread_mutex_unlock(&m2);
    return NULL;
}

void *tC(void *arg) {
    pthread_mutex_lock(&m3);
    pthread_mutex_lock(&m1);
    // travail
    pthread_mutex_unlock(&m1);
    pthread_mutex_unlock(&m3);
    return NULL;
}
```

---

## 10. References

- **Operating System Concepts** (Silberschatz, Galvin, Gagne) -- Chapitres 3-7
- **The Little Book of Semaphores** (Allen B. Downey) -- Gratuit en ligne : https://greenteapress.com/wp/semaphores/
- **Advanced Programming in the UNIX Environment** (Stevens, Rago) -- Chapitres 8, 10, 11, 12
- **Programming with POSIX Threads** (David Butenhof)
- **man pages** : `man 2 fork`, `man 3 pthread_create`, `man 7 signal`
- **Python threading documentation** : https://docs.python.org/3/library/threading.html
- **POSIX threads tutorial** : https://computing.llnl.gov/tutorials/pthreads/

---

*Cours prepare pour le niveau MP2I/MPI -- Fondamentaux d'informatique*
