# Chapitre 2 -- Arithmetique dans Z

## Objectifs du chapitre

- Maitriser la division euclidienne et ses proprietes.
- Calculer le PGCD et le PPCM, notamment via l'algorithme d'Euclide.
- Comprendre et appliquer l'identite de Bezout, calculer les coefficients de Bezout.
- Connaitre les proprietes fondamentales des nombres premiers (crible, decomposition, lemme de Gauss).
- Manipuler les congruences et l'arithmetique modulaire dans Z/nZ.
- Comprendre les applications cryptographiques (RSA, inverse modulaire, exponentiation rapide).

---

## I. Divisibilite dans Z

### 1. Definition et premieres proprietes

**Definition 2.1.** Soient a, b dans Z. On dit que a *divise* b, note a | b, s'il existe k dans Z tel que b = ka. On dit aussi que b est un *multiple* de a, ou que a est un *diviseur* de b.

**Exemples.**
- 3 | 12 car 12 = 4 x 3.
- 7 | 0 car 0 = 0 x 7.
- 1 | n pour tout n dans Z.
- n | 0 pour tout n dans Z.

**Proposition 2.2 (Proprietes de la divisibilite).** Pour tous a, b, c dans Z :

1. a | a (reflexivite)
2. Si a | b et b | c, alors a | c (transitivite)
3. Si a | b et a | c, alors a | (b + c) et a | (b - c)
4. Si a | b et a | c, alors a | (alpha*b + beta*c) pour tous alpha, beta dans Z (combinaisons lineaires)
5. Si a | b et b | a, alors a = +/- b
6. Si a | b et b != 0, alors |a| <= |b|

*Preuve de (4).* Puisque a | b, il existe k dans Z avec b = ka. Puisque a | c, il existe l dans Z avec c = la. Alors alpha*b + beta*c = alpha*ka + beta*la = (alpha*k + beta*l)*a, donc a | (alpha*b + beta*c). QED.

*Preuve de (5).* Si a | b, il existe k avec b = ka. Si b | a, il existe l avec a = lb. Alors a = lb = lka, donc lk = 1. Comme l, k dans Z et lk = 1, on a (l, k) = (1, 1) ou (-1, -1), d'ou a = +/- b. QED.

**Remarque.** La propriete (4) est essentielle : l'ensemble des diviseurs communs a deux entiers est stable par combinaison lineaire. C'est le fondement de l'algorithme d'Euclide.

### 2. Division euclidienne

**Theoreme 2.3 (Division euclidienne).** Soient a dans Z et b dans Z*, avec b > 0. Il existe un unique couple (q, r) dans Z x N tel que :

a = bq + r avec 0 <= r < b

L'entier q est appele *quotient* et r le *reste* de la division euclidienne de a par b.

*Preuve (existence).*

Considerons l'ensemble S = {a - bk | k dans Z, a - bk >= 0}. Cet ensemble est non vide (car pour k suffisamment negatif, a - bk > 0) et contenu dans N. Par la propriete du bon ordre de N (tout sous-ensemble non vide de N admet un plus petit element), S admet un plus petit element r = a - bq pour un certain q dans Z. On a r >= 0 par construction. Supposons r >= b. Alors r - b = a - b(q + 1) >= 0 et r - b < r, ce qui contredit la minimalite de r dans S. Donc 0 <= r < b.

*Preuve (unicite).* Si a = bq_1 + r_1 = bq_2 + r_2 avec 0 <= r_1, r_2 < b, alors b(q_1 - q_2) = r_2 - r_1. Donc b | (r_2 - r_1). Or |r_2 - r_1| < b (puisque 0 <= r_1, r_2 < b), donc r_2 - r_1 = 0, soit r_1 = r_2 et q_1 = q_2. QED.

**Exemples de calcul a la main.**

- a = 37, b = 5 : 37 = 5 x 7 + 2, donc q = 7, r = 2.
- a = -23, b = 7 : -23 = 7 x (-4) + 5, donc q = -4, r = 5. (Verification : 7 x (-4) + 5 = -28 + 5 = -23.)
- a = 100, b = 13 : 100 = 13 x 7 + 9, donc q = 7, r = 9.
- a = 1000, b = 37 : 37 x 27 = 999, donc 1000 = 37 x 27 + 1, q = 27, r = 1.

**Remarque pour les cas negatifs.** L'erreur classique est d'ecrire -23 = 7 x (-3) + (-2), ce qui donnerait r = -2 < 0. Le reste doit etre *positif ou nul*. On ajuste : -23 = 7 x (-3) - 2 = 7 x (-4) + 5, et r = 5 verifie bien 0 <= 5 < 7.

