# Chapitre 8 — Gestion de la memoire et compilation

## Objectifs du chapitre

- Comprendre l'architecture memoire d'un programme (pile, tas, segments)
- Maitriser les pointeurs en C (declaration, dereferencement, arithmetique, pointeurs de fonctions)
- Utiliser correctement l'allocation dynamique (malloc, calloc, realloc, free)
- Detecter les fuites memoire avec Valgrind
- Implementer des structures de donnees dynamiques (tableaux, listes chainees) en C
- Connaitre le principe des buffer overflows et les protections associees
- Comprendre la gestion memoire automatique en OCaml (ramasse-miettes)
- Maitriser la chaine de compilation (preprocesseur, compilation, assemblage, edition de liens)

---

## 1. Architecture memoire d'un programme

### 1.1 Segments memoire

Lorsqu'un programme C est charge en memoire, l'espace d'adressage est divise en plusieurs segments :

```text
Adresses hautes
+------------------+
|      Stack        |  <-- Pile (variables locales, parametres, adresses de retour)
|        |          |      Croit vers les adresses basses
|                   |
|        ^          |
|      Heap         |  <-- Tas (allocation dynamique : malloc, calloc)
|                   |      Croit vers les adresses hautes
+------------------+
|      BSS          |  <-- Variables globales non initialisees (mises a 0)
+------------------+
|      Data         |  <-- Variables globales initialisees
+------------------+
|      Text         |  <-- Code executable (instructions machine)
+------------------+
Adresses basses
```

### 1.2 La pile (stack)

La pile est une zone memoire geree automatiquement selon le principe LIFO (Last In, First Out).

**Contenu** :

- Variables locales des fonctions
- Parametres des fonctions
- Adresses de retour
- Registres sauvegardes (saved %rbp sur x86_64)

**Proprietes** :

