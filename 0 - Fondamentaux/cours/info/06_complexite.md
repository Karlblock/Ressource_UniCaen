# Chapitre 6 — Complexite algorithmique et classes de complexite

## Objectifs du chapitre

- Maitriser les notations asymptotiques O, Omega, Theta avec leurs definitions formelles
- Savoir analyser la complexite temporelle et spatiale d'un algorithme
- Connaitre la complexite des algorithmes classiques (tri, recherche, graphes)
- Appliquer le theoreme maitre pour resoudre des recurrences
- Comprendre les classes P, NP, co-NP et la notion de NP-completude
- Connaitre le theoreme de Cook-Levin et des exemples de problemes NP-complets
- Saisir les implications en cryptographie (securite computationnelle)

---

## 1. Notations asymptotiques

### 1.1 Motivation

Lorsqu'on analyse un algorithme, on s'interesse au comportement de son temps d'execution (ou de sa consommation memoire) lorsque la taille de l'entree `n` tend vers l'infini. Les constantes multiplicatives et les termes de bas degre deviennent negligeables : on cherche un **ordre de grandeur**.

### 1.2 Definition formelle de O (grand O)

Soit `f, g : N -> R+`. On dit que `f(n) = O(g(n))` s'il existe deux constantes `c > 0` et `n0 in N` telles que :

```
pour tout n >= n0,  f(n) <= c * g(n)
```

**Interpretation** : `f` est **majoree asymptotiquement** par `g`, a une constante multiplicative pres.

**Exemple** : Montrons que `3n^2 + 7n + 2 = O(n^2)`.

Pour `n >= 1`, on a `7n <= 7n^2` et `2 <= 2n^2`, donc :

```
3n^2 + 7n + 2 <= 3n^2 + 7n^2 + 2n^2 = 12n^2
```

Ainsi avec `c = 12` et `n0 = 1`, la definition est satisfaite.

### 1.3 Definition formelle de Omega

On dit que `f(n) = Omega(g(n))` s'il existe `c > 0` et `n0 in N` tels que :

```
pour tout n >= n0,  f(n) >= c * g(n)
```

**Interpretation** : `f` est **minoree asymptotiquement** par `g`.

**Exemple** : `3n^2 + 7n + 2 = Omega(n^2)` car `3n^2 + 7n + 2 >= 3n^2` pour tout `n >= 0`, avec `c = 3`.

### 1.4 Definition formelle de Theta

On dit que `f(n) = Theta(g(n))` si et seulement si :

```
f(n) = O(g(n))  ET  f(n) = Omega(g(n))
```

Autrement dit, il existe `c1, c2 > 0` et `n0` tels que :

```
pour tout n >= n0,  c1 * g(n) <= f(n) <= c2 * g(n)
```

**Interpretation** : `f` et `g` ont le **meme ordre de croissance**.

### 1.5 Notations complementaires

- `f(n) = o(g(n))` (petit o) : `lim(n->inf) f(n)/g(n) = 0`. Croissance **strictement inferieure**.
- `f(n) = omega(g(n))` (petit omega) : `lim(n->inf) f(n)/g(n) = +inf`. Croissance **strictement superieure**.

**Exemples** :
- `n = o(n^2)` car `n/n^2 = 1/n -> 0`
- `n^2 = o(2^n)` car tout polynome est domine par une exponentielle
- `log(n) = o(n^epsilon)` pour tout `epsilon > 0`

### 1.6 Proprietes fondamentales

**Transitivite** : Si `f = O(g)` et `g = O(h)`, alors `f = O(h)`. Idem pour Omega et Theta.

**Somme** : `O(f) + O(g) = O(max(f, g))`. Consequence : dans une sequence de blocs, on retient le bloc dominant.

**Produit** : `O(f) * O(g) = O(f * g)`. Consequence : boucles imbriquees, on multiplie les complexites.

**Polynomes** : Si `P(n)` est un polynome de degre `d`, alors `P(n) = Theta(n^d)`.

**Hierarchie usuelle** :

```
O(1) < O(log n) < O(sqrt(n)) < O(n) < O(n log n) < O(n^2) < O(n^3) < O(2^n) < O(n!)
```

### 1.7 Exemple en Python — mesure empirique

```python
import time

def recherche_lineaire(tab, x):
    """O(n) -- parcours sequentiel"""
    for i in range(len(tab)):
        if tab[i] == x:
            return i
    return -1

def recherche_dichotomique(tab, x):
    """O(log n) -- necessite un tableau trie"""
    lo, hi = 0, len(tab) - 1
    while lo <= hi:
        mid = (lo + hi) // 2
        if tab[mid] == x:
            return mid
        elif tab[mid] < x:
            lo = mid + 1
        else:
            hi = mid - 1
    return -1

# Comparaison empirique
for n in [10_000, 100_000, 1_000_000]:
    tab = list(range(n))
    cible = n  # element absent (pire cas)

    t0 = time.perf_counter()
    recherche_lineaire(tab, cible)
    t1 = time.perf_counter()
    recherche_dichotomique(tab, cible)
    t2 = time.perf_counter()

    print(f"n={n:>10} | lineaire: {t1-t0:.6f}s | dichotomique: {t2-t1:.6f}s")
```