---

## II. PGCD et PPCM

### 1. Definitions

**Definition 2.4.** Soient a, b dans Z, non tous deux nuls.

Le *plus grand commun diviseur* de a et b, note pgcd(a, b), est le plus grand entier positif qui divise a la fois a et b.

Le *plus petit commun multiple* de a et b, note ppcm(a, b), est le plus petit entier strictement positif qui est a la fois multiple de a et multiple de b.

**Proprietes elementaires :**
- pgcd(a, b) = pgcd(b, a) = pgcd(|a|, |b|)
- pgcd(a, 0) = |a| pour a != 0
- pgcd(a, 1) = 1
- pgcd(a, a) = |a|

**Definition 2.5.** Deux entiers a et b sont dits *premiers entre eux* (ou *copremiers*) si pgcd(a, b) = 1.

**Exemples.** pgcd(12, 18) = 6. pgcd(15, 28) = 1 (premiers entre eux). pgcd(0, 7) = 7.

### 2. Algorithme d'Euclide

**Theoreme 2.6.** Pour tous a, b dans Z avec b != 0, si a = bq + r est la division euclidienne, alors :

pgcd(a, b) = pgcd(b, r)

*Preuve.* Notons d = pgcd(a, b) et d' = pgcd(b, r). Puisque d | a et d | b, on a d | (a - bq) = r. Donc d divise b et r, d'ou d | d' (car d' est le *plus grand* diviseur commun de b et r, et d en est un). Inversement, d' | b et d' | r, donc d' | (bq + r) = a, d'ou d' | d (car d est le plus grand diviseur commun de a et b, et d' en est un). Ainsi d = d'. QED.

L'algorithme d'Euclide consiste a appliquer ce theoreme de maniere iterative jusqu'a obtenir un reste nul :

```
pgcd(a, b) : tant que b != 0, faire (a, b) <- (b, a mod b). Renvoyer a.
```

**Exemple de calcul a la main : pgcd(252, 198).**

```
252 = 198 x 1 + 54
198 = 54  x 3 + 36
54  = 36  x 1 + 18
36  = 18  x 2 + 0
```

Donc pgcd(252, 198) = 18.

**Exemple : pgcd(1071, 462).**

```
1071 = 462 x 2 + 147
462  = 147 x 3 + 21
147  = 21  x 7 + 0
```

Donc pgcd(1071, 462) = 21.

**Exemple : pgcd(3927, 759).**

```
3927 = 759 x 5 + 132
759  = 132 x 5 + 99
132  = 99  x 1 + 33
99   = 33  x 3 + 0
```

Donc pgcd(3927, 759) = 33.

**Complexite.** L'algorithme d'Euclide termine en au plus 2 log_2(min(a, b)) + 1 etapes. Le pire cas est atteint pour des nombres de Fibonacci consecutifs. C'est un algorithme tres efficace, meme pour de tres grands nombres.

### 3. Relation entre PGCD et PPCM

**Theoreme 2.7.** Pour tous a, b dans N* :

pgcd(a, b) x ppcm(a, b) = a x b

Cette formule permet de calculer le PPCM a partir du PGCD.

**Exemple.** pgcd(12, 18) = 6, donc ppcm(12, 18) = 12 x 18 / 6 = 36.

**Exemple.** pgcd(3927, 759) = 33, donc ppcm(3927, 759) = 3927 x 759 / 33 = 119 x 759 = 90321.

**Exercice de comprehension 1.** Calculer pgcd(4851, 1122) par l'algorithme d'Euclide. En deduire ppcm(4851, 1122).

---

## III. Identite de Bezout et coefficients de Bezout

### 1. Theoreme de Bezout

**Theoreme 2.8 (Identite de Bezout).** Soient a, b dans Z, non tous deux nuls. Il existe u, v dans Z tels que :

au + bv = pgcd(a, b)

Les entiers u et v sont appeles *coefficients de Bezout*.

*Preuve.* On considere l'ensemble I = {ax + by | x, y dans Z, ax + by > 0}. Cet ensemble est non vide (il contient |a| ou |b|). Soit d son plus petit element : d = au_0 + bv_0 > 0. Montrons que d = pgcd(a, b).

D'abord, tout diviseur commun de a et b divise d (par combinaison lineaire), donc pgcd(a, b) | d.

