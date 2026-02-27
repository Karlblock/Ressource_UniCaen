# Chapitre 2 -- Structures de donnees

## Objectifs du chapitre

- Comprendre et implementer les listes chainees (simples et doubles)
- Maitriser les piles (LIFO) et les files (FIFO), leurs implementations et applications
- Comprendre les tables de hachage : fonctions de hachage, gestion des collisions
- Maitriser les arbres binaires, ABR, AVL : parcours, insertion, suppression
- Comprendre les files de priorite et les tas (heaps)
- Connaitre la complexite de chaque operation pour chaque structure

---

## 1. Listes chainees

### 1.1 Principe

Une liste chainee est une structure de donnees ou chaque element (noeud) contient une valeur et un pointeur vers l'element suivant. Contrairement aux tableaux, les elements ne sont pas contigus en memoire.

**Avantages par rapport aux tableaux :**

- Insertion/suppression en O(1) si on a un pointeur sur le noeud precedent
- Taille dynamique sans reallocation

**Inconvenients :**

- Acces par indice en O(n) (pas d'acces direct)
- Surcout memoire pour les pointeurs
- Mauvaise localite spatiale (cache misses)

### 1.2 Liste simplement chainee en C

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct Noeud {
    int valeur;
    struct Noeud *suivant;
} Noeud;

/* Creation d'un nouveau noeud */
Noeud *creer_noeud(int val) {
    Noeud *n = malloc(sizeof(Noeud));
    if (n == NULL) {
        fprintf(stderr, "Erreur allocation memoire\n");
        exit(1);
    }
    n->valeur = val;
    n->suivant = NULL;
    return n;
}

/* Insertion en tete : O(1) */
Noeud *inserer_tete(Noeud *tete, int val) {
    Noeud *n = creer_noeud(val);
    n->suivant = tete;
    return n;
}

/* Insertion en queue : O(n) */
Noeud *inserer_queue(Noeud *tete, int val) {
    Noeud *n = creer_noeud(val);
    if (tete == NULL) return n;

    Noeud *courant = tete;
    while (courant->suivant != NULL) {
        courant = courant->suivant;
    }
    courant->suivant = n;
    return tete;
}

/* Suppression de la premiere occurrence : O(n) */
Noeud *supprimer(Noeud *tete, int val) {
    if (tete == NULL) return NULL;

    if (tete->valeur == val) {
        Noeud *suivant = tete->suivant;
        free(tete);
        return suivant;
    }

    Noeud *courant = tete;
    while (courant->suivant != NULL && courant->suivant->valeur != val) {
        courant = courant->suivant;
    }

    if (courant->suivant != NULL) {
        Noeud *a_supprimer = courant->suivant;
        courant->suivant = a_supprimer->suivant;
        free(a_supprimer);
    }
    return tete;
}

/* Recherche : O(n) */
Noeud *rechercher(Noeud *tete, int val) {
    Noeud *courant = tete;
    while (courant != NULL) {
        if (courant->valeur == val) return courant;
        courant = courant->suivant;
    }
    return NULL;
}

/* Longueur : O(n) */
int longueur(Noeud *tete) {
    int n = 0;
    while (tete != NULL) {
        n++;
        tete = tete->suivant;
    }
    return n;
}

/* Affichage */
void afficher(Noeud *tete) {
    Noeud *courant = tete;
    while (courant != NULL) {
        printf("%d -> ", courant->valeur);
        courant = courant->suivant;
    }
    printf("NULL\n");
}

/* Liberation de la memoire : O(n) */
void liberer(Noeud *tete) {
    while (tete != NULL) {
        Noeud *suivant = tete->suivant;
        free(tete);
        tete = suivant;
    }
}

int main(void) {
    Noeud *liste = NULL;
    liste = inserer_tete(liste, 30);
    liste = inserer_tete(liste, 20);
    liste = inserer_tete(liste, 10);
    liste = inserer_queue(liste, 40);

    afficher(liste);  /* 10 -> 20 -> 30 -> 40 -> NULL */

    liste = supprimer(liste, 20);
    afficher(liste);  /* 10 -> 30 -> 40 -> NULL */

    printf("Longueur: %d\n", longueur(liste));  /* 3 */

    liberer(liste);
    return 0;
}
```

### 1.3 Liste simplement chainee en Python

```python
class Noeud:
    def __init__(self, valeur, suivant=None):
        self.valeur = valeur
        self.suivant = suivant

class ListeChainee:
    def __init__(self):
        self.tete = None

    def inserer_tete(self, val):
        """Insertion en tete : O(1)"""
        self.tete = Noeud(val, self.tete)

    def inserer_queue(self, val):
        """Insertion en queue : O(n)"""
        if self.tete is None:
            self.tete = Noeud(val)
            return
        courant = self.tete
        while courant.suivant is not None:
            courant = courant.suivant
        courant.suivant = Noeud(val)

    def supprimer(self, val):
        """Suppression de la premiere occurrence : O(n)"""
        if self.tete is None:
            return
        if self.tete.valeur == val:
            self.tete = self.tete.suivant
            return
        courant = self.tete
        while courant.suivant is not None and courant.suivant.valeur != val:
            courant = courant.suivant
        if courant.suivant is not None:
            courant.suivant = courant.suivant.suivant

    def rechercher(self, val):
        """Recherche : O(n)"""
        courant = self.tete
        while courant is not None:
            if courant.valeur == val:
                return True
            courant = courant.suivant
        return False

    def longueur(self):
        """Longueur : O(n)"""
        n = 0
        courant = self.tete
        while courant is not None:
            n += 1
            courant = courant.suivant
        return n

    def __str__(self):
        elements = []
        courant = self.tete
        while courant is not None:
            elements.append(str(courant.valeur))
            courant = courant.suivant
        return " -> ".join(elements) + " -> None"


lst = ListeChainee()
lst.inserer_tete(30)
lst.inserer_tete(20)
lst.inserer_tete(10)
lst.inserer_queue(40)
print(lst)  # 10 -> 20 -> 30 -> 40 -> None

lst.supprimer(20)
print(lst)  # 10 -> 30 -> 40 -> None
```

### 1.4 Liste en OCaml

En OCaml, les listes sont nativement des listes chainees immutables :

```ocaml
(* Les listes OCaml sont deja des listes chainees immutables *)
let lst = [10; 20; 30; 40]

(* Ajout en tete : O(1) *)
let lst2 = 5 :: lst   (* [5; 10; 20; 30; 40] *)

(* Longueur : O(n) *)
let rec longueur = function
  | [] -> 0
  | _ :: xs -> 1 + longueur xs

(* Recherche : O(n) *)
let rec mem x = function
  | [] -> false
  | y :: ys -> x = y || mem x ys

(* Concatenation : O(n) ou n = longueur de la premiere liste *)
let lst3 = lst @ [50; 60]

(* Inversion : O(n) *)
let rev lst =
  let rec aux acc = function
    | [] -> acc
    | x :: xs -> aux (x :: acc) xs
  in
  aux [] lst
```

### 1.5 Liste doublement chainee

Chaque noeud contient un pointeur vers le suivant ET vers le precedent. Cela permet le parcours dans les deux sens et la suppression en O(1) si on a un pointeur sur le noeud.

```c
typedef struct DNoeud {
    int valeur;
    struct DNoeud *precedent;
    struct DNoeud *suivant;
} DNoeud;

typedef struct {
    DNoeud *tete;
    DNoeud *queue;
    int taille;
} ListeDouble;

void init_double(ListeDouble *lst) {
    lst->tete = NULL;
    lst->queue = NULL;
    lst->taille = 0;
}

void inserer_tete_double(ListeDouble *lst, int val) {
    DNoeud *n = malloc(sizeof(DNoeud));
    n->valeur = val;
    n->precedent = NULL;
    n->suivant = lst->tete;

    if (lst->tete != NULL) {
        lst->tete->precedent = n;
    } else {
        lst->queue = n;  /* Liste etait vide */
    }
    lst->tete = n;
    lst->taille++;
}

/* Suppression d'un noeud donne : O(1) */
void supprimer_noeud(ListeDouble *lst, DNoeud *n) {
    if (n->precedent != NULL) {
        n->precedent->suivant = n->suivant;
    } else {
        lst->tete = n->suivant;
    }
    if (n->suivant != NULL) {
        n->suivant->precedent = n->precedent;
    } else {
        lst->queue = n->precedent;
    }
    free(n);
    lst->taille--;
}
```

---

## 2. Piles (LIFO -- Last In, First Out)

### 2.1 Principe

Une pile est une structure ou le dernier element insere est le premier retire. Operations fondamentales :

- **push(x)** : empiler un element
- **pop()** : depiler et retourner le sommet
- **top() / peek()** : consulter le sommet sans depiler
- **is_empty()** : tester si la pile est vide

Toutes ces operations sont en **O(1)**.

**Analogie :** une pile d'assiettes. On ne peut prendre que celle du dessus.

### 2.2 Implementation par tableau en C

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define CAPACITE_MAX 1000

typedef struct {
    int elements[CAPACITE_MAX];
    int sommet;  /* Indice du sommet, -1 si vide */
} Pile;

void pile_init(Pile *p) {
    p->sommet = -1;
}

bool pile_est_vide(Pile *p) {
    return p->sommet == -1;
}

bool pile_est_pleine(Pile *p) {
    return p->sommet == CAPACITE_MAX - 1;
}

void pile_push(Pile *p, int val) {
    if (pile_est_pleine(p)) {
        fprintf(stderr, "Pile pleine\n");
        return;
    }
    p->elements[++(p->sommet)] = val;
}

int pile_pop(Pile *p) {
    if (pile_est_vide(p)) {
        fprintf(stderr, "Pile vide\n");
        exit(1);
    }
    return p->elements[(p->sommet)--];
}

int pile_top(Pile *p) {
    if (pile_est_vide(p)) {
        fprintf(stderr, "Pile vide\n");
        exit(1);
    }
    return p->elements[p->sommet];
}
```

### 2.3 Implementation en Python

```python
class Pile:
    def __init__(self):
        self._elements = []

    def est_vide(self):
        return len(self._elements) == 0

    def push(self, val):
        self._elements.append(val)

    def pop(self):
        if self.est_vide():
            raise IndexError("Pile vide")
        return self._elements.pop()

    def top(self):
        if self.est_vide():
            raise IndexError("Pile vide")
        return self._elements[-1]

    def taille(self):
        return len(self._elements)

    def __str__(self):
        return f"Pile({self._elements})"
```

### 2.4 Implementation fonctionnelle en OCaml

En OCaml, une pile est naturellement representee par une liste (ajout/retrait en tete = O(1)) :

```ocaml
(* Une pile fonctionnelle = une liste *)
let pile_vide = []
let push x pile = x :: pile
let pop = function
  | [] -> failwith "Pile vide"
  | _ :: xs -> xs
let top = function
  | [] -> failwith "Pile vide"
  | x :: _ -> x
let est_vide pile = (pile = [])

(* Utilisation *)
let p = pile_vide |> push 10 |> push 20 |> push 30
let () = Printf.printf "Sommet: %d\n" (top p)   (* 30 *)
let p2 = pop p
let () = Printf.printf "Sommet: %d\n" (top p2)  (* 20 *)
```

### 2.5 Applications des piles

**Verification du parenthesage :**

```python
def parenthesage_valide(expression: str) -> bool:
    """Verifie que les parentheses/crochets/accolades sont equilibres."""
    pile = []
    correspondance = {')': '(', ']': '[', '}': '{'}

    for c in expression:
        if c in '([{':
            pile.append(c)
        elif c in ')]}':
            if not pile or pile[-1] != correspondance[c]:
                return False
            pile.pop()

    return len(pile) == 0

# Tests
print(parenthesage_valide("((a + b) * [c - d])"))  # True
print(parenthesage_valide("((a + b) * [c - d)"))    # False
print(parenthesage_valide("{[()]}"))                 # True
print(parenthesage_valide("{[(])}"))                 # False
```

**Evaluation d'une expression postfixe (notation polonaise inverse) :**

```python
def evaluer_postfixe(expression: str) -> float:
    """Evalue une expression en notation polonaise inverse.
    Exemple : '3 4 + 2 *' = (3 + 4) * 2 = 14
    """
    pile = []
    operateurs = {'+', '-', '*', '/'}

    for token in expression.split():
        if token in operateurs:
            b = pile.pop()
            a = pile.pop()
            if token == '+': pile.append(a + b)
            elif token == '-': pile.append(a - b)
            elif token == '*': pile.append(a * b)
            elif token == '/': pile.append(a / b)
        else:
            pile.append(float(token))

    return pile[0]

print(evaluer_postfixe("3 4 + 2 *"))           # 14.0
print(evaluer_postfixe("5 1 2 + 4 * + 3 -"))   # 14.0
```

---

## 3. Files (FIFO -- First In, First Out)

### 3.1 Principe

Une file est une structure ou le premier element insere est le premier retire. Operations fondamentales :

- **enqueue(x)** : ajouter un element a la fin
- **dequeue()** : retirer et retourner l'element en tete
- **front() / peek()** : consulter la tete sans retirer
- **is_empty()** : tester si la file est vide

**Analogie :** une file d'attente a la boulangerie.

### 3.2 Implementation par tableau circulaire en C

Un tableau circulaire evite le decalage des elements et donne des operations en O(1) :

```c
#include <stdio.h>
#include <stdbool.h>

#define CAPACITE 100

typedef struct {
    int elements[CAPACITE];
    int tete;    /* Indice de lecture */
    int queue;   /* Indice d'ecriture */
    int taille;
} File;

void file_init(File *f) {
    f->tete = 0;
    f->queue = 0;
    f->taille = 0;
}

bool file_est_vide(File *f) {
    return f->taille == 0;
}

bool file_est_pleine(File *f) {
    return f->taille == CAPACITE;
}

void file_enqueue(File *f, int val) {
    if (file_est_pleine(f)) {
        fprintf(stderr, "File pleine\n");
        return;
    }
    f->elements[f->queue] = val;
    f->queue = (f->queue + 1) % CAPACITE;  /* Modulo pour circularite */
    f->taille++;
}

int file_dequeue(File *f) {
    if (file_est_vide(f)) {
        fprintf(stderr, "File vide\n");
        return -1;
    }
    int val = f->elements[f->tete];
    f->tete = (f->tete + 1) % CAPACITE;
    f->taille--;
    return val;
}

int file_front(File *f) {
    if (file_est_vide(f)) {
        fprintf(stderr, "File vide\n");
        return -1;
    }
    return f->elements[f->tete];
}
```

### 3.3 Implementation en Python

```python
from collections import deque

class File:
    def __init__(self):
        self._elements = deque()  # deque : O(1) pour popleft

    def est_vide(self):
        return len(self._elements) == 0

    def enqueue(self, val):
        """Ajout en queue : O(1)"""
        self._elements.append(val)

    def dequeue(self):
        """Retrait en tete : O(1) grace a deque"""
        if self.est_vide():
            raise IndexError("File vide")
        return self._elements.popleft()

    def front(self):
        if self.est_vide():
            raise IndexError("File vide")
        return self._elements[0]

    def taille(self):
        return len(self._elements)
```

**Remarque :** utiliser `list.pop(0)` est en O(n) car il faut decaler tous les elements. La classe `deque` du module `collections` offre un `popleft()` en O(1) grace a une implementation en liste doublement chainee de blocs.

### 3.4 Application : BFS (parcours en largeur)

```python
from collections import deque

def bfs(graphe, depart):
    """Parcours en largeur d'un graphe represente par listes d'adjacence."""
    visite = set()
    file = deque([depart])
    visite.add(depart)
    ordre = []

    while file:
        sommet = file.popleft()
        ordre.append(sommet)
        for voisin in graphe[sommet]:
            if voisin not in visite:
                visite.add(voisin)
                file.append(voisin)

    return ordre

graphe = {
    'A': ['B', 'C'],
    'B': ['A', 'D', 'E'],
    'C': ['A', 'F'],
    'D': ['B'],
    'E': ['B', 'F'],
    'F': ['C', 'E']
}

print(bfs(graphe, 'A'))  # ['A', 'B', 'C', 'D', 'E', 'F']
```

---

## 4. Tables de hachage

### 4.1 Principe

Une table de hachage associe des cles a des valeurs via une **fonction de hachage** qui convertit une cle en indice de tableau. En moyenne, les operations (insertion, recherche, suppression) sont en **O(1)**.

Le **facteur de charge** alpha = n/m (nombre d'elements / taille du tableau) influence les performances. On redimensionne generalement quand alpha > 0.7.

### 4.2 Fonction de hachage

Une bonne fonction de hachage doit :

- Etre deterministe (meme cle = meme hash)
- Distribuer uniformement les cles
- Etre rapide a calculer
- Minimiser les collisions

```c
/* Fonction de hachage pour les chaines (djb2 de Bernstein) */
unsigned long hash_djb2(const char *str) {
    unsigned long hash = 5381;
    int c;
    while ((c = *str++)) {
        hash = ((hash << 5) + hash) + c;  /* hash * 33 + c */
    }
    return hash;
}

/* Fonction de hachage pour les entiers (multiplicative) */
unsigned int hash_int(int cle, int taille_table) {
    /* Methode multiplicative avec le nombre d'or */
    double A = 0.6180339887;  /* (sqrt(5) - 1) / 2 */
    double frac = cle * A - (int)(cle * A);
    return (unsigned int)(taille_table * frac);
}
```

### 4.3 Gestion des collisions par chainage

Deux cles differentes peuvent produire le meme indice. Le **chainage** (chaining) place une liste chainee dans chaque case du tableau :

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TABLE_SIZE 101

typedef struct Entree {
    char *cle;
    int valeur;
    struct Entree *suivant;
} Entree;

typedef struct {
    Entree *buckets[TABLE_SIZE];
    int nb_elements;
} TableHash;

unsigned int hash(const char *cle) {
    unsigned long h = 5381;
    int c;
    while ((c = *cle++))
        h = ((h << 5) + h) + c;
    return h % TABLE_SIZE;
}

void table_init(TableHash *t) {
    for (int i = 0; i < TABLE_SIZE; i++)
        t->buckets[i] = NULL;
    t->nb_elements = 0;
}

void table_inserer(TableHash *t, const char *cle, int valeur) {
    unsigned int idx = hash(cle);

    /* Verifier si la cle existe deja */
    Entree *e = t->buckets[idx];
    while (e != NULL) {
        if (strcmp(e->cle, cle) == 0) {
            e->valeur = valeur;  /* Mise a jour */
            return;
        }
        e = e->suivant;
    }

    /* Nouvelle entree en tete de la liste chainee */
    Entree *nouveau = malloc(sizeof(Entree));
    nouveau->cle = strdup(cle);
    nouveau->valeur = valeur;
    nouveau->suivant = t->buckets[idx];
    t->buckets[idx] = nouveau;
    t->nb_elements++;
}

int *table_chercher(TableHash *t, const char *cle) {
    unsigned int idx = hash(cle);
    Entree *e = t->buckets[idx];
    while (e != NULL) {
        if (strcmp(e->cle, cle) == 0)
            return &(e->valeur);
        e = e->suivant;
    }
    return NULL;
}

int main(void) {
    TableHash t;
    table_init(&t);

    table_inserer(&t, "alice", 95);
    table_inserer(&t, "bob", 82);
    table_inserer(&t, "carol", 91);

    int *val = table_chercher(&t, "bob");
    if (val != NULL)
        printf("bob: %d\n", *val);  /* bob: 82 */

    return 0;
}
```

### 4.4 Gestion des collisions par adressage ouvert

En cas de collision, on cherche la prochaine case libre dans le tableau lui-meme. Sondage lineaire :

```python
class TableHashOuverte:
    """Table de hachage avec adressage ouvert (sondage lineaire)."""

    VIDE = None
    SUPPRIME = object()  # Marqueur pour les suppressions paresseuses

    def __init__(self, taille=101):
        self.taille = taille
        self.cles = [self.VIDE] * taille
        self.valeurs = [self.VIDE] * taille
        self.nb_elements = 0

    def _hash(self, cle):
        return hash(cle) % self.taille

    def inserer(self, cle, valeur):
        if self.nb_elements >= self.taille * 0.7:
            self._redimensionner()

        idx = self._hash(cle)
        while self.cles[idx] is not self.VIDE and self.cles[idx] is not self.SUPPRIME:
            if self.cles[idx] == cle:
                self.valeurs[idx] = valeur  # Mise a jour
                return
            idx = (idx + 1) % self.taille  # Sondage lineaire

        self.cles[idx] = cle
        self.valeurs[idx] = valeur
        self.nb_elements += 1

    def chercher(self, cle):
        idx = self._hash(cle)
        while self.cles[idx] is not self.VIDE:
            if self.cles[idx] == cle:
                return self.valeurs[idx]
            idx = (idx + 1) % self.taille
        return None

    def supprimer(self, cle):
        idx = self._hash(cle)
        while self.cles[idx] is not self.VIDE:
            if self.cles[idx] == cle:
                self.cles[idx] = self.SUPPRIME
                self.valeurs[idx] = self.VIDE
                self.nb_elements -= 1
                return True
            idx = (idx + 1) % self.taille
        return False

    def _redimensionner(self):
        anciennes_cles = self.cles
        anciennes_valeurs = self.valeurs
        self.taille *= 2
        self.cles = [self.VIDE] * self.taille
        self.valeurs = [self.VIDE] * self.taille
        self.nb_elements = 0
        for i, cle in enumerate(anciennes_cles):
            if cle is not self.VIDE and cle is not self.SUPPRIME:
                self.inserer(cle, anciennes_valeurs[i])
```

**Comparaison chainage vs adressage ouvert :**

| Critere | Chainage | Adressage ouvert |
|---------|----------|-----------------|
| Facteur de charge | Peut depasser 1 | Doit rester < 1 |
| Cache | Mauvais (pointeurs) | Bon (donnees contigues) |
| Suppression | Simple | Complexe (marqueur) |
| Clustering | Non | Oui (sondage lineaire) |

### 4.5 Complexite

| Operation | Cas moyen | Pire cas |
|-----------|-----------|----------|
| Insertion | O(1) | O(n) |
| Recherche | O(1) | O(n) |
| Suppression | O(1) | O(n) |

Le pire cas O(n) survient quand toutes les cles produisent des collisions (mauvaise fonction de hachage ou table trop petite). En pratique, avec un bon facteur de charge, O(1) amorti est garanti.

---

## 5. Arbres binaires

### 5.1 Definitions

Un **arbre binaire** est une structure arborescente ou chaque noeud a au plus deux fils (gauche et droit). Un arbre est defini recursivement : c'est soit l'arbre vide, soit un noeud avec une valeur et deux sous-arbres.

**Terminologie :**

- **Racine** : noeud sans parent
- **Feuille** : noeud sans fils
- **Hauteur** : longueur du plus long chemin racine-feuille (-1 pour l'arbre vide)
- **Taille** : nombre de noeuds
- **Profondeur** d'un noeud : distance a la racine
- **Arbre complet** : toutes les feuilles sont au meme niveau
- **Arbre parfait** : tous les niveaux sauf le dernier sont remplis, et le dernier est rempli de gauche a droite

**Proprietes :**

- Un arbre binaire de hauteur h contient au plus 2^(h+1) - 1 noeuds
- Un arbre binaire complet de hauteur h contient exactement 2^(h+1) - 1 noeuds
- La hauteur minimale d'un arbre de n noeuds est floor(log2(n))

### 5.2 Implementation

**C :**

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct Noeud {
    int valeur;
    struct Noeud *gauche;
    struct Noeud *droit;
} Noeud;

Noeud *creer_noeud(int val) {
    Noeud *n = malloc(sizeof(Noeud));
    n->valeur = val;
    n->gauche = NULL;
    n->droit = NULL;
    return n;
}

int hauteur(Noeud *n) {
    if (n == NULL) return -1;
    int hg = hauteur(n->gauche);
    int hd = hauteur(n->droit);
    return 1 + (hg > hd ? hg : hd);
}

int taille(Noeud *n) {
    if (n == NULL) return 0;
    return 1 + taille(n->gauche) + taille(n->droit);
}

int nb_feuilles(Noeud *n) {
    if (n == NULL) return 0;
    if (n->gauche == NULL && n->droit == NULL) return 1;
    return nb_feuilles(n->gauche) + nb_feuilles(n->droit);
}
```

**Python :**

```python
class NoeudArbre:
    def __init__(self, valeur, gauche=None, droit=None):
        self.valeur = valeur
        self.gauche = gauche
        self.droit = droit

def hauteur(noeud):
    if noeud is None:
        return -1
    return 1 + max(hauteur(noeud.gauche), hauteur(noeud.droit))

def taille(noeud):
    if noeud is None:
        return 0
    return 1 + taille(noeud.gauche) + taille(noeud.droit)
```

**OCaml :**

```ocaml
type 'a arbre =
  | Vide
  | Noeud of 'a * 'a arbre * 'a arbre

let rec hauteur = function
  | Vide -> -1
  | Noeud (_, g, d) -> 1 + max (hauteur g) (hauteur d)

let rec taille = function
  | Vide -> 0
  | Noeud (_, g, d) -> 1 + taille g + taille d
```

### 5.3 Parcours d'arbres

Trois parcours en profondeur classiques :

```python
def prefixe(noeud):
    """Parcours prefixe (preordre) : racine, gauche, droit"""
    if noeud is None:
        return []
    return [noeud.valeur] + prefixe(noeud.gauche) + prefixe(noeud.droit)

def infixe(noeud):
    """Parcours infixe (inordre) : gauche, racine, droit"""
    if noeud is None:
        return []
    return infixe(noeud.gauche) + [noeud.valeur] + infixe(noeud.droit)

def postfixe(noeud):
    """Parcours postfixe (postordre) : gauche, droit, racine"""
    if noeud is None:
        return []
    return postfixe(noeud.gauche) + postfixe(noeud.droit) + [noeud.valeur]

# Exemple :
#        4
#       / \
#      2   6
#     / \ / \
#    1  3 5  7

arbre = NoeudArbre(4,
    NoeudArbre(2, NoeudArbre(1), NoeudArbre(3)),
    NoeudArbre(6, NoeudArbre(5), NoeudArbre(7)))

print("Prefixe:", prefixe(arbre))    # [4, 2, 1, 3, 6, 5, 7]
print("Infixe:", infixe(arbre))      # [1, 2, 3, 4, 5, 6, 7]
print("Postfixe:", postfixe(arbre))  # [1, 3, 2, 5, 7, 6, 4]
```

**Parcours en largeur (par niveaux) :**

```python
from collections import deque

def parcours_largeur(racine):
    if racine is None:
        return []
    file = deque([racine])
    resultat = []
    while file:
        noeud = file.popleft()
        resultat.append(noeud.valeur)
        if noeud.gauche:
            file.append(noeud.gauche)
        if noeud.droit:
            file.append(noeud.droit)
    return resultat

print("Largeur:", parcours_largeur(arbre))  # [4, 2, 6, 1, 3, 5, 7]
```

---

## 6. Arbres binaires de recherche (ABR)

### 6.1 Propriete ABR

Pour tout noeud n d'un ABR :

- Toutes les valeurs du sous-arbre gauche sont strictement inferieures a n.valeur
- Toutes les valeurs du sous-arbre droit sont strictement superieures a n.valeur

Consequence : le parcours **infixe** d'un ABR donne les elements tries en ordre croissant.

### 6.2 Operations sur un ABR

```python
class ABR:
    def __init__(self, valeur, gauche=None, droit=None):
        self.valeur = valeur
        self.gauche = gauche
        self.droit = droit

def abr_rechercher(arbre, val):
    """Recherche dans un ABR : O(h) ou h = hauteur"""
    if arbre is None:
        return False
    if val == arbre.valeur:
        return True
    elif val < arbre.valeur:
        return abr_rechercher(arbre.gauche, val)
    else:
        return abr_rechercher(arbre.droit, val)

def abr_inserer(arbre, val):
    """Insertion dans un ABR : O(h)"""
    if arbre is None:
        return ABR(val)
    if val < arbre.valeur:
        arbre.gauche = abr_inserer(arbre.gauche, val)
    elif val > arbre.valeur:
        arbre.droit = abr_inserer(arbre.droit, val)
    # Si val == arbre.valeur, on ne fait rien (pas de doublons)
    return arbre

def abr_minimum(arbre):
    """Trouve le minimum (noeud le plus a gauche) : O(h)"""
    while arbre.gauche is not None:
        arbre = arbre.gauche
    return arbre

def abr_maximum(arbre):
    """Trouve le maximum (noeud le plus a droite) : O(h)"""
    while arbre.droit is not None:
        arbre = arbre.droit
    return arbre

def abr_supprimer(arbre, val):
    """Suppression dans un ABR : O(h)
    Trois cas :
    1. Noeud est une feuille -> suppression directe
    2. Noeud a un seul fils -> remplacement par le fils
    3. Noeud a deux fils -> remplacement par le successeur (min du sous-arbre droit)
    """
    if arbre is None:
        return None

    if val < arbre.valeur:
        arbre.gauche = abr_supprimer(arbre.gauche, val)
    elif val > arbre.valeur:
        arbre.droit = abr_supprimer(arbre.droit, val)
    else:
        # Noeud trouve
        if arbre.gauche is None:        # Cas 1 ou 2
            return arbre.droit
        elif arbre.droit is None:       # Cas 2
            return arbre.gauche
        else:                           # Cas 3
            successeur = abr_minimum(arbre.droit)
            arbre.valeur = successeur.valeur
            arbre.droit = abr_supprimer(arbre.droit, successeur.valeur)

    return arbre
```

### 6.3 ABR en OCaml (fonctionnel)

```ocaml
type 'a abr = Vide | Noeud of 'a * 'a abr * 'a abr

let rec rechercher arbre x =
  match arbre with
  | Vide -> false
  | Noeud (v, g, d) ->
    if x = v then true
    else if x < v then rechercher g x
    else rechercher d x

let rec inserer arbre x =
  match arbre with
  | Vide -> Noeud (x, Vide, Vide)
  | Noeud (v, g, d) ->
    if x < v then Noeud (v, inserer g x, d)
    else if x > v then Noeud (v, g, inserer d x)
    else arbre  (* pas de doublons *)

(* L'insertion retourne un NOUVEL arbre -- immutabilite *)
let a = Vide |> inserer 5 |> inserer 3 |> inserer 7 |> inserer 1
```

### 6.4 Complexite

| Operation | Cas moyen (arbre equilibre) | Pire cas (arbre degenere) |
|-----------|----------------------------|---------------------------|
| Recherche | O(log n) | O(n) |
| Insertion | O(log n) | O(n) |
| Suppression | O(log n) | O(n) |

Le pire cas se produit quand l'arbre degenere en liste chainee (insertions dans l'ordre croissant ou decroissant). Solution : les arbres equilibres (AVL, arbres rouge-noir).

---

## 7. Arbres AVL

### 7.1 Principe

Un arbre AVL est un ABR **auto-equilibre** ou, pour chaque noeud, la difference de hauteur entre les sous-arbres gauche et droit (facteur d'equilibre) est au plus 1 en valeur absolue.

**Facteur d'equilibre :** balance(n) = hauteur(gauche) - hauteur(droit)

Si |balance(n)| > 1 apres une insertion ou suppression, il faut reequilibrer par des **rotations**.

### 7.2 Rotations

```
Rotation droite (cas gauche-gauche) :

      z                y
     / \             /   \
    y   T4          x     z
   / \      =>     / \   / \
  x   T3          T1 T2 T3 T4
 / \
T1  T2

Rotation gauche (cas droit-droit) :

  z                  y
 / \               /   \
T1  y             z     x
   / \    =>     / \   / \
  T2  x         T1 T2 T3 T4
     / \
    T3  T4

Cas gauche-droit : rotation gauche sur fils gauche, puis rotation droite
Cas droit-gauche : rotation droite sur fils droit, puis rotation gauche
```

### 7.3 Implementation Python

```python
class NoeudAVL:
    def __init__(self, valeur):
        self.valeur = valeur
        self.gauche = None
        self.droit = None
        self.hauteur = 0

def avl_hauteur(noeud):
    if noeud is None:
        return -1
    return noeud.hauteur

def avl_balance(noeud):
    if noeud is None:
        return 0
    return avl_hauteur(noeud.gauche) - avl_hauteur(noeud.droit)

def avl_maj_hauteur(noeud):
    noeud.hauteur = 1 + max(avl_hauteur(noeud.gauche),
                            avl_hauteur(noeud.droit))

def rotation_droite(z):
    y = z.gauche
    t3 = y.droit
    y.droit = z
    z.gauche = t3
    avl_maj_hauteur(z)
    avl_maj_hauteur(y)
    return y

def rotation_gauche(z):
    y = z.droit
    t2 = y.gauche
    y.gauche = z
    z.droit = t2
    avl_maj_hauteur(z)
    avl_maj_hauteur(y)
    return y

def avl_inserer(noeud, val):
    # Insertion classique ABR
    if noeud is None:
        return NoeudAVL(val)
    if val < noeud.valeur:
        noeud.gauche = avl_inserer(noeud.gauche, val)
    elif val > noeud.valeur:
        noeud.droit = avl_inserer(noeud.droit, val)
    else:
        return noeud  # Pas de doublons

    # Mise a jour de la hauteur
    avl_maj_hauteur(noeud)

    # Calcul du facteur d'equilibre
    bal = avl_balance(noeud)

    # Cas gauche-gauche
    if bal > 1 and val < noeud.gauche.valeur:
        return rotation_droite(noeud)

    # Cas droit-droit
    if bal < -1 and val > noeud.droit.valeur:
        return rotation_gauche(noeud)

    # Cas gauche-droit
    if bal > 1 and val > noeud.gauche.valeur:
        noeud.gauche = rotation_gauche(noeud.gauche)
        return rotation_droite(noeud)

    # Cas droit-gauche
    if bal < -1 and val < noeud.droit.valeur:
        noeud.droit = rotation_droite(noeud.droit)
        return rotation_gauche(noeud)

    return noeud

# Test
racine = None
for val in [10, 20, 30, 40, 50, 25]:
    racine = avl_inserer(racine, val)

# L'arbre reste equilibre malgre les insertions en ordre croissant
print(f"Racine: {racine.valeur}")          # 30
print(f"Hauteur: {avl_hauteur(racine)}")   # 2
print(f"Balance: {avl_balance(racine)}")   # 0 ou +-1
```

**Complexite AVL :** toutes les operations en **O(log n) garanti** car la hauteur est toujours en Theta(log n). Plus precisement, la hauteur d'un AVL de n noeuds est au plus 1.44 * log2(n).

---

## 8. Files de priorite et tas (Heap)

### 8.1 Principe

Une **file de priorite** est une structure ou l'element de priorite maximale (ou minimale) est toujours accessible en O(1). Un **tas binaire** (binary heap) est l'implementation la plus courante.

**Propriete du tas-min :** la valeur de chaque noeud est inferieure ou egale a celles de ses fils.

Un tas binaire est represente efficacement par un **tableau** (pas de pointeurs) :

- Le fils gauche du noeud d'indice i est a l'indice 2i + 1
- Le fils droit est a l'indice 2i + 2
- Le parent est a l'indice (i - 1) / 2

### 8.2 Implementation Python

```python
class TasMin:
    def __init__(self):
        self.elements = []

    def _parent(self, i):
        return (i - 1) // 2

    def _fils_gauche(self, i):
        return 2 * i + 1

    def _fils_droit(self, i):
        return 2 * i + 2

    def _echanger(self, i, j):
        self.elements[i], self.elements[j] = self.elements[j], self.elements[i]

    def _monter(self, i):
        """Remonte un element pour restaurer la propriete de tas (percolation haute)."""
        while i > 0 and self.elements[i] < self.elements[self._parent(i)]:
            self._echanger(i, self._parent(i))
            i = self._parent(i)

    def _descendre(self, i):
        """Descend un element pour restaurer la propriete de tas (percolation basse)."""
        n = len(self.elements)
        while True:
            plus_petit = i
            g = self._fils_gauche(i)
            d = self._fils_droit(i)

            if g < n and self.elements[g] < self.elements[plus_petit]:
                plus_petit = g
            if d < n and self.elements[d] < self.elements[plus_petit]:
                plus_petit = d

            if plus_petit == i:
                break
            self._echanger(i, plus_petit)
            i = plus_petit

    def inserer(self, val):
        """Insertion : O(log n)"""
        self.elements.append(val)
        self._monter(len(self.elements) - 1)

    def extraire_min(self):
        """Extraction du minimum : O(log n)"""
        if not self.elements:
            raise IndexError("Tas vide")
        minimum = self.elements[0]
        dernier = self.elements.pop()
        if self.elements:
            self.elements[0] = dernier
            self._descendre(0)
        return minimum

    def minimum(self):
        """Acces au minimum : O(1)"""
        if not self.elements:
            raise IndexError("Tas vide")
        return self.elements[0]

    def est_vide(self):
        return len(self.elements) == 0


# Test
tas = TasMin()
for val in [15, 10, 20, 8, 12, 25, 5]:
    tas.inserer(val)

while not tas.est_vide():
    print(tas.extraire_min(), end=" ")  # 5 8 10 12 15 20 25
print()
```

### 8.3 Construction en O(n) (heapify)

On peut construire un tas a partir d'un tableau en O(n) (et non O(n log n)) en appliquant `_descendre` de bas en haut :

```python
def heapify(tab):
    """Construit un tas-min en place en O(n)."""
    n = len(tab)
    # Commencer par le dernier noeud interne
    for i in range(n // 2 - 1, -1, -1):
        descendre(tab, i, n)

def descendre(tab, i, n):
    while True:
        plus_petit = i
        g = 2 * i + 1
        d = 2 * i + 2
        if g < n and tab[g] < tab[plus_petit]:
            plus_petit = g
        if d < n and tab[d] < tab[plus_petit]:
            plus_petit = d
        if plus_petit == i:
            break
        tab[i], tab[plus_petit] = tab[plus_petit], tab[i]
        i = plus_petit
```

**Pourquoi O(n) et non O(n log n) ?** La majorite des noeuds sont proches des feuilles et ne descendent que de quelques niveaux. La somme des hauteurs de tous les noeuds est O(n).

### 8.4 Tri par tas (Heapsort)

```python
def heapsort(tab):
    """Tri par tas : O(n log n) dans tous les cas, en place."""
    n = len(tab)
    # Construire un tas-max
    for i in range(n // 2 - 1, -1, -1):
        descendre_max(tab, i, n)
    # Extraire les elements un par un
    for i in range(n - 1, 0, -1):
        tab[0], tab[i] = tab[i], tab[0]
        descendre_max(tab, 0, i)
    return tab

def descendre_max(tab, i, n):
    while True:
        plus_grand = i
        g = 2 * i + 1
        d = 2 * i + 2
        if g < n and tab[g] > tab[plus_grand]:
            plus_grand = g
        if d < n and tab[d] > tab[plus_grand]:
            plus_grand = d
        if plus_grand == i:
            break
        tab[i], tab[plus_grand] = tab[plus_grand], tab[i]
        i = plus_grand

print(heapsort([38, 27, 43, 3, 9, 82, 10]))
# [3, 9, 10, 27, 38, 43, 82]
```

### 8.5 Module heapq de Python

```python
import heapq

# heapq fournit un tas-min
tas = []
heapq.heappush(tas, 15)
heapq.heappush(tas, 10)
heapq.heappush(tas, 20)
heapq.heappush(tas, 5)

print(heapq.heappop(tas))  # 5
print(heapq.heappop(tas))  # 10

# Pour un tas-max : inserer les valeurs negatives
tas_max = []
for val in [15, 10, 20, 5]:
    heapq.heappush(tas_max, -val)
print(-heapq.heappop(tas_max))  # 20
```

### 8.6 Complexite du tas

| Operation | Complexite |
|-----------|------------|
| Insertion | O(log n) |
| Extraction min/max | O(log n) |
| Acces min/max | O(1) |
| Construction (heapify) | O(n) |
| Recherche | O(n) |

---

## 9. Tableau recapitulatif des complexites

| Structure | Acces | Recherche | Insertion | Suppression | Espace |
|-----------|-------|-----------|-----------|-------------|--------|
| Tableau | O(1) | O(n) | O(n) | O(n) | O(n) |
| Liste chainee | O(n) | O(n) | O(1)* | O(1)* | O(n) |
| Pile | O(n) | O(n) | O(1) | O(1) | O(n) |
| File | O(n) | O(n) | O(1) | O(1) | O(n) |
| Table de hachage | -- | O(1) moy | O(1) moy | O(1) moy | O(n) |
| ABR equilibre | -- | O(log n) | O(log n) | O(log n) | O(n) |
| ABR degenere | -- | O(n) | O(n) | O(n) | O(n) |
| AVL | -- | O(log n) | O(log n) | O(log n) | O(n) |
| Tas | -- | O(n) | O(log n) | O(log n) | O(n) |

(*) O(1) si on a un pointeur sur la position d'insertion/suppression, sinon O(n) pour trouver la position.

**Quand utiliser quelle structure ?**

- **Tableau** : acces rapide par indice, taille connue
- **Liste chainee** : insertions/suppressions frequentes, taille variable
- **Pile** : parcours DFS, evaluation d'expressions, backtracking
- **File** : parcours BFS, ordonnancement FIFO
- **Table de hachage** : recherche rapide par cle, comptage, deduplication
- **ABR/AVL** : ensemble ordonne avec recherche, insertion et suppression efficaces
- **Tas** : file de priorite, extraction rapide du min/max

---

## Exercices

### Exercice 1 -- Listes chainees

Implementer en C une fonction `Noeud *inverser(Noeud *tete)` qui inverse une liste chainee en place (sans allocation de nouveaux noeuds). Quelle est la complexite ?

### Exercice 2 -- Piles

Ecrire une fonction Python `infixe_vers_postfixe(expression)` qui convertit une expression infixe (ex: `"3 + 4 * 2"`) en notation postfixe (ex: `"3 4 2 * +"`) en utilisant une pile. Gerer la precedence des operateurs (+, -, *, /).

### Exercice 3 -- Files

Implementer une pile a partir de deux files. Les operations push et pop doivent fonctionner correctement. Quelle est la complexite amortie de chaque operation ?

### Exercice 4 -- Table de hachage

Implementer en Python une fonction qui compte la frequence de chaque mot dans un texte en utilisant un dictionnaire. Afficher les 10 mots les plus frequents. Quelle serait la complexite avec une liste au lieu d'un dictionnaire ?

### Exercice 5 -- ABR

1. Construire un ABR en inserant les valeurs suivantes dans l'ordre : 50, 30, 70, 20, 40, 60, 80.
2. Dessiner l'arbre resultant.
3. Quel est le resultat du parcours infixe ? Du parcours prefixe ?
4. Supprimer le noeud 30. Dessiner l'arbre resultant et expliquer le choix du remplacant.

### Exercice 6 -- AVL

Inserer les valeurs 1, 2, 3, 4, 5, 6, 7 dans un AVL initialement vide. Dessiner l'arbre apres chaque rotation. Comparer la hauteur de l'AVL obtenu avec celle de l'ABR naif (insertions sans equilibrage).

### Exercice 7 -- Tas et file de priorite

On veut fusionner k listes triees en une seule liste triee. Proposer un algorithme utilisant une file de priorite (tas-min) de taille k. Quelle est la complexite si la taille totale des listes est n ?

---

## References

- **Introduction to Algorithms** (CLRS) -- Cormen, Leiserson, Rivest, Stein (chapitres 10-13)
- **Algorithmes** -- Robert Sedgewick, Kevin Wayne
- **Programme officiel MP2I/MPI** -- Bulletin officiel de l'education nationale
- **Cours d'informatique commune MPSI/MP** -- Jean-Pierre Becirspahic (Lycee Louis-le-Grand)
- **Python documentation** -- collections module : <https://docs.python.org/3/library/collections.html>
- **Visualisation d'arbres** -- <https://visualgo.net/en/bst>
