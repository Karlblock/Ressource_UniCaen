# Chapitre 1 -- Programmation : fondements et paradigmes

## Objectifs du chapitre

- Maitriser les types de base et les variables en C, Python et OCaml
- Comprendre les structures de controle (conditionnelles, boucles)
- Savoir definir et utiliser des fonctions, comprendre la portee des variables
- Comprendre la recursivite : cas de base, pile d'appels, recursivite terminale
- Distinguer programmation imperative et programmation fonctionnelle
- Manipuler les types construits (struct en C, types algebriques en OCaml)

---

## 1. Variables et types

### 1.1 Notion de variable

Une variable est un emplacement memoire nomme qui stocke une valeur. En programmation imperative, une variable peut etre modifiee au cours de l'execution (mutation). En programmation fonctionnelle pure, les liaisons sont immutables par defaut.

En C, une variable est directement associee a une adresse memoire et sa taille est fixee par son type. En Python, une variable est une reference vers un objet alloue sur le tas. En OCaml, une liaison `let` associe un nom a une valeur immutable.

### 1.2 Types de base

| Type | C | Python | OCaml |
|------|---|--------|-------|
| Entier | `int`, `long`, `short` | `int` (precision arbitraire) | `int` (63 bits sur 64 bits) |
| Flottant | `float`, `double` | `float` (64 bits) | `float` (64 bits) |
| Caractere | `char` (1 octet) | `str` de longueur 1 | `char` |
| Booleen | `_Bool` ou `stdbool.h` | `bool` | `bool` |
| Chaine | `char[]` ou `char*` | `str` (immutable) | `string` |

**Remarque sur la precision :** en Python, les entiers sont en precision arbitraire (pas de debordement). En C, un `int` est generalement code sur 32 bits (valeurs de -2^31 a 2^31 - 1). En OCaml, les entiers sont codes sur 63 bits (un bit est reserve au GC pour distinguer pointeur et entier immediat).

### 1.3 Declaration et typage

**C -- typage statique explicite :**

```c
#include <stdio.h>
#include <stdbool.h>

int main(void) {
    int age = 25;
    float taille = 1.82f;
    char initiale = 'C';
    bool est_etudiant = true;
    char nom[] = "Alice";

    printf("Nom: %s, Age: %d, Taille: %.2f\n", nom, age, taille);
    printf("Initiale: %c, Etudiant: %d\n", initiale, est_etudiant);
    return 0;
}
```

**Python -- typage dynamique :**

```python
age = 25                # int
taille = 1.82           # float
initiale = 'C'          # str
est_etudiant = True     # bool
nom = "Alice"           # str

print(f"Nom: {nom}, Age: {age}, Taille: {taille:.2f}")
print(f"Initiale: {initiale}, Etudiant: {est_etudiant}")
```

**OCaml -- typage statique avec inference :**

```ocaml
let age = 25                   (* int *)
let taille = 1.82              (* float *)
let initiale = 'C'             (* char *)
let est_etudiant = true        (* bool *)
let nom = "Alice"              (* string *)

let () =
  Printf.printf "Nom: %s, Age: %d, Taille: %.2f\n" nom age taille;
  Printf.printf "Initiale: %c, Etudiant: %b\n" initiale est_etudiant
```

Le compilateur OCaml infere les types sans annotation explicite. Une erreur de type est detectee a la compilation, jamais a l'execution.

### 1.4 Conversions de types

En C, les conversions implicites (promotions) existent mais sont source de bugs. Les conversions explicites (casts) sont preferables :

```c
int a = 7;
int b = 2;
float resultat = (float)a / (float)b;  /* 3.5, pas 3 */

/* Attention : sans cast, division entiere */
float mauvais = a / b;  /* 3.0 ! */
```

En OCaml, aucune conversion implicite. Il faut utiliser les fonctions de conversion :

```ocaml
let a = 7
let b = 2
let resultat = float_of_int a /. float_of_int b  (* 3.5 *)

(* Erreur de compilation si on ecrit : a /. b *)
(* Les operateurs +. *. /. -. sont reserves aux float *)
```

En Python, la division `/` retourne toujours un `float`, `//` fait la division entiere :