Ensuite, montrons que d | a. Par division euclidienne, a = dq + r avec 0 <= r < d. Alors r = a - dq = a - (au_0 + bv_0)q = a(1 - u_0*q) + b(-v_0*q). Donc r est de la forme ax + by. Si r > 0, alors r dans I et r < d, ce qui contredit la minimalite de d. Donc r = 0 et d | a. De meme d | b. Donc d est un diviseur commun de a et b, et d | pgcd(a, b) entraine d <= pgcd(a, b). Avec pgcd(a, b) | d, on conclut d = pgcd(a, b). QED.

**Corollaire 2.9.** Deux entiers a et b sont premiers entre eux si et seulement s'il existe u, v dans Z tels que au + bv = 1.

*Preuve du corollaire.*

(=>) Si pgcd(a, b) = 1, l'identite de Bezout donne directement au + bv = 1.

(<=) Si au + bv = 1, alors tout diviseur commun d de a et b divise au + bv = 1, donc d = +/- 1, d'ou pgcd(a, b) = 1. QED.

### 2. Algorithme d'Euclide etendu

Pour trouver les coefficients de Bezout, on remonte les etapes de l'algorithme d'Euclide.

**Exemple : Coefficients de Bezout pour pgcd(252, 198) = 18.**

On reprend les divisions euclidiennes :

```
252 = 198 x 1 + 54    =>  54 = 252 - 198 x 1        ... (1)
198 = 54  x 3 + 36    =>  36 = 198 - 54 x 3          ... (2)
54  = 36  x 1 + 18    =>  18 = 54 - 36 x 1           ... (3)
```

On remonte :

18 = 54 - 36 x 1 (par (3))

Remplacons 36 par l'expression (2) : 18 = 54 - (198 - 54 x 3) x 1 = 54 x 4 - 198 x 1

Remplacons 54 par l'expression (1) : 18 = (252 - 198 x 1) x 4 - 198 x 1 = 252 x 4 - 198 x 5

**Verification :** 252 x 4 - 198 x 5 = 1008 - 990 = 18. Correct.

Donc u = 4, v = -5 : 252 x 4 + 198 x (-5) = 18.

**Remarque.** Les coefficients de Bezout ne sont pas uniques. Si (u_0, v_0) est une solution de au + bv = d, alors pour tout k dans Z, (u_0 + k*b/d, v_0 - k*a/d) est aussi une solution.

**Exemple : Coefficients de Bezout pour pgcd(1071, 462) = 21.**

```
1071 = 462 x 2 + 147    =>  147 = 1071 - 462 x 2     ... (1)
462  = 147 x 3 + 21     =>  21  = 462 - 147 x 3      ... (2)
```

Remontee :

21 = 462 - 147 x 3 (par (2))
   = 462 - (1071 - 462 x 2) x 3
   = 462 - 1071 x 3 + 462 x 6
   = 462 x 7 - 1071 x 3
   = 1071 x (-3) + 462 x 7

**Verification :** 1071 x (-3) + 462 x 7 = -3213 + 3234 = 21. Correct.

### 3. Lemme de Gauss

**Theoreme 2.10 (Lemme de Gauss).** Si a | bc et pgcd(a, b) = 1, alors a | c.

*Preuve.* Comme pgcd(a, b) = 1, par Bezout il existe u, v dans Z tels que au + bv = 1. Multiplions par c : acu + bcv = c. Or a | ac (trivial) et a | bc (hypothese), donc a | (acu + bcv) = c. QED.

**Corollaire 2.11 (Lemme d'Euclide).** Si p est premier et p | ab, alors p | a ou p | b.

*Preuve.* Si p ne divise pas a, comme p est premier, pgcd(p, a) = 1 (les seuls diviseurs de p sont 1 et p, et p ne divise pas a). Par le lemme de Gauss, p | b. QED.

Le lemme de Gauss est un outil fondamental. Il intervient dans la preuve de l'unicite de la decomposition en facteurs premiers.

**Exercice de comprehension 2.** Trouver les coefficients de Bezout pour pgcd(161, 28). Verifier le resultat.

---

## IV. Nombres premiers

### 1. Definition et proprietes fondamentales

**Definition 2.12.** Un entier p >= 2 est dit *premier* s'il n'admet aucun diviseur positif autre que 1 et p lui-meme. Un entier n >= 2 qui n'est pas premier est dit *compose*.

**Premiers nombres premiers :** 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, ...

**Remarque.** 2 est le seul nombre premier pair. Tout nombre premier p >= 3 est impair. 1 n'est pas premier (par convention, et pour preserver l'unicite de la decomposition en facteurs premiers).

