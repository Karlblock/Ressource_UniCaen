# Chapitre 3 -- Algorithmique

## Objectifs du chapitre

- Savoir prouver la correction d'un programme (pre/post-conditions, invariants de boucle, terminaison)
- Maitriser les algorithmes de tri classiques : insertion, fusion, rapide
- Comprendre la recherche dichotomique et ses variantes
- Connaitre les strategies algorithmiques : glouton, diviser pour regner, programmation dynamique
- Savoir appliquer le backtracking a des problemes de satisfaction de contraintes
- Analyser la complexite temporelle et spatiale de chaque algorithme

---

## 1. Correction de programmes

### 1.1 Pre-conditions et post-conditions

Une **pre-condition** est une propriete qui doit etre vraie avant l'execution d'une fonction. Une **post-condition** est une propriete garantie apres l'execution si la pre-condition etait respectee. Ensemble, elles forment le **contrat** de la fonction.

```python
def recherche_lineaire(tab, x):
    """
    Pre-condition : tab est une liste d'entiers, x est un entier
    Post-condition : retourne i tel que tab[i] == x, ou -1 si x n'est pas dans tab
    """
    for i in range(len(tab)):
        if tab[i] == x:
            return i
    return -1
```

```c
/*
 * Pre-condition : tab est un tableau de taille n >= 1
 * Post-condition : retourne l'indice du maximum de tab[0..n-1]
 */
int indice_max(int tab[], int n) {
    int imax = 0;
    for (int i = 1; i < n; i++) {
        if (tab[i] > tab[imax]) {
            imax = i;
        }
    }
    return imax;
}
```

### 1.2 Invariant de boucle

Un **invariant de boucle** est une propriete qui est vraie :

1. Avant la premiere iteration (**initialisation**)
2. Si elle est vraie avant une iteration, elle l'est apres (**conservation**)
3. A la fin de la boucle, combinee avec la condition d'arret, elle implique la post-condition (**terminaison**)

**Exemple : recherche du maximum**

```c
int maximum(int tab[], int n) {
    int m = tab[0];
    /* Invariant I(i) : m = max(tab[0], ..., tab[i-1]) */
    for (int i = 1; i < n; i++) {
        if (tab[i] > m) {
            m = tab[i];
        }
        /* Invariant preserve : m = max(tab[0], ..., tab[i]) */
    }
    /* En sortie, i = n, donc m = max(tab[0], ..., tab[n-1]) */
    return m;
}
```

**Preuve formelle :**

- **Initialisation :** avant la boucle, i = 1 et m = tab[0] = max(tab[0..0]). L'invariant I(1) est verifie.
- **Conservation :** supposons I(i) vrai, c'est-a-dire m = max(tab[0..i-1]).
  - Si tab[i] > m, alors m prend la valeur tab[i], donc m = max(tab[0..i]).
  - Sinon, m reste inchange et m >= tab[i], donc m = max(tab[0..i]).
  - Dans les deux cas, I(i+1) est verifie.
- **Terminaison :** en sortie i = n, donc par I(n), m = max(tab[0..n-1]). La post-condition est verifiee.

### 1.3 Terminaison

Pour prouver qu'une boucle ou une recursion termine, on exhibe un **variant** : une quantite entiere positive qui decroit strictement a chaque iteration.

**Variant pour une boucle while :**

```python
def pgcd(a, b):
    """
    Variant : b (entier >= 0, decroit strictement a chaque iteration
    car b est remplace par a % b et a % b < b pour b > 0)
    """
    while b != 0:
        a, b = b, a % b
    return a
```

**Variant pour la recursion :**

```python
def factorielle(n):
    """Variant : n (decroit de 1 a chaque appel, cas de base n = 0)"""
    if n == 0:
        return 1
    return n * factorielle(n - 1)
```

**Variant pour la recherche dichotomique :**

```python
def recherche_dicho(tab, x):
    """Variant : droite - gauche (decroit strictement, >= 0)"""
    gauche, droite = 0, len(tab) - 1
    while gauche <= droite:
        milieu = (gauche + droite) // 2
        if tab[milieu] == x:
            return milieu
        elif tab[milieu] < x:
            gauche = milieu + 1    # gauche augmente
        else:
            droite = milieu - 1    # droite diminue
    return -1
```

### 1.4 Correction totale

Un programme est **totalement correct** s'il est :

- **Partiellement correct** : s'il termine, il donne le bon resultat (prouve par invariant)
- **Terminant** : il termine toujours (prouve par variant)

---

## 2. Algorithmes de tri

### 2.1 Tri par insertion

**Principe :** on maintient une partie triee du tableau et on insere chaque element restant a sa bonne position.

**Analogie :** trier des cartes dans sa main, une par une.

```python
def tri_insertion(tab):
    """
    Tri par insertion.
    Invariant : tab[0..i-1] est trie a chaque debut d'iteration.
    Complexite : O(n^2) pire cas, O(n) meilleur cas (deja trie).
    Tri stable et en place.
    """
    for i in range(1, len(tab)):
        cle = tab[i]
        j = i - 1
        while j >= 0 and tab[j] > cle:
            tab[j + 1] = tab[j]
            j -= 1
        tab[j + 1] = cle
    return tab
```