**Sortie typique** :

```
n=     10000 | lineaire: 0.000412s | dichotomique: 0.000005s
n=    100000 | lineaire: 0.004107s | dichotomique: 0.000006s
n=   1000000 | lineaire: 0.041523s | dichotomique: 0.000008s
```

On observe que le temps lineaire est multiplie par ~10 quand n est multiplie par 10, tandis que le temps logarithmique reste quasi-constant.

---

## 2. Analyse de complexite temporelle et spatiale

### 2.1 Complexite temporelle

On compte le nombre d'**operations elementaires** (comparaisons, affectations, operations arithmetiques) en fonction de la taille de l'entree `n`.

On distingue trois cas :
- **Meilleur cas** : entree la plus favorable (rarement informatif)
- **Pire cas** : entree la plus defavorable (garantie de performance)
- **Cas moyen** : esperance sur une distribution d'entrees (plus realiste, mais plus difficile a calculer)

### 2.2 Complexite spatiale

On mesure la **quantite de memoire supplementaire** utilisee (au-dela de l'entree elle-meme).

- Un algorithme **en place** utilise O(1) memoire supplementaire (ex : tri par insertion)
- Un tri fusion utilise O(n) memoire supplementaire
- Une recherche en profondeur (DFS) sur un graphe utilise O(V) pour la pile d'appels

### 2.3 Complexite amortie

La complexite amortie mesure le cout moyen d'une operation sur une **sequence** d'operations, meme si certaines operations individuelles sont couteuses.

**Exemple classique** : tableau dynamique (vector en C++, list en Python).

L'ajout d'un element est en O(1) en general, mais O(n) quand il faut doubler la capacite. Sur une sequence de n insertions, le cout total est O(n), donc le cout amorti par insertion est O(1).

**Methode du potentiel** : on definit une fonction de potentiel Phi(D_i) sur l'etat de la structure apres la i-eme operation. Le cout amorti est :

```
c_i_amorti = c_i_reel + Phi(D_i) - Phi(D_{i-1})
```

### 2.4 Methodes d'analyse

**Boucles simples** : compter les iterations.

```c
// O(n)
int somme(int tab[], int n) {
    int s = 0;
    for (int i = 0; i < n; i++) {
        s += tab[i];    // 1 addition, 1 affectation : O(1) par iteration
    }
    return s;
}
```

**Boucles imbriquees** : multiplier les bornes.

```c
// O(n^2)
void tri_selection(int tab[], int n) {
    for (int i = 0; i < n - 1; i++) {         // n-1 iterations
        int min_idx = i;
        for (int j = i + 1; j < n; j++) {     // au plus n-1 iterations
            if (tab[j] < tab[min_idx])
                min_idx = j;
        }
        int tmp = tab[i];
        tab[i] = tab[min_idx];
        tab[min_idx] = tmp;
    }
}
// Nombre total de comparaisons : (n-1) + (n-2) + ... + 1 = n(n-1)/2 = Theta(n^2)
```

**Boucle logarithmique** :

```c
// O(n log n)
int f(int n) {
    int s = 0;
    for (int i = 1; i <= n; i *= 2)   // log2(n) iterations
        for (int j = 0; j < n; j++)    // n iterations
            s++;
    return s;
}
```

**Recurrence** : resoudre une equation de recurrence.

```
T(n) = 2T(n/2) + O(n)       ->  T(n) = O(n log n)    (tri fusion)
T(n) = T(n/2) + O(1)        ->  T(n) = O(log n)       (recherche dichotomique)
T(n) = 2T(n/2) + O(1)       ->  T(n) = O(n)           (parcours d'arbre binaire)
T(n) = T(n-1) + O(n)        ->  T(n) = O(n^2)          (tri insertion pire cas)
T(n) = T(n-1) + O(1)        ->  T(n) = O(n)           (parcours lineaire recursif)
T(n) = 2T(n-1) + O(1)       ->  T(n) = O(2^n)         (fibonacci naif)
```

### 2.5 Theoreme maitre (Master Theorem)

Pour une recurrence de la forme `T(n) = a * T(n/b) + O(n^d)` avec `a >= 1, b > 1, d >= 0` :

| Cas | Condition | Complexite |
|-----|-----------|-----------|
| 1 | `d < log_b(a)` | `T(n) = Theta(n^{log_b(a)})` |
| 2 | `d = log_b(a)` | `T(n) = Theta(n^d * log n)` |
| 3 | `d > log_b(a)` | `T(n) = Theta(n^d)` |

**Intuition** :
- Cas 1 : le travail aux feuilles domine (beaucoup de sous-problemes)
- Cas 2 : travail reparti uniformement sur tous les niveaux
- Cas 3 : le travail a la racine domine (combinaison couteuse)

**Application au tri fusion** : `a = 2, b = 2, d = 1`. On a `log_2(2) = 1 = d`, donc cas 2 : `T(n) = Theta(n log n)`.

**Application a la multiplication de Karatsuba** : `a = 3, b = 2, d = 1`. On a `log_2(3) ~ 1.585 > 1 = d`, donc cas 1 : `T(n) = Theta(n^{log_2(3)}) ~ Theta(n^{1.585})`. Mieux que la multiplication naive en `Theta(n^2)`.

**Application a Strassen** (multiplication matricielle) : `a = 7, b = 2, d = 2`. On a `log_2(7) ~ 2.807 > 2 = d`, donc cas 1 : `T(n) = Theta(n^{log_2(7)}) ~ Theta(n^{2.807})`. Mieux que le `Theta(n^3)` naif.

### 2.6 Implementation Python du theoreme maitre

```python
import math

def theoreme_maitre(a, b, d):
    """
    Applique le theoreme maitre a T(n) = a*T(n/b) + O(n^d).
    Retourne une description de la complexite.
    """
    log_b_a = math.log(a) / math.log(b)

    print(f"Recurrence : T(n) = {a}*T(n/{b}) + O(n^{d})")
    print(f"log_{b}({a}) = {log_b_a:.4f}")

    if d < log_b_a:
        print(f"Cas 1 : d = {d} < log_b(a) = {log_b_a:.4f}")
        print(f"  => T(n) = Theta(n^{log_b_a:.4f})")
    elif abs(d - log_b_a) < 1e-9:
        print(f"Cas 2 : d = {d} = log_b(a)")
        print(f"  => T(n) = Theta(n^{d} * log n)")
    else:
        print(f"Cas 3 : d = {d} > log_b(a) = {log_b_a:.4f}")
        print(f"  => T(n) = Theta(n^{d})")
    print()

# Exemples
theoreme_maitre(2, 2, 1)   # Tri fusion
theoreme_maitre(3, 2, 1)   # Karatsuba
theoreme_maitre(7, 2, 2)   # Strassen
theoreme_maitre(4, 2, 2)   # T(n) = 4T(n/2) + n^2
theoreme_maitre(2, 2, 0)   # T(n) = 2T(n/2) + O(1) (parcours arbre)
```

---

## 3. Complexite des algorithmes classiques

### 3.1 Algorithmes de tri

| Algorithme | Meilleur | Moyen | Pire | Espace | Stable |
|-----------|----------|-------|------|--------|--------|
| Tri insertion | Theta(n) | Theta(n^2) | Theta(n^2) | O(1) | Oui |
| Tri selection | Theta(n^2) | Theta(n^2) | Theta(n^2) | O(1) | Non |
| Tri fusion | Theta(n log n) | Theta(n log n) | Theta(n log n) | O(n) | Oui |
| Tri rapide (quicksort) | Theta(n log n) | Theta(n log n) | Theta(n^2) | O(log n) | Non |
| Tri par tas (heapsort) | Theta(n log n) | Theta(n log n) | Theta(n log n) | O(1) | Non |
| Tri comptage | Theta(n + k) | Theta(n + k) | Theta(n + k) | O(k) | Oui |

**Borne inferieure** : tout tri par comparaisons necessite `Omega(n log n)` comparaisons dans le pire cas. Preuve par arbre de decision : `n!` feuilles, hauteur `>= log_2(n!) = Theta(n log n)` par la formule de Stirling.

### 3.2 Implementation du tri fusion en C

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void fusion(int tab[], int gauche, int milieu, int droite) {
    int n1 = milieu - gauche + 1;
    int n2 = droite - milieu;

    int *L = malloc(n1 * sizeof(int));
    int *R = malloc(n2 * sizeof(int));

    memcpy(L, tab + gauche, n1 * sizeof(int));
    memcpy(R, tab + milieu + 1, n2 * sizeof(int));

    int i = 0, j = 0, k = gauche;
    while (i < n1 && j < n2) {
        if (L[i] <= R[j])
            tab[k++] = L[i++];
        else
            tab[k++] = R[j++];
    }
    while (i < n1) tab[k++] = L[i++];
    while (j < n2) tab[k++] = R[j++];

    free(L);
    free(R);
}

void tri_fusion(int tab[], int gauche, int droite) {
    if (gauche < droite) {
        int milieu = gauche + (droite - gauche) / 2;
        tri_fusion(tab, gauche, milieu);
        tri_fusion(tab, milieu + 1, droite);
        fusion(tab, gauche, milieu, droite);
    }
}

int main(void) {
    int tab[] = {38, 27, 43, 3, 9, 82, 10};
    int n = sizeof(tab) / sizeof(tab[0]);

    tri_fusion(tab, 0, n - 1);

    for (int i = 0; i < n; i++)
        printf("%d ", tab[i]);
    printf("\n");
    return 0;
}
// Sortie : 3 9 10 27 38 43 82
```

### 3.3 Tri fusion en OCaml (fonctionnel)

```ocaml
(* Tri fusion fonctionnel sur des listes *)
let rec split = function
  | [] -> ([], [])
  | [x] -> ([x], [])
  | x :: y :: rest ->
    let (l1, l2) = split rest in
    (x :: l1, y :: l2)

let rec merge l1 l2 = match l1, l2 with
  | [], l | l, [] -> l
  | x :: xs, y :: ys ->
    if x <= y then x :: merge xs l2
    else y :: merge l1 ys

let rec tri_fusion = function
  | [] -> []
  | [x] -> [x]
  | lst ->
    let (l1, l2) = split lst in
    merge (tri_fusion l1) (tri_fusion l2)

let () =
  let lst = [38; 27; 43; 3; 9; 82; 10] in
  let sorted = tri_fusion lst in
  List.iter (fun x -> Printf.printf "%d " x) sorted;
  print_newline ()
(* Sortie : 3 9 10 27 38 43 82 *)
```

### 3.4 Algorithmes de recherche

| Algorithme | Complexite | Prerequis |
|-----------|-----------|-----------|
| Recherche lineaire | O(n) | Aucun |
| Recherche dichotomique | O(log n) | Tableau trie |
| Recherche dans une table de hachage | O(1) amorti | Bonne fonction de hachage |
| Recherche dans un ABR equilibre | O(log n) | Arbre equilibre (AVL, rouge-noir) |

### 3.5 Algorithmes sur les graphes

| Algorithme | Complexite | Usage |
|-----------|-----------|-------|
| BFS (parcours en largeur) | O(V + E) | Plus court chemin (graphe non pondere) |
| DFS (parcours en profondeur) | O(V + E) | Composantes connexes, tri topologique |
| Dijkstra (tas binaire) | O((V + E) log V) | Plus court chemin (poids positifs) |
| Bellman-Ford | O(V * E) | Plus court chemin (poids negatifs) |
| Floyd-Warshall | O(V^3) | Plus courts chemins (toutes paires) |
| Kruskal | O(E log E) | Arbre couvrant minimal |
| Prim (tas binaire) | O((V + E) log V) | Arbre couvrant minimal |

### 3.6 Implementation de Dijkstra en Python

```python
import heapq

def dijkstra(graphe, source):
    """
    graphe : dict de listes d'adjacence {sommet: [(voisin, poids), ...]}
    Retourne : dict des distances minimales depuis source
    Complexite : O((V + E) log V) avec un tas binaire
    """
    dist = {s: float('inf') for s in graphe}
    dist[source] = 0
    tas = [(0, source)]  # (distance, sommet)

    while tas:
        d, u = heapq.heappop(tas)
        if d > dist[u]:
            continue  # sommet deja traite avec une meilleure distance
        for v, poids in graphe[u]:
            nouvelle_dist = dist[u] + poids
            if nouvelle_dist < dist[v]:
                dist[v] = nouvelle_dist
                heapq.heappush(tas, (nouvelle_dist, v))

    return dist

# Exemple
graphe = {
    'A': [('B', 4), ('C', 1)],
    'B': [('D', 1)],
    'C': [('B', 2), ('D', 5)],
    'D': []
}

distances = dijkstra(graphe, 'A')
for sommet, d in sorted(distances.items()):
    print(f"Distance A -> {sommet} : {d}")
# Distance A -> A : 0
# Distance A -> B : 3
# Distance A -> C : 1
# Distance A -> D : 4
```

---

## 4. Classes de complexite

### 4.1 Problemes de decision

En theorie de la complexite, on s'interesse aux **problemes de decision** : des questions auxquelles la reponse est OUI ou NON.

**Exemples** :
- PRIMALITE : l'entier `n` est-il premier ?
- SAT : la formule booleenne `phi` est-elle satisfaisable ?
- CHEMIN : existe-t-il un chemin de longueur `<= k` entre `s` et `t` dans le graphe `G` ?

### 4.2 La classe P

**Definition** : P est l'ensemble des problemes de decision resolubles par un algorithme deterministe en temps **polynomial** en la taille de l'entree.

Formellement, un langage `L` est dans P s'il existe une machine de Turing deterministe `M` et un polynome `p(n)` tels que pour toute entree `x` de taille `n` :
- `M` s'arrete en au plus `p(n)` etapes
- `M` accepte `x` si et seulement si `x` appartient a `L`

**Exemples de problemes dans P** :
- Tri d'un tableau (O(n log n))
- Plus court chemin dans un graphe (Dijkstra, O((V+E) log V))
- Test de primalite (AKS, O(n^6) ou n = nombre de chiffres)
- Programmation lineaire (algorithme de l'ellipsoide)
- 2-SAT (O(V + E) via composantes fortement connexes)
- Couplage maximum dans un graphe (Edmonds, polynomial)

### 4.3 La classe NP

**Definition** : NP (Nondeterministic Polynomial time) est l'ensemble des problemes de decision pour lesquels une solution positive peut etre **verifiee** en temps polynomial.

Formellement, `L` appartient a NP s'il existe un verificateur polynomial `V` et un polynome `p` tels que :

```
x dans L  <=>  il existe un certificat c de taille <= p(|x|) tel que V(x, c) accepte
```

**Attention** : NP ne signifie PAS "Non-Polynomial". NP signifie "resolu en temps polynomial par une machine de Turing Non-deterministe".

**Definition equivalente** : NP est l'ensemble des langages decides en temps polynomial par une machine de Turing **non deterministe**. A chaque etape, la machine peut "deviner" le bon choix parmi plusieurs transitions possibles.

**Exemples** :
- SAT : le certificat est une affectation des variables ; verifier que la formule est satisfaite est polynomial
- CLIQUE : le certificat est un sous-ensemble de sommets ; verifier que c'est une clique de taille k est polynomial
- CYCLE HAMILTONIEN : le certificat est un parcours de sommets ; verifier qu'il visite chaque sommet exactement une fois est polynomial
- SUBSET SUM : le certificat est un sous-ensemble ; verifier que la somme est correcte est polynomial

**Remarque essentielle** : `P inclus dans NP` (tout probleme resolu en temps polynomial est aussi verifiable en temps polynomial : le certificat peut etre ignore, on execute l'algorithme directement).

### 4.4 La classe co-NP

**Definition** : co-NP est l'ensemble des problemes dont le **complement** est dans NP. C'est-a-dire : les instances negatives ont un certificat verifiable en temps polynomial.

**Exemples** :
- TAUTOLOGIE : une formule booleenne est-elle vraie pour toute affectation ? (Le complement de SAT : une affectation falsifiante est un certificat court pour NON-TAUTOLOGIE)
- PRIMALITE est dans co-NP (et aussi dans P, donc c'est compatible)
- FACTORISATION : "n n'a pas de facteur entre 2 et k" est dans co-NP

**Relation avec NP** :
- `P inclus dans NP inter co-NP`
- Si `P = NP`, alors `NP = co-NP`
- On ne sait pas si `NP = co-NP` (question ouverte)

### 4.5 Diagramme des classes

```
                    EXPTIME
                   /       \
                  /   NP    \
                 /   / \     \
                /   /   \     \
               | P=NP inter coNP|
               |   \   /     |
                \   \ /     /
                 \ co-NP   /
                  \       /
                   -------
(sous l'hypothese P != NP)
```

---

## 5. NP-completude

### 5.1 Reductions polynomiales

**Definition** : On dit que le probleme `A` se reduit polynomialement au probleme `B` (note `A <=_p B`) s'il existe une fonction calculable en temps polynomial `f` telle que :

```
x dans A  <=>  f(x) dans B
```

**Interpretation** : si on sait resoudre `B` efficacement, on sait resoudre `A` efficacement. Donc `B` est "au moins aussi difficile" que `A`.

**Proprietes** :
- Transitivite : si `A <=_p B` et `B <=_p C`, alors `A <=_p C`
- Si `B` dans P et `A <=_p B`, alors `A` dans P
- Si `A` pas dans P et `A <=_p B`, alors `B` pas dans P

### 5.2 Definition de NP-complet

Un probleme `L` est **NP-complet** si :
1. `L` dans NP (il est verifiable en temps polynomial)
2. Tout probleme de NP se reduit polynomialement a `L` : pour tout `A` dans NP, `A <=_p L`

Un probleme **NP-dur** (NP-hard) satisfait la condition 2, mais pas necessairement la condition 1.

**Consequence** : si UN SEUL probleme NP-complet est dans P, alors P = NP.

### 5.3 Theoreme de Cook-Levin (1971)

**Enonce** : SAT est NP-complet.

SAT (probleme de satisfaisabilite booleenne) : Etant donnee une formule booleenne `phi` en forme normale conjonctive (CNF), existe-t-il une affectation des variables qui rend `phi` vraie ?

**Esquisse de preuve** :

1. **SAT est dans NP** : le certificat est une affectation ; la verification (evaluer la formule) est en O(|phi|).

2. **Tout probleme de NP se reduit a SAT** : Pour tout `L` dans NP, il existe un verificateur `V` qui tourne en temps polynomial `p(n)`. On encode le calcul de `V(x, c)` comme un circuit booleeen :
   - Chaque cellule de la bande de la machine de Turing a chaque instant `t` est representee par des variables booleennes
   - Les transitions de la machine sont encodees comme des clauses CNF
   - La formule est satisfaisable ssi il existe un certificat `c` tel que `V(x, c)` accepte

**Importance historique** : C'est le premier probleme prouve NP-complet (independamment par Cook et Levin). Tous les autres resultats de NP-completude procedent par reduction depuis SAT.

### 5.4 Exemples de problemes NP-complets

#### 3-SAT

**Instance** : Une formule CNF ou chaque clause contient exactement 3 litteraux.
**Question** : La formule est-elle satisfaisable ?
**Reduction** : SAT <=_p 3-SAT (toute clause de k litteraux se decompose en clauses de 3 litteraux avec variables auxiliaires).

**Note cruciale** : 2-SAT est dans P (resolu par propagation unitaire et composantes fortement connexes), mais 3-SAT est NP-complet. La frontiere est nette.

#### CLIQUE

**Instance** : Un graphe `G = (V, E)` et un entier `k`.
**Question** : `G` contient-il une clique (sous-graphe complet) de taille `k` ?
**Reduction** : 3-SAT <=_p CLIQUE.

#### COUVERTURE DE SOMMETS (VERTEX COVER)

**Instance** : Un graphe `G = (V, E)` et un entier `k`.
**Question** : Existe-t-il un sous-ensemble `S` de V de taille `<= k` tel que chaque arete a au moins une extremite dans `S` ?
**Reduction** : CLIQUE <=_p VERTEX COVER (par passage au graphe complementaire).

#### SUBSET SUM

**Instance** : Un ensemble d'entiers positifs `S` et un entier cible `t`.
**Question** : Existe-t-il un sous-ensemble de `S` dont la somme vaut exactement `t` ?
**Reduction** : 3-SAT <=_p SUBSET SUM.

#### VOYAGEUR DE COMMERCE (TSP -- decision)

**Instance** : Un ensemble de villes avec distances, et un entier `k`.
**Question** : Existe-t-il un tour passant par toutes les villes exactement une fois de cout total `<= k` ?
**Reduction** : CYCLE HAMILTONIEN <=_p TSP.

### 5.5 Schema des reductions classiques

```
SAT
 |-> 3-SAT
      |-> CLIQUE --> COUVERTURE DE SOMMETS --> ENSEMBLE INDEPENDANT
      |-> CYCLE HAMILTONIEN --> TSP
      |-> 3-COLORATION
      |-> SUBSET SUM --> PARTITION --> KNAPSACK
```

### 5.6 Verificateur SAT naif en Python

```python
from itertools import product

def verifier_sat(clauses, affectation):
    """
    Verifie si une affectation satisfait toutes les clauses.
    clause = liste de litteraux (entiers signes : +i pour x_i, -i pour non x_i)
    affectation = dict {variable: True/False}
    Complexite : O(nombre total de litteraux)
    """
    for clause in clauses:
        satisfaite = False
        for lit in clause:
            var = abs(lit)
            valeur = affectation[var] if lit > 0 else not affectation[var]
            if valeur:
                satisfaite = True
                break
        if not satisfaite:
            return False
    return True

def sat_bruteforce(clauses, variables):
    """
    Resout SAT par force brute. Complexite : O(2^n * m) ou n = |variables|, m = |clauses|.
    """
    for valeurs in product([True, False], repeat=len(variables)):
        affectation = dict(zip(variables, valeurs))
        if verifier_sat(clauses, affectation):
            return affectation
    return None

# Exemple : (x1 v non x2 v x3) et (non x1 v x2) et (non x3)
clauses = [
    [1, -2, 3],
    [-1, 2],
    [-3]
]
variables = [1, 2, 3]

resultat = sat_bruteforce(clauses, variables)
if resultat:
    print("Satisfaisable :", resultat)
else:
    print("Insatisfaisable")
# Sortie : Satisfaisable : {1: True, 2: True, 3: False}
```

### 5.7 DPLL -- solveur SAT par backtracking

```python
def dpll(clauses, affectation):
    """
    Algorithme DPLL : backtracking avec propagation unitaire.
    Beaucoup plus efficace que le brute force en pratique.
    """
    # Simplifier : retirer les clauses satisfaites, retirer les litteraux faux
    clauses = simplifier(clauses, affectation)

    # Si toutes les clauses sont satisfaites
    if len(clauses) == 0:
        return affectation

    # Si une clause est vide (conflit)
    if any(len(c) == 0 for c in clauses):
        return None

    # Propagation unitaire : clause avec un seul litteral
    for clause in clauses:
        if len(clause) == 1:
            lit = clause[0]
            var = abs(lit)
            val = lit > 0
            nouvelle = dict(affectation)
            nouvelle[var] = val
            return dpll(clauses, nouvelle)

    # Choisir une variable non affectee
    toutes_vars = set()
    for c in clauses:
        for lit in c:
            toutes_vars.add(abs(lit))
    var = min(toutes_vars - set(affectation.keys()))

    # Brancher sur True
    aff_true = dict(affectation)
    aff_true[var] = True
    resultat = dpll(clauses, aff_true)
    if resultat is not None:
        return resultat

    # Brancher sur False
    aff_false = dict(affectation)
    aff_false[var] = False
    return dpll(clauses, aff_false)

def simplifier(clauses, affectation):
    """Retire les clauses satisfaites et les litteraux falsifies."""
    nouvelles = []
    for clause in clauses:
        satisfaite = False
        nouvelle_clause = []
        for lit in clause:
            var = abs(lit)
            if var in affectation:
                if (lit > 0 and affectation[var]) or (lit < 0 and not affectation[var]):
                    satisfaite = True
                    break
                # Litteral faux : ne pas l'ajouter
            else:
                nouvelle_clause.append(lit)
        if not satisfaite:
            nouvelles.append(nouvelle_clause)
    return nouvelles

# Test
clauses = [[1, -2, 3], [-1, 2], [-3], [2, 3]]
resultat = dpll(clauses, {})
print("DPLL :", resultat)
```

### 5.8 La question P = NP ?

C'est le probleme ouvert le plus celebre en informatique (l'un des 7 problemes du millenaire, prix d'un million de dollars du Clay Mathematics Institute).

**Si P = NP** :
- Tout probleme verifiable en temps polynomial serait aussi *resolu* en temps polynomial
- La cryptographie a cle publique s'effondrerait (RSA, Diffie-Hellman, courbes elliptiques)
- Les problemes d'optimisation combinatoire deviendraient faciles
- La verification formelle de preuves mathematiques serait revolutionnee

**Si P != NP** (consensus actuel) :
- Il existe des problemes "intrinsequement difficiles" malgre la facilite de verifier les solutions
- La cryptographie moderne repose sur cette hypothese
- Certains problemes d'optimisation n'ont pas de solution efficace exacte

---

## 6. Implications en cryptographie

### 6.1 Securite computationnelle

La cryptographie moderne repose sur des **hypotheses de durete computationnelle** : on suppose que certains problemes ne peuvent pas etre resolus en temps polynomial.

Contrairement a la securite parfaite (chiffrement de Vernam/one-time pad), la **securite computationnelle** admet qu'un adversaire disposant d'un temps illimite pourrait casser le systeme, mais qu'en pratique il ne dispose pas de ce temps.

### 6.2 Hypotheses de durete

| Hypothese | Probleme sous-jacent | Utilise par |
|-----------|---------------------|-------------|
| Factorisation | Factoriser n = p*q en ses facteurs premiers | RSA |
| Logarithme discret | Trouver x tel que g^x = h (mod p) | Diffie-Hellman, ElGamal |
| Log discret sur courbe elliptique | Trouver k tel que Q = k*P | ECDSA, ECDH |
| Learning With Errors (LWE) | Resoudre un systeme lineaire bruite | Cryptographie post-quantique (Kyber, Dilithium) |

**Remarque importante** : aucun de ces problemes n'est prouve NP-complet. La factorisation est dans NP inter co-NP, ce qui suggere qu'elle n'est probablement pas NP-complete (sinon NP = co-NP, ce qui serait surprenant). La securite de RSA repose sur une conjecture non liee directement a P vs NP.

### 6.3 Reductions en cryptographie

La notion de reduction polynomiale est centrale :
- On prouve qu'un schema cryptographique est "sur sous l'hypothese H" en montrant que casser le schema implique resoudre le probleme H
- C'est une **reduction** : "si quelqu'un casse mon systeme, alors il sait factoriser" (contraposee : "si factoriser est dur, mon systeme est sur")

**Exemple concret** : la securite du chiffrement RSA se reduit au probleme RSA (calculer `m` a partir de `m^e mod n`), qui est lie (mais pas prouve equivalent) a la factorisation de `n`.

### 6.4 Fonctions a sens unique

Une **fonction a sens unique** est une fonction `f` qui :
1. Se calcule en temps polynomial
2. Est "difficile" a inverser : aucun algorithme polynomial ne peut, etant donne `f(x)`, retrouver `x` avec probabilite non negligeable

L'existence de fonctions a sens unique implique P != NP (mais la reciproque n'est pas connue).

**Exemples candidats** :
- Multiplication de grands nombres premiers (facile) vs factorisation (supposee difficile)
- Exponentiation modulaire (facile) vs logarithme discret (suppose difficile)
- Fonctions de hachage cryptographiques (SHA-256, etc.)

### 6.5 Cryptographie post-quantique

L'algorithme de Shor (1994) resout la factorisation et le logarithme discret en temps polynomial sur un ordinateur **quantique**. Cela menace RSA, Diffie-Hellman, et les courbes elliptiques.

Les problemes candidats pour la cryptographie post-quantique :
- **Reseaux euclidiens** (lattice-based) : LWE, Ring-LWE -> Kyber, Dilithium (standardises par le NIST en 2024)
- **Codes correcteurs** : syndrome decoding -> Classic McEliece
- **Isogenies** : SIDH/SIKE (casse en 2022)
- **Polynomes multivaries** : MQ problem

---

## 7. Applications pratiques

### 7.1 Evaluation empirique de complexite en OCaml

```ocaml
(* Mesure du temps d'execution en OCaml *)
let chrono f x =
  let t0 = Sys.time () in
  let _ = f x in
  let t1 = Sys.time () in
  t1 -. t0

(* Tri insertion -- O(n^2) *)
let tri_insertion tab =
  let n = Array.length tab in
  for i = 1 to n - 1 do
    let cle = tab.(i) in
    let j = ref (i - 1) in
    while !j >= 0 && tab.(!j) > cle do
      tab.(!j + 1) <- tab.(!j);
      decr j
    done;
    tab.(!j + 1) <- cle
  done

(* Test avec differentes tailles *)
let () =
  List.iter (fun n ->
    let tab = Array.init n (fun _ -> Random.int 100000) in
    let t = chrono tri_insertion tab in
    Printf.printf "n = %6d | temps = %.4f s\n" n t
  ) [1000; 2000; 4000; 8000; 16000]

(* Resultat typique :
   n =   1000 | temps = 0.0020 s
   n =   2000 | temps = 0.0080 s    (x4 : coherent avec O(n^2))
   n =   4000 | temps = 0.0310 s    (x4)
   n =   8000 | temps = 0.1240 s    (x4)
   n =  16000 | temps = 0.4960 s    (x4)
*)
```

### 7.2 Approximation pour les problemes NP-complets

Quand un probleme est NP-complet, on ne peut pas (sauf si P = NP) le resoudre exactement en temps polynomial. On utilise alors :

1. **Algorithmes d'approximation** : solution sous-optimale avec garantie de ratio
2. **Heuristiques** : algorithmes gloutons, recuit simule, algorithmes genetiques
3. **Algorithmes exacts exponentiels** : pour des instances de petite taille
4. **Algorithmes parametres** (FPT) : exponentiels en un parametre k, polynomiaux en n

**Exemple** : Couverture de sommets -- l'algorithme glouton "prendre les deux extremites de chaque arete d'un couplage maximal" donne une 2-approximation.

```python
def couverture_sommets_approx(graphe):
    """
    2-approximation de la couverture minimale de sommets.
    graphe : dict {sommet: set de voisins}
    Garantie : |couverture retournee| <= 2 * |couverture optimale|
    """
    couverture = set()
    aretes_restantes = set()
    for u in graphe:
        for v in graphe[u]:
            if (min(u, v), max(u, v)) not in aretes_restantes:
                aretes_restantes.add((min(u, v), max(u, v)))

    while aretes_restantes:
        u, v = aretes_restantes.pop()
        couverture.add(u)
        couverture.add(v)
        # Retirer les aretes couvertes
        aretes_restantes = {(a, b) for (a, b) in aretes_restantes
                           if a != u and a != v and b != u and b != v}

    return couverture

graphe = {
    0: {1, 2},
    1: {0, 2, 3},
    2: {0, 1, 4},
    3: {1},
    4: {2}
}
print("Couverture :", couverture_sommets_approx(graphe))
```

---

## 8. Exercices

### Exercice 1 -- Notations asymptotiques
Montrer formellement (avec c et n0) que :
1. `5n^3 + 2n^2 - 7n + 3 = Theta(n^3)`
2. `log_2(n!) = Theta(n log n)` (utiliser la formule de Stirling)
3. `2^(n+1) = O(2^n)` mais `2^(2n) != O(2^n)`
4. `(log n)^k = o(n^epsilon)` pour tout k > 0 et epsilon > 0

### Exercice 2 -- Analyse de complexite
Determiner la complexite temporelle (pire cas) des fonctions suivantes :

```c
// Fonction A
int f(int n) {
    int s = 0;
    for (int i = 1; i <= n; i *= 2)
        for (int j = 0; j < n; j++)
            s++;
    return s;
}

// Fonction B
int g(int n) {
    if (n <= 1) return 1;
    return g(n / 2) + g(n / 2) + n;
}

// Fonction C
int h(int n) {
    int s = 0;
    for (int i = 0; i < n; i++)
        for (int j = i; j < n; j++)
            for (int k = j; k < n; k++)
                s++;
    return s;
}
```

### Exercice 3 -- Theoreme maitre
Appliquer le theoreme maitre aux recurrences suivantes :
1. `T(n) = 4T(n/2) + n`
2. `T(n) = 4T(n/2) + n^2`
3. `T(n) = 4T(n/2) + n^3`
4. `T(n) = 3T(n/4) + n log n`

### Exercice 4 -- Reduction polynomiale
Montrer que ENSEMBLE INDEPENDANT <=_p CLIQUE par reduction. (Indication : considerer le graphe complementaire.)

### Exercice 5 -- NP-completude
Prouver que 3-COLORATION est dans NP. (Quel est le certificat ? Quel est le verificateur ?)

### Exercice 6 -- Application cryptographique
On dispose d'un oracle qui resout SAT en temps polynomial. Expliquer comment l'utiliser pour factoriser un entier `n = p * q` en temps polynomial. (Indication : encoder la multiplication comme un circuit booleen, puis le convertir en formule CNF.)

### Exercice 7 -- Programmation
Implementer en Python un algorithme de backtracking pour resoudre 3-SAT (algorithme DPLL simplifie). Tester sur des instances aleatoires de taille croissante et mesurer le temps d'execution. Observer la transition de phase (ratio clauses/variables autour de 4.26).

### Exercice 8 -- Complexite amortie
Demontrer par la methode du potentiel que l'insertion dans un tableau dynamique (doublement de capacite quand plein) a un cout amorti O(1). Prendre Phi(D) = 2 * taille - capacite.

---

## 9. References

- **Introduction to Algorithms** (Cormen, Leiserson, Rivest, Stein) -- Chapitres 3, 4, 34, 35
- **Computational Complexity: A Modern Approach** (Arora, Barak) -- Chapitres 1-3
- **Algorithm Design** (Kleinberg, Tardos) -- Chapitres 8-9 (NP-completude, reductions)
- **The P vs NP Problem** -- Clay Mathematics Institute : https://www.claymath.org/millennium-problems/p-vs-np-problem
- **Introduction to the Theory of Computation** (Sipser) -- Chapitres 7-8
- **Cours de Jean-Paul Delahaye** -- "Complexite algorithmique" (Pour la Science)
- **Handbook of Applied Cryptography** (Menezes, van Oorschot, Vanstone) -- Chapitre 2 (complexite)

---

*Cours prepare pour le niveau MP2I/MPI -- Fondamentaux d'informatique*
