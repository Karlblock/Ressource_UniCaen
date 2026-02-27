# Chapitre 1 -- Logique, Ensembles et Denombrement

## Objectifs du chapitre

- Maitriser les connecteurs logiques et les tables de verite associees.
- Comprendre et manipuler les quantificateurs universels et existentiels.
- Connaitre les principaux schemas de raisonnement (direct, contraposee, absurde, recurrence).
- Definir les operations ensemblistes et demontrer les lois de De Morgan.
- Formaliser les notions de relation, d'application, d'injection, de surjection et de bijection.
- Resoudre des problemes de denombrement a l'aide des combinaisons, arrangements et du principe des tiroirs.

---

## I. Logique propositionnelle

### 1. Propositions et connecteurs

**Definition 1.1.** Une *proposition* (ou *assertion*) est un enonce mathematique qui est soit vrai (V), soit faux (F). On note souvent les propositions par des lettres majuscules P, Q, R, etc.

**Exemples.**
- "2 est un nombre pair" est une proposition (vraie).
- "3 > 5" est une proposition (fausse).
- "x + 1 = 3" n'est pas une proposition au sens strict : c'est un *predicat* (sa valeur de verite depend de x).

**Definition 1.2 (Connecteurs logiques).** Soient P et Q deux propositions. On definit les connecteurs suivants :

| Connecteur | Notation | Nom | Lecture |
|---|---|---|---|
| Negation | ~P | NON | "non P" |
| Conjonction | P ^ Q | ET | "P et Q" |
| Disjonction | P v Q | OU (inclusif) | "P ou Q" |
| Implication | P => Q | IMPLIQUE | "si P alors Q" |
| Equivalence | P <=> Q | EQUIVAUT | "P si et seulement si Q" |

**Remarque.** Le "ou" mathematique est *inclusif* : P v Q est vrai des que l'une au moins des deux propositions est vraie, y compris si les deux le sont. Le "ou exclusif" (XOR), note P xor Q, est vrai si exactement l'une des deux est vraie.

### 2. Tables de verite

Les tables de verite definissent la valeur de verite d'une proposition composee en fonction des valeurs de verite de ses composantes.

**Table de la negation :**

| P | ~P |
|---|---|
| V | F |
| F | V |

**Table de la conjonction :**

| P | Q | P ^ Q |
|---|---|---|
| V | V | V |
| V | F | F |
| F | V | F |
| F | F | F |

**Table de la disjonction :**

| P | Q | P v Q |
|---|---|---|
| V | V | V |
| V | F | V |
| F | V | V |
| F | F | F |

**Table de l'implication :**

| P | Q | P => Q |
|---|---|---|
| V | V | V |
| V | F | F |
| F | V | V |
| F | F | V |