**Proposition 2.13.** Si n >= 2 est compose, alors n admet un diviseur premier p tel que p <= sqrt(n).

*Preuve.* Si n est compose, n = ab avec 2 <= a <= b. Alors a^2 <= ab = n, donc a <= sqrt(n). L'entier a, etant >= 2, admet un diviseur premier p <= a <= sqrt(n). QED.

**Application pratique.** Pour tester si un nombre n est premier, il suffit de verifier qu'il n'est divisible par aucun premier p <= sqrt(n). Pour n = 101, on teste les premiers <= 10 (soit 2, 3, 5, 7). Aucun ne divise 101, donc 101 est premier.

### 2. Crible d'Eratosthene

Pour trouver tous les nombres premiers inferieurs ou egaux a N :
1. Ecrire tous les entiers de 2 a N.
2. Le plus petit nombre non raye (2) est premier. Rayer tous ses multiples stricts.
3. Le prochain nombre non raye (3) est premier. Rayer tous ses multiples stricts.
4. Continuer jusqu'a depasser sqrt(N).
5. Les nombres restants non rayes sont premiers.

**Exemple : Nombres premiers <= 30.**

Depart : 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30.

On raye les multiples de 2 (sauf 2) : restent 2, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29.

On raye les multiples de 3 (sauf 3) : on retire 9, 15, 21, 27. Restent 2, 3, 5, 7, 11, 13, 17, 19, 23, 25, 29.

On raye les multiples de 5 (sauf 5) : on retire 25. Restent 2, 3, 5, 7, 11, 13, 17, 19, 23, 29.

sqrt(30) ~ 5.5, on s'arrete. Les nombres premiers <= 30 sont : **2, 3, 5, 7, 11, 13, 17, 19, 23, 29**.

**Complexite.** Le crible d'Eratosthene a une complexite de O(N log log N), ce qui le rend tres efficace pour generer la liste de tous les premiers jusqu'a une borne donnee.

### 3. Theoreme fondamental de l'arithmetique

**Theoreme 2.14 (Existence et unicite de la decomposition en facteurs premiers).** Tout entier n >= 2 s'ecrit de maniere unique (a l'ordre des facteurs pres) sous la forme :

n = p_1^{a_1} x p_2^{a_2} x ... x p_k^{a_k}

ou p_1 < p_2 < ... < p_k sont des nombres premiers et a_1, ..., a_k >= 1.

*Preuve (existence, par recurrence forte).*

Si n = 2, c'est premier et la decomposition est triviale. Supposons le resultat vrai pour tout entier m avec 2 <= m < n. Si n est premier, la decomposition est n lui-meme. Si n est compose, n = ab avec 2 <= a, b < n. Par hypothese de recurrence, a et b se decomposent en produits de premiers, et le produit de ces decompositions donne celle de n.

*Preuve (unicite).* Supposons n = p_1 ... p_r = q_1 ... q_s deux decompositions en facteurs premiers (ecrits avec repetition). Comme p_1 | q_1 ... q_s, par le lemme d'Euclide applique de maniere iteree, p_1 divise l'un des q_j. Comme q_j est premier et p_1 >= 2, on a p_1 = q_j. On simplifie par p_1 et on continue par recurrence forte sur n. QED.

**Exemples de decomposition.**

- 360 = 2^3 x 3^2 x 5
- 1001 = 7 x 11 x 13
- 2024 = 2^3 x 11 x 23
- 2310 = 2 x 3 x 5 x 7 x 11

**Application au PGCD et PPCM.** Si a = produit(p_i^{a_i}) et b = produit(p_i^{b_i}) (en etendant les decompositions avec des exposants nuls si necessaire), alors :

pgcd(a, b) = produit(p_i^{min(a_i, b_i)}) et ppcm(a, b) = produit(p_i^{max(a_i, b_i)})

**Exemple.** a = 360 = 2^3 x 3^2 x 5, b = 2310 = 2 x 3 x 5 x 7 x 11. Alors pgcd(360, 2310) = 2^1 x 3^1 x 5^1 = 30.

**Nombre de diviseurs.** Si n = p_1^{a_1} x ... x p_k^{a_k}, le nombre de diviseurs positifs de n est (a_1 + 1)(a_2 + 1)...(a_k + 1). Par exemple, 360 = 2^3 x 3^2 x 5 a (3+1)(2+1)(1+1) = 24 diviseurs.

### 4. Infinite des nombres premiers

