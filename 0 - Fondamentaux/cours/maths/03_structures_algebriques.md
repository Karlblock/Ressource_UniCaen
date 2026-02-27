# Chapitre 3 -- Structures algebriques et applications cryptographiques

## Objectifs du chapitre

- Definir et reconnaitre les structures de groupe, anneau et corps.
- Etudier les sous-groupes, les morphismes, l'ordre d'un element, les groupes cycliques.
- Comprendre la structure de Z/nZ comme anneau, identifier ses elements inversibles.
- Maitriser l'indicatrice d'Euler et ses proprietes.
- Demontrer et appliquer le theoreme d'Euler et le petit theoreme de Fermat.
- Enoncer et utiliser le theoreme chinois des restes.
- Relier ces concepts aux fondements de RSA et Diffie-Hellman.

---

## I. Groupes

### 1. Definition et exemples

**Definition 3.1.** Un *groupe* est un couple (G, *) ou G est un ensemble non vide et * est une loi de composition interne sur G (c'est-a-dire * : G x G -> G) verifiant :

1. **Associativite :** pour tout a, b, c dans G, (a * b) * c = a * (b * c).
2. **Element neutre :** il existe e dans G, pour tout a dans G, a * e = e * a = a.
3. **Symetrique (inverse) :** pour tout a dans G, il existe a' dans G, a * a' = a' * a = e.

Si de plus la loi * est *commutative* (pour tout a, b dans G, a * b = b * a), le groupe est dit *abelien* (ou *commutatif*).

**Proposition 3.2.** L'element neutre est unique. L'inverse de chaque element est unique (on le note a^{-1} en notation multiplicative, ou -a en notation additive).

*Preuve (unicite du neutre).* Si e et e' sont deux neutres, alors e = e * e' (car e' est neutre) = e' (car e est neutre). Donc e = e'. QED.

*Preuve (unicite de l'inverse).* Supposons que a' et a'' soient deux inverses de a. Alors a' = a' * e = a' * (a * a'') = (a' * a) * a'' = e * a'' = a''. QED.

**Exemples fondamentaux.**

| Ensemble | Loi | Neutre | Inverse | Abelien ? |
| --- | --- | --- | --- | --- |
| (Z, +) | addition | 0 | -a | Oui |
| (Q*, x) | multiplication | 1 | 1/a | Oui |
| (R*, x) | multiplication | 1 | 1/a | Oui |
| (Z/nZ, +) | addition mod n | 0_barre | (n-a) mod n | Oui |
| (S_n, o) | composition | id | sigma^{-1} | Non (n >= 3) |

**Contre-exemples.**
- (N, +) n'est pas un groupe : pas d'inverse pour n >= 1.
- (Z, x) n'est pas un groupe : seuls 1 et -1 ont un inverse multiplicatif dans Z.
- (M_n(R), x) n'est pas un groupe : les matrices non inversibles n'ont pas d'inverse.

### 2. Sous-groupes

**Definition 3.3.** Soit (G, *) un groupe. Une partie H de G est un *sous-groupe* de G si (H, *) est lui-meme un groupe, c'est-a-dire :
1. e dans H (H contient le neutre).
2. Pour tout a, b dans H, a * b dans H (stabilite par la loi).
3. Pour tout a dans H, a^{-1} dans H (stabilite par passage a l'inverse).

**Proposition 3.4 (Caracterisation).** H sous-ensemble de G est un sous-groupe de G si et seulement si :
- H != ensemble vide,
- Pour tout a, b dans H, a * b^{-1} dans H.

*Preuve.* (=>) Clair par les axiomes de sous-groupe. (<=) Si H != vide, soit a dans H. Alors e = a * a^{-1} dans H (en prenant b = a). Pour tout a dans H, a^{-1} = e * a^{-1} dans H (en prenant le premier element = e, et b = a). Enfin, pour a, b dans H, on a b^{-1} dans H, puis a * b = a * (b^{-1})^{-1} dans H. QED.

**Exemples.**
- nZ = {nk | k dans Z} est un sous-groupe de (Z, +) pour tout n dans Z.
- {0_barre, 2_barre, 4_barre} est un sous-groupe de (Z/6Z, +).
- Les sous-groupes de (Z, +) sont exactement les nZ avec n dans N. (Ceci decoule du fait que Z est principal : tout ideal de Z est de la forme nZ.)

### 3. Ordre d'un element et groupes cycliques

**Definition 3.5.** Soit G un groupe et a dans G. L'*ordre* de a, note ord(a), est le plus petit entier k >= 1 tel que a^k = e (en notation multiplicative) ou ka = 0 (en notation additive). Si un tel k n'existe pas, on dit que a est d'ordre infini.

**Exemples.**
- Dans Z/6Z : ord(1_barre) = 6, ord(2_barre) = 3, ord(3_barre) = 2, ord(0_barre) = 1.
- Dans (Z, +) : tout element non nul est d'ordre infini.
- Dans S_3 : la transposition (1 2) est d'ordre 2, le 3-cycle (1 2 3) est d'ordre 3.

**Proposition 3.6.** Si a est d'ordre fini d, alors a^n = e si et seulement si d | n.

*Preuve.* (<=) Si n = dq, alors a^n = (a^d)^q = e^q = e. (=>) Par division euclidienne, n = dq + r avec 0 <= r < d. Alors a^r = a^{n - dq} = a^n * (a^d)^{-q} = e * e = e. Comme r < d et d est le plus petit entier positif verifiant a^d = e, on a r = 0, donc d | n. QED.

**Definition 3.7.** Un groupe G est dit *cyclique* s'il existe un element g dans G (appele *generateur*) tel que G = {g^k | k dans Z} (notation multiplicative) ou G = {kg | k dans Z} (notation additive). On note G = <g>.

**Exemples.**
- (Z/nZ, +) est cyclique, engendre par 1_barre (ou par tout a_barre avec pgcd(a, n) = 1).
- (Z, +) est cyclique, engendre par 1 (ou par -1).

**Theoreme 3.8 (Structure des groupes cycliques).**
1. Tout groupe cyclique fini d'ordre n est isomorphe a Z/nZ.
2. Tout groupe cyclique infini est isomorphe a Z.
3. Tout sous-groupe d'un groupe cyclique est cyclique.

*Preuve de (3).* Soit G = <g> un groupe cyclique et H un sous-groupe de G. Si H = {e}, c'est cyclique (engendre par e). Sinon, soit d le plus petit entier positif tel que g^d dans H (un tel d existe car H contient un g^k avec k != 0, et alors aussi g^{-k} = g^{|k|}). Montrons que H = <g^d>.

Clairement <g^d> est inclus dans H. Reciproquement, soit g^n dans H. Par division euclidienne, n = dq + r avec 0 <= r < d. Alors g^r = g^{n-dq} = g^n * (g^d)^{-q} dans H (car g^n et g^d sont dans H). Comme r < d et d est minimal, r = 0. Donc g^n = (g^d)^q dans <g^d>. QED.

### 4. Theoreme de Lagrange

**Theoreme 3.9 (Lagrange).** Si G est un groupe fini et H est un sous-groupe de G, alors |H| divise |G|.

*Preuve.* On definit la relation d'equivalence a ~ b si et seulement si a^{-1}b dans H. Les classes d'equivalence (appelees *classes a gauche* de H dans G) sont les ensembles aH = {ah | h dans H} pour a dans G.

**Etape 1 : chaque classe a exactement |H| elements.** L'application h -> ah est une bijection de H sur aH (injective car ah = ah' implique h = h' par simplification ; surjective par construction). Donc |aH| = |H|.

**Etape 2 : les classes forment une partition de G.** C'est une propriete generale des classes d'equivalence.

**Conclusion.** G est l'union disjointe de ses classes a gauche, chacune de cardinal |H|. Le nombre de classes, note [G : H] (l'*indice* de H dans G), verifie |G| = [G : H] x |H|. Donc |H| divise |G|. QED.

**Corollaires importants.**
1. L'ordre de tout element de G divise |G|.
2. Pour tout a dans G, a^{|G|} = e.
3. Si |G| est premier p, alors G est cyclique (et tout element != e est un generateur).

*Preuve de (3).* Soit a dans G avec a != e. L'ordre de a divise |G| = p et est >= 2 (car a != e). Comme p est premier, ord(a) = p, donc <a> est un sous-groupe de G de cardinal p = |G|, d'ou <a> = G. QED.

### 5. Morphismes de groupes

**Definition 3.10.** Soient (G, *) et (G', .) deux groupes. Une application phi : G -> G' est un *morphisme de groupes* (ou *homomorphisme*) si :

Pour tout a, b dans G, phi(a * b) = phi(a) . phi(b)

**Proprietes.**
- phi(e_G) = e_{G'} (le morphisme envoie le neutre sur le neutre).
- phi(a^{-1}) = phi(a)^{-1}.

*Preuve de la premiere propriete.* phi(e_G) = phi(e_G * e_G) = phi(e_G) . phi(e_G). En multipliant les deux membres par phi(e_G)^{-1}, on obtient e_{G'} = phi(e_G). QED.

**Definition 3.11.**
- Le *noyau* de phi est Ker(phi) = {a dans G | phi(a) = e_{G'}}. C'est un sous-groupe de G.
- L'*image* de phi est Im(phi) = {phi(a) | a dans G}. C'est un sous-groupe de G'.

**Proposition 3.12.**
- phi est injective si et seulement si Ker(phi) = {e_G}.
- phi est surjective si et seulement si Im(phi) = G'.
- Un morphisme bijectif est un *isomorphisme*.

*Preuve (injection <=> noyau trivial).* (=>) Si phi est injective et a dans Ker(phi), alors phi(a) = e_{G'} = phi(e_G), donc a = e_G. (<=) Si Ker(phi) = {e_G} et phi(a) = phi(b), alors phi(a * b^{-1}) = phi(a) . phi(b)^{-1} = e_{G'}, donc a * b^{-1} dans Ker(phi) = {e_G}, d'ou a = b. QED.

### 6. Le groupe symetrique S_n

**Definition 3.13.** Le *groupe symetrique* S_n est l'ensemble des bijections de {1, 2, ..., n} dans lui-meme, muni de la composition. Son cardinal est n!.

**Notation.** Une permutation sigma dans S_n peut se noter :
- En notation a deux lignes : les images de chaque element.
- En notation cyclique : sigma = (1 3 2)(4 5) signifie 1 -> 3 -> 2 -> 1 et 4 -> 5 -> 4.

**Definition 3.14.** Une *transposition* est une permutation qui echange exactement deux elements et fixe tous les autres. On note (i j) la transposition qui echange i et j.

**Theoreme 3.15.** Toute permutation sigma dans S_n (n >= 2) se decompose en produit de transpositions. La parite du nombre de transpositions est un invariant : on definit la *signature* de sigma, notee epsilon(sigma), par epsilon(sigma) = (-1)^k si sigma est un produit de k transpositions.

**Remarque.** Un cycle de longueur l se decompose en l - 1 transpositions. Par exemple, (1 2 3) = (1 3)(1 2). Un cycle de longueur paire est une permutation impaire, un cycle de longueur impaire est une permutation paire.

**Definition 3.16.** Le *groupe alterne* A_n est le sous-groupe de S_n forme des permutations paires (epsilon(sigma) = +1). On a |A_n| = n!/2.

**Exercice de comprehension 1.** Dans S_4, ecrire la permutation sigma definie par sigma(1) = 3, sigma(2) = 1, sigma(3) = 4, sigma(4) = 2. L'ecrire en notation cyclique, la decomposer en transpositions, et determiner sa signature.

---

## II. Anneaux

### 1. Definition

**Definition 3.17.** Un *anneau* est un triplet (A, +, x) ou :
1. (A, +) est un groupe abelien (neutre note 0).
2. La loi x est associative et possede un element neutre note 1.
3. La loi x est distributive par rapport a + : pour tout a, b, c dans A, a(b + c) = ab + ac et (a + b)c = ac + bc.

Si x est commutative, l'anneau est dit *commutatif*. Si 1 != 0, l'anneau est dit *non trivial* (ou *non nul*).

**Exemples.**
- (Z, +, x) est un anneau commutatif.
- (Z/nZ, +, x) est un anneau commutatif.
- L'anneau des matrices M_n(R) est un anneau non commutatif (pour n >= 2).
- L'anneau des polynomes K[X] est un anneau commutatif.

**Definition 3.18.** Soit A un anneau. Un element a dans A est dit :
- *inversible* (ou *unite*) s'il existe b dans A tel que ab = ba = 1. L'ensemble des elements inversibles est note A* ou U(A), et forme un *groupe* pour la multiplication.
- *diviseur de zero* si a != 0 et il existe b != 0 tel que ab = 0 ou ba = 0.

**Proposition.** Un element inversible ne peut pas etre diviseur de zero. En effet, si a est inversible et ab = 0, alors b = a^{-1}(ab) = a^{-1} * 0 = 0.

**Definition 3.19.** Un *anneau integre* est un anneau commutatif non trivial sans diviseur de zero. Z est integre. Z/6Z ne l'est pas (car 2_barre x 3_barre = 0_barre).

### 2. Z/nZ comme anneau

L'anneau Z/nZ a des proprietes qui dependent fortement de n.

**Proposition 3.20.**
- Z/nZ est integre si et seulement si n est premier.
- Z/nZ possede des diviseurs de zero si et seulement si n est compose.

*Preuve.* Si n est compose, n = ab avec 1 < a, b < n. Alors a_barre x b_barre = (ab)_barre = n_barre = 0_barre avec a_barre != 0_barre et b_barre != 0_barre : ce sont des diviseurs de zero.

Si n = p est premier et a_barre x b_barre = 0_barre, alors p | ab. Par le lemme d'Euclide, p | a ou p | b, soit a_barre = 0_barre ou b_barre = 0_barre : pas de diviseurs de zero. QED.

### 3. Ideaux (notion)

**Definition 3.21.** Soit A un anneau commutatif. Une partie I de A est un *ideal* de A si :
1. (I, +) est un sous-groupe de (A, +).
2. Pour tout a dans A, pour tout x dans I, ax dans I (stabilite par multiplication externe, aussi appelee *absorption*).

**Exemple.** Pour tout a dans Z, l'ensemble aZ = {ak | k dans Z} est un ideal de Z. En fait, *tous* les ideaux de Z sont de cette forme (Z est un anneau *principal*). L'ideal nZ est engendre par n, et Z/nZ est l'anneau *quotient* de Z par l'ideal nZ.

---

## III. Corps

### 1. Definition

**Definition 3.22.** Un *corps* est un anneau commutatif non trivial (K, +, x) dans lequel tout element non nul est inversible : K* = K \ {0}.

Autrement dit, (K, +) est un groupe abelien, (K*, x) est un groupe abelien, et x distribue sur +.

**Exemples.**
- Q, R, C sont des corps (infinis).
- Z/pZ est un corps lorsque p est premier (voir ci-dessous). On le note souvent F_p.
- Z/nZ n'est *pas* un corps si n est compose (existence de diviseurs de zero).

### 2. Le corps F_p = Z/pZ (p premier)

**Theoreme 3.23.** Si p est premier, alors Z/pZ est un corps fini a p elements.

*Preuve.* On a vu (chapitre 2, Theoreme 2.23) que a_barre dans Z/nZ est inversible si et seulement si pgcd(a, n) = 1. Si n = p est premier, alors pgcd(a, p) = 1 pour tout a dans {1, 2, ..., p-1}. Donc tout element non nul de Z/pZ est inversible. QED.

**Exemple : tables de F_5 = Z/5Z.**

Addition :

| +  | 0 | 1 | 2 | 3 | 4 |
| -- | - | - | - | - | - |
| 0  | 0 | 1 | 2 | 3 | 4 |
| 1  | 1 | 2 | 3 | 4 | 0 |
| 2  | 2 | 3 | 4 | 0 | 1 |
| 3  | 3 | 4 | 0 | 1 | 2 |
| 4  | 4 | 0 | 1 | 2 | 3 |

Multiplication :

| x  | 0 | 1 | 2 | 3 | 4 |
| -- | - | - | - | - | - |
| 0  | 0 | 0 | 0 | 0 | 0 |
| 1  | 0 | 1 | 2 | 3 | 4 |
| 2  | 0 | 2 | 4 | 1 | 3 |
| 3  | 0 | 3 | 1 | 4 | 2 |
| 4  | 0 | 4 | 3 | 2 | 1 |

On lit par exemple : 2^{-1} = 3 dans F_5 (car 2 x 3 = 6 = 1 mod 5), et 3^{-1} = 2, 4^{-1} = 4.

**Remarque.** Le groupe multiplicatif (F_p*, x) est cyclique d'ordre p - 1 (theoreme admis, consequence du fait que tout sous-groupe fini du groupe multiplicatif d'un corps est cyclique). Un generateur de ce groupe est appele *racine primitive* modulo p.

**Exemple.** Dans F_5*, cherchons une racine primitive. Testons g = 2 : 2^1 = 2, 2^2 = 4, 2^3 = 3, 2^4 = 1. Les puissances de 2 parcourent {1, 2, 3, 4} = F_5*. Donc 2 est une racine primitive modulo 5.

---

## IV. Le groupe des inversibles (Z/nZ)*

### 1. Structure

**Definition 3.24.** Le groupe des elements inversibles de Z/nZ est :

(Z/nZ)* = {a_barre dans Z/nZ | pgcd(a, n) = 1}

C'est un groupe multiplicatif d'ordre phi(n), ou phi est l'indicatrice d'Euler.

**Exemples.**
- (Z/8Z)* = {1_barre, 3_barre, 5_barre, 7_barre}, de cardinal phi(8) = 4.
- (Z/12Z)* = {1_barre, 5_barre, 7_barre, 11_barre}, de cardinal phi(12) = 4.
- (Z/7Z)* = {1_barre, 2_barre, 3_barre, 4_barre, 5_barre, 6_barre}, de cardinal phi(7) = 6.

### 2. Indicatrice d'Euler

**Definition 3.25.** Pour n dans N*, l'*indicatrice d'Euler* phi(n) est le nombre d'entiers k avec 1 <= k <= n et pgcd(k, n) = 1.

**Theoreme 3.26 (Formule de calcul).** Si n = p_1^{a_1} x p_2^{a_2} x ... x p_k^{a_k} est la decomposition en facteurs premiers de n, alors :

phi(n) = n x produit(1 - 1/p_i) = n x (1 - 1/p_1) x (1 - 1/p_2) x ... x (1 - 1/p_k)

Ou de maniere equivalente :

phi(n) = p_1^{a_1-1}(p_1 - 1) x p_2^{a_2-1}(p_2 - 1) x ... x p_k^{a_k-1}(p_k - 1)

**Cas particuliers :**
- phi(p) = p - 1 si p est premier.
- phi(p^2) = p^2 - p = p(p - 1) si p est premier.
- phi(pq) = (p - 1)(q - 1) si p, q sont premiers distincts.
- phi(1) = 1 par convention.

**Exemples de calcul.**
- phi(12) = 12 x (1 - 1/2) x (1 - 1/3) = 12 x 1/2 x 2/3 = 4.
- phi(100) = 100 x (1 - 1/2) x (1 - 1/5) = 100 x 1/2 x 4/5 = 40.
- phi(35) = phi(5 x 7) = (5 - 1)(7 - 1) = 24.
- phi(360) = phi(2^3 x 3^2 x 5) = 2^2 x (2-1) x 3^1 x (3-1) x (5-1) = 4 x 6 x 4 = 96.

**Propriete 3.27 (Multiplicativite).** Si pgcd(m, n) = 1, alors phi(mn) = phi(m) x phi(n). La fonction phi est dite *multiplicative*.

*Preuve (par le theoreme chinois des restes).* Si pgcd(m, n) = 1, l'application Z/mnZ -> Z/mZ x Z/nZ definie par x_barre -> (x mod m, x mod n) est un isomorphisme d'anneaux (CRT, voir section VI). Un element x_barre est inversible dans Z/mnZ si et seulement si (x mod m, x mod n) est inversible dans Z/mZ x Z/nZ, c'est-a-dire si et seulement si x est inversible mod m *et* mod n. Donc |(Z/mnZ)*| = |(Z/mZ)*| x |(Z/nZ)*|, soit phi(mn) = phi(m) x phi(n). QED.

**Theoreme 3.28 (Somme des indicatrices).** Pour tout n >= 1 :

Somme_{d | n} phi(d) = n

(La somme porte sur tous les diviseurs positifs d de n.)

*Preuve.* On partitionne {1, 2, ..., n} selon la valeur de pgcd(k, n). Pour chaque diviseur d de n, l'ensemble {k dans {1,...,n} | pgcd(k, n) = d} est en bijection avec {j dans {1,...,n/d} | pgcd(j, n/d) = 1} (via k = dj), donc contient phi(n/d) elements. En sommant sur d : n = Somme_{d | n} phi(n/d) = Somme_{d | n} phi(d) (par changement de variable d <-> n/d). QED.

**Verification.** Pour n = 12 : diviseurs de 12 = {1, 2, 3, 4, 6, 12}. phi(1) + phi(2) + phi(3) + phi(4) + phi(6) + phi(12) = 1 + 1 + 2 + 2 + 2 + 4 = 12. Correct.

**Exercice de comprehension 2.** Calculer phi(360) en utilisant la decomposition 360 = 2^3 x 3^2 x 5. Verifier que Somme_{d | 12} phi(d) = 12.

---

## V. Theoreme d'Euler et petit theoreme de Fermat

### 1. Theoreme d'Euler

**Theoreme 3.29 (Euler).** Si a dans Z et n dans N*, n >= 2, avec pgcd(a, n) = 1, alors :

a^{phi(n)} = 1 (mod n)

*Preuve.* L'element a_barre appartient au groupe (Z/nZ)* qui est de cardinal phi(n). Par le corollaire du theoreme de Lagrange (tout element eleve a la puissance de l'ordre du groupe donne le neutre), a_barre^{phi(n)} = 1_barre, soit a^{phi(n)} = 1 (mod n). QED.

**Exemple.** Calculer 3^{100} mod 14.

phi(14) = phi(2 x 7) = 1 x 6 = 6. Comme pgcd(3, 14) = 1, on a 3^6 = 1 (mod 14).

100 = 6 x 16 + 4, donc 3^{100} = (3^6)^{16} x 3^4 = 1^{16} x 81 = 81 mod 14.

81 = 5 x 14 + 11, donc 3^{100} = 11 (mod 14).

**Exemple.** Calculer 7^{222} mod 15.

phi(15) = phi(3 x 5) = 2 x 4 = 8. Comme pgcd(7, 15) = 1, on a 7^8 = 1 (mod 15).

222 = 8 x 27 + 6, donc 7^{222} = (7^8)^{27} x 7^6 = 7^6 mod 15.

7^2 = 49 = 4 (mod 15). 7^4 = 4^2 = 16 = 1 (mod 15). 7^6 = 7^4 x 7^2 = 1 x 4 = 4 (mod 15).

Donc 7^{222} = 4 (mod 15).

### 2. Petit theoreme de Fermat

**Theoreme 3.30 (Petit theoreme de Fermat).** Si p est premier et a dans Z avec p ne divise pas a, alors :

a^{p-1} = 1 (mod p)

De maniere equivalente, pour tout a dans Z (sans condition sur pgcd) :

a^p = a (mod p)

*Preuve.* C'est un cas particulier du theoreme d'Euler avec n = p : phi(p) = p - 1. Pour la forme a^p = a, si p | a c'est trivial (les deux cotes valent 0 mod p), et si p ne divise pas a on multiplie a^{p-1} = 1 par a. QED.

**Application : test de primalite (test de Fermat).** Si n est premier, alors pour tout a avec pgcd(a, n) = 1, on a a^{n-1} = 1 (mod n). Contraposee : si a^{n-1} != 1 (mod n) pour un certain a, alors n n'est pas premier.

**Attention : nombres de Carmichael.** La reciproque du petit theoreme de Fermat est fausse. Il existe des entiers composes n (appeles nombres de Carmichael) tels que a^{n-1} = 1 (mod n) pour tout a avec pgcd(a, n) = 1. Le plus petit est 561 = 3 x 11 x 17. Le test de Fermat seul n'est donc pas suffisant pour prouver la primalite.

### 3. Preuve de la correction de RSA

Le theoreme d'Euler permet de prouver que RSA fonctionne. Rappelons le contexte (cf. chapitre 2) : n = pq, e et d tels que ed = 1 (mod phi(n)), et le chiffre c = m^e mod n.

**Theoreme 3.31.** Avec les notations ci-dessus, pour tout m avec 0 <= m < n :

(m^e)^d = m (mod n)

*Preuve.* On a ed = 1 + k*phi(n) pour un certain k dans Z. Donc m^{ed} = m^{1 + k*phi(n)} = m x (m^{phi(n)})^k.

**Cas 1 :** pgcd(m, n) = 1. Par le theoreme d'Euler, m^{phi(n)} = 1 (mod n), donc m^{ed} = m x 1^k = m (mod n).

**Cas 2 :** pgcd(m, n) > 1. Comme n = pq avec p, q premiers distincts, m est divisible par p ou q (mais pas les deux, car 0 <= m < n = pq). Supposons p | m et pgcd(m, q) = 1. Alors :

- Par Fermat, m^{q-1} = 1 (mod q), donc m^{phi(n)} = m^{(p-1)(q-1)} = (m^{q-1})^{p-1} = 1 (mod q). Ainsi m^{ed} = m x 1^k = m (mod q).
- Par ailleurs, p | m implique m^{ed} = 0 = m (mod p).

Par le theoreme chinois des restes (car pgcd(p, q) = 1), m^{ed} = m (mod pq = n). QED.

**Exercice de comprehension 3.** Calculer 2^{20} mod 13 en utilisant le petit theoreme de Fermat.

---

## VI. Theoreme chinois des restes

### 1. Enonce

**Theoreme 3.32 (Theoreme chinois des restes, CRT).** Soient n_1, n_2, ..., n_k des entiers >= 2 deux a deux premiers entre eux, et a_1, a_2, ..., a_k dans Z. Le systeme de congruences :

```
x = a_1 (mod n_1)
x = a_2 (mod n_2)
...
x = a_k (mod n_k)
```

admet une solution, et cette solution est unique modulo N = n_1 x n_2 x ... x n_k.

### 2. Preuve constructive (cas k = 2)

Soit le systeme x = a_1 (mod n_1) et x = a_2 (mod n_2) avec pgcd(n_1, n_2) = 1.

Par Bezout, il existe u_1, u_2 dans Z tels que n_1*u_1 + n_2*u_2 = 1. Posons :

x_0 = a_1 * n_2 * u_2 + a_2 * n_1 * u_1

**Verification :**
- x_0 mod n_1 : on a n_1*u_1 + n_2*u_2 = 1, donc n_2*u_2 = 1 (mod n_1), et n_1*u_1 = 0 (mod n_1). Ainsi x_0 = a_1 x 1 + a_2 x 0 = a_1 (mod n_1).
- x_0 mod n_2 : symetriquement, x_0 = a_2 (mod n_2).

**Unicite modulo N :** Si x et y sont deux solutions, alors n_1 | (x - y) et n_2 | (x - y). Comme pgcd(n_1, n_2) = 1, on a n_1*n_2 | (x - y), soit x = y (mod N). QED.

### 3. Exemple de resolution

**Resoudre :** x = 2 (mod 3), x = 3 (mod 5), x = 1 (mod 7).

N = 3 x 5 x 7 = 105.

**Etape 1 :** Resolvons les deux premieres congruences.

x = 2 (mod 3) donne x = 3t + 2 pour un t dans Z.

Substituons dans x = 3 (mod 5) : 3t + 2 = 3 (mod 5), soit 3t = 1 (mod 5).

Inverse de 3 mod 5 : 3 x 2 = 6 = 1 (mod 5), donc 3^{-1} = 2 (mod 5).

t = 2 (mod 5), soit t = 5s + 2. Donc x = 3(5s + 2) + 2 = 15s + 8.

x = 8 (mod 15).

**Etape 2 :** x = 8 (mod 15) et x = 1 (mod 7).

x = 15s + 8. Substituons : 15s + 8 = 1 (mod 7), soit 15s = -7 = 0 (mod 7). Comme 15 = 1 (mod 7), on obtient s = 0 (mod 7), soit s = 7u. Donc x = 15 x 7u + 8 = 105u + 8.

**Solution :** x = 8 (mod 105).

**Verification :** 8 = 2 x 3 + 2, ok. 8 = 1 x 5 + 3, ok. 8 = 1 x 7 + 1, ok.

### 4. Forme isomorphe du CRT

**Theoreme 3.33.** Si pgcd(m, n) = 1, alors l'application :

phi : Z/mnZ -> Z/mZ x Z/nZ definie par phi(x_barre) = (x mod m, x mod n)

est un *isomorphisme d'anneaux*. En particulier :

(Z/mnZ)* est isomorphe a (Z/mZ)* x (Z/nZ)*

Cet isomorphisme explique la multiplicativite de l'indicatrice d'Euler : phi(mn) = phi(m) x phi(n).

**Application cryptographique (CRT-RSA).** Au lieu de calculer c^d mod n directement (ou n = pq est grand), on calcule :
- m_1 = c^d mod p (module plus petit, donc plus rapide)
- m_2 = c^d mod q

Puis on recombine par le CRT pour obtenir m = c^d mod n. Comme la complexite de l'exponentiation modulaire depend cubiquement de la taille du module, cette methode accelere le dechiffrement d'un facteur environ 4.

**Exercice de comprehension 4.** Resoudre le systeme x = 3 (mod 11), x = 5 (mod 13).

---

## VII. Applications cryptographiques

### 1. Fondements algebriques de RSA (synthese)

Le systeme RSA utilise directement les resultats suivants de ce chapitre :

| Concept | Role dans RSA |
| --- | --- |
| Indicatrice d'Euler phi(n) | Calcul de la cle privee d : ed = 1 mod phi(n) |
| Theoreme d'Euler | Preuve que le dechiffrement retrouve le message |
| Identite de Bezout | Calcul de l'inverse modulaire d = e^{-1} mod phi(n) |
| Theoreme chinois des restes | Acceleration du dechiffrement RSA (CRT-RSA) |
| Corps F_p | Choix des parametres, arithmetique sous-jacente |

### 2. Echange de cles Diffie-Hellman

**Contexte.** Alice et Bob veulent s'accorder sur un secret partage via un canal public (non chiffre mais potentiellement ecoute).

**Protocole :**
1. Alice et Bob choisissent publiquement un nombre premier p et un generateur g du groupe cyclique (Z/pZ)*.
2. Alice choisit secretement a dans {2, ..., p-2} et envoie A = g^a mod p.
3. Bob choisit secretement b dans {2, ..., p-2} et envoie B = g^b mod p.
4. Alice calcule le secret s = B^a = (g^b)^a = g^{ab} mod p.
5. Bob calcule le secret s = A^b = (g^a)^b = g^{ab} mod p.

Les deux obtiennent le meme secret g^{ab} mod p.

**Securite.** Un attaquant passif connait p, g, A = g^a et B = g^b, mais doit retrouver g^{ab}. C'est le *probleme de Diffie-Hellman calculatoire (CDH)*, qui est lie au *probleme du logarithme discret (DLP)* : etant donne g^a, retrouver a. Ce probleme est considere comme difficile dans les groupes choisis en pratique.

**Structures algebriques utilisees :** Le protocole repose sur le groupe cyclique (Z/pZ)*, d'ordre p - 1. Le generateur g doit etre choisi tel que <g> = (Z/pZ)* (ou un sous-groupe d'ordre premier suffisamment grand).

**Exemple numerique.** p = 23, g = 5 (qui est un generateur de (Z/23Z)*, car phi(23) = 22 = 2 x 11, et 5 n'est d'ordre ni 1, ni 2, ni 11).

Verifions que 5 est bien un generateur : il suffit de verifier que 5^{11} != 1 et 5^2 != 1 (mod 23).
5^2 = 25 = 2 (mod 23), ok != 1.
5^{11} : 5^4 = 4, 5^8 = 16, 5^{11} = 5^8 x 5^2 x 5 = 16 x 2 x 5 = 160 = 160 - 6x23 = 160 - 138 = 22 = -1 (mod 23), ok != 1. Donc 5 est generateur.

- Alice choisit a = 6 et calcule A = 5^6 mod 23. On a 5^2 = 2, 5^4 = 4, 5^6 = 5^4 x 5^2 = 4 x 2 = 8. Donc A = 8.
- Bob choisit b = 15 et calcule B = 5^{15} mod 23. 5^{15} = 5^8 x 5^4 x 5^2 x 5^1 = 16 x 4 x 2 x 5 = 640. 640 = 27 x 23 + 19. Donc B = 19.
- Alice : s = 19^6 mod 23. 19^2 = 361 = 15 x 23 + 16 = 16. 19^4 = 16^2 = 256 = 11 x 23 + 3 = 3. 19^6 = 3 x 16 = 48 = 2 x 23 + 2 = 2. Donc s = 2.
- Bob : s = 8^{15} mod 23. 8^2 = 64 = 2 x 23 + 18 = 18. 8^4 = 18^2 = 324 = 14 x 23 + 2 = 2. 8^8 = 2^2 = 4. 8^{15} = 8^8 x 8^4 x 8^2 x 8^1 = 4 x 2 x 18 x 8 = 1152. 1152 = 50 x 23 + 2. Donc s = 2.

Le secret partage est s = 2. Les deux cotes donnent bien le meme resultat.

### 3. Logarithme discret et securite

Le probleme du logarithme discret (DLP) dans (Z/pZ)* est le suivant : etant donnes g, h dans (Z/pZ)* avec h = g^x, retrouver x.

**Difficulte.** Les meilleurs algorithmes classiques connus (baby-step giant-step, Pohlig-Hellman, index calculus) sont sous-exponentiels. Pour p de 2048 bits, le DLP est considere infaisable. L'algorithme quantique de Shor resoudrait le DLP en temps polynomial, d'ou l'interet de la cryptographie post-quantique.

**Exercice de comprehension 5.** Avec p = 17 et g = 3. Alice choisit a = 4 et Bob b = 7. Calculer A, B, et le secret partage s. Verifier que les deux cotes donnent le meme resultat.

---

## VIII. Exercices de synthese

**Exercice 6.** Soit G un groupe fini d'ordre n. Montrer que si n est premier, alors G est cyclique. (Indication : prendre a != e et utiliser Lagrange.)

**Exercice 7.** Determiner tous les generateurs du groupe cyclique (Z/11Z, +). En deduire les generateurs du groupe multiplicatif (Z/11Z)*.

*Indication pour (Z/11Z, +) :* a_barre engendre (Z/11Z, +) si et seulement si pgcd(a, 11) = 1, c'est-a-dire a dans {1, 2, ..., 10}.

*Indication pour (Z/11Z)* :* phi(10) = 4 generateurs. Les trouver en testant les ordres.

**Exercice 8.** Montrer que (Z/8Z)* n'est pas cyclique. (Indication : calculer l'ordre de chaque element de (Z/8Z)* = {1, 3, 5, 7}.)

*Aide :* 3^2 = 9 = 1 (mod 8), 5^2 = 25 = 1 (mod 8), 7^2 = 49 = 1 (mod 8). Tous les elements sont d'ordre 1 ou 2, aucun n'est d'ordre 4 = phi(8). Donc (Z/8Z)* n'est pas cyclique. En fait, (Z/8Z)* est isomorphe a Z/2Z x Z/2Z (groupe de Klein).

**Exercice 9.** Soit n = 3 x 5 x 7 = 105. Calculer phi(105). Resoudre x^3 = 1 (mod 105) en se ramenant a un systeme de congruences via le CRT.

**Exercice 10 (RSA complet).** Avec p = 17, q = 23, e = 3 :
1. Calculer n et phi(n).
2. Verifier que pgcd(e, phi(n)) = 1 et calculer d = e^{-1} mod phi(n).
3. Chiffrer le message m = 10.
4. Dechiffrer le resultat et verifier qu'on retrouve m = 10.

*Aide pour 2 :* n = 391, phi(n) = 16 x 22 = 352. pgcd(3, 352) : 352 = 3 x 117 + 1, donc pgcd = 1. Bezout : 1 = 352 - 3 x 117, donc d = -117 = 235 (mod 352).

**Exercice 11.** Montrer que pour tout n >= 1, phi(n) est pair si n >= 3. (Indication : si p^a || n avec p impair, alors p-1 est pair. Si 2^a || n avec a >= 2, alors phi(2^a) = 2^{a-1} est pair.)

---

## References

- D. Perrin, *Cours d'algebre*, Ellipses.
- S. Lang, *Algebra*, Springer (reference avancee).
- J. Velu, *Methodes mathematiques pour l'informatique*, Dunod.
- X. Gourdon, *Les maths en tete -- Algebre*, Ellipses.
- Christof Paar, Jan Pelzl, *Understanding Cryptography*, Springer (chapitres DH et RSA).
- W. Diffie, M. Hellman, *New Directions in Cryptography*, IEEE Trans. on Information Theory, 1976.
- A. Menezes, P. van Oorschot, S. Vanstone, *Handbook of Applied Cryptography*, CRC Press.
- N. Koblitz, *A Course in Number Theory and Cryptography*, Springer.