```python
a, b = 7, 2
print(a / b)   # 3.5
print(a // b)  # 3
print(int(3.7))  # 3 (troncature vers zero)
print(round(3.7))  # 4
```

### 1.5 Representation memoire en C

Un `int` occupe generalement 4 octets (32 bits), un `double` 8 octets (64 bits), un `char` 1 octet. La taille exacte depend de l'architecture et peut etre obtenue avec `sizeof` :

```c
#include <stdio.h>

int main(void) {
    printf("sizeof(char)   = %zu octets\n", sizeof(char));
    printf("sizeof(int)    = %zu octets\n", sizeof(int));
    printf("sizeof(float)  = %zu octets\n", sizeof(float));
    printf("sizeof(double) = %zu octets\n", sizeof(double));
    printf("sizeof(long)   = %zu octets\n", sizeof(long));
    return 0;
}
```

**Attention au debordement (overflow) :**

```c
#include <stdio.h>
#include <limits.h>

int main(void) {
    int x = INT_MAX;
    printf("INT_MAX = %d\n", x);
    printf("INT_MAX + 1 = %d\n", x + 1);  /* Comportement indefini ! */
    /* En pratique, on observe souvent INT_MIN par wrap-around en complement a 2 */

    unsigned int y = UINT_MAX;
    printf("UINT_MAX = %u\n", y);
    printf("UINT_MAX + 1 = %u\n", y + 1);  /* 0, comportement defini pour unsigned */
    return 0;
}
```

---

## 2. Structures de controle

### 2.1 Conditionnelles

**C :**

```c
int note = 15;

if (note >= 16) {
    printf("Tres bien\n");
} else if (note >= 14) {
    printf("Bien\n");
} else if (note >= 12) {
    printf("Assez bien\n");
} else {
    printf("A ameliorer\n");
}

/* Operateur ternaire */
const char *mention = (note >= 16) ? "TB" : (note >= 14) ? "B" : "AB";
```

**Python :**

```python
note = 15

if note >= 16:
    print("Tres bien")
elif note >= 14:
    print("Bien")
elif note >= 12:
    print("Assez bien")
else:
    print("A ameliorer")

# Expression conditionnelle
mention = "TB" if note >= 16 else "B" if note >= 14 else "AB"
```

**OCaml -- le pattern matching est idiomatique :**

```ocaml
let mention note =
  if note >= 16 then "Tres bien"
  else if note >= 14 then "Bien"
  else if note >= 12 then "Assez bien"
  else "A ameliorer"

(* Avec pattern matching et gardes *)
let mention_v2 note =
  match note with
  | n when n >= 16 -> "Tres bien"
  | n when n >= 14 -> "Bien"
  | n when n >= 12 -> "Assez bien"
  | _ -> "A ameliorer"
```

**Point important :** en OCaml, `if ... then ... else` est une **expression** qui retourne une valeur (les deux branches doivent avoir le meme type). En C, c'est une **instruction** (pas de valeur retournee, sauf via l'operateur ternaire).

### 2.2 Boucle while

La boucle `while` repete un bloc tant qu'une condition est vraie.

**C -- calcul du PGCD par algorithme d'Euclide :**

```c
int pgcd(int a, int b) {
    while (b != 0) {
        int temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}
```

**Python :**

```python
def pgcd(a, b):
    while b != 0:
        a, b = b, a % b
    return a
```

OCaml n'a pas de boucle while idiomatique : on utilise la recursion a la place (voir section 4).

### 2.3 Boucle for

**C -- parcours d'un tableau :**

```c
int tab[] = {3, 1, 4, 1, 5, 9, 2, 6};
int n = sizeof(tab) / sizeof(tab[0]);

for (int i = 0; i < n; i++) {
    printf("tab[%d] = %d\n", i, tab[i]);
}
```

**Python -- parcours par indice et par valeur :**

```python
tab = [3, 1, 4, 1, 5, 9, 2, 6]

# Par indice
for i in range(len(tab)):
    print(f"tab[{i}] = {tab[i]}")

# Pythonique : par valeur
for val in tab:
    print(val)

# Avec indice et valeur
for i, val in enumerate(tab):
    print(f"tab[{i}] = {val}")
```

