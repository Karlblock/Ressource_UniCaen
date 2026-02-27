# Chapitre 5 -- Polynomes et arithmetique dans K[X]

## Objectifs du chapitre

- Maitriser la structure d'anneau de K[X] et ses proprietes algebriques fondamentales.
- Savoir effectuer la division euclidienne de polynomes et en deduire le PGCD via l'algorithme d'Euclide.
- Comprendre et appliquer le theoreme de Bezout dans K[X] et le lemme de Gauss.
- Maitriser la notion de racine, de multiplicite, et les relations entre coefficients et racines (formules de Viete).
- Enoncer et comprendre le theoreme de d'Alembert-Gauss (theoreme fondamental de l'algebre).
- Decomposer un polynome en facteurs irreductibles dans R[X] et C[X].
- Etablir le parallele systematique entre l'arithmetique de Z et celle de K[X].
- Entrevoir les applications aux corps finis, aux codes correcteurs d'erreurs et a la cryptographie.

---

## 1. L'anneau K[X]

### 1.1 Definitions fondamentales

Soit K un corps commutatif (typiquement Q, R ou C, ou un corps fini F_p).

**Definition 1.1 (Polynome)**
Un polynome a coefficients dans K est une suite (a_0, a_1, a_2, ...) d'elements de K, presque tous nuls (c'est-a-dire nuls a partir d'un certain rang). On le note :

    P = a_0 + a_1 X + a_2 X^2 + ... + a_n X^n

ou X est une *indeterminee formelle*. L'ensemble de tous ces polynomes est note K[X].

**Definition 1.2 (Degre)**
Soit P = a_0 + a_1 X + ... + a_n X^n un polynome non nul. Le *degre* de P, note deg(P), est le plus grand entier n tel que a_n != 0. Le coefficient a_n est appele *coefficient dominant*. Si a_n = 1, le polynome est dit *unitaire* (ou *monique*).

Par convention, deg(0) = -infini.

**Definition 1.3 (Polynome nul et egalite)**
Le polynome nul est le polynome dont tous les coefficients sont nuls. Deux polynomes sont egaux si et seulement si tous leurs coefficients correspondants sont egaux.

> **Attention fondamentale :** Un polynome est un objet *formel*, distinct de la fonction polynomiale qu'il definit. Dans un corps fini, deux polynomes distincts peuvent definir la meme fonction. Par exemple, dans F_2[X], les polynomes X et X^2 definissent la meme fonction (car 0^2 = 0 et 1^2 = 1) mais sont formellement distincts.

### 1.2 Operations dans K[X]

**Addition.** Si P = sum(a_i X^i) et Q = sum(b_i X^i), alors :

    P + Q = sum((a_i + b_i) X^i)

**Multiplication.** Le produit est defini par :

    P * Q = sum_k (sum_{i+j=k} a_i * b_j) X^k

C'est le *produit de convolution* (ou produit de Cauchy) des suites de coefficients.

**Multiplication par un scalaire.** Pour lambda dans K :

    lambda * P = sum(lambda * a_i) X^i