```c
void tri_insertion(int tab[], int n) {
    for (int i = 1; i < n; i++) {
        int cle = tab[i];
        int j = i - 1;
        /* Decaler les elements plus grands que cle */
        while (j >= 0 && tab[j] > cle) {
            tab[j + 1] = tab[j];
            j--;
        }
        tab[j + 1] = cle;
    }
}
```

**OCaml (version fonctionnelle sur les listes) :**

```ocaml
let rec inserer x = function
  | [] -> [x]
  | y :: ys when x <= y -> x :: y :: ys
  | y :: ys -> y :: inserer x ys

let rec tri_insertion = function
  | [] -> []
  | x :: xs -> inserer x (tri_insertion xs)
```

**Analyse de complexite :**

- **Meilleur cas** (tableau deja trie) : O(n) -- la boucle interne ne s'execute jamais
- **Pire cas** (tableau trie a l'envers) : O(n^2) -- chaque element est compare a tous les precedents
- **Cas moyen** : O(n^2) -- en moyenne n^2/4 comparaisons
- **Stable** : oui (les elements egaux conservent leur ordre relatif)
- **En place** : oui (O(1) memoire supplementaire)

### 2.2 Tri fusion (Merge Sort)

**Principe :** diviser le tableau en deux moities, trier recursivement chaque moitie, puis fusionner les deux moities triees.

```python
def tri_fusion(tab):
    """
    Tri fusion.
    Complexite : O(n log n) dans tous les cas.
    Stable, mais pas en place (O(n) memoire supplementaire).
    """
    if len(tab) <= 1:
        return tab

    milieu = len(tab) // 2
    gauche = tri_fusion(tab[:milieu])
    droite = tri_fusion(tab[milieu:])
    return fusionner(gauche, droite)

def fusionner(g, d):
    """Fusionne deux listes triees en une seule liste triee. O(n)."""
    resultat = []
    i, j = 0, 0
    while i < len(g) and j < len(d):
        if g[i] <= d[j]:       # <= pour la stabilite
            resultat.append(g[i])
            i += 1
        else:
            resultat.append(d[j])
            j += 1
    resultat.extend(g[i:])
    resultat.extend(d[j:])
    return resultat
```

```c
void fusionner(int tab[], int gauche, int milieu, int droite) {
    int n1 = milieu - gauche + 1;
    int n2 = droite - milieu;

    int *G = malloc(n1 * sizeof(int));
    int *D = malloc(n2 * sizeof(int));

    for (int i = 0; i < n1; i++) G[i] = tab[gauche + i];
    for (int j = 0; j < n2; j++) D[j] = tab[milieu + 1 + j];

    int i = 0, j = 0, k = gauche;
    while (i < n1 && j < n2) {
        if (G[i] <= D[j]) {
            tab[k++] = G[i++];
        } else {
            tab[k++] = D[j++];
        }
    }
    while (i < n1) tab[k++] = G[i++];
    while (j < n2) tab[k++] = D[j++];

    free(G);
    free(D);
}

void tri_fusion_rec(int tab[], int gauche, int droite) {
    if (gauche < droite) {
        int milieu = gauche + (droite - gauche) / 2;
        tri_fusion_rec(tab, gauche, milieu);
        tri_fusion_rec(tab, milieu + 1, droite);
        fusionner(tab, gauche, milieu, droite);
    }
}

void tri_fusion(int tab[], int n) {
    tri_fusion_rec(tab, 0, n - 1);
}
```

**OCaml :**

```ocaml
let rec split = function
  | [] -> ([], [])
  | [x] -> ([x], [])
  | x :: y :: rest ->
    let (g, d) = split rest in
    (x :: g, y :: d)

let rec merge l1 l2 =
  match (l1, l2) with
  | ([], l) | (l, []) -> l
  | (x :: xs, y :: ys) ->
    if x <= y then x :: merge xs l2
    else y :: merge l1 ys

let rec tri_fusion = function
  | [] -> []
  | [x] -> [x]
  | lst ->
    let (g, d) = split lst in
    merge (tri_fusion g) (tri_fusion d)
```

**Analyse de complexite :**

L'equation de recurrence est T(n) = 2T(n/2) + O(n).

Par le **theoreme maitre** (cas 2 : a = 2, b = 2, d = 1, d = log_b(a)), T(n) = O(n log n).

La complexite est **O(n log n) dans tous les cas** (meilleur, moyen, pire).

### 2.3 Tri rapide (Quick Sort)

**Principe :** choisir un pivot, partitionner le tableau de sorte que les elements inferieurs au pivot soient a gauche et les superieurs a droite, puis trier recursivement chaque partie.

**Version simple (non en place) :**

```python
def tri_rapide(tab):
    """
    Tri rapide (version simple avec listes auxiliaires).
    Complexite : O(n log n) en moyenne, O(n^2) pire cas.
    """
    if len(tab) <= 1:
        return tab
    pivot = tab[len(tab) // 2]
    gauche = [x for x in tab if x < pivot]
    milieu = [x for x in tab if x == pivot]
    droite = [x for x in tab if x > pivot]
    return tri_rapide(gauche) + milieu + tri_rapide(droite)
```

**Version en place (partition de Lomuto) :**

```python
def partition(tab, debut, fin):
    """
    Partition de Lomuto.
    Choisit tab[fin] comme pivot.
    Retourne l'indice final du pivot.
    Invariant : tab[debut..i] < pivot, tab[i+1..j-1] >= pivot.
    """
    pivot = tab[fin]
    i = debut - 1
    for j in range(debut, fin):
        if tab[j] <= pivot:
            i += 1
            tab[i], tab[j] = tab[j], tab[i]
    tab[i + 1], tab[fin] = tab[fin], tab[i + 1]
    return i + 1

def tri_rapide_en_place(tab, debut, fin):
    if debut < fin:
        p = partition(tab, debut, fin)
        tri_rapide_en_place(tab, debut, p - 1)
        tri_rapide_en_place(tab, p + 1, fin)
```

```c
int partition(int tab[], int debut, int fin) {
    int pivot = tab[fin];
    int i = debut - 1;
    for (int j = debut; j < fin; j++) {
        if (tab[j] <= pivot) {
            i++;
            int temp = tab[i];
            tab[i] = tab[j];
            tab[j] = temp;
        }
    }
    int temp = tab[i + 1];
    tab[i + 1] = tab[fin];
    tab[fin] = temp;
    return i + 1;
}

void tri_rapide(int tab[], int debut, int fin) {
    if (debut < fin) {
        int p = partition(tab, debut, fin);
        tri_rapide(tab, debut, p - 1);
        tri_rapide(tab, p + 1, fin);
    }
}
```

**Amelioration : pivot aleatoire** pour eviter le pire cas O(n^2) sur les tableaux deja tries :

```python
import random

def partition_aleatoire(tab, debut, fin):
    pivot_idx = random.randint(debut, fin)
    tab[pivot_idx], tab[fin] = tab[fin], tab[pivot_idx]
    return partition(tab, debut, fin)
```

### 2.4 Comparaison des tris

| Tri | Meilleur | Moyen | Pire | Stable | En place | Remarque |
|-----|----------|-------|------|--------|----------|----------|
| Insertion | O(n) | O(n^2) | O(n^2) | Oui | Oui | Bon pour petits tableaux / presque tries |
| Fusion | O(n log n) | O(n log n) | O(n log n) | Oui | Non | Garanti n log n, bon pour listes chainees |
| Rapide | O(n log n) | O(n log n) | O(n^2) | Non | Oui | Rapide en pratique, pire cas evitable |

**Borne inferieure des tris par comparaison :** tout algorithme de tri base sur les comparaisons necessite au minimum Omega(n log n) comparaisons dans le pire cas. Cela decoule du fait qu'il y a n! permutations possibles, et un arbre de decision binaire de hauteur h a au plus 2^h feuilles, donc h >= log2(n!) = Omega(n log n) par la formule de Stirling.

---

## 3. Recherche dichotomique

### 3.1 Principe

La recherche dichotomique (binary search) cherche un element dans un **tableau trie** en divisant l'espace de recherche par deux a chaque etape.

**Complexite :** O(log n)

### 3.2 Implementation

```python
def recherche_dichotomique(tab, x):
    """
    Pre-condition : tab est trie en ordre croissant.
    Post-condition : retourne l'indice de x dans tab, ou -1 si absent.
    Invariant : si x est dans tab, il est dans tab[gauche..droite].
    Complexite : O(log n).
    """
    gauche, droite = 0, len(tab) - 1
    while gauche <= droite:
        milieu = (gauche + droite) // 2
        if tab[milieu] == x:
            return milieu
        elif tab[milieu] < x:
            gauche = milieu + 1
        else:
            droite = milieu - 1
    return -1
```

```c
int recherche_dichotomique(int tab[], int n, int x) {
    int gauche = 0, droite = n - 1;
    while (gauche <= droite) {
        int milieu = gauche + (droite - gauche) / 2;  /* Evite overflow */
        if (tab[milieu] == x)
            return milieu;
        else if (tab[milieu] < x)
            gauche = milieu + 1;
        else
            droite = milieu - 1;
    }
    return -1;
}
```

**Version recursive en OCaml :**

```ocaml
let recherche_dicho tab x =
  let rec aux gauche droite =
    if gauche > droite then -1
    else
      let milieu = gauche + (droite - gauche) / 2 in
      if tab.(milieu) = x then milieu
      else if tab.(milieu) < x then aux (milieu + 1) droite
      else aux gauche (milieu - 1)
  in
  aux 0 (Array.length tab - 1)
```

**Attention a l'overflow :** en C, `(gauche + droite) / 2` peut deborder si gauche et droite sont grands. Ecrire `gauche + (droite - gauche) / 2` evite ce probleme.

### 3.3 Variantes utiles

```python
def borne_inferieure(tab, x):
    """Retourne le plus petit indice i tel que tab[i] >= x.
    Si tous les elements sont < x, retourne len(tab).
    Utile pour inserer x a sa place dans un tableau trie.
    """
    gauche, droite = 0, len(tab)
    while gauche < droite:
        milieu = (gauche + droite) // 2
        if tab[milieu] < x:
            gauche = milieu + 1
        else:
            droite = milieu
    return gauche

def borne_superieure(tab, x):
    """Retourne le plus petit indice i tel que tab[i] > x."""
    gauche, droite = 0, len(tab)
    while gauche < droite:
        milieu = (gauche + droite) // 2
        if tab[milieu] <= x:
            gauche = milieu + 1
        else:
            droite = milieu
    return gauche

# Application : compter les occurrences de x dans un tableau trie
def compter_occurrences(tab, x):
    return borne_superieure(tab, x) - borne_inferieure(tab, x)

tab = [1, 2, 2, 2, 3, 4, 5]
print(compter_occurrences(tab, 2))  # 3
```

---

## 4. Algorithmes gloutons

### 4.1 Principe

Un algorithme **glouton** (greedy) fait a chaque etape le choix localement optimal, sans revenir en arriere. Il ne garantit pas toujours la solution optimale globale, mais il est souvent rapide et donne une bonne approximation.

**Quand ca marche :** quand le probleme possede la propriete de **choix glouton** (un choix localement optimal mene a une solution globalement optimale) et la **sous-structure optimale**.

**Quand ca ne marche pas :** quand un choix local optimal peut mener a une impasse globale. Il faut alors utiliser la programmation dynamique ou le backtracking.

### 4.2 Rendu de monnaie

**Probleme :** rendre une somme s avec le minimum de pieces, en utilisant des denominations d1 > d2 > ... > dk.

```python
def rendu_monnaie_glouton(montant, pieces):
    """
    Algorithme glouton pour le rendu de monnaie.
    Fonctionne pour les systemes de monnaie canoniques (euro, dollar).
    Ne donne PAS toujours l'optimal (contre-exemple ci-dessous).
    """
    pieces_triees = sorted(pieces, reverse=True)
    resultat = []

    for piece in pieces_triees:
        while montant >= piece:
            resultat.append(piece)
            montant -= piece

    return resultat

# Systeme euro : glouton optimal
print(rendu_monnaie_glouton(47, [1, 2, 5, 10, 20, 50]))
# [20, 20, 5, 2]

# Contre-exemple : glouton non optimal
# pieces = [1, 3, 4], montant = 6
# Glouton : 4 + 1 + 1 = 3 pieces
# Optimal : 3 + 3 = 2 pieces
print(rendu_monnaie_glouton(6, [1, 3, 4]))  # [4, 1, 1] -- sous-optimal !
```

### 4.3 Sac a dos fractionnaire

**Probleme :** on a n objets de poids w_i et valeur v_i, et un sac de capacite W. On peut prendre des fractions d'objets. Maximiser la valeur totale.

```python
def sac_a_dos_fractionnaire(capacite, objets):
    """
    Algorithme glouton pour le sac a dos fractionnaire.
    objets : liste de (valeur, poids)
    Strategie : trier par ratio valeur/poids decroissant, prendre les meilleurs.
    Complexite : O(n log n) pour le tri.
    Le glouton est OPTIMAL pour le sac a dos fractionnaire.
    """
    objets_tries = sorted(objets, key=lambda o: o[0] / o[1], reverse=True)

    valeur_totale = 0.0
    poids_restant = capacite

    for valeur, poids in objets_tries:
        if poids_restant <= 0:
            break
        if poids <= poids_restant:
            valeur_totale += valeur
            poids_restant -= poids
        else:
            fraction = poids_restant / poids
            valeur_totale += valeur * fraction
            poids_restant = 0

    return valeur_totale

objets = [(60, 10), (100, 20), (120, 30)]  # (valeur, poids)
capacite = 50
print(f"Valeur maximale: {sac_a_dos_fractionnaire(capacite, objets)}")
# Valeur maximale: 240.0
```

### 4.4 Ordonnancement de taches (job scheduling)

**Probleme :** n taches avec dates limites et profits. Chaque tache prend une unite de temps. Maximiser le profit total.

```python
def ordonnancement_glouton(taches):
    """
    taches : liste de (nom, deadline, profit)
    Strategie gloutonne : trier par profit decroissant, placer chaque tache
    le plus tard possible avant sa deadline.
    """
    taches_triees = sorted(taches, key=lambda t: t[2], reverse=True)
    max_deadline = max(t[1] for t in taches_triees)
    slots = [None] * (max_deadline + 1)
    profit_total = 0

    for nom, deadline, profit in taches_triees:
        for t in range(deadline, 0, -1):
            if slots[t] is None:
                slots[t] = nom
                profit_total += profit
                break

    planification = [(t, slots[t]) for t in range(1, max_deadline + 1) if slots[t]]
    return profit_total, planification

taches = [('A', 2, 100), ('B', 1, 19), ('C', 2, 27), ('D', 1, 25), ('E', 3, 15)]
profit, plan = ordonnancement_glouton(taches)
print(f"Profit total: {profit}, Plan: {plan}")
# Profit total: 142, Plan: [(1, 'D'), (2, 'A'), (3, 'E')] ou similaire
```

---

## 5. Diviser pour regner

### 5.1 Principe

La strategie **diviser pour regner** consiste a :

1. **Diviser** le probleme en sous-problemes plus petits
2. **Regner** en resolvant recursivement les sous-problemes
3. **Combiner** les solutions des sous-problemes

### 5.2 Theoreme maitre

L'analyse de complexite repose generalement sur le **theoreme maitre** pour les recurrences de la forme T(n) = aT(n/b) + O(n^d) :

- Si d < log_b(a) : T(n) = O(n^(log_b(a)))
- Si d = log_b(a) : T(n) = O(n^d * log n)
- Si d > log_b(a) : T(n) = O(n^d)

**Applications :**

| Algorithme | Recurrence | a, b, d | Cas | Complexite |
|------------|-----------|---------|-----|------------|
| Tri fusion | T(n) = 2T(n/2) + O(n) | 2, 2, 1 | d = log_b(a) | O(n log n) |
| Recherche dicho | T(n) = T(n/2) + O(1) | 1, 2, 0 | d = log_b(a) | O(log n) |
| Karatsuba | T(n) = 3T(n/2) + O(n) | 3, 2, 1 | d < log_b(a) | O(n^1.585) |
| Strassen | T(n) = 7T(n/2) + O(n^2) | 7, 2, 2 | d < log_b(a) | O(n^2.807) |

### 5.3 Multiplication de Karatsuba

**Probleme :** multiplier deux grands entiers de n chiffres. L'algorithme naif est O(n^2).

**Idee de Karatsuba :** au lieu de 4 multiplications de n/2 chiffres, n'en faire que 3.

Soient x = x1 * B + x0 et y = y1 * B + y0 (ou B = 10^(n/2)).

Alors x*y = z2 * B^2 + z1 * B + z0 avec :
- z2 = x1 * y1
- z0 = x0 * y0
- z1 = (x1 + x0) * (y1 + y0) - z2 - z0

```python
def karatsuba(x, y):
    """
    Multiplication de Karatsuba.
    Complexite : O(n^(log2(3))) ~ O(n^1.585)
    """
    if x < 10 or y < 10:
        return x * y

    n = max(len(str(x)), len(str(y)))
    m = n // 2

    b = 10 ** m
    x1, x0 = divmod(x, b)
    y1, y0 = divmod(y, b)

    z2 = karatsuba(x1, y1)
    z0 = karatsuba(x0, y0)
    z1 = karatsuba(x1 + x0, y1 + y0) - z2 - z0

    return z2 * (b ** 2) + z1 * b + z0

print(karatsuba(1234, 5678))  # 7006652
print(1234 * 5678)            # 7006652 -- verification
```

### 5.4 Quick Select (k-ieme element)

**Probleme :** trouver le k-ieme plus petit element d'un tableau non trie.

```python
def quick_select(tab, k):
    """
    Trouve le k-ieme plus petit element (k commence a 0).
    Complexite : O(n) en moyenne, O(n^2) pire cas.
    Utilise la meme partition que le tri rapide.
    """
    if len(tab) == 1:
        return tab[0]

    pivot = tab[len(tab) // 2]
    gauche = [x for x in tab if x < pivot]
    milieu = [x for x in tab if x == pivot]
    droite = [x for x in tab if x > pivot]

    if k < len(gauche):
        return quick_select(gauche, k)
    elif k < len(gauche) + len(milieu):
        return pivot
    else:
        return quick_select(droite, k - len(gauche) - len(milieu))

tab = [7, 10, 4, 3, 20, 15]
print(quick_select(tab, 0))  # 3  (minimum)
print(quick_select(tab, 2))  # 7  (3e plus petit)
print(quick_select(tab, 5))  # 20 (maximum)
```

---

## 6. Programmation dynamique

### 6.1 Principe

La **programmation dynamique** (DP) s'applique quand un probleme possede :

1. **Sous-structure optimale** : la solution optimale contient les solutions optimales des sous-problemes
2. **Chevauchement des sous-problemes** : les memes sous-problemes sont resolus plusieurs fois

**Deux approches :**

- **Memorisation (top-down)** : recursion avec cache -- on resout les sous-problemes a la demande et on memorise les resultats
- **Tabulation (bottom-up)** : remplissage iteratif d'un tableau -- on resout les sous-problemes dans l'ordre croissant de taille

### 6.2 Fibonacci

```python
# Recursion naive : O(2^n) -- recalcul massif
def fib_naif(n):
    if n <= 1:
        return n
    return fib_naif(n - 1) + fib_naif(n - 2)

# Memorisation (top-down) : O(n) temps, O(n) espace
from functools import lru_cache

@lru_cache(maxsize=None)
def fib_memo(n):
    if n <= 1:
        return n
    return fib_memo(n - 1) + fib_memo(n - 2)

# Tabulation (bottom-up) : O(n) temps, O(n) espace
def fib_tab(n):
    if n <= 1:
        return n
    dp = [0] * (n + 1)
    dp[1] = 1
    for i in range(2, n + 1):
        dp[i] = dp[i - 1] + dp[i - 2]
    return dp[n]

# Optimise : O(n) temps, O(1) espace
def fib_opt(n):
    if n <= 1:
        return n
    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    return b
```

### 6.3 Sac a dos 0/1

**Probleme :** n objets de poids w_i et valeur v_i, sac de capacite W. Chaque objet est pris entierement ou pas du tout (difference avec le fractionnaire).

```python
def sac_a_dos_01(capacite, poids, valeurs):
    """
    Programmation dynamique pour le sac a dos 0/1.
    dp[i][w] = valeur maximale avec les i premiers objets et capacite w.
    Recurrence :
      dp[i][w] = max(dp[i-1][w],                          -- ne pas prendre l'objet i
                     dp[i-1][w-poids[i]] + valeurs[i])     -- prendre l'objet i
    Complexite : O(n * W) en temps et espace (pseudo-polynomial).
    """
    n = len(poids)
    dp = [[0] * (capacite + 1) for _ in range(n + 1)]

    for i in range(1, n + 1):
        for w in range(capacite + 1):
            dp[i][w] = dp[i - 1][w]          # Ne pas prendre l'objet i
            if poids[i - 1] <= w:             # Prendre l'objet i (si possible)
                dp[i][w] = max(dp[i][w],
                               dp[i - 1][w - poids[i - 1]] + valeurs[i - 1])

    return dp[n][capacite]

poids =   [2, 3, 4, 5]
valeurs = [3, 4, 5, 6]
capacite = 8
print(f"Valeur maximale: {sac_a_dos_01(capacite, poids, valeurs)}")
# Valeur maximale: 10 (objets de poids 3+5=8, valeur 4+6=10)
```

**Version avec reconstruction de la solution :**

```python
def sac_a_dos_01_solution(capacite, poids, valeurs):
    n = len(poids)
    dp = [[0] * (capacite + 1) for _ in range(n + 1)]

    for i in range(1, n + 1):
        for w in range(capacite + 1):
            dp[i][w] = dp[i - 1][w]
            if poids[i - 1] <= w:
                dp[i][w] = max(dp[i][w],
                               dp[i - 1][w - poids[i - 1]] + valeurs[i - 1])

    # Reconstruction : remonter la table pour trouver les objets pris
    objets_pris = []
    w = capacite
    for i in range(n, 0, -1):
        if dp[i][w] != dp[i - 1][w]:
            objets_pris.append(i - 1)  # indice 0-base
            w -= poids[i - 1]

    return dp[n][capacite], objets_pris

val, objets = sac_a_dos_01_solution(8, [2, 3, 4, 5], [3, 4, 5, 6])
print(f"Valeur: {val}, Objets (indices): {objets}")
```

### 6.4 Plus longue sous-suite commune (LCS)

**Probleme :** etant donne deux chaines, trouver la plus longue sous-suite commune (les caracteres ne sont pas necessairement consecutifs).

```python
def lcs(x, y):
    """
    Plus longue sous-suite commune.
    dp[i][j] = longueur de la LCS de x[0..i-1] et y[0..j-1].
    Recurrence :
      Si x[i-1] == y[j-1] : dp[i][j] = dp[i-1][j-1] + 1
      Sinon :               dp[i][j] = max(dp[i-1][j], dp[i][j-1])
    Complexite : O(m * n) en temps et espace.
    """
    m, n = len(x), len(y)
    dp = [[0] * (n + 1) for _ in range(m + 1)]

    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if x[i - 1] == y[j - 1]:
                dp[i][j] = dp[i - 1][j - 1] + 1
            else:
                dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])

    # Reconstruction de la sous-suite
    resultat = []
    i, j = m, n
    while i > 0 and j > 0:
        if x[i - 1] == y[j - 1]:
            resultat.append(x[i - 1])
            i -= 1
            j -= 1
        elif dp[i - 1][j] > dp[i][j - 1]:
            i -= 1
        else:
            j -= 1

    resultat.reverse()
    return dp[m][n], ''.join(resultat)

longueur, sous_suite = lcs("ABCBDAB", "BDCABA")
print(f"Longueur LCS: {longueur}, Sous-suite: {sous_suite}")
# Longueur LCS: 4, Sous-suite: BCBA
```

### 6.5 Distance d'edition (Levenshtein)

```python
def distance_edition(s1, s2):
    """
    Distance d'edition (Levenshtein) : nombre minimum d'operations
    (insertion, suppression, substitution) pour transformer s1 en s2.
    dp[i][j] = distance entre s1[0..i-1] et s2[0..j-1].
    Complexite : O(m * n).
    """
    m, n = len(s1), len(s2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]

    for i in range(m + 1):
        dp[i][0] = i    # i suppressions
    for j in range(n + 1):
        dp[0][j] = j    # j insertions

    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if s1[i - 1] == s2[j - 1]:
                dp[i][j] = dp[i - 1][j - 1]       # pas d'operation
            else:
                dp[i][j] = 1 + min(
                    dp[i - 1][j],       # suppression
                    dp[i][j - 1],       # insertion
                    dp[i - 1][j - 1]    # substitution
                )

    return dp[m][n]

print(distance_edition("kitten", "sitting"))   # 3
print(distance_edition("samedi", "dimanche"))  # 4
```

### 6.6 Rendu de monnaie optimal (DP)

```python
def rendu_monnaie_dp(montant, pieces):
    """
    Rendu de monnaie optimal par programmation dynamique.
    dp[m] = nombre minimum de pieces pour rendre m.
    Complexite : O(montant * len(pieces)).
    """
    dp = [float('inf')] * (montant + 1)
    dp[0] = 0
    parent = [-1] * (montant + 1)

    for m in range(1, montant + 1):
        for piece in pieces:
            if piece <= m and dp[m - piece] + 1 < dp[m]:
                dp[m] = dp[m - piece] + 1
                parent[m] = piece

    if dp[montant] == float('inf'):
        return -1, []

    # Reconstruction de la solution
    solution = []
    m = montant
    while m > 0:
        solution.append(parent[m])
        m -= parent[m]

    return dp[montant], solution

nb, pieces_utilisees = rendu_monnaie_dp(6, [1, 3, 4])
print(f"Nombre de pieces: {nb}, Pieces: {pieces_utilisees}")
# Nombre de pieces: 2, Pieces: [3, 3]
```

---

## 7. Backtracking

### 7.1 Principe

Le **backtracking** explore systematiquement toutes les solutions possibles en construisant la solution pas a pas. Si a un moment donne la solution partielle ne peut pas mener a une solution valide, on revient en arriere (backtrack) et on essaie une autre branche.

**Schema general :**

```python
def backtrack(solution_partielle):
    if est_solution(solution_partielle):
        traiter(solution_partielle)
        return

    for candidat in generer_candidats(solution_partielle):
        if est_valide(solution_partielle, candidat):
            solution_partielle.append(candidat)
            backtrack(solution_partielle)
            solution_partielle.pop()  # Backtrack : annuler le choix
```

La difference avec une enumeration exhaustive est l'**elagage** : on coupe les branches qui ne peuvent pas mener a une solution valide.

### 7.2 Probleme des N-reines

**Probleme :** placer N reines sur un echiquier N x N de sorte qu'aucune reine n'en attaque une autre (meme ligne, colonne, ou diagonale).

```python
def n_reines(n):
    """
    Resout le probleme des N reines par backtracking.
    config[i] = colonne de la reine en ligne i.
    On place une reine par ligne, donc pas de conflit de ligne.
    """
    solutions = []

    def est_valide(config, ligne, col):
        for l in range(ligne):
            c = config[l]
            if c == col:                         # Meme colonne
                return False
            if abs(c - col) == abs(l - ligne):   # Meme diagonale
                return False
        return True

    def resoudre(config, ligne):
        if ligne == n:
            solutions.append(config[:])
            return

        for col in range(n):
            if est_valide(config, ligne, col):
                config.append(col)
                resoudre(config, ligne + 1)
                config.pop()  # Backtrack

    resoudre([], 0)
    return solutions

def afficher_echiquier(config, n):
    for ligne in range(n):
        rangee = ['.' for _ in range(n)]
        rangee[config[ligne]] = 'Q'
        print(' '.join(rangee))
    print()

solutions = n_reines(8)
print(f"Nombre de solutions pour 8 reines: {len(solutions)}")  # 92
afficher_echiquier(solutions[0], 8)
```

### 7.3 Solveur de Sudoku

```python
def resoudre_sudoku(grille):
    """
    Resout un sudoku 9x9 par backtracking.
    grille : liste de listes 9x9, 0 = case vide.
    """
    def trouver_vide(grille):
        for i in range(9):
            for j in range(9):
                if grille[i][j] == 0:
                    return (i, j)
        return None

    def est_valide(grille, num, pos):
        ligne, col = pos

        # Verification ligne
        if num in grille[ligne]:
            return False

        # Verification colonne
        for i in range(9):
            if grille[i][col] == num:
                return False

        # Verification carre 3x3
        l_debut = (ligne // 3) * 3
        c_debut = (col // 3) * 3
        for i in range(l_debut, l_debut + 3):
            for j in range(c_debut, c_debut + 3):
                if grille[i][j] == num:
                    return False

        return True

    vide = trouver_vide(grille)
    if vide is None:
        return True  # Grille complete

    ligne, col = vide
    for num in range(1, 10):
        if est_valide(grille, num, (ligne, col)):
            grille[ligne][col] = num
            if resoudre_sudoku(grille):
                return True
            grille[ligne][col] = 0  # Backtrack

    return False  # Aucun chiffre valide : backtrack

# Exemple
sudoku = [
    [5, 3, 0, 0, 7, 0, 0, 0, 0],
    [6, 0, 0, 1, 9, 5, 0, 0, 0],
    [0, 9, 8, 0, 0, 0, 0, 6, 0],
    [8, 0, 0, 0, 6, 0, 0, 0, 3],
    [4, 0, 0, 8, 0, 3, 0, 0, 1],
    [7, 0, 0, 0, 2, 0, 0, 0, 6],
    [0, 6, 0, 0, 0, 0, 2, 8, 0],
    [0, 0, 0, 4, 1, 9, 0, 0, 5],
    [0, 0, 0, 0, 8, 0, 0, 7, 9]
]

if resoudre_sudoku(sudoku):
    for ligne in sudoku:
        print(ligne)
```

### 7.4 Permutations par backtracking

```python
def permutations(lst):
    """Genere toutes les permutations de lst par backtracking.
    Nombre de permutations : n!
    """
    resultats = []

    def backtrack(chemin, restants):
        if not restants:
            resultats.append(chemin[:])
            return
        for i in range(len(restants)):
            chemin.append(restants[i])
            backtrack(chemin, restants[:i] + restants[i+1:])
            chemin.pop()

    backtrack([], lst)
    return resultats

print(permutations([1, 2, 3]))
# [[1,2,3], [1,3,2], [2,1,3], [2,3,1], [3,1,2], [3,2,1]]
```

---

## 8. Recapitulatif des strategies

| Strategie | Principe | Optimalite | Complexite typique | Exemples |
|-----------|----------|------------|-------------------|----------|
| Glouton | Choix local optimal | Pas toujours | Souvent O(n log n) | Rendu monnaie (canonique), Huffman, Kruskal |
| Diviser pour regner | Decouper, resoudre, combiner | Oui | O(n log n) typique | Merge sort, Karatsuba, Strassen |
| Prog. dynamique | Sous-problemes chevauches + memoisation | Oui | O(n * parametre) | Sac a dos 0/1, LCS, Floyd-Warshall |
| Backtracking | Exploration exhaustive avec elagage | Oui (exhaustif) | Exponentiel | N-reines, Sudoku, SAT |

**Comment choisir ?**

1. Le probleme a une structure gloutonne evidente ? Essayer le glouton.
2. Le probleme se decompose en sous-problemes independants ? Diviser pour regner.
3. Les sous-problemes se chevauchent ? Programmation dynamique.
4. On cherche toutes les solutions ou la premiere solution valide ? Backtracking.

---

## Exercices

### Exercice 1 -- Invariant de boucle

Prouver la correction de l'algorithme de recherche dichotomique en identifiant l'invariant de boucle, et en demontrant initialisation, conservation et terminaison (variant).

### Exercice 2 -- Tri

Implementer en C un tri par insertion generique utilisant un pointeur de fonction pour la comparaison, permettant de trier aussi bien des entiers que des chaines de caracteres.

### Exercice 3 -- Programmation dynamique

Implementer en Python la distance d'edition (distance de Levenshtein) entre deux chaines, avec reconstruction du chemin (sequence d'operations insertion/suppression/substitution). Donner la complexite.