### 2.4 Equivalence des boucles

Toute boucle `for` peut s'ecrire comme un `while` et reciproquement :

```c
/* for */
for (int i = 0; i < n; i++) {
    /* corps */
}

/* Equivalent while */
int i = 0;
while (i < n) {
    /* corps */
    i++;
}
```

Cette equivalence est fondamentale pour les preuves de correction (invariants de boucle).

---

## 3. Fonctions

### 3.1 Definition et appel

**C :**

```c
/* Declaration (prototype) -- necessaire si la definition est apres l'appel */
double aire_cercle(double rayon);

/* Definition */
double aire_cercle(double rayon) {
    return 3.14159265358979 * rayon * rayon;
}

int main(void) {
    double r = 5.0;
    printf("Aire = %.4f\n", aire_cercle(r));
    return 0;
}
```

**Python :**

```python
import math

def aire_cercle(rayon: float) -> float:
    """Calcule l'aire d'un cercle de rayon donne."""
    return math.pi * rayon ** 2

r = 5.0
print(f"Aire = {aire_cercle(r):.4f}")
```

**OCaml :**

```ocaml
let aire_cercle rayon =
  Float.pi *. rayon *. rayon

let () =
  let r = 5.0 in
  Printf.printf "Aire = %.4f\n" (aire_cercle r)
```

### 3.2 Portee des variables

La portee (scope) d'une variable determine dans quelles parties du code elle est accessible.

**C -- portee de bloc :**

```c
#include <stdio.h>

int global = 100;  /* Variable globale : visible partout */

void f(void) {
    int local = 42;  /* Variable locale a f */
    printf("local = %d, global = %d\n", local, global);

    {
        int bloc = 7;  /* Variable locale au bloc interne */
        printf("bloc = %d\n", bloc);
    }
    /* bloc n'est plus accessible ici */
}
```

**Python -- regle LEGB** (Local, Enclosing, Global, Built-in) :

```python
x = "global"

def externe():
    x = "enclosing"

    def interne():
        x = "local"
        print(x)  # "local"

    interne()
    print(x)  # "enclosing"

externe()
print(x)  # "global"
```

**OCaml -- portee lexicale stricte :**

```ocaml
let x = 10

let f () =
  let x = 20 in     (* masque le x externe dans ce bloc *)
  let g () = x in   (* g capture x = 20 par fermeture *)
  g ()

let () = Printf.printf "%d\n" (f ())   (* 20 *)
let () = Printf.printf "%d\n" x        (* 10 *)
```

### 3.3 Passage par valeur et passage par reference

En C, le passage d'arguments se fait **toujours par valeur**. Pour simuler un passage par reference, on passe un pointeur :

```c
#include <stdio.h>

/* Passage par valeur : la fonction modifie une copie */
void incrementer_val(int x) {
    x++;
    /* x local modifie, l'original intact */
}

/* Passage par pointeur : la fonction modifie l'original */
void incrementer_ref(int *x) {
    (*x)++;
}

/* Echange de deux entiers */
void echanger(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

int main(void) {
    int a = 10;
    incrementer_val(a);
    printf("Apres val: %d\n", a);  /* 10 */

    incrementer_ref(&a);
    printf("Apres ref: %d\n", a);  /* 11 */

    int x = 3, y = 7;
    echanger(&x, &y);
    printf("x=%d, y=%d\n", x, y);  /* x=7, y=3 */
    return 0;
}
```

En Python, le passage est par **reference d'objet**. Les objets mutables (listes, dictionnaires) peuvent etre modifies en place, les immutables (int, str, tuple) non :

```python
def ajouter_element(lst, elem):
    lst.append(elem)  # Modifie la liste originale (objet mutable)

def tenter_reassigner(lst):
    lst = [1, 2, 3]  # Reassignation locale, pas d'effet exterieur

ma_liste = [10, 20]
ajouter_element(ma_liste, 30)
print(ma_liste)  # [10, 20, 30]

tenter_reassigner(ma_liste)
print(ma_liste)  # [10, 20, 30] -- inchange
```