**Proposition 1.1 (Structure d'anneau)**
(K[X], +, *) est un anneau commutatif unitaire integre. Son element neutre pour l'addition est le polynome nul, et pour la multiplication le polynome constant 1.

*Preuve (integrite) :* Soient P, Q dans K[X] non nuls, de degres respectifs p et q. Le coefficient de X^{p+q} dans P*Q est le produit des coefficients dominants de P et Q. Comme K est un corps (donc integre), ce produit est non nul. Donc P*Q != 0 et deg(P*Q) = p + q. CQFD.

> **Remarque :** K[X] possede en outre une structure de K-algebre commutative unitaire.

**Proposition 1.2 (Degre et operations)**
Pour P, Q dans K[X] non nuls :

    deg(P * Q) = deg(P) + deg(Q)
    deg(P + Q) <= max(deg(P), deg(Q))

avec egalite dans la seconde formule si deg(P) != deg(Q).

Pour la multiplication par un scalaire : deg(lambda * P) = deg(P) si lambda != 0.

### 1.3 Elements inversibles

**Proposition 1.3**
Les elements inversibles (unites) de K[X] sont exactement les polynomes constants non nuls, c'est-a-dire les elements de K*.

*Preuve :* Si P*Q = 1, alors deg(P) + deg(Q) = deg(1) = 0, donc deg(P) = deg(Q) = 0, donc P et Q sont des constantes non nulles. Reciproquement, toute constante non nulle lambda admet un inverse lambda^{-1} dans K, donc dans K[X]. CQFD.

**Exemple 1.1 :** Dans R[X], le polynome 3 est inversible (d'inverse 1/3), mais X + 1 ne l'est pas.

### 1.4 Evaluation et morphisme

**Definition 1.4 (Morphisme d'evaluation)**
Pour tout alpha dans K, l'application ev_alpha : K[X] -> K definie par :

    ev_alpha(P) = P(alpha) = sum(a_k * alpha^k)

est un morphisme d'anneaux (c'est-a-dire ev_alpha(P+Q) = ev_alpha(P) + ev_alpha(Q) et ev_alpha(P*Q) = ev_alpha(P) * ev_alpha(Q)).

> Cette propriete universelle caracterise K[X] : c'est la K-algebre commutative unitaire *libre* sur un generateur X.

---

## 2. Division euclidienne

### 2.1 Enonce et preuve

**Theoreme 2.1 (Division euclidienne)**
Soient A, B dans K[X] avec B != 0. Il existe un *unique* couple (Q, R) de polynomes de K[X] tels que :

    A = B * Q + R    avec deg(R) < deg(B)

Q est le *quotient* et R le *reste* de la division euclidienne de A par B.

*Preuve (existence par recurrence forte sur deg(A)) :*

**Cas de base :** Si deg(A) < deg(B), on prend Q = 0 et R = A.

**Heredite :** Supposons deg(A) = n >= deg(B) = m. Notons a_n le coefficient dominant de A et b_m celui de B. Posons :

    A_1 = A - (a_n / b_m) * X^{n-m} * B

Alors deg(A_1) < deg(A) = n (le terme de degre n s'annule par construction). Par hypothese de recurrence, il existe Q_1, R tels que A_1 = B * Q_1 + R avec deg(R) < deg(B). Donc :

    A = (a_n / b_m) * X^{n-m} * B + A_1
      = B * ((a_n / b_m) * X^{n-m} + Q_1) + R

On pose Q = (a_n / b_m) * X^{n-m} + Q_1.

*Preuve (unicite) :*
Si A = B*Q_1 + R_1 = B*Q_2 + R_2 avec deg(R_1), deg(R_2) < deg(B), alors :

    B * (Q_1 - Q_2) = R_2 - R_1

Si Q_1 != Q_2, le membre de gauche a un degre >= deg(B), mais le membre de droite a un degre < deg(B) (ou est nul). Contradiction. Donc Q_1 = Q_2, et par suite R_1 = R_2. CQFD.

> **Remarque cruciale :** La division euclidienne n'est possible que parce que le coefficient dominant de B est inversible dans K (c'est automatique puisque K est un corps). Dans Z[X], la division euclidienne n'est pas toujours possible.

### 2.2 Algorithme pratique

**Exemple 2.1 :** Divisons A = 2X^4 + 3X^3 - X + 5 par B = X^2 + X - 1 dans Q[X].

    Etape 1 : 2X^4 / X^2 = 2X^2
              A - 2X^2 * B = 2X^4 + 3X^3 - X + 5 - (2X^4 + 2X^3 - 2X^2)
                           = X^3 + 2X^2 - X + 5

    Etape 2 : X^3 / X^2 = X
              X^3 + 2X^2 - X + 5 - X * (X^2 + X - 1) = X^2 + 5

    Etape 3 : X^2 / X^2 = 1
              X^2 + 5 - 1 * (X^2 + X - 1) = -X + 6

    Resultat : Q = 2X^2 + X + 1,  R = -X + 6

*Verification :* (X^2 + X - 1)(2X^2 + X + 1) + (-X + 6) = 2X^4 + 3X^3 - X + 5. OK.

### 2.3 Divisibilite

**Definition 2.1**
On dit que B *divise* A (note B | A) s'il existe Q dans K[X] tel que A = B*Q, c'est-a-dire si le reste de la division euclidienne de A par B est nul.

**Proposition 2.1**
La relation de divisibilite dans K[X] verifie :
- Reflexivite : A | A.
- Antisymetrie a association pres : si A | B et B | A, alors A = lambda * B pour un certain lambda dans K*.
- Transitivite : si A | B et B | C, alors A | C.

**Definition 2.2 (Polynomes associes)**
P et Q sont *associes* si P = lambda * Q pour un lambda dans K*. La divisibilite dans K[X] est un ordre partiel sur les classes de polynomes associes.

---

## 3. PGCD et algorithme d'Euclide

### 3.1 PGCD

**Definition 3.1 (PGCD)**
Soient A, B dans K[X], non tous deux nuls. Le PGCD de A et B, note pgcd(A, B), est le polynome *unitaire* de plus grand degre qui divise a la fois A et B.

**Proposition 3.1**
Le PGCD existe et est unique (en le prenant unitaire). De plus, D = pgcd(A, B) est caracterise par :
1. D | A et D | B.
2. Pour tout D' dans K[X] : si D' | A et D' | B, alors D' | D.

**Definition 3.2**
A et B sont dits *premiers entre eux* (ou *copremiers*) si pgcd(A, B) = 1.

### 3.2 Algorithme d'Euclide

L'algorithme d'Euclide pour les polynomes est *structurellement identique* a celui pour les entiers :

    A   = B   * Q_0 + R_0       deg(R_0) < deg(B)
    B   = R_0 * Q_1 + R_1       deg(R_1) < deg(R_0)
    R_0 = R_1 * Q_2 + R_2       deg(R_2) < deg(R_1)
    ...
    R_{n-2} = R_{n-1} * Q_n + 0

Le dernier reste non nul R_{n-1}, rendu unitaire (divise par son coefficient dominant), est pgcd(A, B).

**Justification :** A chaque etape, les diviseurs communs de R_{k-1} et R_k sont les memes que ceux de R_k et R_{k+1}. Donc :

    pgcd(A, B) = pgcd(B, R_0) = pgcd(R_0, R_1) = ... = pgcd(R_{n-1}, 0) = R_{n-1}

(a un scalaire pres).

**Terminaison :** L'algorithme termine car la suite des degres deg(B) > deg(R_0) > deg(R_1) > ... est une suite strictement decroissante d'entiers naturels.

**Complexite :** Le nombre d'etapes est au plus deg(B) + 1. Si A et B sont de degre au plus n, chaque division euclidienne coute O(n^2) operations dans K, donc l'algorithme complet coute O(n^3).

**Exemple 3.1 :** Calculons pgcd(X^4 - 1, X^3 - 1) dans Q[X].

    X^4 - 1 = (X^3 - 1) * X + (X - 1)         reste X - 1
    X^3 - 1 = (X - 1) * (X^2 + X + 1) + 0      reste 0

Donc pgcd(X^4 - 1, X^3 - 1) = X - 1. (Deja unitaire.)

**Exemple 3.2 :** Calculons pgcd(X^3 + X^2 + X + 1, X^2 + 2X + 1) dans Q[X].

    X^3 + X^2 + X + 1 = (X^2 + 2X + 1) * (X - 1) + (2X + 2)
    X^2 + 2X + 1 = (2X + 2) * ((1/2)X + (1/2)) + 0

Dernier reste non nul : 2X + 2, unitaire : X + 1. Donc pgcd = X + 1.

### 3.3 Theoreme de Bezout

**Theoreme 3.1 (Bezout)**
Soient A, B dans K[X] non tous deux nuls. Il existe U, V dans K[X] tels que :

    A * U + B * V = pgcd(A, B)

En particulier, A et B sont premiers entre eux si et seulement s'il existe U, V dans K[X] tels que :

    A * U + B * V = 1

*Preuve :*
**Methode 1 (ideaux) :** Considerons l'ensemble I = {A*U + B*V : U, V dans K[X]}. C'est un ideal de K[X]. Comme K[X] est principal (on le montrera plus bas), I = (D) pour un certain D unitaire. On verifie que D divise A et B, et que tout diviseur commun divise D. Donc D = pgcd(A, B). CQFD.

**Methode 2 (algorithme d'Euclide etendu) :** On remonte les etapes de l'algorithme d'Euclide. A chaque etape, on exprime R_k comme combinaison de A et B.

**Exemple 3.3 (Remontee de Bezout) :** Reprenons l'Exemple 3.1.

    X - 1 = (X^4 - 1) - X * (X^3 - 1)

Donc U = 1, V = -X, et on a bien : (X^4 - 1) * 1 + (X^3 - 1) * (-X) = X - 1.

### 3.4 Consequences de Bezout

**Corollaire 3.1**
Si A et B sont premiers entre eux, et si A | C et B | C, alors AB | C.

*Preuve :* Par Bezout, AU + BV = 1, donc AUC + BVC = C. Or B | BVC et B | AUC car A | C implique C = AK, donc AUC = A^2UK et ce n'est pas direct... Reprenons. AB | AUC car B | UC ? Non.

Methode correcte : C = AK pour un certain K (car A | C). Donc BV*AK + AU*C = C, soit A*B*VK + AU*C = C. Pas ideal non plus.

On utilise plutot le lemme de Gauss (voir ci-dessous) et on procede par recurrence. Ou directement : A | C donc C = A*K. Or B | C = A*K et pgcd(A, B) = 1, donc par Gauss, B | K, donc K = B*L, donc C = A*B*L, donc AB | C. CQFD.

### 3.5 Lemme de Gauss

**Theoreme 3.2 (Lemme de Gauss)**
Si A | B*C et pgcd(A, B) = 1, alors A | C.

*Preuve :* Par Bezout, il existe U, V dans K[X] tels que AU + BV = 1. Donc :

    C = C * 1 = C * (AU + BV) = AUC + BVC

Or A | AUC (evident) et A | BVC (car A | BC par hypothese). Donc A | (AUC + BVC) = C. CQFD.

> **Parallele avec Z :** Ce lemme est l'exact analogue du lemme de Gauss dans Z. La preuve est identique mot pour mot.

**Corollaire 3.2**
Si P est irreductible et P | A*B, alors P | A ou P | B.

*Preuve :* Si P ne divise pas A, alors pgcd(P, A) = 1 (car les seuls diviseurs de P irreductible sont 1 et les associes de P, et P ne divise pas A). Par Gauss, P | B. CQFD.

### 3.6 K[X] est un anneau euclidien, principal, factoriel

**Theoreme 3.3**
K[X] est un anneau euclidien (pour le stathme deg), donc principal, donc factoriel.

*Preuve de la chaine d'implications :*

1. **K[X] est euclidien :** Le stathme est la fonction degre. La division euclidienne (Theoreme 2.1) garantit que pour A, B avec B != 0, on a A = BQ + R avec deg(R) < deg(B).

2. **Euclidien implique principal :** Soit I un ideal non nul de K[X]. Soit B un element non nul de I de degre minimal. Pour tout A dans I, on divise : A = BQ + R avec deg(R) < deg(B). Or R = A - BQ est dans I, et deg(R) < deg(B), donc R = 0 par minimalite du degre de B. Donc I = (B).

3. **Principal implique factoriel :** C'est un resultat general. L'existence de la factorisation provient de la descente infinie (pas de chaine infinie decroissante de diviseurs car deg diminue strictement). L'unicite provient du lemme de Gauss (Corollaire 3.2).

**Consequence :** Tout polynome non constant admet une decomposition essentiellement unique (a l'ordre et aux constantes multiplicatives pres) en produit de polynomes irreductibles unitaires.

---

## 4. Racines d'un polynome

### 4.1 Evaluation et racines

**Definition 4.1 (Fonction polynomiale)**
A tout polynome P = sum(a_k X^k) de K[X], on associe la *fonction polynomiale* P~ : K -> K definie par P~(alpha) = sum(a_k * alpha^k). On ecrit simplement P(alpha).

**Definition 4.2 (Racine)**
Un element alpha de K (ou d'une extension de K) est une *racine* de P si P(alpha) = 0.

**Theoreme 4.1 (Factorisation par une racine)**
alpha est racine de P si et seulement si (X - alpha) | P.

*Preuve :* Par division euclidienne de P par (X - alpha) : P = (X - alpha) * Q + R avec R constante (deg(R) < deg(X - alpha) = 1). En evaluant en alpha : P(alpha) = 0 + R, donc R = P(alpha). D'ou P(alpha) = 0 ssi R = 0 ssi (X - alpha) | P. CQFD.

### 4.2 Multiplicite

**Definition 4.3 (Multiplicite d'une racine)**
Soit alpha une racine de P non nul. L'*ordre de multiplicite* de alpha est le plus grand entier m >= 1 tel que (X - alpha)^m | P. On note mult_P(alpha) = m.

Equivalemment : P = (X - alpha)^m * Q avec Q(alpha) != 0.

On dit que alpha est racine *simple* si m = 1, *double* si m = 2, *triple* si m = 3, etc.

**Proposition 4.1 (Critere de multiplicite par les derivees)**
alpha est racine d'ordre >= m de P si et seulement si :

    P(alpha) = P'(alpha) = P''(alpha) = ... = P^{(m-1)}(alpha) = 0    et    P^{(m)}(alpha) != 0

*Preuve :* Si P = (X - alpha)^m * Q avec Q(alpha) != 0. La formule de Leibniz donne :

    P^{(k)} = sum_{j=0}^{k} C(k,j) * ((X-alpha)^m)^{(j)} * Q^{(k-j)}

Pour j < m, ((X-alpha)^m)^{(j)} s'annule en alpha. Pour k < m, tous les j sont < m, donc P^{(k)}(alpha) = 0.

Pour k = m : le seul terme survivant est celui ou j = m, c'est-a-dire m! * Q(alpha) != 0. CQFD.

> **Application pratique :** Ce critere est tres utile pour determiner la multiplicite d'une racine sans avoir a factoriser completement le polynome.

### 4.3 Nombre de racines

**Theoreme 4.2**
Un polynome non nul de degre n dans K[X] a au plus n racines dans K, comptees avec multiplicite.

*Preuve :* Si alpha_1, ..., alpha_r sont les racines distinctes de P de multiplicites m_1, ..., m_r, alors le polynome :

    prod_{i=1}^{r} (X - alpha_i)^{m_i}

divise P. Donc sum(m_i) <= deg(P) = n. CQFD.

**Corollaire 4.1**
Si P dans K[X] avec deg(P) = n a strictement plus de n racines dans K, alors P = 0.

**Corollaire 4.2**
Si K est un corps *infini* et si P dans K[X] definit la fonction nulle (P(alpha) = 0 pour tout alpha dans K), alors P = 0. Autrement dit, sur un corps infini, l'application P -> P~ est injective.

> Ce corollaire est **faux** sur un corps fini. Contre-exemple : dans F_2[X], le polynome X^2 + X a pour racines 0 et 1, donc definit la fonction nulle sur F_2, mais X^2 + X != 0 dans F_2[X].

### 4.4 Derivee formelle et racines multiples

**Definition 4.4 (Derivee formelle)**
La derivee formelle de P = sum a_k X^k est :

    P' = sum_{k >= 1} k * a_k * X^{k-1}

Cette definition est purement algebrique (pas de passage a la limite). Elle verifie les regles usuelles : (P+Q)' = P' + Q', (PQ)' = P'Q + PQ', (P^n)' = n*P^{n-1}*P'.

**Proposition 4.2 (Racines multiples et PGCD)**
P a une racine multiple si et seulement si pgcd(P, P') != 1.

Plus precisement, si P = prod (X - alpha_i)^{m_i}, alors :

    pgcd(P, P') = prod (X - alpha_i)^{m_i - 1}

*Preuve :* Si alpha est racine de multiplicite m >= 2 de P, alors P = (X-alpha)^m * Q. Donc P' = m*(X-alpha)^{m-1}*Q + (X-alpha)^m*Q', et (X-alpha)^{m-1} divise P et P'. CQFD.

> **Application :** Pour "enlever" les racines multiples, on calcule D = pgcd(P, P') et on considere P/D, qui a les memes racines que P mais toutes simples. C'est la *separation des racines* (square-free factorization).

### 4.5 Relations coefficients-racines (formules de Viete)

**Theoreme 4.3 (Relations de Viete)**
Soit P = a_n X^n + a_{n-1} X^{n-1} + ... + a_0 un polynome de degre n possedant n racines alpha_1, ..., alpha_n dans K (comptees avec multiplicite). Alors :

    P = a_n * prod_{i=1}^{n} (X - alpha_i)

et les fonctions symetriques elementaires des racines sont :

    sigma_1 = sum(alpha_i) = -a_{n-1}/a_n
    sigma_2 = sum_{i<j}(alpha_i * alpha_j) = a_{n-2}/a_n
    sigma_3 = sum_{i<j<k}(alpha_i * alpha_j * alpha_k) = -a_{n-3}/a_n
    ...
    sigma_k = (-1)^k * a_{n-k}/a_n
    ...
    sigma_n = prod(alpha_i) = (-1)^n * a_0/a_n

**Exemple 4.1 :** Pour P = X^2 - 5X + 6 = (X - 2)(X - 3) :
- sigma_1 = 2 + 3 = 5 = -(-5)/1 = 5. OK.
- sigma_2 = 2 * 3 = 6 = 6/1 = 6. OK.

**Exemple 4.2 :** Pour P = X^3 - 6X^2 + 11X - 6 = (X-1)(X-2)(X-3) :
- sigma_1 = 1 + 2 + 3 = 6 = -(-6)/1.
- sigma_2 = 1*2 + 1*3 + 2*3 = 11 = 11/1.
- sigma_3 = 1*2*3 = 6 = -(-6)/1.

**Sommes de Newton.** On definit p_k = sum alpha_i^k (sommes de puissances des racines). Les formules de Newton relient les p_k aux sigma_k :

    p_1 = sigma_1
    p_2 = sigma_1 * p_1 - 2 * sigma_2
    p_k = sigma_1 * p_{k-1} - sigma_2 * p_{k-2} + ... + (-1)^{k+1} k * sigma_k

---

## 5. Theoreme de d'Alembert-Gauss

### 5.1 Enonce

**Theoreme 5.1 (d'Alembert-Gauss, theoreme fondamental de l'algebre)**
Tout polynome non constant a coefficients complexes possede au moins une racine dans C.

Autrement dit, **C est algebriquement clos** : tout polynome non constant de C[X] est scinde (se factorise completement en facteurs de degre 1).

**Corollaire 5.1**
Tout polynome P de C[X] de degre n >= 1 se factorise completement :

    P = a_n * prod_{i=1}^{n} (X - alpha_i)

ou alpha_1, ..., alpha_n sont les racines de P dans C (comptees avec multiplicite).

### 5.2 Apercu des preuves

Il existe de nombreuses preuves de ce theoreme, faisant appel a l'analyse, a la topologie ou a l'algebre. Aucune n'est purement algebrique.

**Preuve analytique (argument du module minimum) :**

1. On montre que |P(z)| -> +infini quand |z| -> +infini (car le terme dominant domine).
2. L'application z -> |P(z)| est continue sur C et tend vers +infini a l'infini. Donc elle atteint son minimum en un point z_0 de C.
3. On montre par l'absurde que P(z_0) = 0. Si P(z_0) != 0, on ecrit P(z_0 + h) en faisant un developpement limite en h. Il existe un entier k >= 1 et un coefficient b_k != 0 tels que :

        P(z_0 + h) = P(z_0) + b_k h^k + termes d'ordre superieur

    En choisissant h de la forme r * e^{i*theta} avec theta choisi pour que b_k h^k soit colineaire et oppose a P(z_0), on peut rendre |P(z_0 + h)| < |P(z_0)| pour r assez petit. Contradiction avec la minimalite.

**Preuve topologique (indice de lacets) :**
On considere la courbe gamma_R : t -> P(R*e^{it}) pour t dans [0, 2*pi]. Pour R -> +infini, cette courbe s'enroule n fois autour de l'origine (ou n = deg P). Pour R = 0, c'est le point P(0). Si P ne s'annule pas, l'indice varie continument, ce qui est impossible car il doit passer de 0 a n.

### 5.3 Consequences pour les polynomes reels

**Proposition 5.1 (Racines conjuguees)**
Si P dans R[X] et alpha dans C est racine de P, alors le *conjugue* alpha_barre est aussi racine de P, avec la meme multiplicite.

*Preuve :* P(alpha) = 0 implique :

    P(alpha_barre) = sum a_k * alpha_barre^k = sum a_k * (alpha^k)_barre
                    = (sum a_k * alpha^k)_barre = P(alpha)_barre = 0_barre = 0

(car les a_k sont reels, donc a_k = a_k_barre). CQFD.

**Consequence :** Les racines complexes non reelles d'un polynome reel viennent par paires conjuguees {alpha, alpha_barre}. Si n = deg(P) est impair, P a au moins une racine reelle (car les racines complexes "consomment" un nombre pair de degres).

---

## 6. Irreductibles et factorisation

### 6.1 Polynomes irreductibles

**Definition 6.1**
Un polynome P de K[X] de degre >= 1 est dit *irreductible* dans K[X] si ses seuls diviseurs sont les constantes non nulles et les associes de P (c'est-a-dire les lambda*P pour lambda dans K*).

Equivalemment, P est irreductible si on ne peut pas ecrire P = A*B avec deg(A) >= 1 et deg(B) >= 1.

> L'irreductibilite depend du corps de base. Un polynome peut etre irreductible dans Q[X] et reductible dans R[X] ou C[X].

### 6.2 Irreductibles de C[X]

**Theoreme 6.1**
Les polynomes irreductibles de C[X] sont exactement les polynomes de degre 1.

*Preuve :* Consequence directe de d'Alembert-Gauss : tout polynome de degre >= 2 a une racine dans C, donc est divisible par un facteur de degre 1, donc n'est pas irreductible. CQFD.

**Factorisation dans C[X] :** Tout polynome P de C[X] de degre n >= 1 se decompose de maniere unique (a l'ordre pres) en :

    P = a_n * (X - alpha_1)^{m_1} * ... * (X - alpha_r)^{m_r}

avec alpha_1, ..., alpha_r les racines distinctes et m_1 + ... + m_r = n.

### 6.3 Irreductibles de R[X]

**Theoreme 6.2**
Les polynomes irreductibles de R[X] sont :
- Les polynomes de degre 1 : aX + b (a != 0).
- Les polynomes de degre 2 a discriminant strictement negatif : aX^2 + bX + c avec b^2 - 4ac < 0.

*Preuve :* Un polynome de degre 1 est toujours irreductible (pas de factorisation non triviale).

Un polynome de degre 2 est irreductible ssi il n'a pas de racine dans R, ssi son discriminant est < 0.

Un polynome P de degre >= 3 dans R[X] a toujours un facteur irreductible de degre 1 ou 2 : par d'Alembert-Gauss, P a une racine alpha dans C. Si alpha dans R, (X - alpha) | P. Si alpha n'est pas dans R, le polynome (X - alpha)(X - alpha_barre) = X^2 - 2*Re(alpha)*X + |alpha|^2 est dans R[X], irreductible (discriminant = -4*Im(alpha)^2 < 0), et divise P. CQFD.

**Factorisation dans R[X] :** Tout polynome P de R[X] de degre n >= 1 se decompose de maniere unique en :

    P = a_n * prod(X - alpha_i)^{m_i} * prod(X^2 + b_j X + c_j)^{k_j}

ou les alpha_i sont les racines reelles (avec multiplicites m_i) et les X^2 + b_j X + c_j sont les facteurs irreductibles de degre 2 (avec b_j^2 - 4c_j < 0), correspondant aux paires de racines complexes conjuguees.

**Exemple 6.1 :** Factoriser P = X^4 + 1 dans R[X].

Les racines dans C sont les racines 8-iemes primitives de l'unite : e^{i*pi/4}, e^{i*3pi/4}, e^{-i*3pi/4}, e^{-i*pi/4}.

En groupant les paires conjuguees :
- (X - e^{i*pi/4})(X - e^{-i*pi/4}) = X^2 - sqrt(2)*X + 1
- (X - e^{i*3pi/4})(X - e^{-i*3pi/4}) = X^2 + sqrt(2)*X + 1

Donc : X^4 + 1 = (X^2 - sqrt(2)*X + 1)(X^2 + sqrt(2)*X + 1).

> **Remarque :** X^4 + 1 est irreductible dans Q[X] (critere d'Eisenstein apres le changement de variable X -> X+1), reductible dans R[X], et completement scinde dans C[X]. Cet exemple illustre bien la dependance de l'irreductibilite au corps de base.

### 6.4 Criteres d'irreductibilite dans Q[X]

**Theoreme 6.3 (Critere d'Eisenstein)**
Soit P = a_n X^n + ... + a_1 X + a_0 dans Z[X]. S'il existe un nombre premier p tel que :
- p ne divise pas a_n
- p divise a_0, a_1, ..., a_{n-1}
- p^2 ne divise pas a_0

alors P est irreductible dans Q[X].

*Preuve (esquisse) :* Supposons P = A*B avec A, B dans Z[X] (par le lemme de Gauss, on peut se ramener a Z[X]), deg(A) >= 1, deg(B) >= 1. En reduisant modulo p : P = a_n * X^n mod p. Donc A*B = a_n * X^n mod p. Or F_p[X] est factoriel, donc A et B sont de la forme alpha * X^k et beta * X^l mod p. Mais alors a_0 = A(0)*B(0) est divisible par p^2 (car A(0) et B(0) sont tous deux divisibles par p). Contradiction avec la troisieme hypothese. CQFD.

**Exemple 6.2 :** Le polynome cyclotomique Phi_p(X) = X^{p-1} + X^{p-2} + ... + X + 1 est irreductible dans Q[X] pour p premier.

*Preuve :* On considere Phi_p(X+1) = ((X+1)^p - 1)/X = sum_{k=1}^{p} C(p,k) X^{k-1}. Le coefficient de X^{p-1} est 1 (non divisible par p), les coefficients de X^0 a X^{p-2} sont C(p,k)/1 divisibles par p, et le terme constant est C(p,1) = p non divisible par p^2. Eisenstein avec le premier p conclut. CQFD.

**Autres methodes d'irreductibilite :**
- Reduction modulo p : si P mod p est irreductible dans F_p[X], alors P est irreductible dans Q[X] (sous reserve que les degres coincident).
- Critere de la borne de Cauchy + test de racines rationnelles.

---

## 7. Parallele systematique Z / K[X]

L'arithmetique dans K[X] est *structurellement identique* a celle dans Z. Voici le dictionnaire complet :

    | Propriete                | Z                  | K[X]                       |
    |--------------------------|--------------------|----------------------------|
    | Division euclidienne     | oui (stathme |.|)  | oui (stathme deg)          |
    | Anneau euclidien         | oui                | oui                        |
    | Anneau principal         | oui                | oui                        |
    | Anneau factoriel         | oui                | oui                        |
    | Identite de Bezout       | oui                | oui                        |
    | Lemme de Gauss           | oui                | oui                        |
    | Elements irreductibles   | nombres premiers   | polynomes irreductibles    |
    | Unites                   | {+1, -1}           | K*                         |
    | Quotient par irreductible| Z/pZ = F_p (corps) | K[X]/(P) corps si P irred. |
    | Critere d'irreductibilite| tests de primalite  | Eisenstein, reduction      |

**Correspondance structurelle profonde :** Le parallele va au-dela des analogies superficielles. Les deux anneaux sont des exemples fondamentaux d'anneaux euclidiens, et tous les theoremes de l'arithmetique (decomposition en facteurs irreductibles, Bezout, Gauss, CRT) s'enoncent et se demontrent de maniere identique dans les deux cadres.

**Theoreme des restes chinois (CRT) :** Si P_1, ..., P_k sont deux a deux copremiers dans K[X], alors :

    K[X]/(P_1 * ... * P_k) est isomorphe a K[X]/(P_1) x ... x K[X]/(P_k)

Exactement comme Z/(n_1 * ... * n_k) est isomorphe a Z/n_1 x ... x Z/n_k lorsque les n_i sont deux a deux copremiers.

---

## 8. Applications

### 8.1 Corps finis et polynomes

Les corps finis sont au coeur de la cryptographie moderne.

**Theoreme 8.1 (Existence et unicite des corps finis)**
Pour tout nombre premier p et tout entier n >= 1, il existe un unique corps fini (a isomorphisme pres) de cardinal p^n, note F_{p^n} ou GF(p^n).

Ce corps se construit comme quotient :

    F_{p^n} = F_p[X] / (P(X))

ou P est un polynome irreductible de degre n dans F_p[X].

> L'idee : F_p[X]/(P) est un anneau quotient. Si P est irreductible, l'ideal (P) est maximal (car K[X] principal et irreductible = premier dans un anneau principal), donc le quotient est un corps.

**Exemple 8.1 :** Construction de F_4 = GF(4).

Le polynome X^2 + X + 1 est irreductible dans F_2[X] (verification : il n'a pas de racine dans F_2, car 0^2+0+1 = 1 != 0 et 1^2+1+1 = 1 != 0).

Donc F_4 = F_2[X]/(X^2 + X + 1) = {0, 1, alpha, alpha + 1} ou alpha est une racine de X^2 + X + 1 (donc alpha^2 = alpha + 1 dans F_2).

Table de multiplication (les elements non nuls forment un groupe cyclique d'ordre 3) :

    *    | 0  1  a  a+1
    -----|----------------
    0    | 0  0  0  0
    1    | 0  1  a  a+1
    a    | 0  a  a+1 1
    a+1  | 0  a+1 1  a

(On utilise : a*a = a^2 = a+1, a*(a+1) = a^2+a = (a+1)+a = 1, (a+1)*(a+1) = a^2+1 = a.)

**Exemple 8.2 :** Construction de F_8 = GF(8).

On cherche un polynome irreductible de degre 3 dans F_2[X]. Les polynomes de degre 3 dans F_2[X] sont : X^3, X^3+1, X^3+X, X^3+X+1, X^3+X^2, X^3+X^2+1, X^3+X^2+X, X^3+X^2+X+1.

On elimine ceux qui ont une racine dans F_2 (0 ou 1) :
- X^3 : racine 0.
- X^3+1 : 0^3+1=1, 1^3+1=0. Racine 1.
- X^3+X : 0, 1^3+1=0. Racine 0 et 1.
- X^3+X+1 : 0+0+1=1, 1+1+1=1. Pas de racine. Irreductible.
- X^3+X^2 : racine 0.
- X^3+X^2+1 : 0+0+1=1, 1+1+1=1. Pas de racine. Irreductible.
- X^3+X^2+X : racine 0.
- X^3+X^2+X+1 : 1+1+1+1=0. Racine 1.

Donc les irreductibles de degre 3 dans F_2[X] sont X^3+X+1 et X^3+X^2+1. On peut construire F_8 avec l'un ou l'autre.

### 8.2 Codes correcteurs d'erreurs

Les codes de Reed-Solomon, utilises dans les CD, DVD, QR codes, et les communications spatiales, reposent sur l'evaluation de polynomes sur des corps finis.

**Principe :** Un message de k symboles dans F_q est encode comme un polynome P de degre < k. On evalue P en n > k points distincts de F_q pour obtenir un mot de code de longueur n. La redondance (n - k symboles supplementaires) permet de corriger jusqu'a (n-k)/2 erreurs.

**Definition 8.1 (Code de Reed-Solomon)**
Soit alpha un element primitif de F_q (generateur du groupe multiplicatif). Le code RS(n, k) sur F_q est :

    C = {(P(1), P(alpha), P(alpha^2), ..., P(alpha^{n-1})) : P dans F_q[X], deg(P) < k}

**Proprietes :**
- Distance minimale : d = n - k + 1 (code MDS : maximum distance separable).
- Capacite de correction : t = floor((d-1)/2) = floor((n-k)/2) erreurs.
- Decodage : algorithme de Berlekamp-Massey ou Euclide etendu.

**Pourquoi ca marche (argument polynomial) :** Deux polynomes distincts de degre < k coincident en au plus k-1 points. Donc deux mots de code distincts different en au moins n - (k-1) = n - k + 1 positions.

### 8.3 Cryptographie sur les corps finis

Le probleme du logarithme discret dans F_{p^n}* est la base de nombreux protocoles cryptographiques :

- **Diffie-Hellman :** Echange de cles base sur l'exponentiation dans F_p* ou dans un sous-groupe de F_{p^n}*.
- **ElGamal :** Chiffrement asymetrique base sur le logarithme discret.
- **Courbes elliptiques :** Les points d'une courbe elliptique sur F_p forment un groupe abelien. Le logarithme discret y est plus dur, permettant des cles plus courtes.

L'arithmetique des polynomes sur F_p est au coeur des implementations de ces protocoles (multiplication dans F_{p^n}, reduction modulaire, etc.).

### 8.4 Generateurs pseudo-aleatoires (LFSR)

Les registres a decalage a retroaction lineaire (LFSR) sont definis par un polynome de retroaction dans F_2[X]. Les proprietes de ce polynome (irreductibilite, primitivite) determinent la qualite de la sequence pseudo-aleatoire generee.

**Definition 8.2 (LFSR)**
Un LFSR de longueur n est defini par un polynome P(X) = X^n + c_{n-1}X^{n-1} + ... + c_0 dans F_2[X]. La sequence (s_i) satisfait :

    s_{i+n} = c_{n-1}*s_{i+n-1} + ... + c_0*s_i  (mod 2)

Si P est *primitif* (irreductible et d'ordre maximal 2^n - 1 dans le groupe multiplicatif de F_2[X]/(P)), la sequence a une periode maximale de 2^n - 1.

> **En securite :** Les LFSR seuls ne sont pas cryptographiquement surs (attaque de Berlekamp-Massey en O(n^2) a partir de 2n bits consecutifs de la sequence). Mais combines de maniere non lineaire, ils forment la base de nombreux chiffrements par flot (A5/1 pour le GSM, etc.).

---

## 9. Decomposition en elements simples (complement)

La decomposition en elements simples, fondee sur l'arithmetique de K[X], est un outil essentiel en analyse (calcul de primitives, transformees inverses).

**Theoreme 9.1 (Decomposition en elements simples sur C)**
Soit F = P/Q une fraction rationnelle avec deg(P) < deg(Q) et :

    Q = prod (X - alpha_i)^{m_i}

Alors il existe des constantes uniques lambda_{i,j} telles que :

    F = sum_i sum_{j=1}^{m_i} lambda_{i,j} / (X - alpha_i)^j

**Sur R :** Si Q a des facteurs irreductibles de degre 2, on obtient des termes de la forme (alpha_j X + beta_j) / (X^2 + b_j X + c_j)^j.

---

## 10. Exercices de comprehension

**Exercice 1 (Division euclidienne)**
Effectuer la division euclidienne de A = X^5 + X^3 - 2X + 1 par B = X^2 - X + 1 dans Q[X]. Verifier le resultat.

**Exercice 2 (PGCD et Bezout)**
a) Calculer pgcd(X^4 + X^3 + X^2 + X + 1, X^3 + X^2 + X + 1) dans Q[X] par l'algorithme d'Euclide.
b) En deduire une relation de Bezout.
c) Les deux polynomes sont-ils premiers entre eux ?

**Exercice 3 (Racines et multiplicite)**
Soit P = X^5 - 3X^4 + 4X^3 - 4X^2 + 3X - 1.
a) Verifier que 1 est racine de P. Quel est son ordre de multiplicite ? (Utiliser le critere des derivees successives.)
b) Factoriser completement P dans C[X].
c) Factoriser P dans R[X].

**Exercice 4 (Viete et sommes de Newton)**
Soit P = X^3 + pX + q (polynome cubique sans terme en X^2). Notons alpha_1, alpha_2, alpha_3 ses racines dans C.
a) Exprimer sigma_1, sigma_2, sigma_3 en fonction de p et q.
b) En deduire alpha_1^2 + alpha_2^2 + alpha_3^2 en fonction de p.
c) Calculer alpha_1^3 + alpha_2^3 + alpha_3^3 en fonction de q.
(Indication : utiliser les formules de Newton p_k = sigma_1*p_{k-1} - sigma_2*p_{k-2} + ...)

**Exercice 5 (Irreductibilite)**
a) Montrer que X^4 + 1 est irreductible dans Q[X] (par Eisenstein apres changement de variable) mais reductible dans R[X] et dans F_2[X].
b) Trouver tous les polynomes irreductibles de degre 3 dans F_2[X] et construire F_8.
c) Verifier que X^2 + 1 est irreductible dans F_3[X] et construire F_9.

**Exercice 6 (Corps fini)**
Dans F_3[X], montrer que P = X^2 + 1 est irreductible. Construire F_9 = F_3[X]/(X^2 + 1). Dresser les tables d'addition et de multiplication des 9 elements.

**Exercice 7 (Reed-Solomon)**
On travaille dans F_7. On encode un message (a_0, a_1, a_2) par le polynome P = a_0 + a_1 X + a_2 X^2.
a) Encoder le message (3, 1, 2) en evaluant P en 1, 2, 3, 4, 5.
b) On recoit le mot (6, 4, 0, 3, 2). Sachant qu'il y a eu au plus une erreur, retrouver le message original.
(Indication : utiliser le fait que 5 evaluations pour un polynome de degre 2 donnent de la redondance.)

**Exercice 8 (LFSR et sequences)**
Soit le LFSR defini par P(X) = X^3 + X + 1 dans F_2[X] avec l'etat initial (1, 0, 0).
a) Verifier que P est irreductible dans F_2[X].
b) Generer les 15 premiers bits de la sequence.
c) Quelle est la periode ? Est-ce la periode maximale 2^3 - 1 = 7 ?
d) Montrer que si on connait 6 bits consecutifs de la sequence, on peut retrouver le polynome de retroaction par l'algorithme de Berlekamp-Massey.