- Allocation/desallocation automatique (a l'entree/sortie de fonction)
- Acces tres rapide (localite spatiale, gestion par le pointeur de pile `%rsp`)
- Taille limitee (typiquement 8 Mo sous Linux, configurable via `ulimit -s`)
- Risque de **stack overflow** si recursion trop profonde

**Cadre de pile (stack frame)** : chaque appel de fonction cree un cadre de pile contenant les variables locales, les parametres, l'adresse de retour et le pointeur de base sauvegarde.

```text
+------------------+  <-- %rsp (sommet de pile)
|  var locale 2    |
|  var locale 1    |
|  saved %rbp      |  <-- %rbp (base du cadre actuel)
|  adresse retour  |
|  argument 1      |
|  argument 2      |
+------------------+  <-- ancien %rbp (cadre de l'appelant)
```

```c
#include <stdio.h>

void f(int n) {
    int tab[1000];  // 4000 octets sur la pile a chaque appel
    printf("Profondeur %d, adresse de tab : %p\n", n, (void*)tab);
    if (n > 0) f(n - 1);
}

int main(void) {
    f(5);  // 5 cadres de pile empiles
    return 0;
}
```

### 1.3 Le tas (heap)

Le tas est une zone memoire geree manuellement par le programmeur via `malloc`/`free`.

**Proprietes** :

- Taille potentiellement tres grande (limitee par la RAM + swap)
- Allocation/desallocation explicite -- risque de fuites memoire
- Acces plus lent que la pile (fragmentation, indirection)
- Les donnees persistent jusqu'au `free` explicite
- L'allocateur (ptmalloc2, jemalloc, tcmalloc) gere les blocs libres via des listes chainees internes

### 1.4 Visualisation avec un programme C

```c
#include <stdio.h>
#include <stdlib.h>

int global_init = 42;        // segment Data
int global_non_init;          // segment BSS (initialise a 0)
const char *chaine = "hello"; // la chaine est dans .rodata (lecture seule)

void fonction(int param) {
    int local = 10;           // pile (stack)
    int *dyn = malloc(sizeof(int));  // tas (heap)
    *dyn = 99;

    printf("Segment Text     (code)  : %p\n", (void*)fonction);
    printf("Segment Data     (init)  : %p\n", (void*)&global_init);
    printf("Segment BSS      (bss)   : %p\n", (void*)&global_non_init);
    printf("Pile             (param) : %p\n", (void*)&param);
    printf("Pile             (local) : %p\n", (void*)&local);
    printf("Tas              (dyn)   : %p\n", (void*)dyn);

    free(dyn);
}

int main(void) {
    fonction(7);
    return 0;
}
```

**Sortie typique (Linux x86_64)** :

```text
Segment Text     (code)  : 0x55a3b4c01169
Segment Data     (init)  : 0x55a3b4c04010
Segment BSS      (bss)   : 0x55a3b4c04018
Pile             (param) : 0x7ffc8a3e1abc
Pile             (local) : 0x7ffc8a3e1ab8
Tas              (dyn)   : 0x55a3b5e012a0
```

On constate que les adresses de la pile (0x7ffc...) sont nettement plus hautes que celles du tas (0x55a3...).

### 1.5 Inspection memoire sous Linux

```bash
# Voir la carte memoire d'un processus
cat /proc/self/maps

# Taille de la pile par defaut
ulimit -s    # typiquement 8192 (Ko) = 8 Mo

# Memoire utilisee par un processus
ps aux | grep programme
top -p <PID>
```

---

## 2. Pointeurs en C

### 2.1 Declaration et dereferencement

Un **pointeur** est une variable qui contient une **adresse memoire**. La taille d'un pointeur depend de l'architecture : 8 octets sur x86_64, 4 octets sur x86_32.

```c
#include <stdio.h>

int main(void) {
    int x = 42;
    int *p = &x;   // p pointe vers x (contient l'adresse de x)

    printf("Valeur de x      : %d\n", x);        // 42
    printf("Adresse de x     : %p\n", (void*)&x); // ex: 0x7ffc...
    printf("Valeur de p      : %p\n", (void*)p);   // meme adresse
    printf("Valeur pointee   : %d\n", *p);         // 42 (dereferencement)
    printf("Taille de p      : %zu octets\n", sizeof(p));  // 8 sur x86_64

    *p = 100;  // modification via le pointeur
    printf("Nouvelle valeur de x : %d\n", x);      // 100

    return 0;
}
```

**Operateurs** :

- `&x` : adresse de `x` (operateur d'adressage)
- `*p` : valeur a l'adresse contenue dans `p` (operateur de dereferencement)

### 2.2 Pointeurs et tableaux

En C, un tableau est intimement lie aux pointeurs : le nom du tableau est un pointeur constant vers son premier element.

```c
#include <stdio.h>

int main(void) {
    int tab[] = {10, 20, 30, 40, 50};
    int *p = tab;  // equivalent a : int *p = &tab[0];

    // Les deux notations sont equivalentes :
    for (int i = 0; i < 5; i++) {
        printf("tab[%d] = %d  |  *(p + %d) = %d\n", i, tab[i], i, *(p + i));
    }

    // Difference : tab n'est pas modifiable (on ne peut pas faire tab = autre_tab)
    // mais p est modifiable (on peut faire p = &autre_variable)

    return 0;
}
```

### 2.3 Arithmetique de pointeurs

L'arithmetique des pointeurs tient compte de la **taille du type pointe**.

```c
#include <stdio.h>

int main(void) {
    int tab[] = {10, 20, 30, 40};
    int *p = tab;

    printf("p     = %p  -> *p     = %d\n", (void*)p, *p);           // 10
    printf("p + 1 = %p  -> *(p+1) = %d\n", (void*)(p+1), *(p+1));  // 20
    printf("p + 2 = %p  -> *(p+2) = %d\n", (void*)(p+2), *(p+2));  // 30

    // Difference entre adresses : on avance de sizeof(int) = 4 octets a chaque pas
    printf("Ecart en octets entre p et p+1 : %ld\n",
           (char*)(p+1) - (char*)p);  // 4

    // Iteration avec pointeur
    for (int *q = tab; q < tab + 4; q++) {
        printf("%d ", *q);
    }
    printf("\n");

    // Difference entre deux pointeurs : nombre d'elements entre eux
    int *debut = &tab[0];
    int *fin = &tab[3];
    printf("Nombre d'elements entre debut et fin : %ld\n", fin - debut);  // 3

    return 0;
}
```

### 2.4 Passage par adresse

En C, les arguments sont passes **par valeur**. Pour modifier une variable depuis une fonction, on passe son adresse.

```c
#include <stdio.h>

// Echange INCORRECT (par valeur) : ne modifie pas les originaux
void echange_faux(int a, int b) {
    int tmp = a;
    a = b;
    b = tmp;
}

// Echange CORRECT (par adresse)
void echange(int *a, int *b) {
    int tmp = *a;
    *a = *b;
    *b = tmp;
}

int main(void) {
    int x = 3, y = 7;

    echange_faux(x, y);
    printf("Apres echange_faux : x=%d, y=%d\n", x, y);  // x=3, y=7 (inchange)

    echange(&x, &y);
    printf("Apres echange       : x=%d, y=%d\n", x, y);  // x=7, y=3

    return 0;
}
```

### 2.5 Pointeurs de pointeurs

Un pointeur de pointeur (`int **pp`) stocke l'adresse d'un pointeur. Utilise pour les tableaux 2D dynamiques et les fonctions qui doivent modifier un pointeur.

```c
#include <stdio.h>
#include <stdlib.h>

// Alloue un tableau dynamique et modifie le pointeur de l'appelant
void allouer_tableau(int **ptab, int n) {
    *ptab = malloc(n * sizeof(int));
    for (int i = 0; i < n; i++)
        (*ptab)[i] = i * 10;
}

int main(void) {
    int *tab = NULL;
    allouer_tableau(&tab, 5);  // on passe l'adresse du pointeur

    for (int i = 0; i < 5; i++)
        printf("%d ", tab[i]);  // 0 10 20 30 40
    printf("\n");

    free(tab);
    return 0;
}
```

### 2.6 Pointeurs sur fonctions

Un pointeur sur fonction permet de stocker l'adresse d'une fonction et de l'appeler indirectement. C'est le mecanisme de base pour les callbacks et le polymorphisme en C.

```c
#include <stdio.h>
#include <stdlib.h>

// Deux fonctions de comparaison
int comparer_croissant(const void *a, const void *b) {
    return *(const int*)a - *(const int*)b;
}

int comparer_decroissant(const void *a, const void *b) {
    return *(const int*)b - *(const int*)a;
}

// Fonction qui prend un pointeur sur fonction en parametre
void trier_et_afficher(int tab[], int n, int (*cmp)(const void*, const void*)) {
    qsort(tab, n, sizeof(int), cmp);
    for (int i = 0; i < n; i++)
        printf("%d ", tab[i]);
    printf("\n");
}

// Tableau de pointeurs de fonctions
typedef double (*operation_t)(double, double);

double addition(double a, double b) { return a + b; }
double soustraction(double a, double b) { return a - b; }
double multiplication(double a, double b) { return a * b; }

int main(void) {
    int tab1[] = {5, 2, 8, 1, 9, 3};
    int tab2[] = {5, 2, 8, 1, 9, 3};
    int n = 6;

    printf("Croissant   : ");
    trier_et_afficher(tab1, n, comparer_croissant);    // 1 2 3 5 8 9

    printf("Decroissant : ");
    trier_et_afficher(tab2, n, comparer_decroissant);  // 9 8 5 3 2 1

    // Tableau de pointeurs de fonctions
    operation_t ops[] = {addition, soustraction, multiplication};
    const char *noms[] = {"add", "sub", "mul"};

    for (int i = 0; i < 3; i++)
        printf("%s(3.0, 2.0) = %.1f\n", noms[i], ops[i](3.0, 2.0));

    return 0;
}
```

### 2.7 Pointeurs et const

```c
int x = 10, y = 20;

int *p1 = &x;              // pointeur modifiable vers int modifiable
const int *p2 = &x;        // pointeur modifiable vers int constant (ne peut pas modifier *p2)
int *const p3 = &x;        // pointeur constant vers int modifiable (ne peut pas modifier p3)
const int *const p4 = &x;  // pointeur constant vers int constant

// p2 = &y;    // OK
// *p2 = 42;   // ERREUR : l'entier pointe est const
// p3 = &y;    // ERREUR : le pointeur est const
// *p3 = 42;   // OK
```

---

## 3. Allocation dynamique

### 3.1 malloc, calloc, realloc, free

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    // malloc : alloue n octets, contenu NON initialise
    int *tab1 = malloc(5 * sizeof(int));
    if (tab1 == NULL) {
        perror("malloc");
        return 1;
    }
    // Contenu indetermine ! Il faut initialiser.
    for (int i = 0; i < 5; i++)
        tab1[i] = i * 10;

    // calloc : alloue n elements, initialises a 0
    int *tab2 = calloc(5, sizeof(int));
    if (tab2 == NULL) {
        perror("calloc");
        free(tab1);
        return 1;
    }
    // tab2[0..4] == 0

    // realloc : redimensionne un bloc existant
    int *tmp = realloc(tab1, 10 * sizeof(int));
    if (tmp == NULL) {
        perror("realloc");
        free(tab1);  // l'ancien bloc est toujours valide si realloc echoue
        free(tab2);
        return 1;
    }
    tab1 = tmp;
    // Les 5 premiers elements sont conserves, les 5 nouveaux sont indetermines
    for (int i = 5; i < 10; i++)
        tab1[i] = i * 10;

    // Affichage
    printf("tab1 : ");
    for (int i = 0; i < 10; i++)
        printf("%d ", tab1[i]);
    printf("\n");

    // free : libere la memoire
    free(tab1);
    free(tab2);
    // Apres free, ne JAMAIS acceder aux pointeurs (use-after-free)
    tab1 = NULL;  // bonne pratique : mettre a NULL apres free
    tab2 = NULL;

    return 0;
}
```

**Piege classique avec realloc** : ne jamais faire `p = realloc(p, new_size)` directement. Si realloc echoue, il retourne NULL et on perd la reference vers l'ancien bloc (fuite memoire).

### 3.2 Erreurs courantes

| Erreur | Description | Consequence |
| ------ | ----------- | ----------- |
| Fuite memoire (memory leak) | `malloc` sans `free` correspondant | Consommation memoire croissante |
| Use-after-free | Acceder a la memoire apres `free` | Comportement indefini |
| Double free | Appeler `free` deux fois sur le meme pointeur | Corruption du tas |
| Buffer overflow | Ecrire au-dela de la zone allouee | Corruption memoire, faille de securite |
| Dereferencement NULL | `*p` quand `p == NULL` | Segfault |
| Utilisation non initialisee | Lire un malloc sans initialiser | Valeur indeterminee |

### 3.3 Detection avec Valgrind

Valgrind est un outil d'analyse dynamique qui detecte les erreurs memoire.

```c
// fichier : fuite.c
#include <stdlib.h>

int main(void) {
    int *p = malloc(100 * sizeof(int));
    p[0] = 42;
    // Oubli de free(p) -> fuite memoire

    int *q = malloc(10 * sizeof(int));
    free(q);
    q[0] = 7;  // Use-after-free !

    return 0;
}
```

```bash
gcc -g -O0 -o fuite fuite.c
valgrind --leak-check=full --show-reachable=yes --track-origins=yes ./fuite
```

**Sortie Valgrind** :

```text
==12345== Invalid write of size 4
==12345==    at 0x40058A: main (fuite.c:9)
==12345==  Address 0x5205040 is 0 bytes inside a block of size 40 free'd
==12345==    at 0x4C30D3B: free (vg_replace_malloc.c:530)
==12345==    by 0x400585: main (fuite.c:8)
==12345==
==12345== LEAK SUMMARY:
==12345==    definitely lost: 400 bytes in 1 blocks
==12345==    indirectly lost: 0 bytes in 0 blocks
```

Valgrind identifie :

1. L'ecriture invalide (use-after-free) a la ligne 9
2. La fuite de 400 octets (100 int * 4 octets) non liberes

**Autres outils** :

- **AddressSanitizer (ASan)** : `gcc -fsanitize=address -g` -- plus rapide que Valgrind, integre au compilateur
- **MemorySanitizer (MSan)** : detecte les lectures de memoire non initialisee
- **LeakSanitizer (LSan)** : detecte les fuites, integre dans ASan

```bash
# Compilation avec ASan
gcc -fsanitize=address -g -O1 -o prog prog.c
./prog  # crash avec rapport detaille si erreur memoire
```

---

## 4. Structures de donnees dynamiques en C

### 4.1 Tableau dynamique redimensionnable

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int *data;
    int taille;     // nombre d'elements actuels
    int capacite;   // taille allouee
} VecteurDyn;

VecteurDyn* vecteur_creer(int capacite_initiale) {
    VecteurDyn *v = malloc(sizeof(VecteurDyn));
    if (!v) return NULL;
    v->data = malloc(capacite_initiale * sizeof(int));
    if (!v->data) { free(v); return NULL; }
    v->taille = 0;
    v->capacite = capacite_initiale;
    return v;
}

void vecteur_ajouter(VecteurDyn *v, int valeur) {
    if (v->taille == v->capacite) {
        // Doubler la capacite (amortissement : cout amorti O(1) par ajout)
        v->capacite *= 2;
        int *nouveau = realloc(v->data, v->capacite * sizeof(int));
        if (!nouveau) {
            fprintf(stderr, "Erreur realloc\n");
            exit(1);
        }
        v->data = nouveau;
    }
    v->data[v->taille++] = valeur;
}

int vecteur_get(VecteurDyn *v, int index) {
    if (index < 0 || index >= v->taille) {
        fprintf(stderr, "Index hors bornes : %d (taille : %d)\n", index, v->taille);
        exit(1);
    }
    return v->data[index];
}

void vecteur_supprimer(VecteurDyn *v, int index) {
    if (index < 0 || index >= v->taille) {
        fprintf(stderr, "Index hors bornes\n");
        exit(1);
    }
    // Decaler les elements
    for (int i = index; i < v->taille - 1; i++)
        v->data[i] = v->data[i + 1];
    v->taille--;
}

void vecteur_detruire(VecteurDyn *v) {
    free(v->data);
    free(v);
}

int main(void) {
    VecteurDyn *v = vecteur_creer(4);

    for (int i = 0; i < 20; i++) {
        vecteur_ajouter(v, i * i);
        printf("Ajout %2d : taille=%2d, capacite=%2d\n", i*i, v->taille, v->capacite);
    }

    printf("\nContenu : ");
    for (int i = 0; i < v->taille; i++)
        printf("%d ", vecteur_get(v, i));
    printf("\n");

    vecteur_detruire(v);
    return 0;
}
```

### 4.2 Liste chainee

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct Noeud {
    int valeur;
    struct Noeud *suivant;
} Noeud;

typedef struct {
    Noeud *tete;
    int taille;
} ListeChainee;

ListeChainee* liste_creer(void) {
    ListeChainee *l = malloc(sizeof(ListeChainee));
    if (!l) return NULL;
    l->tete = NULL;
    l->taille = 0;
    return l;
}

void liste_inserer_tete(ListeChainee *l, int valeur) {
    Noeud *n = malloc(sizeof(Noeud));
    if (!n) { perror("malloc"); exit(1); }
    n->valeur = valeur;
    n->suivant = l->tete;
    l->tete = n;
    l->taille++;
}

void liste_inserer_fin(ListeChainee *l, int valeur) {
    Noeud *n = malloc(sizeof(Noeud));
    if (!n) { perror("malloc"); exit(1); }
    n->valeur = valeur;
    n->suivant = NULL;

    if (l->tete == NULL) {
        l->tete = n;
    } else {
        Noeud *courant = l->tete;
        while (courant->suivant != NULL)
            courant = courant->suivant;
        courant->suivant = n;
    }
    l->taille++;
}

int liste_supprimer_tete(ListeChainee *l) {
    if (l->tete == NULL) {
        fprintf(stderr, "Liste vide\n");
        exit(1);
    }
    Noeud *ancien = l->tete;
    int valeur = ancien->valeur;
    l->tete = ancien->suivant;
    free(ancien);
    l->taille--;
    return valeur;
}

Noeud* liste_rechercher(ListeChainee *l, int valeur) {
    Noeud *courant = l->tete;
    while (courant != NULL) {
        if (courant->valeur == valeur)
            return courant;
        courant = courant->suivant;
    }
    return NULL;
}

void liste_afficher(ListeChainee *l) {
    Noeud *courant = l->tete;
    printf("[");
    while (courant != NULL) {
        printf("%d", courant->valeur);
        if (courant->suivant) printf(" -> ");
        courant = courant->suivant;
    }
    printf("] (taille: %d)\n", l->taille);
}

void liste_detruire(ListeChainee *l) {
    Noeud *courant = l->tete;
    while (courant != NULL) {
        Noeud *suivant = courant->suivant;
        free(courant);
        courant = suivant;
    }
    free(l);
}

int main(void) {
    ListeChainee *l = liste_creer();

    liste_inserer_fin(l, 10);
    liste_inserer_fin(l, 20);
    liste_inserer_fin(l, 30);
    liste_inserer_tete(l, 5);

    printf("Apres insertions : ");
    liste_afficher(l);  // [5 -> 10 -> 20 -> 30] (taille: 4)

    int v = liste_supprimer_tete(l);
    printf("Supprime : %d\n", v);  // 5

    printf("Apres suppression : ");
    liste_afficher(l);  // [10 -> 20 -> 30] (taille: 3)

    Noeud *trouve = liste_rechercher(l, 20);
    printf("Recherche 20 : %s\n", trouve ? "trouve" : "pas trouve");

    liste_detruire(l);
    return 0;
}
```

### 4.3 Comparaison tableau dynamique vs liste chainee

| Operation | Tableau dynamique | Liste chainee |
| --------- | ----------------- | ------------- |
| Acces par index | O(1) | O(n) |
| Insertion en tete | O(n) | O(1) |
| Insertion en fin | O(1) amorti | O(n) sans pointeur de fin, O(1) avec |
| Suppression en tete | O(n) | O(1) |
| Recherche | O(n) | O(n) |
| Memoire | Contigue, bonne localite de cache | Fragmentee, mauvaise localite |

---

## 5. Buffer overflow

### 5.1 Principe

Un **buffer overflow** (debordement de tampon) se produit lorsqu'un programme ecrit des donnees au-dela des limites d'un buffer alloue. C'est l'une des vulnerabilites les plus classiques en securite informatique, a l'origine de nombreuses exploitations (Morris Worm 1988, Code Red 2001, Heartbleed 2014).

### 5.2 Exemple de stack-based buffer overflow

```c
#include <stdio.h>
#include <string.h>

void fonction_vulnerable(char *input) {
    char buffer[64];          // 64 octets sur la pile
    strcpy(buffer, input);    // DANGER : aucune verification de taille !
    printf("Buffer : %s\n", buffer);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <input>\n", argv[0]);
        return 1;
    }
    fonction_vulnerable(argv[1]);
    return 0;
}
```

**Exploitation** : si `input` fait plus de 64 octets, `strcpy` ecrase les donnees adjacentes sur la pile : la sauvegarde du pointeur de base (`%rbp`), puis l'adresse de retour. Un attaquant peut rediriger l'execution vers du code arbitraire (shellcode).

```text
Pile avant overflow :       Pile apres overflow :
+------------------+       +------------------+
|  adresse retour  |       |  AAAA (ecrasee)  |  <-- detournement
+------------------+       +------------------+
|  saved %rbp      |       |  AAAA (ecrase)   |
+------------------+       +------------------+
|  buffer[63..0]   |       |  AAAA...AAAA     |  <-- input trop long
+------------------+       +------------------+
```

### 5.3 Heap-based buffer overflow

Les overflows sur le tas sont aussi dangereux. Ils peuvent corrompre les metadonnees de l'allocateur (malloc) et permettre une ecriture arbitraire en memoire.

```c
#include <stdlib.h>
#include <string.h>

