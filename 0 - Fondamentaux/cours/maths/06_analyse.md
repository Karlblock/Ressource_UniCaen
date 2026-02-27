# Chapitre 6 -- Analyse reelle

## Objectifs du chapitre

- Maitriser la notion de convergence des suites reelles et les outils associes (monotonie, Cauchy, Bolzano-Weierstrass).
- Etudier les suites recurrentes : points fixes, convergence, vitesse de convergence.
- Connaitre les proprietes fondamentales des fonctions continues et derivables.
- Demontrer et appliquer les theoremes de Rolle, des accroissements finis, et les formules de Taylor.
- Comprendre l'integration de Riemann et les integrales generalisees.
- Etudier les series numeriques avec les principaux criteres de convergence.
- Aborder les suites et series de fonctions avec la convergence uniforme.
- Resoudre les equations differentielles lineaires d'ordres 1 et 2 a coefficients constants.

---

## 1. Suites numeriques

### 1.1 Generalites et convergence

**Definition 1.1 (Suite)**
Une suite reelle est une application u : N -> R. On note (u_n)_{n >= 0} ou simplement (u_n).

**Definition 1.2 (Convergence)**
La suite (u_n) *converge* vers L dans R si :

    pour tout epsilon > 0, il existe N dans N tel que
    pour tout n >= N, |u_n - L| < epsilon

On note u_n -> L ou lim_{n -> +infini} u_n = L. Une suite qui ne converge pas est dite *divergente*.

