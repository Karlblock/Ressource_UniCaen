# Chapitre 7 -- Probabilites discretes

## Objectifs du chapitre

- Formaliser le cadre mathematique des probabilites sur des espaces finis (axiomes de Kolmogorov).
- Maitriser les probabilites conditionnelles, la formule des probabilites totales et la formule de Bayes.
- Comprendre la notion d'independance (evenements et variables aleatoires).
- Definir et manipuler les variables aleatoires discretes et leurs lois.
- Connaitre les lois classiques discretes (Bernoulli, binomiale, Poisson, geometrique) et leurs proprietes.
- Calculer esperance, variance, covariance et comprendre leur signification.
- Enoncer et comprendre la loi des grands nombres (faible et forte).
- Appliquer ces outils a la modelisation de problemes de securite informatique : paradoxe des anniversaires, brute force, filtres de Bloom, classification bayesienne.

---

## 1. Espaces probabilises finis

### 1.1 Vocabulaire de base

**Definition 1.1 (Experience aleatoire)**
Une *experience aleatoire* est une experience dont le resultat ne peut pas etre prevu avec certitude avant sa realisation, mais dont l'ensemble des resultats possibles est connu a l'avance.

**Definition 1.2 (Univers)**
L'*univers* Omega est l'ensemble de tous les resultats possibles (appeles *eventualites* ou *issues*) d'une experience aleatoire.

**Exemples :**
- Lancer d'un de a 6 faces : Omega = {1, 2, 3, 4, 5, 6}.
- Deux lancers d'une piece : Omega = {PP, PF, FP, FF}.
- Mot de passe aleatoire de n caracteres sur un alphabet de taille k : Omega = {0, ..., k-1}^n, de cardinal k^n.
- Tirage aleatoire d'une cle AES-128 : Omega = {0, 1}^{128}, de cardinal 2^{128}.

### 1.2 Evenements

**Definition 1.3 (Evenement)**
Un *evenement* est une partie A de Omega (sous-ensemble de Omega). L'ensemble de tous les evenements est P(Omega), l'ensemble des parties de Omega.

**Terminologie :**
- *Evenement certain* : Omega.
- *Evenement impossible* : l'ensemble vide.
- *Evenement elementaire* : singleton {omega}.
- *Evenement contraire* de A : A^c = Omega \ A.
- A et B *incompatibles* (mutuellement exclusifs) : A inter B = vide.