int main(void) {
    char *buf1 = malloc(64);
    char *buf2 = malloc(64);

    // Si on deborde buf1, on ecrase les metadonnees de buf2
    // (taille, pointeurs de la liste chainee de l'allocateur)
    strcpy(buf1, "AAAAAAAAAA...");  // si > 64 octets : corruption du tas

    free(buf1);
    free(buf2);
    return 0;
}
```

### 5.4 Fonctions dangereuses vs sures

| Dangereuse | Alternative sure | Raison |
| ---------- | ---------------- | ------ |
| `gets()` | `fgets()` | Aucune limite de taille |
| `strcpy()` | `strncpy()` ou `strlcpy()` | Pas de verification de borne |
| `sprintf()` | `snprintf()` | Pas de limite de taille |
| `strcat()` | `strncat()` | Pas de verification de borne |
| `scanf("%s", ...)` | `scanf("%63s", ...)` | Specifier la largeur maximale |

```c
// Version corrigee
void fonction_securisee(char *input) {
    char buffer[64];
    strncpy(buffer, input, sizeof(buffer) - 1);
    buffer[sizeof(buffer) - 1] = '\0';  // s'assurer de la terminaison
    printf("Buffer : %s\n", buffer);
}
```

### 5.5 Protections modernes

| Protection | Principe | Contournement |
| ---------- | -------- | ------------- |
| **ASLR** (Address Space Layout Randomization) | Rend aleatoire la position des segments en memoire | Information leak, brute force (32 bits) |
| **Stack canary** | Valeur sentinelle entre le buffer et l'adresse de retour, verifiee avant le `ret` | Fuite de la valeur du canary |
| **NX/DEP** (No-Execute) | Marque la pile comme non executable | Return-Oriented Programming (ROP) |
| **RELRO** | Rend la GOT en lecture seule | Ecriture dans d'autres structures |
| **PIE** (Position Independent Executable) | Code independant de la position, combine avec ASLR | Information leak |
| **FORTIFY_SOURCE** | Remplace les fonctions dangereuses par des versions verifiees | Couverture incomplete |

```bash
# Verifier les protections d'un binaire avec checksec
checksec --file=./programme