**Theoreme 2.15 (Euclide).** Il existe une infinite de nombres premiers.

*Preuve.* Supposons par l'absurde qu'il n'existe qu'un nombre fini de premiers : p_1, p_2, ..., p_n. Considerons N = p_1 x p_2 x ... x p_n + 1. Pour tout i, la division de N par p_i donne un reste de 1, donc p_i ne divise pas N. Or N >= 2 admet au moins un diviseur premier (par le theoreme fondamental), qui n'est aucun des p_i. Contradiction avec l'hypothese que p_1, ..., p_n sont *tous* les premiers. QED.

**Theoreme 2.16 (Distribution asymptotique -- admis).** Si pi(x) designe le nombre de premiers <= x, alors pi(x) ~ x / ln(x) quand x tend vers l'infini. C'est le *theoreme des nombres premiers*. En pratique, la proportion de nombres premiers parmi les entiers jusqu'a x decroit comme 1/ln(x).

**Exercice de comprehension 3.** Decomposer 2310 en produit de facteurs premiers. En deduire le nombre de diviseurs positifs de 2310.

---

## V. Congruences dans Z

### 1. Definition et premieres proprietes

**Definition 2.17.** Soient a, b dans Z et n dans N, n >= 2. On dit que a est *congru a b modulo n*, note a = b [n] ou a = b (mod n), si n | (a - b), c'est-a-dire si a et b ont le meme reste dans la division euclidienne par n.

**Exemples.**
- 17 = 2 (mod 5) car 5 | (17 - 2) = 15.
- -3 = 4 (mod 7) car 7 | (-3 - 4) = -7.
- 100 = 0 (mod 10) car 10 | 100.
- 2^10 = 1024 = 4 (mod 10) (le dernier chiffre de 1024 est 4).

**Proposition 2.18.** La relation de congruence modulo n est une *relation d'equivalence* sur Z :
- Reflexive : a = a (mod n) car n | 0.
- Symetrique : si a = b (mod n), alors b = a (mod n).
- Transitive : si a = b (mod n) et b = c (mod n), alors a = c (mod n).

Les classes d'equivalence sont les ensembles {r, r+n, r+2n, ...} = {r + kn | k dans Z} pour r dans {0, 1, ..., n-1}.

**Proposition 2.19 (Compatibilite avec les operations).** Si a = a' (mod n) et b = b' (mod n), alors :

1. a + b = a' + b' (mod n)
2. a - b = a' - b' (mod n)
3. a x b = a' x b' (mod n)
4. a^k = a'^k (mod n) pour tout k dans N

*Preuve de (3).* On a a = a' + n*alpha et b = b' + n*beta pour certains alpha, beta dans Z. Alors ab = (a' + n*alpha)(b' + n*beta) = a'b' + n(a'*beta + b'*alpha + n*alpha*beta), donc ab = a'b' (mod n). QED.

**Attention.** La division (simplification) n'est pas toujours valide dans les congruences. Par exemple, 6 = 0 (mod 6) et 2 x 3 = 0 (mod 6), mais on ne peut pas "simplifier par 2" pour obtenir 3 = 0 (mod 6), qui est faux.

**Proposition 2.20 (Simplification).** Si ac = bc (mod n) et pgcd(c, n) = 1, alors a = b (mod n).

*Preuve.* ac = bc (mod n) signifie n | c(a - b). Comme pgcd(c, n) = 1, par le lemme de Gauss, n | (a - b), soit a = b (mod n). QED.

### 2. L'anneau Z/nZ

**Definition 2.21.** L'ensemble Z/nZ = {0_barre, 1_barre, 2_barre, ..., (n-1)_barre} est l'ensemble des classes de congruence modulo n. On le munit des operations :

- Addition : a_barre + b_barre = (a + b) mod n
- Multiplication : a_barre x b_barre = (a x b) mod n

Ces operations sont *bien definies* grace a la compatibilite de la congruence (Proposition 2.19).

**Exemple : table de multiplication de Z/4Z.**

| x   | 0 | 1 | 2 | 3 |
| --- | - | - | - | - |
| 0   | 0 | 0 | 0 | 0 |
| 1   | 0 | 1 | 2 | 3 |
| 2   | 0 | 2 | 0 | 2 |
| 3   | 0 | 3 | 2 | 1 |

On remarque que 2 x 2 = 0 dans Z/4Z : le produit de deux elements non nuls peut etre nul. On dit que 2_barre est un *diviseur de zero*. C'est impossible dans un corps (cf. chapitre 3).

### 3. Inverse modulaire