**Operations ensemblistes et evenements :**
- A union B : "A ou B" (au moins l'un des deux se realise).
- A inter B : "A et B" (les deux se realisent).
- A^c : "non A" (A ne se realise pas).

### 1.3 Axiomes de Kolmogorov (cas fini)

**Definition 1.4 (Probabilite sur un ensemble fini)**
Une *probabilite* sur un univers fini Omega est une application P : P(Omega) -> [0, 1] verifiant :

    (i)   P(Omega) = 1
    (ii)  Pour tout A, B dans P(Omega) avec A inter B = vide :
          P(A union B) = P(A) + P(B)       (additivite)

Plus generalement (sigma-additivite finie) : pour A_1, ..., A_n deux a deux disjoints :

    P(A_1 union ... union A_n) = P(A_1) + ... + P(A_n)

Le triplet (Omega, P(Omega), P) est appele *espace probabilise* (fini).

> **Remarque :** Sur un univers fini, une probabilite est entierement determinee par les poids p(omega) = P({omega}) pour omega dans Omega, avec p(omega) >= 0 et sum_{omega} p(omega) = 1. On a alors P(A) = sum_{omega in A} p(omega).

**Proposition 1.1 (Proprietes immediates)**

- P(vide) = 0.
- P(A^c) = 1 - P(A).
- Si A inclus dans B, alors P(A) <= P(B) (croissance).
- P(A union B) = P(A) + P(B) - P(A inter B) (formule d'inclusion-exclusion pour 2 evenements).

*Preuve de la derniere :* A union B = A union (B \ (A inter B)), reunion disjointe. Donc P(A union B) = P(A) + P(B \ (A inter B)). Or B = (A inter B) union (B \ (A inter B)) (disjoint), donc P(B) = P(A inter B) + P(B \ (A inter B)), d'ou P(B \ (A inter B)) = P(B) - P(A inter B). En substituant : P(A union B) = P(A) + P(B) - P(A inter B). CQFD.

### 1.4 Formule du crible (inclusion-exclusion)

**Theoreme 1.1 (Poincare)**
Pour des evenements A_1, ..., A_n :

    P(A_1 union ... union A_n) = sum_i P(A_i)
                                  - sum_{i<j} P(A_i inter A_j)
                                  + sum_{i<j<k} P(A_i inter A_j inter A_k)
                                  - ...
                                  + (-1)^{n+1} P(A_1 inter ... inter A_n)

*Preuve :* Par recurrence sur n, en utilisant la formule pour 2 evenements et la distributivite de l'intersection sur l'union. CQFD.

> **Complexite :** La formule comporte 2^n - 1 termes. En pratique, on l'utilise surtout pour n = 2 ou 3, ou dans des cas ou beaucoup de termes sont nuls ou egaux.

### 1.5 Probabilite uniforme

**Definition 1.5 (Equiprobabilite)**
Sur un univers fini Omega, la *probabilite uniforme* (ou *equiprobabilite*) est definie par :

    P(A) = |A| / |Omega|

ou |A| est le cardinal de A. Chaque eventualite a la meme probabilite 1/|Omega|.

> Sous l'hypothese d'equiprobabilite, calculer une probabilite revient a un probleme de *denombrement* : compter les cas favorables et les cas totaux.

**Exemple 1.1 :** Probabilite de tirer un carre au poker (5 cartes parmi 52).

- |Omega| = C(52, 5) = 2598960.
- Nombre de carres : 13 * C(4,4) * 48 = 624 (13 valeurs pour le carre, 48 choix pour la 5e carte).
- P(carre) = 624/2598960 = 0.000240.

**Exemple 1.2 :** Probabilite que deux personnes (parmi n) aient le meme anniversaire (N = 365 jours).

    P(pas de collision) = 365/365 * 364/365 * ... * (365-n+1)/365
                        = prod_{k=0}^{n-1} (1 - k/365)

Pour n = 23 : P(collision) = 1 - P(pas de collision) > 0.5. C'est le *paradoxe des anniversaires* (voir Section 9.1).

---

## 2. Probabilites conditionnelles

### 2.1 Definition

**Definition 2.1 (Probabilite conditionnelle)**
Soit B un evenement de probabilite non nulle. La *probabilite conditionnelle* de A sachant B est :

    P(A | B) = P(A inter B) / P(B)

L'application A -> P(A | B) definit une nouvelle probabilite sur Omega (c'est-a-dire qu'elle verifie les axiomes de Kolmogorov).

**Interpretation :** P(A | B) est la probabilite de A lorsqu'on sait que B est realise. On "restreint" l'univers a B.

**Formule de la multiplication :**

    P(A inter B) = P(A | B) * P(B) = P(B | A) * P(A)

### 2.2 Formule des probabilites composees

**Proposition 2.1**
Pour des evenements A_1, ..., A_n tels que P(A_1 inter ... inter A_{n-1}) > 0 :

    P(A_1 inter A_2 inter ... inter A_n) = P(A_1) * P(A_2 | A_1) * P(A_3 | A_1 inter A_2) * ...
                                            * P(A_n | A_1 inter ... inter A_{n-1})

*Preuve :* Par recurrence, en utilisant P(A inter B) = P(B|A)*P(A) a chaque etape. CQFD.

### 2.3 Formule des probabilites totales

**Theoreme 2.1 (Probabilites totales)**
Soit (B_1, ..., B_n) un *systeme complet d'evenements* (partition de Omega : B_i deux a deux disjoints, reunion = Omega, P(B_i) > 0 pour tout i). Alors pour tout evenement A :

    P(A) = sum_{i=1}^{n} P(A | B_i) * P(B_i)

*Preuve :* A = A inter Omega = union (A inter B_i), reunion disjointe. Par sigma-additivite :

    P(A) = sum P(A inter B_i) = sum P(A | B_i) * P(B_i)

CQFD.

> **Utilite :** Quand on ne sait pas calculer P(A) directement, on "decoupe" par rapport a un systeme complet (B_i) dont on connait les probabilites conditionnelles P(A | B_i).

### 2.4 Formule de Bayes

**Theoreme 2.2 (Bayes)**
Sous les memes hypotheses que le theoreme 2.1 :

    P(B_j | A) = P(A | B_j) * P(B_j) / P(A)
               = P(A | B_j) * P(B_j) / sum_{i=1}^{n} P(A | B_i) * P(B_i)

C'est la formule d'*inversion* : connaissant les probabilites "dans un sens" P(A | B_i), on calcule les probabilites "dans l'autre sens" P(B_j | A).

**Vocabulaire bayesien :**
- P(B_j) : probabilite *a priori* (avant observation).
- P(B_j | A) : probabilite *a posteriori* (apres observation de A).
- P(A | B_j) : *vraisemblance* (likelihood).

**Exemple 2.1 (Detection d'intrusion -- paradoxe du faux positif)**
Un IDS a un taux de vrais positifs de 99% : P(alerte | intrusion) = 0.99. Taux de faux positifs de 2% : P(alerte | pas d'intrusion) = 0.02. Probabilite d'intrusion a priori : P(intrusion) = 0.001.

    P(intrusion | alerte) = P(alerte | intrusion) * P(intrusion) / P(alerte)

    P(alerte) = 0.99 * 0.001 + 0.02 * 0.999 = 0.000990 + 0.019980 = 0.020970

    P(intrusion | alerte) = 0.000990 / 0.020970 = 0.0472

Malgre un IDS performant, *seulement environ 4.7% des alertes correspondent a de vraies intrusions*. C'est le paradoxe du faux positif, fondamental en securite : quand l'evenement cherche est rare (P(intrusion) = 0.001), meme un test tres specifique produit beaucoup de faux positifs.

**Lecon pratique :** C'est pour cela que les SOC (Security Operations Center) ne peuvent pas reagir a chaque alerte. Un triage (correlation, enrichissement, analyse contextuelle) est indispensable pour remonter P(B_j | A) a un niveau exploitable.

---

## 3. Independance

### 3.1 Evenements independants

**Definition 3.1 (Independance de deux evenements)**
A et B sont *independants* si :

    P(A inter B) = P(A) * P(B)

Equivalemment (si P(B) > 0) : P(A | B) = P(A). Savoir que B est realise ne change pas la probabilite de A.

> **Attention critique :** Independance et incompatibilite sont des notions *differentes* et meme en un sens opposees. Deux evenements incompatibles de probabilites non nulles ne sont jamais independants : P(A inter B) = 0 != P(A)*P(B) > 0.

**Definition 3.2 (Independance mutuelle)**
Les evenements A_1, ..., A_n sont *mutuellement independants* si pour *toute* partie I de {1, ..., n} (avec |I| >= 2) :

    P(inter_{i in I} A_i) = prod_{i in I} P(A_i)

**Attention :** L'independance *deux a deux* n'implique pas l'independance *mutuelle*.

**Exemple 3.1 (Contre-exemple classique) :** On lance deux des equilibres.
- A = "la somme est paire"
- B = "le premier de est pair"
- C = "le second de est pair"

On a P(A) = P(B) = P(C) = 1/2 et P(A inter B) = P(A inter C) = P(B inter C) = 1/4. Donc A, B, C sont deux a deux independants.

Mais P(A inter B inter C) = P("somme paire ET premier pair ET second pair") = P("premier pair ET second pair") = 1/4 != 1/8 = P(A)*P(B)*P(C).

Il n'y a *pas* d'independance mutuelle.

### 3.2 Modelisation du tirage aleatoire independant

En cryptographie et en securite, l'hypothese d'independance est fondamentale pour modeliser :
- Le tirage aleatoire des bits d'une cle (chaque bit est un Bernoulli(1/2) independant).
- Les tentatives successives de brute force (chaque essai est independant si on tire avec remise).
- Les sorties d'une fonction de hachage (modelisee comme un oracle aleatoire : chaque sortie est independante et uniforme).

---

## 4. Variables aleatoires discretes

### 4.1 Definition

**Definition 4.1 (Variable aleatoire discrete)**
Une *variable aleatoire* (VA) discrete sur (Omega, P(Omega), P) est une application X : Omega -> E ou E est un ensemble au plus denombrable.

En pratique, X associe a chaque issue omega un nombre (souvent reel).

**Notation :** {X = x} designe l'evenement {omega in Omega : X(omega) = x}. On ecrit P(X = x) pour P({X = x}).

**Exemple 4.1 :** Lancer de deux des. X = somme des deux des. X : {1,...,6}^2 -> {2, 3, ..., 12}.

P(X = 7) = 6/36 = 1/6 (les couples (1,6), (2,5), (3,4), (4,3), (5,2), (6,1)).

### 4.2 Loi d'une variable aleatoire

**Definition 4.2 (Loi de probabilite)**
La *loi* de X est la donnee de P(X = x) pour tout x dans X(Omega). Elle est souvent presentee sous forme de tableau :

    | x       | x_1     | x_2     | ... | x_r     |
    |---------|---------|---------|-----|---------|
    | P(X=x)  | p_1     | p_2     | ... | p_r     |

avec p_i >= 0 et sum p_i = 1.

**Definition 4.3 (Fonction de repartition)**
F_X(t) = P(X <= t) = sum_{x_i <= t} P(X = x_i). F est croissante, continue a droite, avec lim_{-infini} F = 0 et lim_{+infini} F = 1.

### 4.3 Formule de transfert

**Theoreme 4.1 (Formule de transfert)**
Si g : E -> R et X est une VA discrete :

    E(g(X)) = sum_{x in X(Omega)} g(x) * P(X = x)

(quand la serie converge absolument.) C'est la formule fondamentale pour calculer des esperances sans revenir a l'univers Omega.

---

## 5. Lois classiques discretes

### 5.1 Loi de Bernoulli B(p)

**Definition 5.1**
X suit une *loi de Bernoulli* de parametre p in [0, 1] (notee X ~ B(p)) si :

    P(X = 1) = p,    P(X = 0) = 1 - p = q

- E(X) = p.
- V(X) = p*q = p*(1-p).

**Interpretation :** Modelise une epreuve a deux issues (succes/echec, 0/1, vrai/faux). C'est la brique de base de toutes les lois discretes.

### 5.2 Loi binomiale B(n, p)

**Definition 5.2**
X suit une *loi binomiale* B(n, p) si :

    P(X = k) = C(n, k) * p^k * (1-p)^{n-k}    pour k = 0, 1, ..., n

**Interpretation :** Nombre de succes dans n epreuves de Bernoulli *independantes* de meme parametre p.

**Proprietes :**
- E(X) = n*p.
- V(X) = n*p*(1-p).
- Si X_1, ..., X_n sont des B(p) independantes, alors X_1 + ... + X_n ~ B(n, p).

*Preuve de l'esperance (par linearite) :* X = X_1 + ... + X_n ou les X_i ~ B(p) sont independantes. E(X) = sum E(X_i) = n*p. CQFD.

*Preuve de la variance (par independance) :* V(X) = sum V(X_i) = n*p*q (car les X_i sont independantes, les variances s'additionnent). CQFD.

**Exemple 5.1 (Brute force) :** On teste n mots de passe, chacun avec probabilite p de succes (independamment). Le nombre de succes suit B(n, p). La probabilite d'*au moins un* succes est :

    P(X >= 1) = 1 - P(X = 0) = 1 - (1-p)^n

Pour n grand et p petit : P(X >= 1) = 1 - (1-p)^n ≈ 1 - e^{-np} (approximation exponentielle).

### 5.3 Loi de Poisson P(lambda)

**Definition 5.3**
X suit une *loi de Poisson* de parametre lambda > 0 (notee X ~ P(lambda)) si :

    P(X = k) = e^{-lambda} * lambda^k / k!    pour k = 0, 1, 2, ...

**Verification :** sum P(X = k) = e^{-lambda} * sum lambda^k/k! = e^{-lambda} * e^{lambda} = 1.

**Proprietes :**
- E(X) = lambda.
- V(X) = lambda (esperance = variance, propriete caracteristique).
- *Stabilite par sommation :* Si X ~ P(lambda) et Y ~ P(mu) independantes, alors X + Y ~ P(lambda + mu).

*Preuve de l'esperance :*

    E(X) = sum_{k=0}^{infini} k * e^{-lambda} * lambda^k / k!
         = e^{-lambda} * sum_{k=1}^{infini} lambda^k / (k-1)!
         = e^{-lambda} * lambda * sum_{j=0}^{infini} lambda^j / j!
         = e^{-lambda} * lambda * e^{lambda} = lambda

CQFD.

**Theoreme 5.1 (Approximation de Poisson)**
Si X_n ~ B(n, p_n) avec n -> +infini, p_n -> 0 et n*p_n -> lambda, alors pour tout k fixe :

    P(X_n = k) -> e^{-lambda} * lambda^k / k!

La loi binomiale B(n, p) est approchee par P(n*p) quand n est grand et p est petit.

*Preuve (esquisse) :*

    C(n,k) * p_n^k * (1-p_n)^{n-k} = (n!/(k!(n-k)!)) * (lambda/n)^k * (1-lambda/n)^{n-k}

    = (lambda^k/k!) * (n*(n-1)*...*(n-k+1)/n^k) * (1-lambda/n)^n * (1-lambda/n)^{-k}

Quand n -> +infini : le deuxieme facteur -> 1, le troisieme -> e^{-lambda}, le quatrieme -> 1. CQFD.

**Application :** La loi de Poisson modelise le nombre d'evenements *rares* sur un intervalle : nombre d'attaques par unite de temps, nombre de defaillances systeme, nombre de paquets malveillants dans un flux reseau.

### 5.4 Loi geometrique G(p)

**Definition 5.4**
X suit une *loi geometrique* de parametre p in ]0, 1] (notee X ~ G(p)) si :

    P(X = k) = (1-p)^{k-1} * p    pour k = 1, 2, 3, ...

**Interpretation :** X represente le *rang du premier succes* dans une suite d'epreuves de Bernoulli independantes de parametre p.

**Proprietes :**
- E(X) = 1/p.
- V(X) = (1-p)/p^2.
- *Absence de memoire :* P(X > m + n | X > m) = P(X > n) pour tout m, n >= 0.

*Preuve de l'esperance :*

    E(X) = sum_{k=1}^{infini} k * (1-p)^{k-1} * p = p * sum_{k=1}^{infini} k * q^{k-1}

ou q = 1 - p. Or sum_{k=1}^{infini} k*q^{k-1} = d/dq(sum q^k) = d/dq(1/(1-q)) = 1/(1-q)^2 = 1/p^2.

Donc E(X) = p/p^2 = 1/p. CQFD.

*Preuve de l'absence de memoire :*

    P(X > m) = sum_{k=m+1}^{infini} (1-p)^{k-1} * p = (1-p)^m * sum_{j=0}^{infini} (1-p)^j * p = (1-p)^m

Donc P(X > m+n | X > m) = P(X > m+n) / P(X > m) = (1-p)^{m+n} / (1-p)^m = (1-p)^n = P(X > n). CQFD.

> La loi geometrique est la *seule* loi discrete a valeurs dans N* qui possede la propriete d'absence de memoire.

**Exemple 5.2 (Brute force sequentiel) :** Nombre moyen de tentatives pour cracker un hash par essai aleatoire, avec probabilite de succes p = 1/N par essai. E(T) = N. La mediane (valeur m telle que P(T <= m) >= 1/2) est m = ceil(ln(2) / ln(1/(1-1/N))) ≈ N * ln(2) ≈ 0.693 * N.

### 5.5 Loi uniforme discrete U({x_1, ..., x_n})

**Definition 5.5**
X suit une *loi uniforme* sur {x_1, ..., x_n} si P(X = x_i) = 1/n pour tout i.

- E(X) = (x_1 + ... + x_n)/n.
- V(X) = E(X^2) - E(X)^2.

**Cas particulier :** X uniforme sur {1, ..., n}. E(X) = (n+1)/2. V(X) = (n^2 - 1)/12.

---

## 6. Esperance, variance, covariance

### 6.1 Esperance

**Definition 6.1**
L'*esperance* d'une VA discrete X a valeurs reelles est :

    E(X) = sum_{x in X(Omega)} x * P(X = x)

a condition que la serie converge absolument.

**Proprietes fondamentales :**
- *Linearite :* E(aX + bY) = a*E(X) + b*E(Y). Toujours vraie, *avec ou sans independance*.
- *Positivite :* si X >= 0 p.s., alors E(X) >= 0.
- *Croissance :* si X <= Y p.s., alors E(X) <= E(Y).
- *Esperance d'une constante :* E(c) = c.

> La linearite est la propriete la plus puissante. Elle permet de calculer des esperances complexes en decomposant X en somme de VA simples (indicatrices).

### 6.2 Variance et ecart-type

**Definition 6.2**
La *variance* de X est :

    V(X) = E((X - E(X))^2) = E(X^2) - E(X)^2

(La deuxieme egalite est la *formule de Koenig-Huygens*.)

L'*ecart-type* est sigma(X) = sqrt(V(X)).

*Preuve de Koenig-Huygens :*

    V(X) = E((X - E(X))^2) = E(X^2 - 2X*E(X) + E(X)^2)
         = E(X^2) - 2*E(X)*E(X) + E(X)^2 = E(X^2) - E(X)^2

CQFD.

**Proprietes :**
- V(X) >= 0, avec egalite ssi X est constante p.s.
- V(aX + b) = a^2 * V(X) (insensible a la translation, sensible a l'echelle au carre).
- V(X + Y) = V(X) + V(Y) + 2*Cov(X, Y).
- *Si X et Y sont independantes :* V(X + Y) = V(X) + V(Y).

### 6.3 Covariance

**Definition 6.3**
La *covariance* de X et Y est :

    Cov(X, Y) = E((X - E(X)) * (Y - E(Y))) = E(X*Y) - E(X)*E(Y)

**Proprietes :**
- Cov(X, X) = V(X).
- Cov(X, Y) = Cov(Y, X) (symetrie).
- Cov(aX + b, cY + d) = a*c * Cov(X, Y) (bilinearite).
- *Si X et Y sont independantes :* Cov(X, Y) = 0. (Reciproque fausse en general.)

**Definition 6.4 (Coefficient de correlation lineaire)**
Si V(X) > 0 et V(Y) > 0 :

    rho(X, Y) = Cov(X, Y) / (sigma(X) * sigma(Y))

Par Cauchy-Schwarz : |rho(X, Y)| <= 1, avec egalite ssi X et Y sont liees par une relation affine.

### 6.4 Inegalites fondamentales

**Theoreme 6.1 (Inegalite de Markov)**
Si X >= 0 et a > 0 :

    P(X >= a) <= E(X) / a

*Preuve :* E(X) = sum_{x} x*P(X=x) >= sum_{x >= a} x*P(X=x) >= a * sum_{x >= a} P(X=x) = a*P(X >= a). CQFD.

**Theoreme 6.2 (Inegalite de Bienayme-Tchebychev)**
Pour tout epsilon > 0 :

    P(|X - E(X)| >= epsilon) <= V(X) / epsilon^2

*Preuve :* Appliquer Markov a la VA Y = (X - E(X))^2 >= 0 et au seuil epsilon^2 :

    P((X - E(X))^2 >= epsilon^2) <= E((X-E(X))^2) / epsilon^2 = V(X) / epsilon^2

CQFD.

**Interpretation :** La probabilite de s'ecarter de la moyenne de plus de k ecarts-types est au plus 1/k^2. C'est une borne *universelle* (ne depend pas de la loi), mais souvent tres lache.

---

## 7. Couples de variables aleatoires

### 7.1 Loi conjointe et lois marginales

**Definition 7.1 (Loi conjointe)**
La *loi conjointe* du couple (X, Y) est la donnee de P(X = x_i, Y = y_j) pour tous i, j. On la represente par un tableau a double entree.

**Definition 7.2 (Lois marginales)**
Les *lois marginales* sont les lois de X et Y obtenues par sommation :

    P(X = x_i) = sum_j P(X = x_i, Y = y_j)
    P(Y = y_j) = sum_i P(X = x_i, Y = y_j)

> La loi conjointe determine les lois marginales. La reciproque est fausse : les marginales seules ne determinent pas la conjointe (sauf en cas d'independance).

### 7.2 Independance de variables aleatoires

**Definition 7.3**
X et Y sont *independantes* si pour tout (x, y) :

    P(X = x, Y = y) = P(X = x) * P(Y = y)

Equivalemment : la loi conjointe est le *produit* des lois marginales.

**Proposition 7.1**
Si X et Y sont independantes, alors pour toutes fonctions f, g :

    E(f(X) * g(Y)) = E(f(X)) * E(g(Y))

(quand les esperances existent). En particulier, E(XY) = E(X)*E(Y).

---

## 8. Loi des grands nombres

### 8.1 Loi faible

**Theoreme 8.1 (Loi faible des grands nombres)**
Soit (X_n) une suite de VA independantes de meme loi, d'esperance mu et de variance sigma^2 < +infini. La *moyenne empirique* est X_barre_n = (X_1 + ... + X_n)/n. Alors pour tout epsilon > 0 :

    P(|X_barre_n - mu| >= epsilon) -> 0 quand n -> +infini

On dit que X_barre_n *converge en probabilite* vers mu.

*Preuve :*

    E(X_barre_n) = (1/n) * sum E(X_i) = (1/n) * n * mu = mu

    V(X_barre_n) = (1/n^2) * sum V(X_i) = (1/n^2) * n * sigma^2 = sigma^2/n

Par Bienayme-Tchebychev :

    P(|X_barre_n - mu| >= epsilon) <= V(X_barre_n) / epsilon^2 = sigma^2 / (n * epsilon^2) -> 0

CQFD.

### 8.2 Loi forte (admise)

**Theoreme 8.2 (Loi forte des grands nombres)**
Sous les memes hypotheses (ou plus generalement sous la seule hypothese d'existence de l'esperance) :

    X_barre_n -> mu  presque surement

C'est-a-dire que l'ensemble des omega pour lesquels X_barre_n(omega) ne converge pas vers mu est de probabilite 0.

### 8.3 Interpretation et vitesse de convergence

La loi des grands nombres justifie l'interpretation *frequentiste* des probabilites : la frequence empirique d'un evenement converge vers sa probabilite theorique quand le nombre d'experiences tend vers l'infini.

**Vitesse de convergence :** La borne de Tchebychev donne P(|X_barre_n - mu| >= epsilon) <= sigma^2/(n*epsilon^2) = O(1/n). Le theoreme central limite (hors programme strict mais a connaitre) affine : (X_barre_n - mu)/(sigma/sqrt(n)) converge en loi vers la loi normale N(0,1), ce qui donne des bornes beaucoup plus precises.

---

## 9. Applications en securite informatique

### 9.1 Paradoxe des anniversaires et collisions de hachage

**Probleme :** Dans un ensemble de N valeurs possibles (sorties d'une fonction de hachage), combien d'elements faut-il tirer uniformement et independamment pour avoir une probabilite >= 1/2 d'obtenir une collision ?

**Modelisation :** Soit X_1, ..., X_k des VA uniformes independantes sur {1, ..., N}. On cherche le plus petit k tel que P(collision) >= 1/2.

    P(pas de collision) = prod_{i=0}^{k-1} (1 - i/N)

Pour i/N petit, ln(1 - i/N) ≈ -i/N, donc :

    ln(P(pas de collision)) ≈ -sum_{i=0}^{k-1} i/N = -k*(k-1)/(2N)

On veut P(collision) >= 1/2, soit k*(k-1)/(2N) >= ln(2), soit :

    k ≈ sqrt(2N * ln(2)) ≈ 1.177 * sqrt(N)

**Consequence pour les fonctions de hachage :** Pour un hash de n bits (N = 2^n), une collision est probable apres environ 2^{n/2} essais. D'ou les tailles minimales exigees :

    | Hash      | Bits (n) | Attaque anniversaire (2^{n/2}) | Statut         |
    |-----------|----------|-------------------------------|----------------|
    | MD5       | 128      | 2^{64}                        | Casse (2004)   |
    | SHA-1     | 160      | 2^{80}                        | Casse (2017)   |
    | SHA-256   | 256      | 2^{128}                       | Sur            |
    | SHA-3-256 | 256      | 2^{128}                       | Sur            |

### 9.2 Modelisation du brute force

**Probleme :** Mot de passe de longueur L sur un alphabet de taille A. Espace = A^L.

**Avec remise (essais uniformes independants) :** Le nombre de tentatives T avant succes suit G(1/A^L). E(T) = A^L.

**Taux de succes apres m essais :**

    P(succes en m essais) = 1 - (1 - 1/A^L)^m ≈ 1 - e^{-m/A^L}

Pour atteindre P = 0.5 : m ≈ A^L * ln(2) ≈ 0.693 * A^L.

**Exemple numerique :** Mot de passe de 8 caracteres alphanumeriques (A = 62) :
- Espace : 62^8 ≈ 2.18 * 10^{14}.
- A 10^9 essais/seconde : couverture complete en ≈ 2.5 jours.
- Pour 50% de chance : ≈ 1.7 jours.

Avec un alphabet etendu (A = 95, caracteres imprimables ASCII) et L = 12 : espace ≈ 5.4 * 10^{23}. A 10^9 essais/s, 17 millions d'annees pour l'espace complet.

### 9.3 Filtres de Bloom

Un *filtre de Bloom* est une structure de donnees probabiliste pour tester l'appartenance a un ensemble. Il utilise k fonctions de hachage independantes sur un tableau de m bits pour stocker n elements.

Apres insertion, la probabilite qu'un bit donne soit encore a 0 est :

    (1 - 1/m)^{k*n} ≈ e^{-k*n/m}

La probabilite de *faux positif* (un element absent est declare present) est :

    P(FP) ≈ (1 - e^{-k*n/m})^k

Le nombre optimal de fonctions de hachage est k_opt = (m/n) * ln(2), donnant :

    P(FP) ≈ (1/2)^k = (0.6185)^{m/n}

> Les filtres de Bloom sont utilises dans les systemes de cache, les anti-spam, les bases de donnees distribuees, et en securite pour les listes de revocation de certificats (CRL).

### 9.4 Inference bayesienne en detection d'intrusion

**Classification bayesienne naive :** On observe des caracteristiques x = (x_1, ..., x_d) d'un flux reseau.

- H_0 : flux normal.
- H_1 : flux malveillant.

Par Bayes :

    P(H_1 | x) = P(x | H_1) * P(H_1) / P(x)

Sous hypothese d'independance conditionnelle des caracteristiques (hypothese "naive") :

    P(x | H_j) ≈ prod_{i=1}^{d} P(x_i | H_j)

On classifie comme malveillant si P(H_1 | x) > P(H_0 | x), soit :

    prod P(x_i | H_1) * P(H_1) > prod P(x_i | H_0) * P(H_0)

En pratique, on travaille avec les log-vraisemblances pour eviter les sous-depassements numeriques :

    sum ln P(x_i | H_1) + ln P(H_1) > sum ln P(x_i | H_0) + ln P(H_0)

> C'est le *classifieur bayesien naif*, utilise dans les filtres anti-spam (SpamBayes) et comme baseline dans les IDS.

### 9.5 Entropie et securite des mots de passe

**Definition (Entropie de Shannon)**
L'entropie d'une VA discrete X est :

    H(X) = -sum P(X = x) * log_2(P(X = x))

Elle mesure la quantite moyenne d'information (en bits) necessaire pour decrire X.

**Entropie d'un mot de passe :** Si chaque caractere est tire uniformement et independamment dans un alphabet de taille A, un mot de passe de longueur L a une entropie de L * log_2(A) bits.

    | Alphabet                | A   | Bits/car | L=8   | L=12  | L=16   |
    |-------------------------|-----|----------|-------|-------|--------|
    | Chiffres                | 10  | 3.32     | 26.6  | 39.9  | 53.1   |
    | Minuscules              | 26  | 4.70     | 37.6  | 56.4  | 75.2   |
    | Alphanum (maj+min+chif) | 62  | 5.95     | 47.6  | 71.5  | 95.3   |
    | ASCII imprimable        | 95  | 6.57     | 52.6  | 78.8  | 105.1  |

Pour une securite de 128 bits d'entropie (standard actuel), il faut un mot de passe d'au moins 22 caracteres alphanumeriques ou 20 caracteres ASCII complets.

---

## 10. Exercices de comprehension

**Exercice 1 (Probabilites de base)**
On lance 3 des equilibres. Calculer la probabilite d'obtenir :
a) Un total de 10.
b) Exactement deux des identiques (mais pas les trois).
c) Au moins un 6.

**Exercice 2 (Bayes)**
Un test de vulnerabilite detecte 95% des failles presentes (sensibilite) mais genere 10% de faux positifs (specificite = 90%). On estime que 5% des points testes presentent une faille.
a) Quelle est la probabilite qu'un point signale comme vulnerable soit reellement vulnerable ?
b) Si on enchaine deux tests independants (positifs tous les deux), quelle est la nouvelle probabilite a posteriori ?

**Exercice 3 (Loi binomiale)**
Un serveur recoit 1000 requetes par minute, chacune ayant independamment une probabilite 0.01 d'etre malveillante.
a) Quelle loi suit le nombre X de requetes malveillantes par minute ?
b) Calculer E(X) et V(X).
c) Approximer P(X >= 15) par la loi de Poisson.
d) Utiliser Tchebychev pour borner P(X >= 15).