### Exercice 4 -- Diviser pour regner

Implementer l'algorithme de recherche du k-ieme plus petit element dans un tableau non trie (Quick Select) en C. Comparer la complexite moyenne et le pire cas avec un tri complet suivi d'un acces.

### Exercice 5 -- Backtracking

Ecrire un programme qui genere toutes les combinaisons de k elements parmi n (C(n,k)) par backtracking. Verifier que le nombre de resultats est bien C(n,k).

### Exercice 6 -- Glouton vs DP

Pour le probleme du rendu de monnaie avec les pieces [1, 6, 10] et un montant de 12 :

1. Quelle solution donne l'algorithme glouton ?
2. Quelle solution donne la programmation dynamique ?
3. Expliquer pourquoi le glouton echoue ici.

### Exercice 7 -- Complexite

Pour chacun des algorithmes suivants, donner la complexite en notation O :

1. Tri par insertion sur un tableau presque trie (au plus k inversions, k << n)
2. Recherche dichotomique iteree : trouver m elements dans un tableau trie de n elements
3. Construction d'un tas a partir d'un tableau de n elements (heapify)
4. Tri fusion sur une liste chainee de n elements

---

## References

- **Introduction to Algorithms** (CLRS) -- Cormen, Leiserson, Rivest, Stein
- **Algorithm Design** -- Jon Kleinberg, Eva Tardos
- **Algorithms** -- Robert Sedgewick, Kevin Wayne
- **Programme officiel MP2I/MPI** -- Bulletin officiel de l'education nationale
- **Competitive Programming** -- Steven Halim, Felix Halim
- **Visualisation des tris** -- <https://visualgo.net/en/sorting>