**Definition 2.22.** Soit a_barre dans Z/nZ. On dit que a_barre est *inversible* s'il existe b_barre dans Z/nZ tel que a_barre x b_barre = 1_barre. L'element b_barre est appele l'*inverse* de a_barre, note a_barre^{-1}.

**Theoreme 2.23.** L'element a_barre dans Z/nZ est inversible si et seulement si pgcd(a, n) = 1.

*Preuve.*

(=>) Si a_barre est inversible, il existe b tel que ab = 1 (mod n), soit ab = 1 + kn pour un certain k dans Z, d'ou ab - kn = 1. Tout diviseur commun de a et n divise 1, donc pgcd(a, n) = 1.

(<=) Si pgcd(a, n) = 1, par Bezout il existe u, v dans Z tels que au + nv = 1. Alors au = 1 (mod n), donc u_barre = a_barre^{-1}. QED.

**Methode pratique : calcul de l'inverse modulaire.**

Pour trouver l'inverse de a modulo n (quand pgcd(a, n) = 1) :
1. Appliquer l'algorithme d'Euclide etendu pour trouver u tel que au + nv = 1.
2. L'inverse de a modulo n est u mod n.

**Exemple : inverse de 7 modulo 11.**

Algorithme d'Euclide :
```
11 = 7 x 1 + 4
7  = 4 x 1 + 3
4  = 3 x 1 + 1
3  = 1 x 3 + 0
```

Remontee :
```
1 = 4 - 3 x 1
  = 4 - (7 - 4 x 1) = 4 x 2 - 7
  = (11 - 7) x 2 - 7 = 11 x 2 - 7 x 3
```

Donc 7 x (-3) + 11 x 2 = 1, soit 7 x (-3) = 1 (mod 11). L'inverse de 7 modulo 11 est -3 = 8 (mod 11).

**Verification :** 7 x 8 = 56 = 5 x 11 + 1. Bien 56 = 1 (mod 11). Correct.

**Exemple : inverse de 13 modulo 47.**

```
47 = 13 x 3 + 8
13 = 8  x 1 + 5
8  = 5  x 1 + 3
5  = 3  x 1 + 2
3  = 2  x 1 + 1
2  = 1  x 2 + 0
```

Remontee :
```
1 = 3 - 2 x 1
  = 3 - (5 - 3) = 3 x 2 - 5
  = (8 - 5) x 2 - 5 = 8 x 2 - 5 x 3
  = 8 x 2 - (13 - 8) x 3 = 8 x 5 - 13 x 3
  = (47 - 13 x 3) x 5 - 13 x 3 = 47 x 5 - 13 x 18
```

Donc 13 x (-18) + 47 x 5 = 1, soit 13 x (-18) = 1 (mod 47). L'inverse de 13 modulo 47 est -18 = 29 (mod 47).

**Verification :** 13 x 29 = 377 = 8 x 47 + 1. Correct.

**Exercice de comprehension 4.** Calculer l'inverse de 23 modulo 97 par l'algorithme d'Euclide etendu. Verifier le resultat.

---

## VI. Exponentiation modulaire

### 1. Methode naive vs exponentiation rapide

Pour calculer a^k mod n avec de grands nombres, la methode naive (calculer a^k puis reduire) est impraticable car a^k peut etre astronomiquement grand.

**Methode de l'exponentiation rapide (square-and-multiply).** On decompose l'exposant k en binaire et on procede par carres successifs.

**Algorithme :**
```
Resultat = 1
Tant que k > 0 :
    Si k est impair : Resultat = (Resultat x a) mod n
    a = (a x a) mod n
    k = k / 2 (division entiere)
Renvoyer Resultat
```

**Principe.** On ecrit k en binaire : k = b_t b_{t-1} ... b_1 b_0. Alors a^k = a^{b_t x 2^t + ... + b_1 x 2 + b_0} = (a^{2^t})^{b_t} x ... x (a^2)^{b_1} x a^{b_0}. On calcule les puissances de a par carres successifs, et on multiplie le resultat quand le bit correspondant est 1.

**Exemple : calculer 3^13 mod 17.**

Ecriture binaire de 13 : 1101 (base 2).

```
Etape 1 : k = 13 (impair) -> Resultat = 1 x 3 = 3      ; a = 3^2 = 9    ; k = 6
Etape 2 : k = 6 (pair)    -> Resultat = 3                ; a = 9^2 = 81 = 81 - 4x17 = 13   ; k = 3
Etape 3 : k = 3 (impair)  -> Resultat = 3 x 13 = 39 = 5 ; a = 13^2 = 169 = 169 - 9x17 = 16 ; k = 1
Etape 4 : k = 1 (impair)  -> Resultat = 5 x 16 = 80 = 80 - 4x17 = 12 ; k = 0
```