**Exercice 4 (Loi geometrique et brute force)**
Un attaquant tente de se connecter a un compte avec un mot de passe aleatoire. L'espace des mots de passe est N = 10^6.
a) Quelle loi suit le nombre T de tentatives (avec remise) ?
b) Calculer E(T).
c) Quelle est la probabilite de succes en moins de 1000 tentatives ?
d) Apres combien de tentatives a-t-on 50% de chance de succes ?

**Exercice 5 (Paradoxe des anniversaires)**
a) Calculer la probabilite exacte que parmi 23 personnes, au moins deux aient le meme anniversaire (N = 365).
b) Pour une fonction de hachage sur 64 bits, combien de hachages faut-il calculer pour avoir P(collision) >= 50% ?
c) Pourquoi SHA-1 (160 bits) est-il considere comme insuffisant ? (Indication : 2^{80} operations.)

**Exercice 6 (Variance et Tchebychev)**
Soit X le nombre de piles en n = 10000 lancers d'une piece equilibree.
a) Calculer E(X) et V(X).
b) En utilisant Tchebychev, donner une borne superieure pour P(|X - 5000| >= 100).
c) Comparer avec la borne obtenue par l'approximation normale (TCL) : P(|X - 5000| >= 100) ≈ 2*(1 - Phi(2)) ≈ 0.0455.