> **Interpretation :** A partir d'un certain rang N, tous les termes de la suite sont dans l'intervalle ]L - epsilon, L + epsilon[, aussi petit que soit epsilon > 0.

**Definition 1.3 (Suite bornee)**
(u_n) est *bornee* s'il existe M >= 0 tel que |u_n| <= M pour tout n.

**Proposition 1.1**
Toute suite convergente est bornee.

*Preuve :* Soit L = lim u_n. Pour epsilon = 1, il existe N tel que |u_n - L| < 1 pour n >= N. Donc |u_n| < |L| + 1 pour n >= N. On pose M = max(|u_0|, |u_1|, ..., |u_{N-1}|, |L| + 1). Alors |u_n| <= M pour tout n. CQFD.

La reciproque est fausse : u_n = (-1)^n est bornee mais divergente.

**Theoreme 1.1 (Unicite de la limite)**
Si (u_n) converge, sa limite est unique.

*Preuve :* Supposons u_n -> L et u_n -> L' avec L != L'. Pour epsilon = |L - L'|/2 > 0, il existe N_1 tel que |u_n - L| < epsilon pour n >= N_1, et N_2 tel que |u_n - L'| < epsilon pour n >= N_2. Pour n >= max(N_1, N_2) :

    |L - L'| <= |L - u_n| + |u_n - L'| < 2*epsilon = |L - L'|

Contradiction. CQFD.

### 1.2 Operations sur les limites

**Proposition 1.2**
Si u_n -> L et v_n -> L', alors :

- u_n + v_n -> L + L'
- lambda * u_n -> lambda * L pour tout lambda dans R
- u_n * v_n -> L * L'
- u_n / v_n -> L / L' si L' != 0 et v_n != 0 a partir d'un certain rang

**Theoreme 1.2 (Theoreme des gendarmes)**
Si u_n <= w_n <= v_n a partir d'un certain rang et si u_n -> L et v_n -> L, alors w_n -> L.

*Preuve :* Pour epsilon > 0, il existe N tel que pour n >= N : L - epsilon < u_n et v_n < L + epsilon. Donc L - epsilon < u_n <= w_n <= v_n < L + epsilon, soit |w_n - L| < epsilon. CQFD.

### 1.3 Suites monotones

**Theoreme 1.3 (Convergence monotone)**
Toute suite croissante majoree converge. Toute suite decroissante minoree converge.

*Preuve :* Soit (u_n) croissante majoree. L'ensemble {u_n : n dans N} est non vide et majore, donc admet une borne superieure L = sup{u_n} (axiome de la borne superieure dans R).

Pour tout epsilon > 0, L - epsilon n'est pas un majorant de {u_n}, donc il existe N tel que u_N > L - epsilon. Pour n >= N, par croissance : L - epsilon < u_N <= u_n <= L. Donc |u_n - L| <= epsilon. CQFD.

> **Remarque :** Ce theoreme utilise de maniere essentielle la *completude* de R (axiome de la borne superieure). Il est faux dans Q : la suite u_{n+1} = (u_n + 2/u_n)/2 avec u_0 = 1 est decroissante minoree par 0 dans Q, mais converge vers sqrt(2) qui n'est pas rationnel.

### 1.4 Suites recurrentes

**Methode d'etude des suites u_{n+1} = f(u_n) :**

1. Determiner les *points fixes* de f : resoudre f(x) = x.
2. Etudier la monotonie de (u_n) (signe de f(x) - x sur l'intervalle de travail).
3. Montrer que la suite est bornee (par recurrence ou par etude de f).
4. Conclure par le theoreme de convergence monotone.
5. Identifier la limite parmi les points fixes (la limite d'une suite recurrente u_{n+1} = f(u_n), si elle existe et si f est continue, est necessairement un point fixe de f).

**Exemple 1.1 :** Soit u_0 = 1 et u_{n+1} = sqrt(2 + u_n).

Points fixes : x = sqrt(2 + x), donc x^2 = 2 + x (pour x >= 0), soit x^2 - x - 2 = 0, d'ou x = 2 (on rejette x = -1 < 0).

On montre par recurrence que 0 < u_n < 2 pour tout n, et que (u_n) est croissante (car f(x) - x = sqrt(2+x) - x >= 0 pour x dans [0, 2], ce qui se verifie en etudiant la fonction g(x) = sqrt(2+x) - x). Donc (u_n) converge vers 2.

**Vitesse de convergence.** Si f est derivable au point fixe L avec |f'(L)| < 1, la convergence est *geometrique* : |u_n - L| = O(|f'(L)|^n). Si f'(L) = 0, la convergence est *super-lineaire* (au moins quadratique si f''(L) != 0).

### 1.5 Suites adjacentes

**Definition 1.4**
Deux suites (u_n) et (v_n) sont *adjacentes* si l'une est croissante, l'autre decroissante, et u_n - v_n -> 0.

**Theoreme 1.4**
Deux suites adjacentes convergent vers la meme limite L, et on a u_n <= L <= v_n (ou inversement) pour tout n.

> **Application :** Les suites adjacentes fournissent des encadrements : on sait que la limite est dans [u_n, v_n] (si u_n croissante, v_n decroissante), intervalle de longueur tendant vers 0.

### 1.6 Suites de Cauchy

**Definition 1.5 (Suite de Cauchy)**
(u_n) est une *suite de Cauchy* si :

    pour tout epsilon > 0, il existe N dans N tel que
    pour tout m, n >= N, |u_m - u_n| < epsilon

**Theoreme 1.5 (Completude de R)**
Une suite reelle est convergente si et seulement si elle est de Cauchy.

*Preuve (sens direct) :* Si u_n -> L, pour epsilon > 0, il existe N tel que |u_n - L| < epsilon/2 pour n >= N. Pour m, n >= N :

    |u_m - u_n| <= |u_m - L| + |L - u_n| < epsilon/2 + epsilon/2 = epsilon

CQFD.

*Preuve (sens reciproque) :* Une suite de Cauchy est bornee (prendre epsilon = 1 : tous les termes a partir du rang N sont dans un intervalle de longueur 2 centre sur u_N, et il n'y a qu'un nombre fini de termes avant N). Par Bolzano-Weierstrass (Theoreme 1.6 ci-dessous), elle admet une sous-suite convergente (u_{phi(n)}) -> L. On montre alors que u_n -> L en utilisant la propriete de Cauchy et l'inegalite triangulaire. CQFD.

> **Importance :** Le critere de Cauchy permet de prouver la convergence d'une suite *sans connaitre la limite*.

### 1.7 Sous-suites et Bolzano-Weierstrass

**Definition 1.6 (Sous-suite)**
Une sous-suite (ou suite extraite) de (u_n) est une suite de la forme (u_{phi(n)}) ou phi : N -> N est strictement croissante.

**Theoreme 1.6 (Bolzano-Weierstrass)**
De toute suite *bornee* on peut extraire une sous-suite convergente.

*Preuve (par dichotomie) :* Soit (u_n) bornee, incluse dans [a, b].

On coupe [a, b] en deux moities egales. L'une au moins contient une infinite de termes de la suite (sinon la suite serait finie). On note [a_1, b_1] cette moitie.

On itere : on construit des intervalles emboites [a_k, b_k] de longueur (b-a)/2^k, chacun contenant une infinite de termes. On extrait phi(0) dans [a_0, b_0], phi(1) > phi(0) dans [a_1, b_1], etc.

La suite (u_{phi(n)}) est telle que u_{phi(n)} est dans [a_n, b_n] pour tout n. Comme les intervalles sont emboites et de longueur tendant vers 0, les suites (a_n) et (b_n) convergent vers la meme limite L, et par encadrement, u_{phi(n)} -> L. CQFD.

---

## 2. Fonctions continues

### 2.1 Continuite en un point

**Definition 2.1**
f : I -> R est *continue en a* dans I si :

    pour tout epsilon > 0, il existe delta > 0 tel que
    pour tout x dans I, |x - a| < delta implique |f(x) - f(a)| < epsilon

**Caracterisation sequentielle :** f est continue en a si et seulement si pour toute suite (x_n) de I convergeant vers a, on a f(x_n) -> f(a).

**Proposition 2.1**
Les operations algebriques preservent la continuite : somme, produit, quotient (si denominateur non nul), composee de fonctions continues sont continues.

### 2.2 Theoremes fondamentaux

**Theoreme 2.1 (Valeurs intermediaires, TVI)**
Si f : [a, b] -> R est continue et si f(a) * f(b) < 0, alors il existe c dans ]a, b[ tel que f(c) = 0.

*Preuve (par dichotomie) :* Posons a_0 = a, b_0 = b. A chaque etape, on considere le milieu m = (a_n + b_n)/2 :
- Si f(m) = 0, c'est fini.
- Si f(m) * f(a_n) < 0, on pose a_{n+1} = a_n, b_{n+1} = m.
- Sinon, on pose a_{n+1} = m, b_{n+1} = b_n.

On a f(a_n) * f(b_n) <= 0 pour tout n, et b_n - a_n = (b-a)/2^n -> 0. Les suites (a_n) et (b_n) sont adjacentes, convergent vers un meme c, et par continuite : f(c)^2 = lim f(a_n)*f(b_n) <= 0, donc f(c) = 0. CQFD.

> **Remarque algorithmique :** La preuve est constructive et fournit un algorithme de recherche de zero (methode de dichotomie). A chaque etape, l'intervalle est divise par 2 : apres n etapes, l'erreur est au plus (b-a)/2^n. Pour une precision epsilon, il faut n = ceil(log_2((b-a)/epsilon)) etapes.

**Theoreme 2.2 (Version generale du TVI)**
Si f : [a, b] -> R est continue, alors f([a, b]) est un intervalle. Plus precisement, f([a, b]) = [m, M] ou m = min f([a,b]) et M = max f([a,b]).

**Theoreme 2.3 (Bornes atteintes)**
Toute fonction continue sur un segment [a, b] est bornee et atteint ses bornes.

*Preuve (pour la borne superieure) :* f continue sur [a,b] est bornee (sinon on construit (x_n) avec |f(x_n)| -> +infini ; par Bolzano-Weierstrass, il existe une sous-suite (x_{phi(n)}) -> c dans [a,b] ; par continuite f(x_{phi(n)}) -> f(c) fini, contradiction).

Soit M = sup{f(x) : x in [a,b]}. Pour tout n, il existe x_n tel que f(x_n) > M - 1/n. Par Bolzano-Weierstrass, il existe une sous-suite (x_{phi(n)}) -> c dans [a,b]. Par continuite, f(c) = lim f(x_{phi(n)}) = M. CQFD.

### 2.3 Continuite uniforme

**Definition 2.2 (Continuite uniforme)**
f : I -> R est *uniformement continue* sur I si :

    pour tout epsilon > 0, il existe delta > 0 tel que
    pour tout x, y dans I, |x - y| < delta implique |f(x) - f(y)| < epsilon

La difference avec la continuite : delta ne depend que de epsilon, pas du point.

**Theoreme 2.4 (Heine)**
Toute fonction continue sur un *segment* [a, b] est uniformement continue.

*Preuve :* Par l'absurde. Si f n'est pas uniformement continue, il existe epsilon_0 > 0 et des suites (x_n), (y_n) dans [a,b] avec |x_n - y_n| < 1/n et |f(x_n) - f(y_n)| >= epsilon_0. Par Bolzano-Weierstrass, on extrait x_{phi(n)} -> c. Alors y_{phi(n)} -> c aussi. Par continuite, f(x_{phi(n)}) -> f(c) et f(y_{phi(n)}) -> f(c), donc |f(x_{phi(n)}) - f(y_{phi(n)})| -> 0. Contradiction avec >= epsilon_0. CQFD.

### 2.4 Fonctions lipschitziennes

**Definition 2.3**
f est *k-lipschitzienne* sur I si |f(x) - f(y)| <= k|x - y| pour tout x, y dans I.

Lipschitzienne implique uniformement continue (prendre delta = epsilon/k). Uniformement continue n'implique pas lipschitzienne (contre-exemple : sqrt(x) sur [0, 1]).

### 2.5 Bijection continue et fonctions reciproques

**Theoreme 2.5 (Bijection continue)**
Soit f : I -> R continue et strictement monotone sur un intervalle I. Alors f est une bijection de I sur f(I) (qui est un intervalle), et la bijection reciproque f^{-1} : f(I) -> I est continue et strictement monotone de meme sens.

---

## 3. Derivation

### 3.1 Definition et interpretation

**Definition 3.1**
f : I -> R est *derivable en a* (a dans l'interieur de I) si le taux d'accroissement admet une limite finie :

    f'(a) = lim_{h -> 0} (f(a+h) - f(a)) / h

Geometriquement, f'(a) est la pente de la tangente au graphe de f au point (a, f(a)).

**Proposition 3.1**
Derivable en a implique continue en a.

*Preuve :* f(a+h) - f(a) = ((f(a+h) - f(a))/h) * h -> f'(a) * 0 = 0 quand h -> 0. CQFD.

La reciproque est fausse : x -> |x| est continue en 0 mais non derivable.

**Definition 3.2 (Classes de regularite)**
f est de *classe C^k* sur I si f est k fois derivable sur I et f^{(k)} est continue. f est de *classe C^infini* (ou *lisse*) si elle est infiniment derivable.

### 3.2 Theoreme de Rolle et accroissements finis

**Theoreme 3.1 (Rolle)**
Soit f : [a, b] -> R continue sur [a, b], derivable sur ]a, b[, avec f(a) = f(b). Alors il existe c dans ]a, b[ tel que f'(c) = 0.

*Preuve :* f continue sur [a, b] atteint son maximum M et son minimum m (Theoreme 2.3).

Si m = M, f est constante, donc f' = 0 partout sur ]a, b[.

Si m != M, l'un des deux (m ou M) est different de f(a) = f(b), donc est atteint en un point interieur c dans ]a, b[. En ce point c, f a un extremum local. Pour tout h assez petit :

    (f(c+h) - f(c))/h >= 0 pour h > 0 petit (si c est un maximum) => f'(c) >= 0 au passage a la limite
    (f(c+h) - f(c))/h <= 0 pour h < 0 petit (si c est un maximum) => f'(c) <= 0 au passage a la limite

Donc f'(c) = 0. CQFD.

**Theoreme 3.2 (Egalite des accroissements finis, EAF)**
Soit f : [a, b] -> R continue sur [a, b], derivable sur ]a, b[. Alors il existe c dans ]a, b[ tel que :

    f(b) - f(a) = f'(c) * (b - a)

*Preuve :* On applique Rolle a la fonction auxiliaire :

    g(x) = f(x) - f(a) - ((f(b) - f(a))/(b - a)) * (x - a)

On verifie : g est continue sur [a,b], derivable sur ]a,b[, g(a) = 0, g(b) = 0. Par Rolle, il existe c avec g'(c) = 0, soit f'(c) - (f(b)-f(a))/(b-a) = 0. CQFD.

**Corollaire 3.1 (Inegalite des accroissements finis, IAF)**
Si |f'(x)| <= M pour tout x dans ]a, b[, alors :

    |f(b) - f(a)| <= M * |b - a|

**Applications du TAF :**

- f' >= 0 sur I implique f croissante sur I.
- f' = 0 sur I implique f constante sur I.
- |f'| <= k < 1 sur I implique f est contractante, ce qui garantit l'existence et l'unicite d'un point fixe (theoreme du point fixe de Banach).

### 3.3 Formules de Taylor

**Theoreme 3.3 (Taylor-Young, developpement limite)**
Si f est n fois derivable en a, alors :

    f(x) = sum_{k=0}^{n} (f^{(k)}(a) / k!) * (x - a)^k + o((x - a)^n)

quand x -> a. C'est le *developpement limite* d'ordre n de f au voisinage de a.

**Theoreme 3.4 (Taylor avec reste integral)**
Si f est de classe C^{n+1} sur un intervalle contenant a et x :

    f(x) = sum_{k=0}^{n} (f^{(k)}(a) / k!) * (x - a)^k + int_a^x ((x-t)^n / n!) * f^{(n+1)}(t) dt

Le dernier terme est le reste integral, expression *exacte* de l'erreur.

**Theoreme 3.5 (Taylor-Lagrange)**
Sous les memes hypotheses, il existe c entre a et x tel que :

    f(x) = sum_{k=0}^{n} (f^{(k)}(a) / k!) * (x - a)^k + (f^{(n+1)}(c) / (n+1)!) * (x - a)^{n+1}

**Corollaire 3.2 (Majoration du reste)**
Si |f^{(n+1)}(t)| <= M_{n+1} pour t entre a et x :

    |f(x) - sum_{k=0}^{n} (f^{(k)}(a)/k!) (x-a)^k| <= M_{n+1} * |x-a|^{n+1} / (n+1)!

> **Application :** Taylor-Lagrange est l'outil principal pour *majorer l'erreur* dans les approximations polynomiales. Par exemple, pour estimer e^x avec n termes, l'erreur est au plus e^{|x|} * |x|^{n+1} / (n+1)!.

---

## 4. Integration de Riemann

### 4.1 Fonctions en escalier et integrale

**Definition 4.1 (Subdivision)**
Une subdivision de [a, b] est une famille finie sigma = (x_0, x_1, ..., x_n) avec a = x_0 < x_1 < ... < x_n = b. Le *pas* de la subdivision est max(x_{i+1} - x_i).

**Definition 4.2 (Fonction en escalier)**
f est *en escalier* sur [a, b] s'il existe une subdivision telle que f est constante sur chaque intervalle ouvert ]x_{i-1}, x_i[.

**Definition 4.3 (Integrale de Riemann)**
f : [a, b] -> R est *Riemann-integrable* si pour tout epsilon > 0, il existe des fonctions en escalier phi et psi telles que phi <= f <= psi et :

    int_a^b (psi - phi) < epsilon

L'integrale de f est alors l'unique reel compris entre sup{int phi : phi <= f en escalier} et inf{int psi : psi >= f en escalier}.

**Theoreme 4.1 (Classes de fonctions integrables)**
Sont Riemann-integrables sur [a, b] :
- Toute fonction continue.
- Toute fonction monotone.
- Toute fonction continue par morceaux.

### 4.2 Proprietes de l'integrale

**Proprietes fondamentales :**

- **Linearite :** int_a^b (alpha*f + beta*g) = alpha * int_a^b f + beta * int_a^b g.
- **Positivite :** si f >= 0, alors int_a^b f >= 0.
- **Croissance :** si f <= g, alors int_a^b f <= int_a^b g.
- **Inegalite triangulaire :** |int_a^b f| <= int_a^b |f|.
- **Relation de Chasles :** int_a^b f = int_a^c f + int_c^b f pour tout c dans [a, b].

**Proposition 4.1 (Fonction positive d'integrale nulle)**
Si f est continue, f >= 0, et int_a^b f = 0, alors f = 0 sur [a, b].

*Preuve :* Si f(c) > 0 pour un c dans ]a,b[, par continuite il existe delta > 0 tel que f(x) >= f(c)/2 > 0 pour |x - c| < delta. Donc int_a^b f >= int_{c-delta}^{c+delta} f(c)/2 > 0. Contradiction. CQFD.

### 4.3 Theoreme fondamental de l'analyse

**Theoreme 4.2 (Theoreme fondamental)**
Si f est continue sur [a, b], la fonction F definie par :

    F(x) = int_a^x f(t) dt

est l'unique primitive de f qui s'annule en a. En particulier, F est derivable et F'(x) = f(x).

*Preuve :* (F(x+h) - F(x))/h = (1/h) * int_x^{x+h} f(t) dt. Par continuite de f, pour tout epsilon, il existe delta tel que |t - x| < delta implique |f(t) - f(x)| < epsilon. Pour |h| < delta :

    |(1/h) int_x^{x+h} f(t) dt - f(x)| = |(1/h) int_x^{x+h} (f(t) - f(x)) dt| <= epsilon

Donc F'(x) = f(x). CQFD.

**Corollaire 4.1 (Formule de Newton-Leibniz)**
Si G est une primitive quelconque de f continue :

    int_a^b f(t) dt = G(b) - G(a) = [G(t)]_a^b

### 4.4 Integration par parties et changement de variable

**Theoreme 4.3 (Integration par parties, IPP)**
Si u et v sont C^1 sur [a, b] :

    int_a^b u(t) * v'(t) dt = [u(t) * v(t)]_a^b - int_a^b u'(t) * v(t) dt

*Preuve :* (u*v)' = u'v + uv'. On integre de a a b et on reorganise. CQFD.

**Theoreme 4.4 (Changement de variable)**
Si phi : [alpha, beta] -> [a, b] est un C^1-diffeomorphisme et f est continue :

    int_a^b f(t) dt = int_alpha^beta f(phi(s)) * phi'(s) ds

### 4.5 Integrales generalisees (impropres)

**Definition 4.4**
Si f est continue sur [a, +infini[, l'integrale generalisee est :

    int_a^{+infini} f(t) dt = lim_{x -> +infini} int_a^x f(t) dt

si cette limite existe et est finie (on dit que l'integrale *converge*).

Meme definition si f est continue sur [a, b[ avec une singularite en b :

    int_a^b f(t) dt = lim_{x -> b^-} int_a^x f(t) dt

**Theoreme 4.5 (Integrales de Riemann, reference)**
- int_1^{+infini} 1/t^alpha dt converge si et seulement si alpha > 1.
- int_0^1 1/t^alpha dt converge si et seulement si alpha < 1.

*Preuve (premier cas) :* Pour alpha != 1, une primitive de 1/t^alpha est t^{1-alpha}/(1-alpha). Donc int_1^x 1/t^alpha dt = (x^{1-alpha} - 1)/(1-alpha). Quand x -> +infini : si alpha > 1, 1-alpha < 0 donc x^{1-alpha} -> 0, l'integrale converge vers 1/(alpha-1). Si alpha < 1, x^{1-alpha} -> +infini, divergence. Si alpha = 1, int = ln(x) -> +infini. CQFD.

**Theoreme 4.6 (Comparaison pour les fonctions positives)**
Si 0 <= f(t) <= g(t) pour t assez grand :
- int g convergente implique int f convergente (et int f <= int g).
- int f divergente implique int g divergente.

**Theoreme 4.7 (Convergence absolue)**
Si int_a^{+infini} |f(t)| dt converge, alors int_a^{+infini} f(t) dt converge. On dit que l'integrale est *absolument convergente*.

> La reciproque est fausse : int_0^{+infini} sin(t)/t dt converge (integrale de Dirichlet) mais n'est pas absolument convergente.

---

## 5. Series numeriques

### 5.1 Definitions

**Definition 5.1**
La *serie* de terme general a_n est la suite des sommes partielles :

    S_N = sum_{n=0}^{N} a_n

La serie *converge* si la suite (S_N) converge. Sa *somme* est S = lim S_N = sum_{n=0}^{+infini} a_n.

**Proposition 5.1 (Condition necessaire de convergence)**
Si la serie sum a_n converge, alors a_n -> 0.

*Preuve :* a_n = S_n - S_{n-1} -> S - S = 0. CQFD.

La reciproque est **fausse** : la serie harmonique sum 1/n diverge bien que 1/n -> 0.

**Definition 5.2 (Reste)**
Si la serie converge, le reste d'ordre N est R_N = S - S_N = sum_{n=N+1}^{+infini} a_n. On a R_N -> 0.

### 5.2 Series a termes positifs

**Theoreme 5.1**
Une serie a termes positifs converge si et seulement si ses sommes partielles sont bornees.

**Theoreme 5.2 (Comparaison)**
Si 0 <= a_n <= b_n a partir d'un certain rang :
- sum b_n converge => sum a_n converge.
- sum a_n diverge => sum b_n diverge.

**Comparaison par equivalents :** Si a_n ~ b_n (avec a_n, b_n > 0), les deux series ont *meme nature*.

**Theoreme 5.3 (Comparaison a une integrale)**
Si f : [1, +infini[ -> R+ est continue decroissante et a_n = f(n), alors :

    sum_{n=1}^{+infini} a_n converge  <=>  int_1^{+infini} f(t) dt converge

De plus : int_1^{N+1} f(t) dt <= sum_{n=1}^{N} f(n) <= f(1) + int_1^{N} f(t) dt.

**Exemple fondamental (series de Riemann) :** sum 1/n^alpha converge ssi alpha > 1.

### 5.3 Critere de d'Alembert

**Theoreme 5.4 (d'Alembert)**
Soit (a_n) a termes strictement positifs. Si la limite L = lim |a_{n+1}/a_n| existe :

- Si L < 1, la serie converge (absolument).
- Si L > 1, la serie diverge grossierement.
- Si L = 1, on ne peut pas conclure.

*Preuve (cas L < 1) :* Soit r tel que L < r < 1. Pour n assez grand (n >= N), |a_{n+1}| < r * |a_n|. Par recurrence : |a_{N+k}| < r^k * |a_N|. La serie est dominee par une serie geometrique de raison r < 1, donc converge. CQFD.

**Exemple 5.1 :** sum n!/n^n. On a a_{n+1}/a_n = (n/(n+1))^n = (1 - 1/(n+1))^n -> 1/e < 1. Converge.

### 5.4 Critere de Cauchy (de la racine)

**Theoreme 5.5 (Cauchy)**
Soit (a_n) a termes positifs. Si L = lim (a_n)^{1/n} existe :

- Si L < 1, la serie converge.
- Si L > 1, la serie diverge.
- Si L = 1, on ne peut pas conclure.

> Le critere de Cauchy est *plus fort* que celui de d'Alembert : si d'Alembert conclut, Cauchy aussi, mais pas reciproquement.

### 5.5 Convergence absolue

**Definition 5.3**
La serie sum a_n est *absolument convergente* si sum |a_n| converge.

**Theoreme 5.6**
Toute serie absolument convergente est convergente, et |sum a_n| <= sum |a_n|.

*Preuve :* Posons a_n^+ = max(a_n, 0) et a_n^- = max(-a_n, 0). Alors a_n = a_n^+ - a_n^- et |a_n| = a_n^+ + a_n^-. Si sum |a_n| converge, par comparaison (0 <= a_n^+ <= |a_n| et 0 <= a_n^- <= |a_n|), les deux series sum a_n^+ et sum a_n^- convergent. Par difference, sum a_n converge. CQFD.

La reciproque est fausse : sum (-1)^{n+1}/n converge mais pas absolument (serie *semi-convergente*).

### 5.6 Series alternees -- Critere de Leibniz

**Theoreme 5.7 (Critere de Leibniz)**
Si (a_n) est une suite *decroissante* de reels *positifs* tendant vers 0, alors la serie alternee sum_{n=0}^{+infini} (-1)^n a_n converge. De plus, le reste est majore par le premier terme omis :

    |R_N| <= a_{N+1}

*Preuve :* Les sommes partielles paires S_{2p} forment une suite croissante (car S_{2p+2} - S_{2p} = a_{2p+1} - a_{2p+2} >= 0, puisque (a_n) decroissante). Les sommes partielles impaires S_{2p+1} forment une suite decroissante (car S_{2p+3} - S_{2p+1} = -(a_{2p+2} - a_{2p+3}) <= 0). De plus, S_{2p} <= S_{2p+1} (car S_{2p+1} - S_{2p} = -a_{2p+1} <= ... non, c'est = a_{2p+1} >= 0... non).

Reprenons proprement. sum (-1)^n a_n = a_0 - a_1 + a_2 - a_3 + ...

S_{2p} = (a_0 - a_1) + (a_2 - a_3) + ... + (a_{2p-2} - a_{2p-1}) >= 0 et croissante.
S_{2p} = a_0 - (a_1 - a_2) - ... - (a_{2p-1} - a_{2p}) <= a_0, donc majoree.
S_{2p+1} = S_{2p} - a_{2p+1}, donc S_{2p+1} <= S_{2p}. Et S_{2p+1} decroissante car S_{2p+3} - S_{2p+1} = a_{2p+2} - a_{2p+3}... non c'est = -a_{2p+2} + a_{2p+3}... Hmm.

Plus simplement : on montre que (S_{2p}) est croissante majoree et (S_{2p+1}) est decroissante minoree, et S_{2p+1} - S_{2p} = (-1)^{2p+1} a_{2p+1} -> 0. Donc les deux sous-suites convergent vers la meme limite S. De plus, S_{2p} <= S <= S_{2p+1} (ou l'inverse selon la convention de signe). CQFD.

**Exemple 5.2 :** sum_{n=1}^{+infini} (-1)^{n+1}/n = ln(2). (Serie harmonique alternee, convergente mais pas absolument.)

---

## 6. Suites et series de fonctions

### 6.1 Convergence simple et uniforme

**Definition 6.1 (Convergence simple, CVS)**
La suite de fonctions (f_n) converge *simplement* vers f sur I si pour tout x dans I, f_n(x) -> f(x).

**Definition 6.2 (Convergence uniforme, CVU)**
(f_n) converge *uniformement* vers f sur I si :

    ||f_n - f||_infini = sup_{x dans I} |f_n(x) - f(x)| -> 0

Equivalemment : pour tout epsilon > 0, il existe N (*independant de x*) tel que pour tout n >= N et pour tout x dans I : |f_n(x) - f(x)| < epsilon.

> **Difference cruciale :** En CVS, le rang N depend de x. En CVU, N ne depend que de epsilon.

**Exemple 6.1 :** f_n(x) = x^n sur [0, 1].

Convergence simple vers f(x) = 0 si x in [0, 1[ et f(1) = 1. La limite n'est pas continue, donc la convergence n'est *pas uniforme* sur [0, 1] (sinon la limite serait continue par le theoreme ci-dessous). En revanche, la convergence est uniforme sur [0, a] pour tout a < 1 (car ||f_n||_{[0,a]} = a^n -> 0).

### 6.2 Theoremes d'echange de limites

**Theoreme 6.1 (Continuite de la limite uniforme)**
Si les f_n sont continues sur I et si f_n -> f uniformement sur I, alors f est continue sur I.

*Preuve :* Soit a dans I et epsilon > 0. Par CVU, il existe N tel que ||f_N - f||_infini < epsilon/3. Par continuite de f_N, il existe delta > 0 tel que |x - a| < delta implique |f_N(x) - f_N(a)| < epsilon/3. Alors :

    |f(x) - f(a)| <= |f(x) - f_N(x)| + |f_N(x) - f_N(a)| + |f_N(a) - f(a)|
                   < epsilon/3 + epsilon/3 + epsilon/3 = epsilon

CQFD.

**Theoreme 6.2 (Integration et limite uniforme)**
Si f_n -> f uniformement sur [a, b] et les f_n sont continues :

    lim int_a^b f_n(t) dt = int_a^b f(t) dt

On peut *echanger limite et integrale* sous convergence uniforme.

*Preuve :* |int_a^b f_n - int_a^b f| = |int_a^b (f_n - f)| <= (b-a) * ||f_n - f||_infini -> 0. CQFD.

**Theoreme 6.3 (Derivation et limite uniforme)**
Si les f_n sont C^1 sur I, si (f_n) converge simplement vers f, et si (f_n') converge *uniformement* vers g sur I, alors f est C^1 et f' = g. Autrement dit :

    (lim f_n)' = lim f_n'

### 6.3 Series de fonctions et convergence normale

**Definition 6.3 (Convergence normale)**
La serie de fonctions sum f_n converge *normalement* sur I si sum ||f_n||_infini converge (ou ||f_n||_infini = sup_{x in I} |f_n(x)|).

**Proposition 6.1**
Convergence normale => convergence uniforme => convergence simple.

**Theoreme 6.4 (Proprietes sous convergence normale)**
Sous convergence normale sur I :
- La somme d'une serie de fonctions continues est continue.
- On peut integrer terme a terme.
- On peut deriver terme a terme (sous hypotheses supplementaires sur les derivees).

---

## 7. Integrales dependant d'un parametre

**Theoreme 7.1 (Continuite sous le signe integrale)**
Si f(x, t) est continue sur I x [a, b] (I intervalle), alors :

    F(x) = int_a^b f(x, t) dt

est continue sur I.

**Theoreme 7.2 (Derivation sous le signe integrale -- Leibniz)**
Si f(x, t) et df/dx(x, t) sont continues sur I x [a, b], alors F est C^1 et :

    F'(x) = int_a^b (df/dx)(x, t) dt

**Theoreme 7.3 (Convergence dominee -- admis)**
Si f_n -> f simplement et |f_n| <= g avec int g < +infini, alors :

    lim int f_n = int lim f_n = int f

> C'est le theoreme le plus puissant pour echanger limite et integrale. Il ne requiert pas la convergence uniforme mais une *domination* par une fonction integrable.

---

## 8. Equations differentielles lineaires

### 8.1 Ordre 1

**Equation homogene :** y' + a(t)*y = 0, ou a est continue sur un intervalle I.

**Theoreme 8.1 (Solutions de l'homogene)**
Les solutions sont les fonctions :

    y_h(t) = C * exp(-A(t))

ou A(t) = int_{t_0}^{t} a(s) ds est une primitive de a, et C dans R est une constante arbitraire.

*Preuve :* y' + a(t)*y = 0 equivaut a y'/y = -a(t) (si y != 0), soit (ln|y|)' = -a(t), d'ou ln|y| = -A(t) + cte, soit y = C*exp(-A(t)). La solution y = 0 correspond a C = 0. CQFD.

**Equation complete :** y' + a(t)*y = b(t).

**Theoreme 8.2 (Structure de l'ensemble des solutions)**
L'ensemble des solutions de l'equation complete est :

    S = {y_p + y_h : y_h solution de l'homogene}

ou y_p est une solution particuliere quelconque. (C'est un sous-espace affine de dimension 1.)

**Methode de variation de la constante :** On cherche y_p sous la forme y_p(t) = C(t) * exp(-A(t)). En substituant :

    C'(t) * exp(-A(t)) = b(t), donc C'(t) = b(t) * exp(A(t))

    C(t) = int_{t_0}^{t} b(s) * exp(A(s)) ds

    y_p(t) = exp(-A(t)) * int_{t_0}^{t} b(s) * exp(A(s)) ds

**Theoreme 8.3 (Cauchy-Lipschitz lineaire, ordre 1)**
Pour toute condition initiale y(t_0) = y_0, l'equation y' + a(t)*y = b(t) admet une *unique* solution maximale, definie sur I tout entier.

**Exemple 8.1 :** Resoudre y' - 2t*y = t.

Homogene : y' - 2ty = 0, donc y_h(t) = C*exp(t^2).

Variation de la constante : C'(t)*exp(t^2) = t, donc C'(t) = t*exp(-t^2), donc C(t) = -1/2 * exp(-t^2) + cte.

Solution particuliere : y_p(t) = (-1/2 * exp(-t^2)) * exp(t^2) = -1/2.

Solution generale : y(t) = C*exp(t^2) - 1/2.

### 8.2 Ordre 2 a coefficients constants

**Equation :** y'' + a*y' + b*y = f(t), ou a, b dans R sont des constantes.

**Equation caracteristique :** r^2 + a*r + b = 0.

**Theoreme 8.4 (Solutions de l'homogene y'' + ay' + by = 0)**
Selon le discriminant Delta = a^2 - 4b :

- **Delta > 0 :** deux racines reelles distinctes r_1, r_2.

      y_h(t) = C_1 * e^{r_1 t} + C_2 * e^{r_2 t}

- **Delta = 0 :** une racine double r_0 = -a/2.

      y_h(t) = (C_1 + C_2 * t) * e^{r_0 t}

- **Delta < 0 :** deux racines complexes conjuguees r = alpha +/- i*beta (alpha = -a/2, beta = sqrt(4b - a^2)/2).

      y_h(t) = e^{alpha t} * (C_1 * cos(beta*t) + C_2 * sin(beta*t))

> L'espace des solutions de l'homogene est un espace vectoriel de *dimension 2*, engendre par les deux solutions de base du theoreme.

**Theoreme 8.5 (Cauchy-Lipschitz, ordre 2)**
Pour toutes conditions initiales (t_0, y_0, y_0'), il existe une unique solution maximale definie sur R.

### 8.3 Recherche de solutions particulieres

**Second membre f(t) = P(t)*e^{lambda t} :**

On cherche y_p sous la forme y_p(t) = t^s * Q(t) * e^{lambda t} ou :
- Q est un polynome de meme degre que P.
- s = 0 si lambda n'est pas racine de l'equation caracteristique.
- s = 1 si lambda est racine simple.
- s = 2 si lambda est racine double.

**Second membre trigonometrique :** f(t) = e^{alpha t}*(P_1(t)*cos(beta t) + P_2(t)*sin(beta t)).

On passe en complexe : on resout avec e^{(alpha + i*beta)t} et on prend la partie reelle ou imaginaire.

**Exemple 8.2 :** Resoudre y'' + y = cos(t).

Equation caracteristique : r^2 + 1 = 0, racines +/- i. Solution homogene : y_h = C_1*cos(t) + C_2*sin(t).

Second membre : cos(t) = Re(e^{it}). Comme i est racine simple de r^2 + 1 = 0, on cherche z_p = t * A * e^{it} (s = 1).

Calculons z_p'' + z_p :
- z_p = A*t*e^{it}
- z_p' = A*e^{it} + A*i*t*e^{it}
- z_p'' = 2A*i*e^{it} + A*i^2*t*e^{it} = 2A*i*e^{it} - A*t*e^{it}

Donc z_p'' + z_p = 2A*i*e^{it} - A*t*e^{it} + A*t*e^{it} = 2A*i*e^{it}.

On veut 2A*i*e^{it} = e^{it}, donc A = 1/(2i) = -i/2.

y_p = Re(t*(-i/2)*e^{it}) = Re((-i*t/2)*(cos(t) + i*sin(t)))
    = Re(-i*t*cos(t)/2 + t*sin(t)/2 - ... non, calculons :
    = Re(-i*t*cos(t)/2 - i^2*t*sin(t)/2) = Re(-i*t*cos(t)/2 + t*sin(t)/2)
    = t*sin(t)/2

Solution generale : y(t) = C_1*cos(t) + C_2*sin(t) + (t/2)*sin(t).

> **Remarque physique :** Le terme (t/2)*sin(t) croit lineairement avec t. C'est le phenomene de *resonance* : lorsque la frequence de l'excitation coincide avec la frequence propre du systeme, l'amplitude croit indefiniment.

---

## 9. Exercices de comprehension

**Exercice 1 (Suites recurrentes)**
Soit u_0 > 0 et u_{n+1} = (u_n + 3/u_n)/2.
a) Montrer que u_n >= sqrt(3) pour tout n >= 1.
b) Montrer que (u_n) est decroissante a partir du rang 1.
c) Determiner la limite.
d) Montrer que la convergence est quadratique : |u_{n+1} - sqrt(3)| <= |u_n - sqrt(3)|^2 / (2*sqrt(3)).

**Exercice 2 (Suite de Cauchy)**
Montrer que la suite u_n = sum_{k=1}^{n} sin(k)/k^2 est de Cauchy, donc convergente.
(Indication : majorer |u_m - u_n| pour m > n en utilisant |sin(k)| <= 1.)

**Exercice 3 (Theoreme de Rolle)**
Soit f : [0, 1] -> R de classe C^1, avec f(0) = f(1) = 0 et f(1/2) = 1.
a) Montrer qu'il existe c_1 dans ]0, 1/2[ et c_2 dans ]1/2, 1[ tels que f'(c_1) > 0 et f'(c_2) < 0. (Utiliser les accroissements finis.)
b) En deduire qu'il existe c dans ]c_1, c_2[ tel que f'(c) = 0.
c) Montrer qu'il existe d dans ]0, 1[ tel que f'(d) = 2. (Appliquer le TAF a f sur [0, 1/2].)

**Exercice 4 (Integrale generalisee)**
Etudier la convergence de :
a) int_1^{+infini} sin(t)/t^2 dt (montrer la convergence absolue par comparaison a 1/t^2).
b) int_0^{+infini} sin(t)/t dt (integrale de Dirichlet -- convergence non absolue, utiliser une IPP).
c) int_0^1 ln(t)/(1-t) dt (etudier le comportement en 0 et en 1).

**Exercice 5 (Series numeriques)**
Determiner la nature des series suivantes :
a) sum n^2/3^n (d'Alembert, L = 1/3 < 1, converge).
b) sum 1/(n*ln(n)^2) pour n >= 2 (comparaison integrale avec int 1/(t*ln(t)^2) dt).
c) sum (-1)^n/sqrt(n) (Leibniz).
d) sum n!/n^n (d'Alembert, utiliser Stirling : n! ~ sqrt(2*pi*n)*(n/e)^n).

**Exercice 6 (Convergence uniforme)**
Soit f_n(x) = n*x*e^{-n*x^2} sur [0, +infini[.
a) Determiner la limite simple f(x) = lim f_n(x) pour tout x >= 0.
b) Calculer ||f_n||_infini = sup_{x >= 0} f_n(x). La convergence est-elle uniforme ?
c) Comparer lim int_0^{+infini} f_n(t) dt et int_0^{+infini} f(t) dt. Commenter (c'est un cas ou on ne peut pas echanger limite et integrale).

**Exercice 7 (Equations differentielles)**
Resoudre les equations differentielles :
a) y' + y*tan(t) = cos(t) sur ]-pi/2, pi/2[.
b) y'' - 3y' + 2y = e^t.
c) y'' + 4y = sin(2t).
d) y'' + 2y' + y = e^{-t} (racine double, s = 2).

**Exercice 8 (Point fixe et securite)**
Les fonctions de hachage iteratives satisfont h_{n+1} = f(h_n).
a) Si f est *contractante* sur un intervalle I (il existe k dans [0, 1[ tel que |f(x) - f(y)| <= k|x-y| pour tout x, y dans I, et f(I) inclus dans I), montrer que la suite (h_n) converge vers un unique point fixe L. (Theoreme du point fixe de Banach.)
b) Majorer |h_n - L| en fonction de |h_1 - h_0| et k.
c) Discuter les implications pour la recherche de collisions dans une fonction de hachage : si l'espace de sortie est fini de taille N, pourquoi les iterations finissent-elles toujours par cycler ?

---

## 10. References

- **Gourdon, X.** *Les Maths en Tete -- Analyse.* Ellipses.
- **Rudin, W.** *Principles of Mathematical Analysis.* McGraw-Hill.
- **Zuily, C. & Queffelec, H.** *Analyse pour l'agregation.* Dunod.
- **Demailly, J.-P.** *Analyse numerique et equations differentielles.* EDP Sciences.
- **Hirsch, M. & Smale, S.** *Differential Equations, Dynamical Systems, and Linear Algebra.* Academic Press.
- Programme officiel MP2I/MPI pour l'analyse.