**Remarque fondamentale.** L'implication P => Q est fausse *uniquement* lorsque P est vraie et Q est fausse. En particulier, si P est fausse, alors P => Q est toujours vraie, quelle que soit Q. C'est le principe du *ex falso quodlibet*. Cela surprend souvent : "si la Lune est en fromage, alors 2 + 2 = 5" est une proposition *vraie* (car l'hypothese est fausse).

**Table de l'equivalence :**

| P | Q | P <=> Q |
|---|---|---|
| V | V | V |
| V | F | F |
| F | V | F |
| F | F | V |

L'equivalence P <=> Q est vraie lorsque P et Q ont la meme valeur de verite. On a : P <=> Q est logiquement equivalente a (P => Q) ^ (Q => P).

**Table du XOR (ou exclusif) :**

| P | Q | P xor Q |
|---|---|---|
| V | V | F |
| V | F | V |
| F | V | V |
| F | F | F |

On a : P xor Q <=> (P v Q) ^ ~(P ^ Q).

### 3. Tautologies et equivalences logiques fondamentales

**Definition 1.3.** Une *tautologie* est une proposition composee qui est vraie pour toute assignation de valeurs de verite a ses variables. Une *contradiction* (ou *antilogie*) est une proposition toujours fausse.

**Proposition 1.4 (Equivalences fondamentales).** Pour toutes propositions P, Q, R :

1. **Double negation :** ~(~P) <=> P
2. **Commutativite :** P ^ Q <=> Q ^ P et P v Q <=> Q v P
3. **Associativite :** (P ^ Q) ^ R <=> P ^ (Q ^ R) et (P v Q) v R <=> P v (Q v R)
4. **Distributivite :** P ^ (Q v R) <=> (P ^ Q) v (P ^ R) et P v (Q ^ R) <=> (P v Q) ^ (P v R)
5. **Lois de De Morgan :** ~(P ^ Q) <=> (~P) v (~Q) et ~(P v Q) <=> (~P) ^ (~Q)
6. **Contraposee :** (P => Q) <=> (~Q => ~P)
7. **Implication et disjonction :** (P => Q) <=> (~P v Q)
8. **Idempotence :** P ^ P <=> P et P v P <=> P
9. **Absorption :** P ^ (P v Q) <=> P et P v (P ^ Q) <=> P
10. **Tiers exclu :** P v ~P est une tautologie.
11. **Non-contradiction :** P ^ ~P est une contradiction.

*Preuve de la loi de De Morgan ~(P ^ Q) <=> (~P) v (~Q).*

On verifie par table de verite :

| P | Q | P ^ Q | ~(P ^ Q) | ~P | ~Q | (~P) v (~Q) |
|---|---|---|---|---|---|---|
| V | V | V | F | F | F | F |
| V | F | F | V | F | V | V |
| F | V | F | V | V | F | V |
| F | F | F | V | V | V | V |

Les colonnes 4 et 7 sont identiques, donc les deux propositions sont logiquement equivalentes. QED.

*Preuve de la contraposee (P => Q) <=> (~Q => ~P).*

| P | Q | P => Q | ~Q | ~P | ~Q => ~P |
|---|---|---|---|---|---|
| V | V | V | F | F | V |
| V | F | F | V | F | F |
| F | V | V | F | V | V |
| F | F | V | V | V | V |

Les colonnes "P => Q" et "~Q => ~P" coincident. QED.

### 4. Application en informatique

En securite informatique et en programmation, la logique propositionnelle est omnipresente :
- Les conditions dans les programmes sont des propositions composees.
- Les circuits logiques des processeurs implementent physiquement les portes ET, OU, NON.
- En cryptographie, le XOR (ou exclusif) est un connecteur fondamental : il est utilise massivement dans les chiffrements par flot (stream ciphers) et les chiffrements par blocs (AES).
- Les lois de De Morgan permettent de transformer des expressions booleennes, ce qui est utile pour l'optimisation de circuits et l'analyse de protocoles cryptographiques.

**Exercice de comprehension 1.** Montrer par table de verite que (P => Q) <=> (~P v Q).

**Exercice de comprehension 2.** Simplifier la proposition ~((P ^ Q) v (~P ^ ~Q)). Indication : developper avec De Morgan, puis simplifier.

**Exercice de comprehension 3.** Montrer que ((P => Q) ^ (Q => R)) => (P => R) est une tautologie (transitivite de l'implication).

---

## II. Logique des predicats

### 1. Predicats et quantificateurs

**Definition 1.5.** Un *predicat* est une proposition contenant une ou plusieurs variables libres. On note P(x) un predicat a une variable. La valeur de verite de P(x) depend de la valeur attribuee a x dans un ensemble de reference E (appele *univers du discours*).

**Exemple.** Soit E = Z et P(x) : "x^2 = 4". Alors P(2) est vraie, P(-2) est vraie, P(3) est fausse.

**Definition 1.6 (Quantificateurs).**

- **Quantificateur universel :** La proposition "pour tout x dans E, P(x)" est vraie si P(x) est vraie pour *tout* element x de E.
- **Quantificateur existentiel :** La proposition "il existe x dans E, P(x)" est vraie s'il existe *au moins un* element x de E pour lequel P(x) est vraie.
- **Quantificateur existentiel unique :** "il existe un unique x dans E, P(x)" signifie qu'il existe un et un seul x dans E verifiant P(x).

### 2. Negation des propositions quantifiees

**Proposition 1.7.** Les negations des propositions quantifiees s'obtiennent en echangeant les quantificateurs et en niant le predicat :

- ~(pour tout x dans E, P(x)) <=> il existe x dans E, ~P(x)
- ~(il existe x dans E, P(x)) <=> pour tout x dans E, ~P(x)

**Intuition.** Pour nier "tous les elements verifient P", il suffit de trouver un seul element qui ne verifie pas P. Pour nier "il en existe un qui verifie P", il faut montrer qu'aucun ne la verifie.

**Exemple fondamental.** La definition de la convergence d'une suite (u_n) vers l est :

"Pour tout epsilon > 0, il existe N dans N, pour tout n >= N, |u_n - l| < epsilon."

Sa negation est :

"Il existe epsilon > 0, pour tout N dans N, il existe n >= N, |u_n - l| >= epsilon."

On a successivement : echange "pour tout" en "il existe", echange "il existe" en "pour tout", echange "pour tout" en "il existe", et negation de l'inegalite stricte (<) en inegalite large (>=).

### 3. Ordre des quantificateurs

L'ordre dans lequel on ecrit les quantificateurs est *essentiel* et modifier cet ordre change generalement le sens de la proposition.

**Exemple.** Comparons :
- (a) "Pour tout x dans R, il existe y dans R, x + y = 0." C'est VRAI : pour tout x, on peut choisir y = -x.
- (b) "Il existe y dans R, pour tout x dans R, x + y = 0." C'est FAUX : aucun y fixe ne peut annuler x + y pour tout x.

En (a), y peut dependre de x (y est choisi *apres* x). En (b), y est fixe *avant* de considerer x.

**Exercice de comprehension 4.** Ecrire la negation formelle de chacune des propositions suivantes :
1. Pour tout x dans R, il existe y dans R, x + y = 0.
2. Il existe n dans N, pour tout m dans N, n <= m.
3. Pour tout epsilon > 0, il existe delta > 0, pour tout x, |x - a| < delta => |f(x) - f(a)| < epsilon (continuite de f en a).

---

## III. Raisonnements mathematiques

### 1. Raisonnement direct

On part des hypotheses et on enchaine des implications pour aboutir a la conclusion.

**Exemple.** Montrons que la somme de deux entiers pairs est paire.

*Preuve.* Soient a et b deux entiers pairs. Par definition, il existe k, l dans Z tels que a = 2k et b = 2l. Alors a + b = 2k + 2l = 2(k + l). Comme k + l est un entier, a + b est pair. QED.

### 2. Raisonnement par contraposee

Pour montrer P => Q, on montre ~Q => ~P (ce qui est logiquement equivalent).

**Exemple.** Montrons que si n^2 est pair, alors n est pair.

*Preuve par contraposee.* On montre : si n est impair, alors n^2 est impair.

Supposons n impair. Alors il existe k dans Z tel que n = 2k + 1. On a n^2 = (2k + 1)^2 = 4k^2 + 4k + 1 = 2(2k^2 + 2k) + 1, qui est impair. QED.

### 3. Raisonnement par l'absurde

Pour montrer P, on suppose ~P et on aboutit a une contradiction.

**Theoreme 1.8.** Racine de 2 est irrationnel.

*Preuve.* Supposons par l'absurde que sqrt(2) est dans Q. Alors il existe p, q dans Z avec q != 0 et pgcd(p, q) = 1 tels que sqrt(2) = p/q. On a 2 = p^2/q^2, d'ou p^2 = 2q^2. Ainsi p^2 est pair, donc p est pair (par la contraposee montree ci-dessus). Ecrivons p = 2k. Alors 4k^2 = 2q^2, soit q^2 = 2k^2. Donc q^2 est pair, et q est pair. Mais alors p et q sont tous deux pairs, ce qui contredit pgcd(p, q) = 1. Contradiction. Donc sqrt(2) est irrationnel. QED.

### 4. Raisonnement par recurrence

**Principe de recurrence.** Soit P(n) un predicat dependant de n dans N. Si :
1. P(n_0) est vraie pour un certain n_0 dans N (*initialisation*),
2. Pour tout n >= n_0, P(n) => P(n + 1) (*heredite*),

alors pour tout n >= n_0, P(n) est vraie.

**Exemple.** Montrons par recurrence que pour tout n dans N* :

1 + 2 + ... + n = n(n+1)/2

*Preuve.*

**Initialisation (n = 1) :** Le membre gauche vaut 1. Le membre droit vaut 1(1+1)/2 = 1. L'egalite est verifiee.

**Heredite :** Supposons la propriete vraie au rang n (hypothese de recurrence). Montrons-la au rang n + 1.

1 + 2 + ... + n + (n + 1) = [1 + 2 + ... + n] + (n + 1) = n(n+1)/2 + (n + 1) = (n + 1)(n/2 + 1) = (n + 1)(n + 2)/2.

C'est bien la formule au rang n + 1. QED.

**Variante : recurrence forte.** L'hypothese de recurrence porte sur *tous* les rangs de n_0 a n (et pas seulement le rang n) pour montrer P(n + 1). Utile notamment pour les preuves liees a la decomposition en facteurs premiers.

**Exemple.** Montrons que tout entier n >= 2 admet un diviseur premier.

*Preuve par recurrence forte.* Initialisation : P(2) est vraie car 2 est premier et se divise lui-meme. Heredite : soit n >= 2, supposons que tout entier m avec 2 <= m <= n admet un diviseur premier. Considerons n + 1. Si n + 1 est premier, il est son propre diviseur premier. Sinon, n + 1 = ab avec 2 <= a, b <= n. Par hypothese de recurrence, a admet un diviseur premier p. Alors p divise a et a divise n + 1, donc p divise n + 1. QED.

**Exercice de comprehension 5.** Montrer par recurrence que pour tout n >= 1, on a 2^n > n.

**Exercice de comprehension 6.** Montrer par recurrence que pour tout n >= 0, 3 divise 4^n - 1.

---

## IV. Theorie des ensembles

### 1. Definitions fondamentales

**Definition 1.9.** Un *ensemble* est une collection d'objets, appeles *elements*. On note x dans E si x est un element de l'ensemble E, et x n'est pas dans E sinon.

**Ensembles classiques :**
- N = {0, 1, 2, 3, ...} (entiers naturels)
- Z = {..., -2, -1, 0, 1, 2, ...} (entiers relatifs)
- Q = {p/q | p dans Z, q dans Z*} (rationnels)
- R (reels), C (complexes)

**Definition 1.10.** L'ensemble vide, note {}, est l'ensemble qui ne contient aucun element. Pour tout ensemble E, on a {} est inclus dans E.

**Definition 1.11 (Inclusion).** On dit que A est un *sous-ensemble* (ou une *partie*) de E, note A inclus dans E, si tout element de A est un element de E :

A inclus dans E <=> (pour tout x, x dans A => x dans E)

**Definition 1.12 (Egalite d'ensembles).** Deux ensembles A et B sont egaux si et seulement si A inclus dans B et B inclus dans A. C'est la methode standard pour montrer une egalite ensembliste : la *double inclusion*.

### 2. Operations sur les ensembles

**Definition 1.13.** Soient A et B deux parties d'un ensemble E.

- **Reunion :** A union B = {x dans E | x dans A ou x dans B}
- **Intersection :** A inter B = {x dans E | x dans A et x dans B}
- **Complementaire :** compl(A) = E \ A = {x dans E | x n'est pas dans A}
- **Difference :** A \ B = {x dans E | x dans A et x n'est pas dans B}
- **Difference symetrique :** A delta B = (A \ B) union (B \ A)
- **Produit cartesien :** A x B = {(a, b) | a dans A et b dans B}

**Definition 1.14 (Ensemble des parties).** L'ensemble de toutes les parties de E est note P(E). Si E est fini de cardinal n, alors |P(E)| = 2^n.

*Preuve que |P(E)| = 2^n.* Par recurrence sur n. Si n = 0, E = {} et P(E) = {{}} est de cardinal 1 = 2^0. Supposons le resultat vrai pour un ensemble a n elements. Soit E un ensemble a n + 1 elements, et fixons a dans E. Toute partie X de E soit contient a (et alors X \ {a} est une partie de E \ {a}, ensemble a n elements), soit ne contient pas a (et X est directement une partie de E \ {a}). On obtient une bijection entre P(E) et P(E \ {a}) x {0, 1} (le bit indique si a est present). Donc |P(E)| = 2 * |P(E \ {a})| = 2 * 2^n = 2^(n+1). QED.

### 3. Lois de De Morgan ensemblistes

**Theoreme 1.15 (Lois de De Morgan).** Soient A et B deux parties d'un ensemble E.

1. Complementaire d'une reunion : compl(A union B) = compl(A) inter compl(B)
2. Complementaire d'une intersection : compl(A inter B) = compl(A) union compl(B)

*Preuve de (1) par double inclusion.*

**Inclusion directe :** Soit x dans compl(A union B). Alors x n'est pas dans A union B. Donc x n'est pas dans A et x n'est pas dans B (car si x etait dans A ou dans B, il serait dans A union B). Donc x dans compl(A) et x dans compl(B), d'ou x dans compl(A) inter compl(B).

**Inclusion reciproque :** Soit x dans compl(A) inter compl(B). Alors x dans compl(A) et x dans compl(B), c'est-a-dire x n'est pas dans A et x n'est pas dans B. Donc x n'est pas dans A union B, d'ou x dans compl(A union B).

Par double inclusion, compl(A union B) = compl(A) inter compl(B). QED.

**Generalisation aux familles.** Pour une famille (A_i) indexee par i dans I :

- compl(union des A_i) = intersection des compl(A_i)
- compl(intersection des A_i) = union des compl(A_i)

**Application (securite/crypto).** En logique booleenne (circuits, crypto symetrique), les lois de De Morgan sont fondamentales pour transformer des portes AND en portes OR (et reciproquement) en presence de negations. Le chiffrement AES utilise des operations booleennes dans GF(2^8) que l'on peut analyser et optimiser via ces lois.

**Exercice de comprehension 7.** Demontrer la deuxieme loi de De Morgan par double inclusion.

**Exercice de comprehension 8.** Montrer par double inclusion que A inter (B union C) = (A inter B) union (A inter C) (distributivite).

---

## V. Relations et applications

### 1. Relations binaires

**Definition 1.16.** Une *relation binaire* R sur un ensemble E est une partie de E x E. On note xRy pour (x, y) dans R.

**Definition 1.17 (Proprietes).** Soit R une relation sur E.

- **Reflexivite :** pour tout x dans E, xRx.
- **Symetrie :** pour tout x, y dans E, xRy => yRx.
- **Antisymetrie :** pour tout x, y dans E, (xRy et yRx) => x = y.
- **Transitivite :** pour tout x, y, z dans E, (xRy et yRz) => xRz.

**Definition 1.18.** Une *relation d'equivalence* est une relation reflexive, symetrique et transitive. Une *relation d'ordre* est une relation reflexive, antisymetrique et transitive.

**Exemple.** La congruence modulo n sur Z est une relation d'equivalence : on a a ~ b si et seulement si n | (a - b). On verifie : reflexivite (n | 0), symetrie (si n | (a-b) alors n | (b-a)), transitivite (si n | (a-b) et n | (b-c), alors n | ((a-b)+(b-c)) = n | (a-c)).

**Definition 1.19 (Classes d'equivalence).** Si ~ est une relation d'equivalence sur E, la *classe d'equivalence* de x est l'ensemble [x] = {y dans E | y ~ x}. L'ensemble des classes d'equivalence forme une *partition* de E : les classes sont non vides, deux a deux disjointes, et leur reunion est E.

**Exemple.** Pour la congruence modulo 3 sur Z, les classes d'equivalence sont :
- [0] = {..., -6, -3, 0, 3, 6, 9, ...} (les multiples de 3)
- [1] = {..., -5, -2, 1, 4, 7, 10, ...}
- [2] = {..., -4, -1, 2, 5, 8, 11, ...}

Ces trois classes forment une partition de Z.

**Exemple (relation d'ordre).** La divisibilite sur N* : a | b. C'est un ordre *partiel* (tous les elements ne sont pas comparables : on ne peut pas comparer 2 et 3 par la divisibilite).

### 2. Applications

**Definition 1.20.** Une *application* (ou *fonction*) de E dans F, notee f : E -> F, est une regle qui a *chaque* element x de E associe un *unique* element f(x) de F. E est l'*ensemble de depart* (ou domaine), F est l'*ensemble d'arrivee* (ou codomaine).

**Definition 1.21 (Image et antecedent).**
- L'*image directe* de A inclus dans E par f est f(A) = {f(x) | x dans A}.
- L'*image reciproque* de B inclus dans F par f est f^{-1}(B) = {x dans E | f(x) dans B}.
- L'*image* de f est Im(f) = f(E) = {f(x) | x dans E}.

**Attention.** f^{-1}(B) est defini meme si f n'est pas bijective. Ce n'est pas la meme chose que la bijection reciproque.

### 3. Injection, surjection, bijection

**Definition 1.22.**

- f est *injective* si : pour tout x_1, x_2 dans E, f(x_1) = f(x_2) => x_1 = x_2.
- f est *surjective* si : pour tout y dans F, il existe x dans E, f(x) = y. (Autrement dit, Im(f) = F.)
- f est *bijective* si elle est a la fois injective et surjective.

**Proposition 1.23.** Si f : E -> F est bijective, alors il existe une unique application g : F -> E telle que g o f = id_E et f o g = id_F. Cette application g est appelee la *bijection reciproque* de f, notee f^{-1}.

**Theoreme 1.24 (Composition).** Soient f : E -> F et g : F -> G deux applications.
1. Si f et g sont injectives, alors g o f est injective.
2. Si f et g sont surjectives, alors g o f est surjective.
3. Si f et g sont bijectives, alors g o f est bijective et (g o f)^{-1} = f^{-1} o g^{-1}.

*Preuve de (1).* Soient x_1, x_2 dans E tels que (g o f)(x_1) = (g o f)(x_2), i.e. g(f(x_1)) = g(f(x_2)). Comme g est injective, on obtient f(x_1) = f(x_2). Comme f est injective, on obtient x_1 = x_2. QED.

**Theoreme 1.25 (Cardinal et bijection).** Si E et F sont deux ensembles finis, alors |E| = |F| si et seulement s'il existe une bijection de E dans F. De plus, pour E et F finis de meme cardinal, une application f : E -> F est injective si et seulement si elle est surjective (si et seulement si elle est bijective).

*Preuve (injection => surjection en dimension finie).* Si f est injective, les n = |E| elements de E ont des images deux a deux distinctes dans F. Comme |F| = n, l'image de f contient n elements distincts de F, donc Im(f) = F et f est surjective. QED.

**Proposition 1.26 (Conditions sur la composition).** Soient f : E -> F et g : F -> G.
- Si g o f est injective, alors f est injective.
- Si g o f est surjective, alors g est surjective.

*Preuve de la premiere assertion.* Si f(x_1) = f(x_2), alors g(f(x_1)) = g(f(x_2)), donc (g o f)(x_1) = (g o f)(x_2). Comme g o f est injective, x_1 = x_2. Donc f est injective. QED.

**Proposition 1.27 (Image directe et reciproque).** Pour toute application f : E -> F :
- f^{-1}(B_1 union B_2) = f^{-1}(B_1) union f^{-1}(B_2)
- f^{-1}(B_1 inter B_2) = f^{-1}(B_1) inter f^{-1}(B_2)
- f(A_1 union A_2) = f(A_1) union f(A_2)
- f(A_1 inter A_2) est inclus dans f(A_1) inter f(A_2) (inclusion potentiellement stricte si f n'est pas injective)

**Exercice de comprehension 9.** Montrer que l'application f : Z -> Z definie par f(n) = 2n + 1 est injective mais pas surjective. Determiner Im(f).

**Exercice de comprehension 10.** Soit f : R -> R definie par f(x) = x^2. Donner un exemple montrant que f(A inter B) != f(A) inter f(B). Montrer que si f est injective, l'egalite est toujours verifiee.

---

## VI. Denombrement

### 1. Principes fondamentaux

**Principe additif.** Si A_1, A_2, ..., A_k sont des ensembles finis *deux a deux disjoints*, alors :

|A_1 union A_2 union ... union A_k| = |A_1| + |A_2| + ... + |A_k|

**Formule d'inclusion-exclusion (cas de deux ensembles).** Pour A, B finis :

|A union B| = |A| + |B| - |A inter B|

**Generalisation a trois ensembles :**

|A union B union C| = |A| + |B| + |C| - |A inter B| - |A inter C| - |B inter C| + |A inter B inter C|

**Principe multiplicatif.** Si l'on doit effectuer deux choix successifs, le premier parmi n_1 possibilites et le second parmi n_2 possibilites (independamment du premier), alors le nombre total de choix est n_1 x n_2. En particulier : |A x B| = |A| x |B|.

### 2. Arrangements et permutations

**Definition 1.28.** Un *arrangement* de p elements parmi n (avec p <= n) est une liste ordonnee de p elements distincts choisis parmi n. Le nombre d'arrangements est :

A(n, p) = n! / (n - p)! = n(n - 1)(n - 2)...(n - p + 1)

**Cas particulier : permutation.** Une permutation d'un ensemble a n elements est un arrangement de n elements parmi n. Le nombre de permutations est n!.

**Rappel :** 0! = 1 par convention, et n! = 1 x 2 x 3 x ... x n pour n >= 1.

**Exemple.** De combien de facons peut-on choisir un president, un vice-president et un secretaire parmi 10 personnes ? C'est un arrangement de 3 parmi 10 : A(10, 3) = 10 x 9 x 8 = 720.

### 3. Combinaisons

**Definition 1.29.** Le nombre de *combinaisons* de p elements parmi n est le nombre de parties a p elements d'un ensemble a n elements, note C(n, p) :

C(n, p) = n! / (p! (n - p)!)

La difference avec les arrangements est que l'*ordre ne compte pas*.

**Proposition 1.30 (Proprietes des coefficients binomiaux).**

1. C(n, 0) = C(n, n) = 1
2. C(n, p) = C(n, n - p) (symetrie)
3. C(n, p) = C(n - 1, p - 1) + C(n - 1, p) (formule de Pascal)

*Preuve combinatoire de la formule de Pascal.* Soit E un ensemble a n elements et fixons un element a dans E. Les parties de E a p elements se repartissent en deux categories :
- Celles qui contiennent a : il faut choisir p - 1 elements parmi les n - 1 restants, soit C(n - 1, p - 1) parties.
- Celles qui ne contiennent pas a : il faut choisir p elements parmi les n - 1 restants, soit C(n - 1, p) parties.

Par le principe additif (les deux categories sont disjointes) : C(n, p) = C(n - 1, p - 1) + C(n - 1, p). QED.

**Triangle de Pascal (premieres lignes) :**

```
n=0 :                1
n=1 :              1   1
n=2 :            1   2   1
n=3 :          1   3   3   1
n=4 :        1   4   6   4   1
n=5 :      1   5  10  10   5   1
```

**Theoreme 1.31 (Formule du binome de Newton).** Pour tout a, b dans R (ou dans un anneau commutatif) et tout n dans N :

(a + b)^n = Somme(k = 0 a n) C(n, k) a^k b^(n-k)

*Preuve par recurrence.*

**Initialisation (n = 0) :** (a + b)^0 = 1 = C(0, 0) a^0 b^0. Vrai.

**Heredite :** Supposons la formule vraie au rang n. Alors :

(a + b)^(n+1) = (a + b)(a + b)^n = (a + b) Somme(k = 0 a n) C(n, k) a^k b^(n-k)

= Somme(k = 0 a n) C(n, k) a^(k+1) b^(n-k) + Somme(k = 0 a n) C(n, k) a^k b^(n+1-k)

En reindexant le premier somme (j = k + 1) et en utilisant la formule de Pascal, on obtient la formule au rang n + 1. QED.

**Corollaire 1.32.** En prenant a = b = 1, on obtient : Somme(k = 0 a n) C(n, k) = 2^n. C'est le nombre total de parties d'un ensemble a n elements.

### 4. Le principe des tiroirs (pigeonhole principle)

**Theoreme 1.33 (Principe des tiroirs de Dirichlet).** Si l'on repartit n + 1 objets dans n tiroirs, alors au moins un tiroir contient au moins 2 objets.

**Forme generalisee.** Si l'on repartit n objets dans k tiroirs, alors au moins un tiroir contient au moins ceil(n/k) objets.

*Preuve.* Par l'absurde. Si chaque tiroir contenait au plus ceil(n/k) - 1 objets, le nombre total d'objets serait au plus k(ceil(n/k) - 1) < k * (n/k) = n, ce qui contredit le fait qu'il y a n objets. QED.

**Exemple 1.** Parmi 13 personnes, au moins 2 sont nees le meme mois. (13 personnes, 12 mois.)

**Exemple 2 (Securite).** Dans une fonction de hachage qui produit des empreintes de 256 bits, l'espace d'arrivee contient 2^256 valeurs possibles. Par le principe des tiroirs, si l'on hache plus de 2^256 messages distincts, au moins deux auront le meme hash (collision). Le *paradoxe des anniversaires* montre qu'en pratique, une collision est probable des environ 2^128 essais.

**Exemple 3.** Parmi 6 entiers quelconques, on peut toujours en trouver 2 dont la difference est divisible par 5. Preuve : il y a 5 restes possibles modulo 5 (les tiroirs sont {0, 1, 2, 3, 4}). Comme on a 6 entiers et seulement 5 tiroirs, deux entiers au moins ont le meme reste modulo 5, et leur difference est donc divisible par 5.

---

## VII. Applications en cryptographie et securite

### 1. Lien avec la cryptographie

Le denombrement est au coeur de l'evaluation de la securite des systemes cryptographiques :

- **Taille de l'espace des cles :** Un mot de passe de longueur n sur un alphabet de k caracteres offre k^n possibilites. Un mot de passe de 8 caracteres alphanumeriques (62 symboles : a-z, A-Z, 0-9) donne 62^8 ~ 2.18 x 10^14 combinaisons. Avec du materiel moderne (GPU), cet espace est explorable en quelques heures pour des algorithmes rapides (MD5, NTLM).

- **Attaque par force brute :** Le nombre d'essais necessaires est directement lie au denombrement des possibilites. La complexite en temps d'une attaque exhaustive est O(|espace des cles|).

- **Paradoxe des anniversaires :** Pour une fonction de hachage a n bits, la probabilite d'une collision depasse 50% apres environ 2^(n/2) essais. C'est pourquoi SHA-256 (n = 256) est considere comme resistant aux collisions (2^128 essais necessaires), tandis que MD5 (n = 128) ne l'est plus (2^64 essais sont faisables).

### 2. Lien avec l'injection et la surjection

- Une fonction de hachage n'est **pas injective** (par le principe des tiroirs, puisque l'ensemble de depart est plus grand que l'ensemble d'arrivee).
- Un chiffrement par blocs avec une cle fixee *doit* etre une **bijection** (pour permettre le dechiffrement).
- La relation d'equivalence modulo n est la base de toute l'arithmetique modulaire utilisee en cryptographie (RSA, Diffie-Hellman, courbes elliptiques).

### 3. Lien avec l'IA

Les ensembles et les relations structurent les donnees en IA (graphes de connaissances, bases de donnees relationnelles). La logique des predicats est le fondement de Prolog et du raisonnement symbolique. Les techniques de denombrement interviennent dans le calcul des probabilites, elles-memes centrales en apprentissage automatique (analyse combinatoire pour le calcul de vraisemblances, estimation bayesienne).

---

## VIII. Exercices de synthese

**Exercice 11.** Montrer par table de verite que P => Q est logiquement equivalent a ~P v Q.

**Exercice 12.** Soit f : E -> F une application. Montrer que pour toutes parties A, B de E :
1. f(A union B) = f(A) union f(B)
2. f(A inter B) est inclus dans f(A) inter f(B) (donner un contre-exemple montrant que l'inclusion peut etre stricte)
3. Si f est injective, alors f(A inter B) = f(A) inter f(B)

**Exercice 13.** Combien de fonctions y a-t-il de {1, 2, ..., n} dans {1, 2, ..., p} ? Parmi celles-ci, combien sont injectives (quand p >= n) ?

**Exercice 14 (Denombrement et crypto).** Un code PIN est constitue de 4 chiffres (de 0 a 9).
1. Combien de codes PIN distincts existe-t-il ?
2. Si l'on interdit la repetition de chiffres, combien en reste-t-il ?
3. Un attaquant peut tester 100 codes par seconde. Combien de temps (au pire) pour tester tous les codes dans chaque cas ?

**Exercice 15.** Montrer que parmi n+1 entiers choisis dans {1, 2, ..., 2n}, il en existe toujours deux qui sont premiers entre eux. (Indication : considerer les n paires {1,2}, {3,4}, ..., {2n-1, 2n} et appliquer le principe des tiroirs.)

**Exercice 16.** On choisit 5 points a coordonnees entieres dans le plan Z x Z. Montrer que le milieu d'au moins un segment reliant deux de ces points est aussi a coordonnees entieres. (Indication : classer les points selon la parite de leurs coordonnees : il y a 4 classes (pair,pair), (pair,impair), (impair,pair), (impair,impair). 5 points, 4 classes.)

**Exercice 17.** Montrer par recurrence la formule d'inclusion-exclusion pour n ensembles :

|A_1 union ... union A_n| = Somme_i |A_i| - Somme_{i<j} |A_i inter A_j| + Somme_{i<j<k} |A_i inter A_j inter A_k| - ... + (-1)^(n+1) |A_1 inter ... inter A_n|

**Exercice 18.** Montrer que Somme(k=0 a n) (-1)^k C(n,k) = 0. En deduire que le nombre de parties de cardinal pair d'un ensemble a n >= 1 elements est egal au nombre de parties de cardinal impair (et vaut 2^(n-1)).

---

## References

- J. Velu, *Methodes mathematiques pour l'informatique*, Dunod.
- R. Music, J. Queyrut, *Algebre, Arithmetique et Applications*, cours MP2I/MPI.
- K. H. Rosen, *Discrete Mathematics and Its Applications*, McGraw-Hill.
- D. Velleman, *How to Prove It: A Structured Approach*, Cambridge University Press.
- X. Gourdon, *Les maths en tete -- Algebre*, Ellipses.
- D. Perrin, *Cours d'algebre*, Ellipses, chapitre 1.
- Christof Paar, Jan Pelzl, *Understanding Cryptography*, Springer (pour les liens avec la crypto).