# Compiler SANS protections (pour lab de securite uniquement)
gcc -fno-stack-protector -z execstack -no-pie -o vuln vuln.c

# Compiler AVEC toutes les protections
gcc -fstack-protector-strong -D_FORTIFY_SOURCE=2 -pie -Wl,-z,relro,-z,now -o safe safe.c
```

---

## 6. Gestion memoire en OCaml

### 6.1 Le ramasse-miettes (garbage collector)

En OCaml, la gestion memoire est **automatique** : le programmeur n'a pas besoin d'appeler `malloc` ni `free`. Le **ramasse-miettes** (GC) se charge de recycler la memoire des valeurs qui ne sont plus accessibles.

### 6.2 Fonctionnement du GC d'OCaml

OCaml utilise un GC **generationnel** avec deux generations :

- **Tas mineur** (minor heap) : petit (~256 Ko par defaut), rapide, pour les allocations recentes. Collecte frequemment par un algorithme de copie (stop-and-copy).
- **Tas majeur** (major heap) : plus grand, pour les objets qui survivent a plusieurs collectes mineures. Collecte par un algorithme de marquage-balayage incremental (mark-and-sweep).

**Principe generationnel** : la plupart des objets ont une duree de vie courte (hypothese generationnelle). Les objets qui survivent sont promus du tas mineur au tas majeur.

**Cycle de vie** :

1. Allocation dans le tas mineur (tres rapide, simple incrementation de pointeur)
2. Quand le tas mineur est plein : collecte mineure (copie des objets vivants vers le tas majeur)
3. Periodiquement : collecte majeure incremental (marquage-balayage)

### 6.3 Comparaison C vs OCaml

```c
/* En C : allocation manuelle, risque de fuite */
#include <stdlib.h>

