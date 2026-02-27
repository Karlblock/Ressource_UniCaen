# Chapitre 4 -- Theorie des graphes et algorithmes

## Objectifs du chapitre

- Connaitre les definitions fondamentales de la theorie des graphes
- Maitriser les representations en memoire (matrice et listes d'adjacence)
- Implementer les parcours BFS et DFS et connaitre leurs applications
- Comprendre et implementer les algorithmes de plus courts chemins (Dijkstra, Bellman-Ford)
- Comprendre et implementer les algorithmes d'arbre couvrant minimal (Kruskal, Prim)
- Connaitre l'algorithme de Tarjan pour les composantes fortement connexes
- Appliquer ces algorithmes a des problemes concrets

---

## 1. Definitions

### 1.1 Graphe non oriente

Un **graphe non oriente** G = (V, E) est compose de :

- V : un ensemble fini de **sommets** (vertices)
- E : un ensemble d'**aretes** (edges), ou chaque arete est une paire non ordonnee {u, v} avec u, v dans V

**Terminologie :**

- **Degre** d'un sommet : nombre d'aretes incidentes. Lemme des poignees de main : la somme des degres vaut 2|E|.
- **Voisins** de u : ensemble des sommets v tels que {u, v} est une arete
- **Chemin** : suite de sommets consecutivement relies par des aretes
- **Chemin simple** : chemin sans repetition de sommet
- **Cycle** : chemin dont le premier et le dernier sommet sont identiques
- **Graphe connexe** : il existe un chemin entre toute paire de sommets
- **Composante connexe** : sous-graphe connexe maximal
- **Arbre** : graphe connexe acyclique (|E| = |V| - 1)

### 1.2 Graphe oriente

Un **graphe oriente** (digraphe) G = (V, A) utilise des **arcs** ordonnes (u, v) au lieu d'aretes. L'arc (u, v) va de u vers v mais pas de v vers u.

**Terminologie supplementaire :**

- **Degre entrant** de v : nombre d'arcs arrivant en v
- **Degre sortant** de v : nombre d'arcs partant de v
- **Graphe fortement connexe** : pour toute paire (u, v), il existe un chemin de u a v ET de v a u
- **Composante fortement connexe** (CFC) : sous-graphe fortement connexe maximal
- **DAG** (Directed Acyclic Graph) : graphe oriente sans cycle

### 1.3 Graphe pondere

Un **graphe pondere** associe un poids (ou cout) a chaque arete ou arc. Formellement, on ajoute une fonction de poids w : E -> R.

**Proprietes utiles :**

- Un graphe non oriente de n sommets a au plus n(n-1)/2 aretes
- Un graphe oriente de n sommets a au plus n(n-1) arcs
- Un graphe **dense** a |E| ~ |V|^2, un graphe **creux** a |E| ~ |V|

---

## 2. Representations

### 2.1 Matrice d'adjacence

La matrice d'adjacence est un tableau 2D M de taille |V| x |V| ou M[i][j] = 1 si l'arete (i, j) existe, 0 sinon. Pour un graphe pondere, M[i][j] contient le poids (et 0 ou inf pour l'absence d'arete).

```python
class GrapheMatrice:
    def __init__(self, n):
        """Cree un graphe a n sommets (numerotes 0 a n-1)."""
        self.n = n
        self.matrice = [[0] * n for _ in range(n)]

    def ajouter_arete(self, u, v, poids=1):
        self.matrice[u][v] = poids
        self.matrice[v][u] = poids  # Supprimer pour graphe oriente

    def voisins(self, u):
        return [v for v in range(self.n) if self.matrice[u][v] != 0]

    def a_arete(self, u, v):
        return self.matrice[u][v] != 0

    def afficher(self):
        for ligne in self.matrice:
            print(ligne)
```

```c
#define MAX_SOMMETS 100

typedef struct {
    int matrice[MAX_SOMMETS][MAX_SOMMETS];
    int n;  /* nombre de sommets */
} GrapheMatrice;

void init_graphe(GrapheMatrice *g, int n) {
    g->n = n;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++)
            g->matrice[i][j] = 0;
}

void ajouter_arete(GrapheMatrice *g, int u, int v, int poids) {
    g->matrice[u][v] = poids;
    g->matrice[v][u] = poids;  /* Supprimer pour graphe oriente */
}
```

**Complexite :**

- Espace : O(|V|^2)
- Tester si (u, v) existe : O(1)
- Lister les voisins de u : O(|V|)
- Parcourir toutes les aretes : O(|V|^2)

### 2.2 Listes d'adjacence

Chaque sommet maintient une liste de ses voisins. C'est la representation la plus courante pour les graphes creux.

```python
class GrapheListes:
    def __init__(self):
        """Graphe represente par un dictionnaire de listes d'adjacence."""
        self.adj = {}

    def ajouter_sommet(self, u):
        if u not in self.adj:
            self.adj[u] = []

    def ajouter_arete(self, u, v, poids=1):
        self.ajouter_sommet(u)
        self.ajouter_sommet(v)
        self.adj[u].append((v, poids))
        self.adj[v].append((u, poids))  # Supprimer pour graphe oriente

    def voisins(self, u):
        return self.adj.get(u, [])

    def sommets(self):
        return self.adj.keys()

    def afficher(self):
        for sommet in sorted(self.adj):
            voisins = [(v, p) for v, p in self.adj[sommet]]
            print(f"{sommet}: {voisins}")
```

```c
/* Representation par listes d'adjacence en C */
typedef struct Arete {
    int dest;
    int poids;
    struct Arete *suivant;
} Arete;

typedef struct {
    Arete *adj[MAX_SOMMETS];
    int n;
} GrapheListes;

void init_graphe_listes(GrapheListes *g, int n) {
    g->n = n;
    for (int i = 0; i < n; i++)
        g->adj[i] = NULL;
}

void ajouter_arete_liste(GrapheListes *g, int u, int v, int poids) {
    Arete *a = malloc(sizeof(Arete));
    a->dest = v;
    a->poids = poids;
    a->suivant = g->adj[u];
    g->adj[u] = a;
}
```

**Complexite :**

- Espace : O(|V| + |E|)
- Tester si (u, v) existe : O(degre(u))
- Lister les voisins de u : O(degre(u))
- Parcourir toutes les aretes : O(|V| + |E|)

### 2.3 Comparaison

| Critere | Matrice | Listes |
|---------|---------|--------|
| Espace | O(V^2) | O(V + E) |
| Arete (u,v) existe ? | O(1) | O(degre(u)) |
| Lister voisins(u) | O(V) | O(degre(u)) |
| Ajouter arete | O(1) | O(1) |
| Graphes denses (E ~ V^2) | Adapte | OK |
| Graphes creux (E << V^2) | Gaspillage | Adapte |

**Regle pratique :** utiliser les listes d'adjacence par defaut. La matrice est utile quand |E| est proche de |V|^2 ou quand on a besoin de tester rapidement l'existence d'une arete.

---

## 3. Parcours BFS (Breadth-First Search)

### 3.1 Principe

Le parcours en **largeur** explore les sommets par niveaux croissants de distance au sommet de depart. Il utilise une **file** (FIFO).

**Propriete fondamentale :** BFS calcule les plus courts chemins (en nombre d'aretes) depuis la source dans un graphe non pondere.

### 3.2 Implementation

```python
from collections import deque

def bfs(graphe, source):
    """
    Parcours en largeur.
    Retourne les distances et les parents pour reconstruire les chemins.
    Complexite : O(V + E).
    """
    distances = {source: 0}
    parents = {source: None}
    file = deque([source])

    while file:
        u = file.popleft()
        for v, _ in graphe.voisins(u):
            if v not in distances:
                distances[v] = distances[u] + 1
                parents[v] = u
                file.append(v)

    return distances, parents

def reconstruire_chemin(parents, destination):
    """Reconstruit le plus court chemin vers destination."""
    if destination not in parents:
        return None  # Pas de chemin
    chemin = []
    courant = destination
    while courant is not None:
        chemin.append(courant)
        courant = parents[courant]
    chemin.reverse()
    return chemin
```

```c
void bfs(GrapheListes *g, int source, int distances[], int parents[]) {
    bool visite[MAX_SOMMETS] = {false};
    int file[MAX_SOMMETS];
    int debut = 0, fin = 0;

    for (int i = 0; i < g->n; i++) {
        distances[i] = -1;
        parents[i] = -1;
    }

    distances[source] = 0;
    visite[source] = true;
    file[fin++] = source;

    while (debut < fin) {
        int u = file[debut++];
        Arete *a = g->adj[u];
        while (a != NULL) {
            int v = a->dest;
            if (!visite[v]) {
                visite[v] = true;
                distances[v] = distances[u] + 1;
                parents[v] = u;
                file[fin++] = v;
            }
            a = a->suivant;
        }
    }
}
```

### 3.3 Test

```python
g = GrapheListes()
for u, v in [('A','B'), ('A','C'), ('B','D'), ('B','E'),
             ('C','F'), ('D','F'), ('E','F')]:
    g.ajouter_arete(u, v)

distances, parents = bfs(g, 'A')
print("Distances depuis A:", distances)
# {'A': 0, 'B': 1, 'C': 1, 'D': 2, 'E': 2, 'F': 2}

chemin = reconstruire_chemin(parents, 'F')
print("Plus court chemin A -> F:", chemin)
# ['A', 'C', 'F'] (distance 2)
```

### 3.4 Applications de BFS

- Plus courts chemins dans un graphe non pondere
- Detection de bipartition (coloration a 2 couleurs)
- Composantes connexes
- Plus courte distance entre deux cases d'un labyrinthe

---

## 4. Parcours DFS (Depth-First Search)

### 4.1 Principe

Le parcours en **profondeur** explore aussi loin que possible avant de revenir en arriere. Il utilise une **pile** (ou la recursion, qui utilise implicitement la pile d'appels).

### 4.2 Implementation recursive

```python
def dfs(graphe, source, visite=None):
    """
    Parcours en profondeur recursif.
    Complexite : O(V + E).
    """
    if visite is None:
        visite = set()
    visite.add(source)

    for v, _ in graphe.voisins(source):
        if v not in visite:
            dfs(graphe, v, visite)

    return visite
```

### 4.3 Implementation iterative (avec pile explicite)

```python
def dfs_iteratif(graphe, source):
    """Parcours en profondeur iteratif avec pile explicite."""
    visite = set()
    pile = [source]
    ordre = []

    while pile:
        u = pile.pop()
        if u in visite:
            continue
        visite.add(u)
        ordre.append(u)
        for v, _ in graphe.voisins(u):
            if v not in visite:
                pile.append(v)

    return ordre
```

**Remarque :** l'ordre de visite peut differer entre les versions recursive et iterative, car la pile inverse l'ordre des voisins.

### 4.4 Classification des aretes (graphe oriente)

Lors d'un DFS sur un graphe oriente, les arcs sont classes en :

- **Arc d'arbre** : vers un sommet non visite
- **Arc retour** : vers un ancetre (indique un **cycle**)
- **Arc avant** : vers un descendant non direct
- **Arc croise** : vers un sommet d'un autre sous-arbre

```python
def classification_arcs(graphe):
    """
    Classifie les arcs d'un graphe oriente lors du DFS.
    Utilise la coloration : BLANC (non visite), GRIS (en cours), NOIR (termine).
    """
    BLANC, GRIS, NOIR = 0, 1, 2
    couleur = {s: BLANC for s in graphe.sommets()}
    arcs = {'arbre': [], 'retour': [], 'avant': [], 'croise': []}
    debut = {}
    fin = {}
    temps = [0]

    def dfs_visite(u):
        temps[0] += 1
        debut[u] = temps[0]
        couleur[u] = GRIS

        for v, _ in graphe.voisins(u):
            if couleur[v] == BLANC:
                arcs['arbre'].append((u, v))
                dfs_visite(v)
            elif couleur[v] == GRIS:
                arcs['retour'].append((u, v))   # Cycle !
            elif debut[u] < debut[v]:
                arcs['avant'].append((u, v))
            else:
                arcs['croise'].append((u, v))

        couleur[u] = NOIR
        temps[0] += 1
        fin[u] = temps[0]

    for s in graphe.sommets():
        if couleur[s] == BLANC:
            dfs_visite(s)

    return arcs
```

### 4.5 Detection de cycles

**Graphe oriente :** un cycle existe si et seulement si le DFS rencontre un arc retour (sommet GRIS).

```python
def a_cycle_oriente(graphe):
    """Detecte si un graphe oriente contient un cycle. O(V + E)."""
    BLANC, GRIS, NOIR = 0, 1, 2
    couleur = {s: BLANC for s in graphe.sommets()}

    def dfs_visite(u):
        couleur[u] = GRIS
        for v, _ in graphe.voisins(u):
            if couleur[v] == GRIS:
                return True  # Arc retour = cycle
            if couleur[v] == BLANC and dfs_visite(v):
                return True
        couleur[u] = NOIR
        return False

    for s in graphe.sommets():
        if couleur[s] == BLANC:
            if dfs_visite(s):
                return True
    return False
```

### 4.6 Tri topologique

Un **tri topologique** d'un DAG est un ordre lineaire des sommets tel que pour tout arc (u, v), u apparait avant v. Il existe si et seulement si le graphe n'a pas de cycle.

```python
def tri_topologique(graphe):
    """
    Tri topologique par DFS.
    Les sommets sont ajoutes a la pile apres exploration de tous les descendants.
    L'inversion de la pile donne l'ordre topologique.
    Complexite : O(V + E).
    """
    visite = set()
    pile = []

    def dfs_topo(u):
        visite.add(u)
        for v, _ in graphe.voisins(u):
            if v not in visite:
                dfs_topo(v)
        pile.append(u)  # Ajoute apres exploration complete

    for s in graphe.sommets():
        if s not in visite:
            dfs_topo(s)

    pile.reverse()
    return pile
```

**Algorithme de Kahn (alternative BFS) :**

```python
from collections import deque

def tri_topologique_kahn(graphe):
    """
    Tri topologique par l'algorithme de Kahn (BFS-like).
    Base sur le retrait progressif des sommets de degre entrant 0.
    """
    degre_entrant = {s: 0 for s in graphe.sommets()}
    for u in graphe.sommets():
        for v, _ in graphe.voisins(u):
            degre_entrant[v] += 1

    file = deque([s for s in graphe.sommets() if degre_entrant[s] == 0])
    ordre = []

    while file:
        u = file.popleft()
        ordre.append(u)
        for v, _ in graphe.voisins(u):
            degre_entrant[v] -= 1
            if degre_entrant[v] == 0:
                file.append(v)

    if len(ordre) != len(list(graphe.sommets())):
        raise ValueError("Le graphe contient un cycle !")
    return ordre
```

---

## 5. Plus courts chemins

### 5.1 Algorithme de Dijkstra

**Probleme :** trouver le plus court chemin depuis une source vers tous les autres sommets dans un graphe a **poids positifs ou nuls**.

**Principe :** algorithme glouton qui, a chaque etape, selectionne le sommet non visite ayant la plus petite distance estimee et relache ses voisins.

```python
import heapq

def dijkstra(graphe, source):
    """
    Algorithme de Dijkstra avec file de priorite (tas min).
    Pre-condition : tous les poids sont >= 0.
    Complexite : O((V + E) * log V) avec un tas binaire.
    """
    distances = {s: float('inf') for s in graphe.sommets()}
    distances[source] = 0
    parents = {s: None for s in graphe.sommets()}
    tas = [(0, source)]  # (distance, sommet)
    visite = set()

    while tas:
        dist_u, u = heapq.heappop(tas)

        if u in visite:
            continue
        visite.add(u)

        for v, poids in graphe.voisins(u):
            if v not in visite:
                nouvelle_dist = dist_u + poids
                if nouvelle_dist < distances[v]:
                    distances[v] = nouvelle_dist
                    parents[v] = u
                    heapq.heappush(tas, (nouvelle_dist, v))

    return distances, parents
```

```c
/* Dijkstra simplifie avec matrice d'adjacence */
void dijkstra(GrapheMatrice *g, int source, int dist[], int parent[]) {
    bool visite[MAX_SOMMETS] = {false};

    for (int i = 0; i < g->n; i++) {
        dist[i] = INT_MAX;
        parent[i] = -1;
    }
    dist[source] = 0;

    for (int iter = 0; iter < g->n; iter++) {
        /* Trouver le sommet non visite le plus proche */
        int u = -1;
        for (int i = 0; i < g->n; i++) {
            if (!visite[i] && (u == -1 || dist[i] < dist[u]))
                u = i;
        }

        if (u == -1 || dist[u] == INT_MAX) break;
        visite[u] = true;

        /* Relacher les voisins de u */
        for (int v = 0; v < g->n; v++) {
            if (g->matrice[u][v] != 0 && !visite[v]) {
                int nouvelle_dist = dist[u] + g->matrice[u][v];
                if (nouvelle_dist < dist[v]) {
                    dist[v] = nouvelle_dist;
                    parent[v] = u;
                }
            }
        }
    }
}
/* Complexite : O(V^2) avec matrice, O((V+E) log V) avec tas */
```

**Test :**

```python
g = GrapheListes()
g.ajouter_arete('A', 'B', 4)
g.ajouter_arete('A', 'C', 2)
g.ajouter_arete('B', 'D', 3)
g.ajouter_arete('B', 'C', 1)
g.ajouter_arete('C', 'D', 4)
g.ajouter_arete('C', 'E', 5)
g.ajouter_arete('D', 'E', 1)

distances, parents = dijkstra(g, 'A')
print("Distances depuis A:")
for s in sorted(distances):
    print(f"  {s}: {distances[s]}")

chemin = reconstruire_chemin(parents, 'E')
print(f"Chemin A -> E: {chemin} (distance: {distances['E']})")
```

### 5.2 Pourquoi Dijkstra echoue avec les poids negatifs

Si un arc a un poids negatif, un sommet deja marque "visite" pourrait avoir une distance sous-optimale qu'un chemin passant par l'arc negatif ameliorerait. Dijkstra ne revient jamais sur un sommet visite, donc il rate cette amelioration.

**Exemple :** A-B: 1, A-C: 5, B-C: -10. Dijkstra visite B (dist 1), puis C (dist 5), mais le chemin A-B-C a cout 1-10 = -9.

### 5.3 Algorithme de Bellman-Ford

**Probleme :** plus courts chemins depuis une source, autorise les **poids negatifs**. Detecte les **cycles de poids negatif**.

**Principe :** relacher toutes les aretes |V| - 1 fois. Si une amelioration est encore possible au |V|-ieme passage, il y a un cycle negatif.

```python
def bellman_ford(graphe, source):
    """
    Algorithme de Bellman-Ford.
    Gere les poids negatifs et detecte les cycles negatifs.
    Complexite : O(V * E).
    """
    distances = {s: float('inf') for s in graphe.sommets()}
    distances[source] = 0
    parents = {s: None for s in graphe.sommets()}

    # Collecte de toutes les aretes
    aretes = []
    for u in graphe.sommets():
        for v, poids in graphe.voisins(u):
            aretes.append((u, v, poids))

    n = len(list(graphe.sommets()))

    # Relaxation : V-1 iterations
    for iteration in range(n - 1):
        amelioration = False
        for u, v, poids in aretes:
            if distances[u] != float('inf') and distances[u] + poids < distances[v]:
                distances[v] = distances[u] + poids
                parents[v] = u
                amelioration = True
        if not amelioration:
            break  # Optimisation : arret premature si aucun changement

    # Detection de cycle negatif : une V-ieme passe ne devrait rien changer
    for u, v, poids in aretes:
        if distances[u] != float('inf') and distances[u] + poids < distances[v]:
            raise ValueError("Cycle de poids negatif detecte !")

    return distances, parents
```

**Justification du nombre d'iterations :** dans un graphe de n sommets, tout plus court chemin simple a au plus n-1 aretes. Apres k iterations, les distances des chemins de longueur au plus k sont correctes. Donc apres n-1 iterations, toutes les distances sont correctes (s'il n'y a pas de cycle negatif).

### 5.4 Comparaison Dijkstra vs Bellman-Ford

| Critere | Dijkstra | Bellman-Ford |
|---------|----------|-------------|
| Complexite | O((V+E) log V) | O(V * E) |
| Poids negatifs | Non | Oui |
| Detection cycle negatif | Non | Oui |
| Structure de donnees | Tas / file de priorite | Aucune |
| Utilisation | Poids >= 0 | Poids quelconques |

---

## 6. Arbres couvrants minimaux

### 6.1 Definitions

Un **arbre couvrant** d'un graphe connexe G est un sous-graphe connexe acyclique (arbre) qui contient tous les sommets de G. Il a exactement |V| - 1 aretes.

Un **arbre couvrant minimal** (ACM) est un arbre couvrant dont la somme des poids des aretes est minimale.

**Propriete de coupure :** pour toute coupure du graphe (partition des sommets en deux ensembles), l'arete de poids minimal traversant la coupure appartient a un ACM.

### 6.2 Union-Find (structure auxiliaire)

La structure **Union-Find** (ensembles disjoints) est utilisee par Kruskal pour detecter les cycles efficacement.

```python
class UnionFind:
    """Structure Union-Find avec compression de chemin et union par rang.
    Complexite amortie : quasi O(1) par operation (inverse d'Ackermann).
    """

    def __init__(self, elements):
        self.parent = {x: x for x in elements}
        self.rang = {x: 0 for x in elements}

    def trouver(self, x):
        """Trouve le representant de x avec compression de chemin."""
        if self.parent[x] != x:
            self.parent[x] = self.trouver(self.parent[x])  # Compression
        return self.parent[x]

    def unir(self, x, y):
        """Unit les ensembles contenant x et y. Retourne True si fusion effectuee."""
        rx, ry = self.trouver(x), self.trouver(y)
        if rx == ry:
            return False  # Deja dans le meme ensemble (cycle)
        # Union par rang : le plus petit arbre est rattache au plus grand
        if self.rang[rx] < self.rang[ry]:
            rx, ry = ry, rx
        self.parent[ry] = rx
        if self.rang[rx] == self.rang[ry]:
            self.rang[rx] += 1
        return True
```

### 6.3 Algorithme de Kruskal

**Principe :** trier les aretes par poids croissant, puis les ajouter une par une si elles ne creent pas de cycle (verifie par Union-Find).

```python
def kruskal(graphe):
    """
    Algorithme de Kruskal pour l'arbre couvrant minimal.
    Complexite : O(E log E) (dominee par le tri des aretes).
    """
    # Collecter toutes les aretes (eviter les doublons)
    aretes = set()
    for u in graphe.sommets():
        for v, poids in graphe.voisins(u):
            arete = (poids, min(u, v), max(u, v))
            aretes.add(arete)
    aretes = sorted(aretes)  # Tri par poids croissant

    uf = UnionFind(graphe.sommets())
    acm = []
    poids_total = 0

    for poids, u, v in aretes:
        if uf.unir(u, v):  # Pas de cycle
            acm.append((u, v, poids))
            poids_total += poids
            if len(acm) == len(list(graphe.sommets())) - 1:
                break  # ACM complet

    return acm, poids_total
```

### 6.4 Algorithme de Prim

**Principe :** partir d'un sommet arbitraire et ajouter a chaque etape l'arete de poids minimal reliant un sommet de l'arbre a un sommet hors de l'arbre. Similaire a Dijkstra dans son fonctionnement.

```python
import heapq

def prim(graphe, depart):
    """
    Algorithme de Prim pour l'arbre couvrant minimal.
    Complexite : O((V + E) log V) avec un tas binaire.
    """
    visite = set()
    acm = []
    poids_total = 0
    tas = [(0, depart, None)]  # (poids, sommet_courant, sommet_parent)

    while tas and len(visite) < len(list(graphe.sommets())):
        poids, u, parent = heapq.heappop(tas)
        if u in visite:
            continue
        visite.add(u)
        if parent is not None:
            acm.append((parent, u, poids))
            poids_total += poids

        for v, p in graphe.voisins(u):
            if v not in visite:
                heapq.heappush(tas, (p, v, u))

    return acm, poids_total
```

**Test :**

```python
g = GrapheListes()
aretes = [('A','B',4), ('A','H',8), ('B','C',8), ('B','H',11),
          ('C','D',7), ('C','F',4), ('C','I',2), ('D','E',9),
          ('D','F',14), ('E','F',10), ('F','G',2), ('G','H',1),
          ('G','I',6), ('H','I',7)]
for u, v, p in aretes:
    g.ajouter_arete(u, v, p)

acm_k, poids_k = kruskal(g)
print(f"Kruskal - poids total: {poids_k}")
for u, v, p in acm_k:
    print(f"  {u} -- {v} : {p}")

acm_p, poids_p = prim(g, 'A')
print(f"\nPrim - poids total: {poids_p}")
for u, v, p in acm_p:
    print(f"  {u} -- {v} : {p}")
```

### 6.5 Comparaison Kruskal vs Prim

| Critere | Kruskal | Prim |
|---------|---------|------|
| Complexite | O(E log E) | O((V+E) log V) |
| Structure | Union-Find | Tas binaire |
| Prefere pour | Graphes creux | Graphes denses |
| Approche | Globale (aretes triees) | Locale (croissance) |

---

## 7. Composantes connexes et fortement connexes

### 7.1 Composantes connexes (graphe non oriente)

```python
def composantes_connexes(graphe):
    """
    Trouve les composantes connexes par BFS.
    Complexite : O(V + E).
    """
    visite = set()
    composantes = []

    for s in graphe.sommets():
        if s not in visite:
            composante = []
            file = deque([s])
            visite.add(s)
            while file:
                u = file.popleft()
                composante.append(u)
                for v, _ in graphe.voisins(u):
                    if v not in visite:
                        visite.add(v)
                        file.append(v)
            composantes.append(composante)

    return composantes
```

### 7.2 Algorithme de Tarjan (CFC)

L'algorithme de Tarjan trouve les **composantes fortement connexes** d'un graphe oriente en un seul parcours DFS.

**Principe :** chaque sommet recoit un numero d'ordre (decouverte DFS) et un "lowlink" (le plus petit numero d'ordre accessible en remontant les arcs retour). Un sommet est racine d'une CFC si son lowlink est egal a son numero d'ordre.

```python
def tarjan(graphe):
    """
    Algorithme de Tarjan pour les composantes fortement connexes.
    Complexite : O(V + E).
    """
    index_compteur = [0]
    pile = []
    sur_pile = set()
    index = {}
    lowlink = {}
    cfcs = []

    def strongconnect(v):
        index[v] = index_compteur[0]
        lowlink[v] = index_compteur[0]
        index_compteur[0] += 1
        pile.append(v)
        sur_pile.add(v)

        for w, _ in graphe.voisins(v):
            if w not in index:
                # w n'a pas encore ete visite
                strongconnect(w)
                lowlink[v] = min(lowlink[v], lowlink[w])
            elif w in sur_pile:
                # w est sur la pile, donc dans la CFC courante
                lowlink[v] = min(lowlink[v], index[w])

        # Si v est racine d'une CFC
        if lowlink[v] == index[v]:
            cfc = []
            while True:
                w = pile.pop()
                sur_pile.remove(w)
                cfc.append(w)
                if w == v:
                    break
            cfcs.append(cfc)

    for v in graphe.sommets():
        if v not in index:
            strongconnect(v)

    return cfcs
```

**Test :**

```python
g_oriente = GrapheListes()
for s in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']:
    g_oriente.ajouter_sommet(s)
arcs = [('A','B'), ('B','C'), ('C','A'),   # CFC {A,B,C}
        ('C','D'), ('D','E'), ('E','F'),
        ('F','D'),                          # CFC {D,E,F}
        ('F','G'), ('G','H'), ('H','G')]    # CFC {G,H}
for u, v in arcs:
    g_oriente.adj[u].append((v, 1))

cfcs = tarjan(g_oriente)
print("Composantes fortement connexes:")
for i, cfc in enumerate(cfcs):
    print(f"  CFC {i+1}: {cfc}")
```

### 7.3 Graphe de condensation

Le **graphe de condensation** (ou DAG des CFC) est obtenu en contractant chaque CFC en un seul sommet. Ce graphe est toujours un DAG. Il est utile pour resoudre des problemes comme la propagation d'information dans un graphe oriente.

---

## 8. Applications

### 8.1 Routage reseau (Dijkstra / OSPF)

```python
def simuler_routage(topologie, routeur_source):
    """Simule le calcul de table de routage avec Dijkstra (protocole OSPF)."""
    distances, parents = dijkstra(topologie, routeur_source)

    print(f"Table de routage pour {routeur_source}:")
    print(f"{'Destination':<15} {'Distance':<10} {'Prochain saut'}")
    print("-" * 40)

    for dest in sorted(distances):
        if dest == routeur_source:
            continue
        chemin = reconstruire_chemin(parents, dest)
        prochain_saut = chemin[1] if chemin and len(chemin) > 1 else "-"
        print(f"{dest:<15} {distances[dest]:<10} {prochain_saut}")

reseau = GrapheListes()
liens = [('R1','R2',10), ('R1','R3',5), ('R2','R3',2),
         ('R2','R4',1), ('R3','R4',9), ('R3','R5',2),
         ('R4','R5',4)]
for u, v, p in liens:
    reseau.ajouter_arete(u, v, p)

simuler_routage(reseau, 'R1')
```

### 8.2 Ordonnancement de taches (tri topologique)

```python
def ordonnancer_taches(dependances):
    """
    Determine un ordre d'execution des taches respectant les dependances.
    dependances : dict {tache: [liste des prerequis]}
    """
    g = GrapheListes()
    for tache in dependances:
        g.ajouter_sommet(tache)
    for tache, prereqs in dependances.items():
        for prereq in prereqs:
            g.adj.setdefault(prereq, [])
            g.adj[prereq].append((tache, 1))

    ordre = tri_topologique_kahn(g)
    print("Ordre d'execution des taches:")
    for i, tache in enumerate(ordre, 1):
        print(f"  {i}. {tache}")

dependances = {
    'compilation': ['edition'],
    'edition': [],
    'tests': ['compilation'],
    'documentation': ['edition'],
    'livraison': ['tests', 'documentation'],
    'deploiement': ['livraison']
}
ordonnancer_taches(dependances)
```

---

## 9. Tableau recapitulatif des complexites

| Algorithme | Complexite temps | Espace | Contraintes |
|------------|-----------------|--------|-------------|
| BFS | O(V + E) | O(V) | -- |
| DFS | O(V + E) | O(V) | -- |
| Dijkstra (tas) | O((V+E) log V) | O(V) | Poids >= 0 |
| Dijkstra (matrice) | O(V^2) | O(V) | Poids >= 0 |
| Bellman-Ford | O(V * E) | O(V) | Detecte cycles negatifs |
| Kruskal | O(E log E) | O(V) | Union-Find |
| Prim (tas) | O((V+E) log V) | O(V) | -- |
| Tarjan (CFC) | O(V + E) | O(V) | Graphe oriente |
| Tri topologique | O(V + E) | O(V) | DAG uniquement |

---

## Exercices

### Exercice 1 -- Representations

Representer le graphe suivant sous forme de matrice d'adjacence ET de listes d'adjacence : sommets {1, 2, 3, 4, 5}, aretes {(1,2), (1,3), (2,4), (3,4), (3,5), (4,5)}. Calculer le degre de chaque sommet et verifier le lemme des poignees de main.

### Exercice 2 -- BFS

Ecrire une fonction `distance_bfs(graphe, source, destination)` qui retourne la distance (nombre d'aretes) entre deux sommets. Si aucun chemin n'existe, retourner -1. Tester sur un graphe deconnecte.

### Exercice 3 -- Detection de bipartition

Un graphe est biparti si ses sommets peuvent etre colories en deux couleurs tel que deux sommets adjacents n'ont jamais la meme couleur. Ecrire un algorithme base sur BFS pour determiner si un graphe est biparti. Quel est le lien avec les cycles de longueur impaire ?

### Exercice 4 -- Dijkstra

Appliquer l'algorithme de Dijkstra au graphe suivant (depart : A) :
A-B: 6, A-C: 2, A-D: 1, B-E: 2, C-B: 3, C-D: 1, C-E: 5, D-C: 1, D-E: 6.
Donner les distances finales et le chemin le plus court vers E. Tracer l'execution pas a pas.

### Exercice 5 -- Kruskal vs Prim

Appliquer les deux algorithmes au meme graphe et verifier qu'ils donnent le meme poids total. Les aretes de l'ACM sont-elles forcement identiques ? Donner un contre-exemple si non.

### Exercice 6 -- Composantes fortement connexes

Dessiner un graphe oriente a 8 sommets ayant exactement 3 CFC. Verifier avec l'algorithme de Tarjan. Construire le graphe de condensation et verifier que c'est un DAG.

### Exercice 7 -- Application pratique

Modeliser un reseau de metro (stations = sommets, lignes = aretes, temps de trajet = poids) et implementer un planificateur de trajet utilisant Dijkstra. Le planificateur doit afficher le chemin complet avec les correspondances et le temps total.

---

## References

- **Introduction to Algorithms** (CLRS) -- Cormen, Leiserson, Rivest, Stein (chapitres 22-26)
- **Algorithm Design** -- Jon Kleinberg, Eva Tardos (chapitres 3-4, 6)
- **Graph Theory** -- Reinhard Diestel (disponible en ligne)
- **Programme officiel MP2I/MPI** -- Bulletin officiel de l'education nationale
- **Visualisation de graphes** -- <https://visualgo.net/en/sssp>
- **NetworkX** (Python) -- <https://networkx.org/>