**Exercice 9 (Separation des racines)**
Soit P = X^4 - 2X^3 + 2X^2 - 2X + 1.
a) Calculer pgcd(P, P').
b) En deduire les racines multiples de P et leurs multiplicites.
c) Factoriser P dans C[X].

**Exercice 10 (Theoreme des restes chinois polynomial)**
Soient P_1 = X - 1 et P_2 = X^2 + X + 1 dans Q[X].
a) Verifier que pgcd(P_1, P_2) = 1.
b) Trouver A dans Q[X] tel que A = 2 mod P_1 et A = X mod P_2.
(Indication : utiliser Bezout pour ecrire 1 = U*P_1 + V*P_2.)

---

## 11. References

- **Perrin, D.** *Algebre, Cours de mathematiques de premiere annee.* Ellipses.
- **Gourdon, X.** *Les Maths en Tete -- Algebre.* Ellipses.
- **Lang, S.** *Algebra.* Springer (pour approfondir la theorie des corps et extensions).
- **Lidl, R. & Niederreiter, H.** *Introduction to Finite Fields and Their Applications.* Cambridge University Press.
- **Berlekamp, E.** *Algebraic Coding Theory.* World Scientific.
- **Menezes, A., van Oorschot, P., Vanstone, S.** *Handbook of Applied Cryptography.* CRC Press. Chapitres 4 (corps finis) et 12 (codes correcteurs).
- **Ireland, K. & Rosen, M.** *A Classical Introduction to Modern Number Theory.* Springer.
- Programme officiel MP2I/MPI pour l'algebre polynomiale.