Donc 3^13 = 12 (mod 17).

**Verification alternative :** 3^1 = 3, 3^2 = 9, 3^4 = 81 = 13, 3^8 = 13^2 = 169 = 16 = -1.
3^13 = 3^8 x 3^4 x 3^1 = (-1) x 13 x 3 = -39 = -39 + 3x17 = -39 + 51 = 12. Correct.

**Complexite.** L'exponentiation rapide effectue O(log k) multiplications modulaires, au lieu de k multiplications pour la methode naive. C'est *fondamental* en cryptographie, ou k peut avoir des centaines de chiffres.

---

## VII. Applications cryptographiques

### 1. Le systeme RSA

Le chiffrement RSA (Rivest-Shamir-Adleman, 1977) repose directement sur l'arithmetique modulaire etudiee dans ce chapitre.

**Generation des cles :**
1. Choisir deux grands nombres premiers distincts p et q.
2. Calculer n = pq.
3. Calculer phi(n) = (p - 1)(q - 1) (indicatrice d'Euler, voir chapitre 3).
4. Choisir e tel que 1 < e < phi(n) et pgcd(e, phi(n)) = 1.
5. Calculer d = e^{-1} mod phi(n) (inverse modulaire de e, par Bezout).
6. Cle publique : (n, e). Cle privee : (n, d).

**Chiffrement :** Pour un message m (entier avec 0 <= m < n), le chiffre est c = m^e mod n.

**Dechiffrement :** Le message original est m = c^d mod n.

La correction repose sur le theoreme d'Euler (chapitre 3) : m^{ed} = m (mod n), car ed = 1 (mod phi(n)).

### 2. Exemple complet RSA (petits nombres)

Choisissons p = 11 et q = 13. Alors n = 143 et phi(n) = 10 x 12 = 120.

Choisissons e = 7 (on verifie pgcd(7, 120) : 120 = 7 x 17 + 1, donc pgcd = 1, OK).

Calculons d = 7^{-1} mod 120 par Euclide etendu :

```
120 = 7 x 17 + 1
```

Donc 1 = 120 - 7 x 17, soit 7 x (-17) = 1 (mod 120), d'ou d = -17 = 103 (mod 120).

**Verification :** 7 x 103 = 721 = 6 x 120 + 1. Bien 721 = 1 (mod 120). Correct.

Cle publique : (143, 7). Cle privee : (143, 103).

**Chiffrement du message m = 9 :**

c = 9^7 mod 143.

9^2 = 81. 9^4 = 81^2 = 6561 = 45 x 143 + 126, donc 9^4 = 126 (mod 143).

9^7 = 9^4 x 9^2 x 9^1 = 126 x 81 x 9 mod 143.

126 x 81 = 10206 = 71 x 143 + 53, donc = 53. Puis 53 x 9 = 477 = 3 x 143 + 48, donc c = 48.

**Dechiffrement :**

m = 48^{103} mod 143. (Ce calcul se fait par exponentiation rapide en pratique.)

On peut verifier que 48^{103} = 9 (mod 143) -- c'est garanti par le theoreme d'Euler.

### 3. Securite de RSA

La securite de RSA repose sur la difficulte de *factoriser* n = pq en connaissant seulement n. Si un attaquant peut factoriser n, il retrouve p et q, calcule phi(n), puis d par Bezout. En pratique :

- Les cles RSA utilisent n de 2048 ou 4096 bits (environ 617 ou 1234 chiffres decimaux).
- La factorisation de tels nombres est calculatoirement infaisable avec les algorithmes classiques actuels (GNFS : General Number Field Sieve, sous-exponentiel).
- Les algorithmes quantiques (Shor, 1994) pourraient factoriser en temps polynomial, d'ou le developpement de la cryptographie post-quantique (basee sur les reseaux, les codes, les isogenies, etc.).
- La taille des cles est choisie pour resister aux progres previsibles en puissance de calcul et en algorithmique. Les recommandations actuelles (NIST, ANSSI) sont de 2048 bits minimum, 4096 bits recommande.

### 4. Exemple avec p = 5 et q = 7 (exercice guide)

n = 35, phi(n) = 4 x 6 = 24. Choisissons e = 5.

pgcd(5, 24) : 24 = 5 x 4 + 4, 5 = 4 x 1 + 1. Donc pgcd = 1, OK.

Bezout : 1 = 5 - 4 = 5 - (24 - 5 x 4) = 5 x 5 - 24. Donc d = 5 (car 5 x 5 = 25 = 1 (mod 24)).

Cle publique : (35, 5). Cle privee : (35, 5). (Cas degenere ou e = d, car e^2 = 1 mod phi(n).)

Chiffrement de m = 3 : c = 3^5 mod 35 = 243 mod 35 = 243 - 6 x 35 = 243 - 210 = 33.

Dechiffrement : m = 33^5 mod 35. 33 = -2 (mod 35), donc 33^5 = (-2)^5 = -32 = 3 (mod 35). On retrouve bien m = 3.

**Exercice de comprehension 5.** Avec p = 17 et q = 23, e = 3 :
1. Calculer n et phi(n).
2. Verifier que pgcd(e, phi(n)) = 1 et calculer d = e^{-1} mod phi(n).
3. Chiffrer le message m = 10.
4. (Optionnel) Dechiffrer le resultat par exponentiation rapide.

---

## VIII. Exercices de synthese

**Exercice 6.** Montrer que pour tout n dans N, n(n+1)(n+2) est divisible par 6. (Indication : parmi trois entiers consecutifs, l'un est divisible par 2 et l'un est divisible par 3.)

**Exercice 7.** Resoudre le systeme de congruences :
```
x = 2 (mod 3)
x = 3 (mod 5)
x = 1 (mod 7)
```
(Indication : proceder par substitution ou utiliser le theoreme chinois des restes, voir chapitre 3.)

**Exercice 8.** Montrer que si p est premier et p >= 5, alors p^2 = 1 (mod 24). (Indication : p est impair et non multiple de 3, donc p = 6k +/- 1.)

**Exercice 9.** Calculer le dernier chiffre de 7^{2024} (c'est-a-dire 7^{2024} mod 10).

*Indication.* Observer le cycle de 7^k mod 10 : 7^1 = 7, 7^2 = 9, 7^3 = 3, 7^4 = 1, 7^5 = 7, ... Le cycle est de longueur 4. Calculer 2024 mod 4 = 0, donc 7^{2024} = (7^4)^{506} = 1^{506} = 1.

**Exercice 10 (Algorithme d'Euclide etendu -- pseudo-code).** Ecrire en pseudo-code l'algorithme d'Euclide etendu qui, etant donnes a et b, retourne (d, u, v) avec d = pgcd(a, b) = au + bv. Tester sur pgcd(161, 28).

```
Fonction Euclide_Etendu(a, b) :
    Si b = 0 :
        Renvoyer (a, 1, 0)
    Sinon :
        (d, u', v') = Euclide_Etendu(b, a mod b)
        Renvoyer (d, v', u' - (a div b) x v')
```

**Verification sur pgcd(161, 28) :**
```
161 = 28 x 5 + 21
28  = 21 x 1 + 7
21  = 7  x 3 + 0
```
pgcd = 7. Remontee : 7 = 28 - 21 = 28 - (161 - 28 x 5) = 28 x 6 - 161. Donc 161 x (-1) + 28 x 6 = 7. Verification : -161 + 168 = 7. Correct.

**Exercice 11.** Montrer que si pgcd(a, b) = 1 et pgcd(a, c) = 1, alors pgcd(a, bc) = 1. (Indication : Bezout.)

**Exercice 12 (Crypto).** Un serveur RSA utilise n = 3233, e = 17. On intercepte le chiffre c = 2790. Sachant que 3233 = 53 x 61, retrouver le message clair m.
1. Calculer phi(3233).
2. Calculer d = 17^{-1} mod phi(3233) par Euclide etendu.
3. Calculer m = 2790^d mod 3233 par exponentiation rapide.

---

## References

- J.-P. Serre, *Cours d'arithmetique*, PUF (classique, niveau avance).
- D. Perrin, *Cours d'algebre*, Ellipses (chapitres d'arithmetique).
- J. Velu, *Methodes mathematiques pour l'informatique*, Dunod.
- X. Gourdon, *Les maths en tete -- Algebre*, Ellipses.
- Christof Paar, Jan Pelzl, *Understanding Cryptography*, Springer (chapitre RSA).
- A. Menezes, P. van Oorschot, S. Vanstone, *Handbook of Applied Cryptography*, CRC Press (disponible en ligne).
- NIST, recommandations sur les tailles de cles RSA : https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final