En OCaml, les valeurs sont immutables par defaut. Les references (`ref`) permettent la mutabilite explicite :

```ocaml
let x = ref 0      (* creation d'une reference *)
let () = x := 42   (* modification *)
let () = Printf.printf "%d\n" !x   (* lecture : 42 *)
```

---

## 4. Recursivite

### 4.1 Principe

Une fonction recursive est une fonction qui s'appelle elle-meme. Elle doit posseder :
1. Un **cas de base** (condition d'arret) pour eviter la recursion infinie
2. Un **cas recursif** qui reduit le probleme vers le cas de base

### 4.2 Exemple fondamental : la factorielle

**Definition mathematique :** n! = 1 si n = 0, sinon n! = n * (n-1)!

**C :**

```c
long factorielle(int n) {
    if (n == 0) return 1;           /* Cas de base */
    return n * factorielle(n - 1);  /* Cas recursif */
}
```

**Python :**

```python
def factorielle(n: int) -> int:
    if n == 0:
        return 1
    return n * factorielle(n - 1)
```

**OCaml :**

```ocaml
let rec factorielle n =
  if n = 0 then 1
  else n * factorielle (n - 1)
```

Note : en OCaml, le mot-cle `rec` est obligatoire pour declarer une fonction recursive.

### 4.3 Pile d'appels

Chaque appel recursif empile un cadre (frame) sur la pile d'execution. Pour `factorielle(4)` :

```
factorielle(4)
  -> 4 * factorielle(3)
       -> 3 * factorielle(2)
            -> 2 * factorielle(1)
                 -> 1 * factorielle(0)
                      -> 1          (cas de base)
                 -> 1 * 1 = 1
            -> 2 * 1 = 2
       -> 3 * 2 = 6
  -> 4 * 6 = 24
```

La profondeur de recursion est O(n). Chaque frame consomme de la memoire. Pour n tres grand, on risque un **debordement de pile** (stack overflow). En C, la taille de pile est typiquement de 1 a 8 Mo. En Python, la limite par defaut est de 1000 appels recursifs (`sys.setrecursionlimit` pour modifier).

### 4.4 Recursivite terminale

Un appel recursif est **terminal** (tail call) s'il est la derniere operation de la fonction -- il n'y a plus rien a faire apres le retour de l'appel recursif. Certains compilateurs/interpreteurs optimisent les appels terminaux en reutilisant la meme frame (tail call optimization, TCO).

**Factorielle non terminale :** `n * factorielle(n-1)` -- la multiplication est effectuee **apres** le retour.

**Factorielle terminale en OCaml :**

```ocaml
let factorielle n =
  let rec aux acc k =
    if k = 0 then acc
    else aux (acc * k) (k - 1)   (* appel terminal : rien apres *)
  in
  aux 1 n
```

**En C (le compilateur peut optimiser avec -O2) :**

```c
long fact_terminale(int n, long acc) {
    if (n == 0) return acc;
    return fact_terminale(n - 1, acc * n);  /* appel terminal */
}

long factorielle(int n) {
    return fact_terminale(n, 1);
}
```

**En Python** (pas de TCO garanti, mais le pattern est utile conceptuellement) :

```python
def factorielle_term(n, acc=1):
    if n == 0:
        return acc
    return factorielle_term(n - 1, acc * n)
```

**Attention :** Python ne fait pas de TCO. Pour de grands n, utiliser une version iterative ou `sys.setrecursionlimit`.

### 4.5 Exemples classiques

**Suite de Fibonacci (recursion naive vs memorisation) :**

```python
# Naive : O(2^n) -- tres lent, recalcul massif
def fib_naive(n):
    if n <= 1:
        return n
    return fib_naive(n - 1) + fib_naive(n - 2)

# Avec memorisation (top-down) : O(n) temps, O(n) espace
from functools import lru_cache

@lru_cache(maxsize=None)
def fib_memo(n):
    if n <= 1:
        return n
    return fib_memo(n - 1) + fib_memo(n - 2)

# Iteratif (bottom-up) : O(n) temps, O(1) espace
def fib_iter(n):
    if n <= 1:
        return n
    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    return b
```

**Exponentiation rapide :**

```python
def puissance(x, n):
    """Calcule x^n en O(log n) multiplications."""
    if n == 0:
        return 1
    if n % 2 == 0:
        demi = puissance(x, n // 2)
        return demi * demi
    else:
        return x * puissance(x, n - 1)
```

```c
long puissance(long x, int n) {
    if (n == 0) return 1;
    if (n % 2 == 0) {
        long demi = puissance(x, n / 2);
        return demi * demi;
    }
    return x * puissance(x, n - 1);
}
```

**Tours de Hanoi :**

```python
def hanoi(n, source, auxiliaire, destination):
    """Deplace n disques de source vers destination via auxiliaire.
    Complexite : 2^n - 1 deplacements.
    """
    if n == 1:
        print(f"Deplacer disque 1 de {source} vers {destination}")
        return
    hanoi(n - 1, source, destination, auxiliaire)
    print(f"Deplacer disque {n} de {source} vers {destination}")
    hanoi(n - 1, auxiliaire, source, destination)

hanoi(3, 'A', 'B', 'C')
```

---

## 5. Programmation imperative vs fonctionnelle

### 5.1 Paradigme imperatif

Le paradigme imperatif decrit **comment** le programme doit executer ses taches, instruction par instruction. L'etat du programme est modifie par des affectations successives.

**Caracteristiques :**
- Variables mutables
- Boucles (`for`, `while`)
- Effets de bord (modification de variables, I/O)
- Controle explicite du flux d'execution

**Exemple C -- somme des carres des nombres pairs :**

```c
int somme_carres_pairs(int tab[], int n) {
    int somme = 0;
    for (int i = 0; i < n; i++) {
        if (tab[i] % 2 == 0) {
            somme += tab[i] * tab[i];
        }
    }
    return somme;
}
```

### 5.2 Paradigme fonctionnel

Le paradigme fonctionnel decrit **quoi** calculer. Les fonctions sont des citoyens de premiere classe, les donnees sont immutables, et on compose des transformations.

**Caracteristiques :**
- Immutabilite par defaut
- Fonctions pures (pas d'effets de bord)
- Fonctions d'ordre superieur (map, filter, fold)
- Recursion au lieu de boucles
- Transparence referentielle (une expression peut etre remplacee par sa valeur)

**Meme exemple en OCaml :**

```ocaml
let somme_carres_pairs lst =
  lst
  |> List.filter (fun x -> x mod 2 = 0)
  |> List.map (fun x -> x * x)
  |> List.fold_left (+) 0
```

**En Python (style fonctionnel) :**

```python
def somme_carres_pairs(tab):
    return sum(x**2 for x in tab if x % 2 == 0)

# Ou avec map/filter explicites
from functools import reduce
def somme_carres_pairs_v2(tab):
    pairs = filter(lambda x: x % 2 == 0, tab)
    carres = map(lambda x: x**2, pairs)
    return reduce(lambda a, b: a + b, carres, 0)
```

### 5.3 Fonctions d'ordre superieur

Une fonction d'ordre superieur est une fonction qui prend une fonction en argument ou qui retourne une fonction.

**map, filter, fold en OCaml :**

```ocaml
(* map : applique f a chaque element *)
let doubles = List.map (fun x -> 2 * x) [1; 2; 3; 4]
(* [2; 4; 6; 8] *)

(* filter : garde les elements satisfaisant le predicat *)
let positifs = List.filter (fun x -> x > 0) [-3; 1; -2; 4; -1; 5]
(* [1; 4; 5] *)

(* fold_left : accumule de gauche a droite *)
let somme = List.fold_left (+) 0 [1; 2; 3; 4; 5]
(* 15 *)

(* Composition *)
let somme_des_positifs lst =
  lst |> List.filter (fun x -> x > 0) |> List.fold_left (+) 0
```

**Application partielle et currying en OCaml :**

```ocaml
let ajouter a b = a + b      (* int -> int -> int *)
let ajouter_5 = ajouter 5    (* int -> int -- application partielle *)
let x = ajouter_5 3          (* 8 *)

let appliquer_deux_fois f x = f (f x)
let plus_10 = appliquer_deux_fois (ajouter 5)
let y = plus_10 0             (* 10 *)
```

### 5.4 Comparaison

| Critere | Imperatif (C) | Fonctionnel (OCaml) |
|---------|---------------|---------------------|
| Etat | Mutable | Immutable par defaut |
| Controle | Boucles | Recursion |
| Abstraction | Procedures | Fonctions d'ordre superieur |
| Effets de bord | Frequents | Evites / isoles |
| Raisonnement | Suivre les mutations | Evaluation d'expressions |
| Performance | Controle fin de la memoire | Allocation/GC automatique |
| Debug | Suivre les etats successifs | Reproductibilite (purete) |

### 5.5 Quand utiliser quoi ?

- **Imperatif** : programmation systeme, embarque, performance critique, manipulation directe de la memoire
- **Fonctionnel** : traitement de donnees, compilateurs, preuves de correction, parallelisme
- **Multi-paradigme** (Python, Scala, Rust) : combiner les deux selon le contexte

---

## 6. Types construits

### 6.1 Structures en C

Les `struct` permettent de regrouper des donnees heterogenes sous un meme type :

```c
#include <stdio.h>
#include <string.h>
#include <math.h>

/* Definition d'un type Point */
typedef struct {
    double x;
    double y;
} Point;

/* Fonction utilisant le type Point */
double distance(Point a, Point b) {
    double dx = a.x - b.x;
    double dy = a.y - b.y;
    return sqrt(dx * dx + dy * dy);
}

/* Structure plus complexe */
typedef struct {
    char nom[50];
    int age;
    float moyenne;
} Etudiant;

void afficher_etudiant(Etudiant e) {
    printf("Nom: %s, Age: %d, Moyenne: %.2f\n", e.nom, e.age, e.moyenne);
}

int main(void) {
    Point p1 = {3.0, 4.0};
    Point p2 = {0.0, 0.0};
    printf("Distance = %.2f\n", distance(p1, p2));  /* 5.00 */

    Etudiant e1;
    strcpy(e1.nom, "Alice");
    e1.age = 20;
    e1.moyenne = 15.5;
    afficher_etudiant(e1);

    return 0;
}
```

**Enumerations en C :**

```c
typedef enum {
    LUNDI, MARDI, MERCREDI, JEUDI, VENDREDI, SAMEDI, DIMANCHE
} Jour;

const char *nom_jour(Jour j) {
    const char *noms[] = {
        "Lundi", "Mardi", "Mercredi", "Jeudi",
        "Vendredi", "Samedi", "Dimanche"
    };
    return noms[j];
}
```

### 6.2 Types algebriques en OCaml

OCaml offre des types bien plus expressifs : les **types sommes** (variantes) et les **types produits** (enregistrements).

**Type somme (union disjointe) :**

```ocaml
(* Un type forme geometrique *)
type forme =
  | Cercle of float                  (* rayon *)
  | Rectangle of float * float       (* largeur, hauteur *)
  | Triangle of float * float * float (* cotes a, b, c *)

let aire = function
  | Cercle r -> Float.pi *. r *. r
  | Rectangle (l, h) -> l *. h
  | Triangle (a, b, c) ->
    let s = (a +. b +. c) /. 2.0 in
    sqrt (s *. (s -. a) *. (s -. b) *. (s -. c))

let () =
  Printf.printf "Aire cercle: %.2f\n" (aire (Cercle 5.0));
  Printf.printf "Aire rectangle: %.2f\n" (aire (Rectangle (3.0, 4.0)));
  Printf.printf "Aire triangle: %.2f\n" (aire (Triangle (3.0, 4.0, 5.0)))
```

Le compilateur verifie l'exhaustivite du pattern matching : si on oublie un cas, il emet un avertissement.

**Type enregistrement (record) :**

```ocaml
type etudiant = {
  nom : string;
  age : int;
  moyenne : float;
}

let afficher_etudiant e =
  Printf.printf "Nom: %s, Age: %d, Moyenne: %.2f\n" e.nom e.age e.moyenne

let () =
  let e1 = { nom = "Alice"; age = 20; moyenne = 15.5 } in
  afficher_etudiant e1
```

**Type option -- gestion explicite de l'absence de valeur :**

```ocaml
(* Recherche dans une liste *)
let rec chercher lst x =
  match lst with
  | [] -> None
  | t :: _ when t = x -> Some t
  | _ :: q -> chercher q x

let () =
  match chercher [1; 2; 3; 4; 5] 3 with
  | Some v -> Printf.printf "Trouve: %d\n" v
  | None -> Printf.printf "Non trouve\n"
```

Le type `option` remplace avantageusement les pointeurs nuls de C (pas de NullPointerException possible).

**Type recursif -- definition d'un arbre binaire :**

```ocaml
type 'a arbre =
  | Vide
  | Noeud of 'a * 'a arbre * 'a arbre

let rec taille = function
  | Vide -> 0
  | Noeud (_, g, d) -> 1 + taille g + taille d

let rec hauteur = function
  | Vide -> -1
  | Noeud (_, g, d) -> 1 + max (hauteur g) (hauteur d)

let rec infixe = function
  | Vide -> []
  | Noeud (v, g, d) -> infixe g @ [v] @ infixe d

let exemple =
  Noeud (1,
    Noeud (2, Noeud (4, Vide, Vide), Vide),
    Noeud (3, Vide, Noeud (5, Vide, Vide)))

let () =
  Printf.printf "Taille: %d, Hauteur: %d\n" (taille exemple) (hauteur exemple)
```

### 6.3 Equivalent Python avec des dataclasses

Python n'a pas de types algebriques natifs mais les `dataclass` et le structural pattern matching (3.10+) offrent une approche similaire :

```python
from dataclasses import dataclass
import math

@dataclass
class Cercle:
    rayon: float

@dataclass
class Rectangle:
    largeur: float
    hauteur: float

@dataclass
class Triangle:
    a: float
    b: float
    c: float

Forme = Cercle | Rectangle | Triangle

def aire(forme: Forme) -> float:
    match forme:
        case Cercle(rayon=r):
            return math.pi * r ** 2
        case Rectangle(largeur=l, hauteur=h):
            return l * h
        case Triangle(a=a, b=b, c=c):
            s = (a + b + c) / 2
            return math.sqrt(s * (s - a) * (s - b) * (s - c))

print(f"Aire cercle: {aire(Cercle(5.0)):.2f}")
print(f"Aire rectangle: {aire(Rectangle(3.0, 4.0)):.2f}")
print(f"Aire triangle: {aire(Triangle(3.0, 4.0, 5.0)):.2f}")
```

### 6.4 Listes en OCaml

Les listes OCaml sont des listes chainees immutables, fondamentales en programmation fonctionnelle :

```ocaml
(* Construction *)
let l1 = [1; 2; 3; 4; 5]
let l2 = 0 :: l1              (* ajout en tete : O(1) *)
let l3 = l1 @ [6; 7]          (* concatenation : O(n) *)

(* Deconstruction par pattern matching *)
let rec somme = function
  | [] -> 0
  | x :: xs -> x + somme xs

(* Fonctions classiques *)
let carres = List.map (fun x -> x * x) l1
let pairs = List.filter (fun x -> x mod 2 = 0) l1
let total = List.fold_left (+) 0 l1

let () =
  Printf.printf "Somme: %d\n" (somme l1);
  Printf.printf "Total: %d\n" total
```

---

## 7. Applications pratiques

### 7.1 Programme complet : gestion d'un carnet de notes (C)

```c
#include <stdio.h>
#include <string.h>

#define MAX_ETUDIANTS 100

typedef struct {
    char nom[50];
    float notes[10];
    int nb_notes;
} Etudiant;

float moyenne(Etudiant e) {
    if (e.nb_notes == 0) return 0.0f;
    float somme = 0.0f;
    for (int i = 0; i < e.nb_notes; i++) {
        somme += e.notes[i];
    }
    return somme / e.nb_notes;
}

void ajouter_note(Etudiant *e, float note) {
    if (e->nb_notes < 10) {
        e->notes[e->nb_notes] = note;
        e->nb_notes++;
    }
}

int main(void) {
    Etudiant alice;
    strcpy(alice.nom, "Alice");
    alice.nb_notes = 0;

    ajouter_note(&alice, 15.0);
    ajouter_note(&alice, 12.5);
    ajouter_note(&alice, 18.0);

    printf("%s : moyenne = %.2f\n", alice.nom, moyenne(alice));
    return 0;
}
```

### 7.2 Programme complet : filtrage et transformation (OCaml)

```ocaml
(* Pipeline de traitement d'une liste d'etudiants *)
type etudiant = { nom : string; notes : float list }

let moyenne e =
  let somme = List.fold_left (+.) 0.0 e.notes in
  somme /. float_of_int (List.length e.notes)

let mention moy =
  if moy >= 16.0 then "Tres bien"
  else if moy >= 14.0 then "Bien"
  else if moy >= 12.0 then "Assez bien"
  else "Passable"

let etudiants = [
  { nom = "Alice"; notes = [15.0; 12.5; 18.0] };
  { nom = "Bob";   notes = [8.0; 10.0; 9.5] };
  { nom = "Carol"; notes = [17.0; 16.5; 19.0] };
]

let () =
  etudiants
  |> List.map (fun e -> (e.nom, moyenne e))
  |> List.filter (fun (_, m) -> m >= 10.0)
  |> List.sort (fun (_, m1) (_, m2) -> compare m2 m1)
  |> List.iter (fun (nom, moy) ->
       Printf.printf "%s : %.2f (%s)\n" nom moy (mention moy))
```

---

## Exercices

### Exercice 1 -- Types et conversions

Ecrire en C une fonction `celsius_vers_fahrenheit` qui convertit une temperature. Attention au type de retour. Tester avec des valeurs entieres et flottantes. Que se passe-t-il si on utilise `int` partout ?

### Exercice 2 -- Boucles et tableaux

Ecrire en C une fonction `int maximum(int tab[], int n)` qui retourne le maximum d'un tableau, et une fonction `void inverser(int tab[], int n)` qui inverse le tableau en place. Ecrire les versions Python equivalentes.

### Exercice 3 -- Recursivite

1. Ecrire une fonction recursive `puissance(x, n)` qui calcule x^n en C et en Python.
2. Quelle est la complexite en nombre de multiplications ?
3. Ecrire une version par exponentiation rapide (diviser n par 2 a chaque etape). Complexite ?

### Exercice 4 -- Recursivite terminale

Transformer la fonction `somme_liste` suivante en version terminale (OCaml) :

```ocaml
let rec somme_liste = function
  | [] -> 0
  | x :: xs -> x + somme_liste xs
```

Ecrire egalement une version terminale de `longueur` et de `reverse`.

### Exercice 5 -- Types algebriques

Definir en OCaml un type `expression` representant des expressions arithmetiques (constantes, addition, multiplication, negation). Ecrire :
1. `evaluer : expression -> int`
2. `afficher : expression -> string`
3. `simplifier : expression -> expression` (simplifier 0 + e en e, 1 * e en e, etc.)

### Exercice 6 -- Paradigmes

Ecrire une fonction qui, etant donne une liste d'entiers, retourne la somme des cubes des nombres impairs superieurs a 5 :
1. En C (style imperatif avec boucle)
2. En OCaml (style fonctionnel avec pipeline)
3. En Python (les deux styles)

### Exercice 7 -- Passage par reference

Ecrire en C une fonction `void tri_trois(int *a, int *b, int *c)` qui trie trois entiers en ordre croissant. Utiliser la fonction `echanger` definie dans le cours.

---

## References

- **The C Programming Language** -- Brian Kernighan, Dennis Ritchie (K&R)
- **Real World OCaml** -- Yaron Minsky, Anil Madhavapeddy, Jason Hickey (disponible en ligne : https://dev.realworldocaml.org/)
- **Structure and Interpretation of Computer Programs** (SICP) -- Abelson, Sussman
- **Programme officiel MP2I/MPI** -- Bulletin officiel de l'education nationale
- **OCaml manual** -- https://v2.ocaml.org/manual/
- **Python documentation** -- https://docs.python.org/3/