**Exercice 7 (Filtre de Bloom)**
Un filtre de Bloom utilise m = 10000 bits et k = 7 fonctions de hachage pour stocker n = 1000 elements.
a) Calculer la probabilite de faux positif.
b) Si on double m (m = 20000), comment evolue le taux de faux positifs ?
c) Quel est le k optimal pour m = 10000 et n = 1000 ?

**Exercice 8 (Independance et XOR)**
On genere deux cles K_1 et K_2 uniformement et independamment sur {0, 1}^n. Soit K = K_1 XOR K_2.
a) Montrer que K suit une loi uniforme sur {0, 1}^n.
b) K et K_1 sont-ils independants ? (Indication : P(K = k, K_1 = k_1) = P(K_2 = k XOR k_1) * P(K_1 = k_1).)
c) Connaitre K_1 et K donne-t-il de l'information sur K_2 ? Discuter l'implication pour le one-time pad.

**Exercice 9 (Entropie)**
a) Calculer l'entropie d'un de equilibre a 6 faces.
b) Calculer l'entropie d'un de pipe ou P(6) = 1/2 et P(k) = 1/10 pour k = 1, ..., 5. Comparer avec le de equilibre.
c) Montrer que l'entropie est maximale pour la loi uniforme (parmi les lois sur un ensemble fini de cardinal n).

---

## 11. References

- **Ouvrard, J.-Y.** *Probabilites 1 -- Cours et exercices corriges.* Dunod.
- **Cottrell, M., Duhamel, C., Genon-Catalot, V.** *Exercices de probabilites.* Cassini.
- **Feller, W.** *An Introduction to Probability Theory and Its Applications.* Wiley.
- **Mitzenmacher, M. & Upfal, E.** *Probability and Computing.* Cambridge University Press. (Approche orientee informatique, excellente reference.)
- **Cover, T. & Thomas, J.** *Elements of Information Theory.* Wiley. (Pour l'entropie et ses applications.)
- **Menezes, A., van Oorschot, P., Vanstone, S.** *Handbook of Applied Cryptography.* CRC Press. (Chapitres sur la complexite probabiliste et les attaques par anniversaire.)
- Programme officiel MP2I/MPI pour les probabilites discretes.