int *creer_tableau(int n) {
    int *t = malloc(n * sizeof(int));
    if (!t) return NULL;
    for (int i = 0; i < n; i++) t[i] = i;
    return t;  // Le caller DOIT appeler free(t) plus tard
}

int main(void) {
    int *t = creer_tableau(100);
    // ... utilisation ...
    free(t);  // oubli = fuite memoire
    return 0;
}
```

```ocaml
(* En OCaml : allocation automatique, pas de fuite possible *)
let creer_tableau n =
  Array.init n (fun i -> i)
  (* Le tableau sera collecte automatiquement quand plus aucune
     reference ne pointe dessus *)

let () =
  let t = creer_tableau 100 in
  Array.iter (fun x -> Printf.printf "%d " x) t;
  print_newline ()
  (* A la fin du scope, si t n'est plus reference, le GC le collecte *)
```

### 6.4 Listes en OCaml (allocation implicite)

```ocaml
(* Chaque cellule de liste est allouee sur le tas *)
let rec map f = function
  | [] -> []
  | x :: xs -> f x :: map f xs
  (* Chaque appel a :: alloue une cellule cons sur le tas mineur *)

(* Exemple : doubler chaque element *)
let () =
  let lst = [1; 2; 3; 4; 5] in
  let doubled = map (fun x -> 2 * x) lst in
  List.iter (fun x -> Printf.printf "%d " x) doubled;
  print_newline ()
  (* Sortie : 2 4 6 8 10 *)

(* Version tail-recursive (evite le stack overflow sur de longues listes) *)
let map_tr f lst =
  let rec aux acc = function
    | [] -> List.rev acc
    | x :: xs -> aux (f x :: acc) xs
  in
  aux [] lst
```

### 6.5 Controle du GC

```ocaml
(* Statistiques du GC *)
let () =
  let stat = Gc.stat () in
  Printf.printf "Collectes mineures  : %.0f\n" stat.Gc.minor_collections;
  Printf.printf "Collectes majeures  : %.0f\n" stat.Gc.major_collections;
  Printf.printf "Taille du tas mineur: %d mots\n" (Gc.get ()).Gc.minor_heap_size;
  Printf.printf "Mots vivants (majeur): %.0f\n" stat.Gc.live_words

(* Forcer une collecte complete *)
let () = Gc.full_major ()

(* Ajuster les parametres du GC *)
let () =
  let ctrl = Gc.get () in
  Gc.set { ctrl with Gc.minor_heap_size = 1_000_000 }  (* augmenter le tas mineur *)
```

### 6.6 Comparaison des approches

| Critere | Gestion manuelle (C) | GC (OCaml, Java) | Ownership (Rust) |
| ------- | -------------------- | ----------------- | ----------------- |
| Fuites memoire | Possibles | Impossibles (quasi) | Impossibles |
| Use-after-free | Possible | Impossible | Impossible (compile-time) |
| Performance | Maximale si bien fait | Pauses GC | Proche du C, sans pause |
| Complexite code | Elevee | Faible | Moyenne (borrow checker) |
| Fragmentation | Possible | Geree par le GC | Geree par l'allocateur |

---

## 7. Compilation et edition de liens

### 7.1 Les quatre etapes de la compilation C

Un fichier source `.c` passe par quatre etapes avant de devenir un executable :

```text
source.c -> [Preprocesseur] -> source.i -> [Compilateur] -> source.s ->
[Assembleur] -> source.o -> [Editeur de liens] -> executable
```

### 7.2 Etape 1 : Preprocesseur

Le preprocesseur traite les directives `#include`, `#define`, `#ifdef`, etc. Il produit un fichier `.i` (code C pur, sans directives).

```c
// fichier : exemple.c
#include <stdio.h>
#define MAX 100
#define CARRE(x) ((x) * (x))

#ifdef DEBUG
    #define LOG(msg) printf("[DEBUG] %s\n", msg)
#else
    #define LOG(msg)
#endif

int main(void) {
    int tab[MAX];
    printf("Carre de 5 : %d\n", CARRE(5));
    LOG("Fin du programme");
    return 0;
}
```

```bash
# Voir la sortie du preprocesseur
gcc -E exemple.c -o exemple.i
# exemple.i contient le code source avec les #include remplaces
# par le contenu des fichiers d'en-tete et les macros expansees

# Compiler avec le symbole DEBUG defini
gcc -DDEBUG -o exemple exemple.c
```

**Pieges du preprocesseur** :

```c
#define DOUBLE(x) x + x      // INCORRECT : DOUBLE(3) * 2 = 3 + 3 * 2 = 9
#define DOUBLE(x) ((x) + (x)) // CORRECT : DOUBLE(3) * 2 = ((3) + (3)) * 2 = 12

#define CARRE(x) ((x) * (x))  // Attention : CARRE(i++) incremente i deux fois !
```

### 7.3 Etape 2 : Compilation (C vers assembleur)

Le compilateur traduit le C en assembleur specifique a l'architecture cible.

```bash
gcc -S exemple.c -o exemple.s
```

```asm
; Extrait de exemple.s (x86_64, syntaxe AT&T)
main:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $416, %rsp          ; allocation du tableau sur la pile
    movl    $25, %esi           ; CARRE(5) = 25, calcule a la compilation
    leaq    .LC0(%rip), %rdi    ; adresse de la chaine format
    movl    $0, %eax
    call    printf@PLT
    movl    $0, %eax
    leave
    ret
```

### 7.4 Etape 3 : Assemblage (assembleur vers code objet)

L'assembleur traduit les mnemoniques en code machine binaire. Le resultat est un fichier objet `.o`.

```bash
gcc -c exemple.c -o exemple.o

# Examiner le fichier objet
objdump -d exemple.o    # desassemblage
nm exemple.o             # symboles definis et non definis
readelf -h exemple.o     # en-tete ELF
readelf -S exemple.o     # sections du fichier objet
```

### 7.5 Etape 4 : Edition de liens (linking)

L'editeur de liens combine les fichiers objets et resout les references entre eux. Il attache les bibliotheques necessaires (libc, etc.).

```bash
# Compilation separee de deux fichiers
gcc -c main.c -o main.o
gcc -c utils.c -o utils.o

# Edition de liens
gcc main.o utils.o -o programme

# Avec une bibliotheque externe
gcc main.o -lm -o programme  # lie la bibliotheque mathematique libm
```

**Types de liaison** :

- **Statique** : le code de la bibliotheque est copie dans l'executable (`gcc -static`). L'executable est autonome mais plus gros.
- **Dynamique** : l'executable reference la bibliotheque partagee (.so / .dll), chargee a l'execution. Plus leger mais depend de la presence de la bibliotheque.

```bash
# Voir les bibliotheques dynamiques necessaires
ldd ./programme
# Exemple de sortie :
# linux-vdso.so.1
# libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6
# /lib64/ld-linux-x86-64.so.2

# Creer une bibliotheque statique
ar rcs libutils.a utils.o
gcc main.o -L. -lutils -o programme

# Creer une bibliotheque dynamique
gcc -shared -fPIC -o libutils.so utils.c
gcc main.o -L. -lutils -o programme
```

### 7.6 Exemple complet : compilation multi-fichiers

```c
// fichier : math_utils.h
#ifndef MATH_UTILS_H
#define MATH_UTILS_H

int factorielle(int n);
int fibonacci(int n);

#endif
```

```c
// fichier : math_utils.c
#include "math_utils.h"

int factorielle(int n) {
    if (n <= 1) return 1;
    return n * factorielle(n - 1);
}

int fibonacci(int n) {
    if (n <= 1) return n;
    int a = 0, b = 1;
    for (int i = 2; i <= n; i++) {
        int tmp = a + b;
        a = b;
        b = tmp;
    }
    return b;
}
```

```c
// fichier : main.c
#include <stdio.h>
#include "math_utils.h"

int main(void) {
    for (int i = 0; i <= 10; i++) {
        printf("fact(%2d) = %10d    fib(%2d) = %5d\n",
               i, factorielle(i), i, fibonacci(i));
    }
    return 0;
}
```

```bash
# Compilation et edition de liens
gcc -Wall -Wextra -c math_utils.c -o math_utils.o
gcc -Wall -Wextra -c main.c -o main.o
gcc math_utils.o main.o -o programme
./programme
```

### 7.7 Makefile

```makefile
CC = gcc
CFLAGS = -Wall -Wextra -g -O2

programme: main.o math_utils.o
	$(CC) $(CFLAGS) $^ -o $@

main.o: main.c math_utils.h
	$(CC) $(CFLAGS) -c $< -o $@

math_utils.o: math_utils.c math_utils.h
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o programme

.PHONY: clean
```

**Variables automatiques** :

- `$@` : la cible
- `$<` : la premiere dependance
- `$^` : toutes les dependances

### 7.8 Options de compilation utiles

```bash
# Warnings (toujours activer)
gcc -Wall -Wextra -Wpedantic -Werror  # traiter les warnings comme des erreurs

# Optimisation
gcc -O0    # pas d'optimisation (debug)
gcc -O1    # optimisation de base
gcc -O2    # optimisation standard (recommande pour la production)
gcc -O3    # optimisation agressive
gcc -Os    # optimisation pour la taille

# Debug
gcc -g     # informations de debug (pour gdb et valgrind)
gcc -g3    # informations de debug maximales (macros incluses)

# Standard C
gcc -std=c11   # norme C11
gcc -std=c17   # norme C17

# Securite
gcc -fstack-protector-strong -D_FORTIFY_SOURCE=2 -pie -Wl,-z,relro,-z,now
```

---

## 8. Exercices

### Exercice 1 -- Segments memoire

Pour chaque variable du programme suivant, indiquer dans quel segment memoire elle se trouve (Text, Data, BSS, Stack, Heap) :

```c
int a = 10;
int b;
const char *msg = "hello";
int main(void) {
    int c = 5;
    static int d = 3;
    char *p = malloc(100);
    free(p);
    return 0;
}
```

### Exercice 2 -- Pointeurs

Que produit le programme suivant ? Justifier chaque valeur affichee.

```c
#include <stdio.h>
int main(void) {
    int tab[] = {10, 20, 30, 40, 50};
    int *p = tab + 2;
    printf("%d\n", *p);
    printf("%d\n", *(p - 1));
    printf("%d\n", p[1]);
    printf("%d\n", p[-2]);
    printf("%ld\n", p - tab);
    return 0;
}
```

### Exercice 3 -- Allocation dynamique

Ecrire en C une fonction `char* concat(const char *s1, const char *s2)` qui alloue dynamiquement une chaine resultat et retourne la concatenation de `s1` et `s2`. Le caller est responsable du `free`.

### Exercice 4 -- Liste chainee doublement chainee

Implementer en C une liste doublement chainee avec les operations : insertion en tete, insertion en queue, suppression d'un element par valeur, affichage dans les deux sens. Verifier l'absence de fuites avec Valgrind.

### Exercice 5 -- Buffer overflow

Le programme suivant contient un buffer overflow. Identifier la ligne vulnerable, expliquer le risque, et proposer une correction.

```c
#include <stdio.h>
#include <string.h>

void traiter(char *input) {
    char buf[32];
    sprintf(buf, "Resultat: %s", input);
    puts(buf);
}

int main(void) {
    char input[256];
    printf("Entree: ");
    fgets(input, sizeof(input), stdin);
    traiter(input);
    return 0;
}
```

### Exercice 6 -- Compilation

Expliquer ce que fait chaque commande de la sequence suivante :

```bash
cpp programme.c > programme.i
gcc -S programme.i -o programme.s
as programme.s -o programme.o
ld programme.o -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o programme
```

### Exercice 7 -- OCaml et GC

Ecrire une fonction OCaml qui genere une grande liste (1 million d'elements), la filtre, puis affiche les statistiques du GC avant et apres. Observer le comportement des collectes mineures et majeures.

### Exercice 8 -- Matrice dynamique

Implementer en C une matrice de taille m x n allouee dynamiquement (tableau de pointeurs). Ecrire les fonctions : creation, acces, multiplication de matrices, destruction. Verifier avec Valgrind.

---

## 9. References

- **The C Programming Language** (Kernighan, Ritchie) -- Chapitre 5 (Pointeurs)
- **Computer Systems: A Programmer's Perspective** (Bryant, O'Hallaron) -- Chapitres 3, 7, 9
- **Hacking: The Art of Exploitation** (Jon Erickson) -- Chapitres 2-3 (Buffer overflow)
- **Real World OCaml** (Minsky, Madhavapeddy, Hickey) -- Chapitre 22 (GC)
- **Valgrind Documentation** : https://valgrind.org/docs/manual/
- **OWASP Buffer Overflow** : https://owasp.org/www-community/vulnerabilities/Buffer_Overflow
- **Manuel GCC** : https://gcc.gnu.org/onlinedocs/
- **OCaml GC** : https://v2.ocaml.org/api/Gc.html

---

*Cours prepare pour le niveau MP2I/MPI -- Fondamentaux d'informatique*
