# Chapitre 4 -- Algebre lineaire

## Objectifs du chapitre

- Definir et manipuler les espaces vectoriels, sous-espaces, familles libres, generatrices, bases et dimension.
- Comprendre les applications lineaires, leur noyau, leur image, et le theoreme du rang.
- Maitriser le calcul matriciel : operations, rang, changement de base.
- Calculer des determinants et appliquer les formules de Cramer.
- Reduire les endomorphismes : valeurs propres, vecteurs propres, diagonalisation, trigonalisation.
- Connaitre le theoreme de Cayley-Hamilton et le theoreme spectral.

---

## I. Espaces vectoriels

### 1. Definition

Dans tout ce chapitre, K designe un corps (typiquement R ou C, ou un corps fini F_p).

**Definition 4.1.** Un *espace vectoriel sur K* (ou *K-espace vectoriel*) est un ensemble E muni de deux operations :
- une addition interne + : E x E -> E,
- une multiplication externe . : K x E -> E (appelee multiplication par un scalaire),

verifiant les axiomes suivants, pour tous u, v, w dans E et tous lambda, mu dans K :

1. (E, +) est un groupe abelien (neutre note 0_E ou simplement 0).
2. lambda . (u + v) = lambda . u + lambda . v (distributivite sur l'addition vectorielle).
3. (lambda + mu) . u = lambda . u + mu . u (distributivite sur l'addition scalaire).
4. (lambda * mu) . u = lambda . (mu . u) (associativite mixte).
5. 1_K . u = u (element neutre scalaire).

Les elements de E sont appeles *vecteurs* et ceux de K des *scalaires*.

**Exemples fondamentaux.**

- K^n = {(x_1, ..., x_n) | x_i dans K} avec les operations composante par composante.
- L'espace des polynomes K[X] a coefficients dans K.
- L'espace des matrices M_{m,n}(K) de taille m x n.
- L'espace des fonctions continues C^0([a,b], R).
- L'espace trivial {0}.

**Proposition 4.2 (Proprietes immediates).** Pour tout espace vectoriel E :
- 0_K . u = 0_E pour tout u dans E.
- lambda . 0_E = 0_E pour tout lambda dans K.
- (-1) . u = -u pour tout u dans E.
- Si lambda . u = 0_E, alors lambda = 0 ou u = 0_E.

*Preuve de la derniere propriete.* Si lambda != 0, alors lambda est inversible dans K. Multiplions lambda . u = 0_E par lambda^{-1} : u = lambda^{-1} . (lambda . u) = lambda^{-1} . 0_E = 0_E. QED.

### 2. Sous-espaces vectoriels

**Definition 4.3.** Soit E un K-espace vectoriel. Une partie F de E est un *sous-espace vectoriel* (sev) de E si :
1. 0_E dans F (F est non vide et contient le vecteur nul).
2. Pour tout u, v dans F, u + v dans F (stabilite par addition).
3. Pour tout lambda dans K, pour tout u dans F, lambda.u dans F (stabilite par multiplication scalaire).

**Proposition 4.4 (Caracterisation).** F sous-ensemble de E est un sev si et seulement si :
- F != ensemble vide,
- Pour tout u, v dans F, pour tout lambda, mu dans K, lambda.u + mu.v dans F (stabilite par combinaison lineaire).

**Exemples.**
- Dans R^3, le plan d'equation x + y + z = 0 est un sev (il contient 0 et est stable par c.l.). Le plan d'equation x + y + z = 1 n'en est pas un (ne contient pas 0).
- Dans K[X], l'ensemble K_n[X] des polynomes de degre <= n est un sev de K[X].
- Le noyau d'une application lineaire est un sev (voir section II).

**Proposition 4.5.**
- L'intersection de sous-espaces vectoriels est un sous-espace vectoriel.
- La reunion de deux sev n'est en general *pas* un sev (sauf si l'un est inclus dans l'autre).

*Preuve du second point (contre-exemple).* Dans R^2, F = Vect((1, 0)) (l'axe des x) et G = Vect((0, 1)) (l'axe des y) sont des sev. Mais F union G n'est pas un sev : (1, 0) dans F et (0, 1) dans G, mais (1, 0) + (0, 1) = (1, 1) n'est ni dans F ni dans G. QED.

**Definition 4.6 (Somme de sous-espaces).** Si F et G sont deux sev de E :

F + G = {u + v | u dans F, v dans G}

C'est le plus petit sev contenant F et G. Si de plus F inter G = {0}, la somme est dite *directe*, notee F (+) G. On ecrit alors E = F (+) G si de plus F + G = E.

**Proposition 4.7.** La somme F + G est directe si et seulement si tout vecteur de F + G s'ecrit de maniere *unique* comme somme d'un vecteur de F et d'un vecteur de G.

### 3. Combinaisons lineaires, familles libres, generatrices

**Definition 4.8.** Soit {v_1, ..., v_n} une famille de vecteurs de E. Une *combinaison lineaire* de ces vecteurs est un vecteur de la forme lambda_1.v_1 + lambda_2.v_2 + ... + lambda_n.v_n avec lambda_i dans K.

**Definition 4.9.** L'ensemble de toutes les combinaisons lineaires de {v_1, ..., v_n} est appele le *sous-espace engendre* par cette famille, note Vect(v_1, ..., v_n) ou <v_1, ..., v_n>. C'est le plus petit sev contenant v_1, ..., v_n.

**Definition 4.10.** Une famille {v_1, ..., v_n} est :
- *libre* (ou *lineairement independante*) si la seule combinaison lineaire egale a 0 est la combinaison triviale : lambda_1.v_1 + ... + lambda_n.v_n = 0 implique lambda_1 = ... = lambda_n = 0.
- *liee* (ou *lineairement dependante*) si elle n'est pas libre, c'est-a-dire s'il existe des scalaires non tous nuls tels que lambda_1.v_1 + ... + lambda_n.v_n = 0.
- *generatrice* de E si Vect(v_1, ..., v_n) = E.

**Exemple.** Dans R^3 :
- {(1,0,0), (0,1,0), (0,0,1)} est libre et generatrice (c'est la base canonique).
- {(1,1,0), (0,1,1), (1,0,-1)} est liee car (1,1,0) - (0,1,1) - (1,0,-1) = (0,0,0).

**Proposition 4.11.** Une famille {v_1, ..., v_n} est liee si et seulement si l'un des vecteurs est combinaison lineaire des autres.

### 4. Bases et dimension

**Definition 4.12.** Une *base* de E est une famille a la fois libre et generatrice. Si B = {e_1, ..., e_n} est une base de E, tout vecteur v dans E s'ecrit de maniere unique comme combinaison lineaire des vecteurs de B : v = lambda_1.e_1 + ... + lambda_n.e_n. Les scalaires (lambda_1, ..., lambda_n) sont les *coordonnees* de v dans la base B.

**Theoreme 4.13 (Existence et dimension).** Si E admet une famille generatrice finie, alors E admet une base. De plus, toutes les bases de E ont le meme cardinal, appele *dimension* de E, note dim(E) ou dim_K(E).

**Theoreme 4.14 (Theoreme de la base incomplete).** Toute famille libre de E peut etre completee en une base de E. Toute famille generatrice de E contient une sous-famille qui est une base.

**Exemples.**
- dim(K^n) = n. La base canonique est {e_1, ..., e_n} avec e_i = (0, ..., 1, ..., 0) (1 en position i).
- dim(K_n[X]) = n + 1. Base canonique : {1, X, X^2, ..., X^n}.
- dim(M_{m,n}(K)) = mn. Base canonique : les matrices E_{ij} avec un 1 en position (i,j) et des 0 partout ailleurs.

**Proposition 4.15 (Criteres en dimension finie).** Si dim(E) = n, alors :
- Toute famille libre de n vecteurs est une base.
- Toute famille generatrice de n vecteurs est une base.
- Toute famille libre a au plus n vecteurs.
- Toute famille generatrice a au moins n vecteurs.

**Theoreme 4.16 (Formule de Grassmann).** Si F et G sont deux sev de dimension finie d'un meme espace E :

dim(F + G) = dim(F) + dim(G) - dim(F inter G)

Si F + G est directe (F inter G = {0}), alors dim(F (+) G) = dim(F) + dim(G).

*Preuve (esquisse).* Soit {u_1, ..., u_r} une base de F inter G. Completons-la en une base {u_1, ..., u_r, f_1, ..., f_s} de F et en une base {u_1, ..., u_r, g_1, ..., g_t} de G. Alors {u_1, ..., u_r, f_1, ..., f_s, g_1, ..., g_t} est une base de F + G (la preuve de la liberte utilise le fait que F inter G = Vect(u_1, ..., u_r)). On obtient dim(F+G) = r + s + t = (r + s) + (r + t) - r = dim(F) + dim(G) - dim(F inter G). QED.

**Exercice de comprehension 1.** Montrer que les vecteurs v_1 = (1, 2, 1), v_2 = (0, 1, -1), v_3 = (1, 0, 3) forment une base de R^3. Exprimer w = (3, 5, 2) dans cette base.

---

## II. Applications lineaires

### 1. Definition et premieres proprietes

**Definition 4.17.** Soient E et F deux K-espaces vectoriels. Une application f : E -> F est *lineaire* si :

Pour tout u, v dans E, pour tout lambda dans K : f(u + v) = f(u) + f(v) et f(lambda.u) = lambda.f(u)

De maniere equivalente : pour tout u, v dans E, pour tout lambda, mu dans K, f(lambda.u + mu.v) = lambda.f(u) + mu.f(v).

On note L(E, F) l'ensemble des applications lineaires de E dans F. Si E = F, on parle d'*endomorphisme* et on note L(E) = L(E, E).

**Proprietes immediates.**
- f(0_E) = 0_F.
- f(-u) = -f(u).
- f(lambda_1.v_1 + ... + lambda_n.v_n) = lambda_1.f(v_1) + ... + lambda_n.f(v_n).

**Consequence fondamentale.** Une application lineaire est *entierement determinee par les images des vecteurs d'une base*. Si B = {e_1, ..., e_n} est une base de E et si l'on fixe f(e_1), ..., f(e_n) dans F, alors il existe une unique application lineaire f : E -> F ayant ces images.

*Preuve.* Pour v = lambda_1.e_1 + ... + lambda_n.e_n (decomposition unique car B est une base), on definit necessairement f(v) = lambda_1.f(e_1) + ... + lambda_n.f(e_n). Cette definition est bien une application lineaire (verification directe). QED.

### 2. Noyau et image

**Definition 4.18.** Soit f : E -> F lineaire.
- Le *noyau* de f est Ker(f) = {u dans E | f(u) = 0_F}. C'est un sous-espace vectoriel de E.
- L'*image* de f est Im(f) = {f(u) | u dans E}. C'est un sous-espace vectoriel de F.

**Proposition 4.19.**
- f est injective si et seulement si Ker(f) = {0_E}.
- f est surjective si et seulement si Im(f) = F.

*Preuve de l'injectivite.* (=>) Si f est injective et u dans Ker(f), alors f(u) = 0 = f(0), donc u = 0. (<=) Si Ker(f) = {0} et f(u) = f(v), alors f(u - v) = 0, donc u - v dans Ker(f) = {0}, d'ou u = v. QED.

### 3. Theoreme du rang

**Definition 4.20.** Le *rang* de f, note rg(f), est la dimension de Im(f).

**Theoreme 4.21 (Theoreme du rang).** Si E est de dimension finie et f : E -> F est lineaire, alors :

dim(E) = dim(Ker(f)) + dim(Im(f)) = dim(Ker(f)) + rg(f)

*Preuve.* Soit p = dim(Ker(f)) et {u_1, ..., u_p} une base de Ker(f). Completons-la en une base de E : {u_1, ..., u_p, v_{p+1}, ..., v_n} (par le theoreme de la base incomplete), avec n = dim(E).

Montrons que {f(v_{p+1}), ..., f(v_n)} est une base de Im(f).

**Generatrice :** Tout w dans Im(f) s'ecrit w = f(x) pour un certain x = alpha_1.u_1 + ... + alpha_p.u_p + alpha_{p+1}.v_{p+1} + ... + alpha_n.v_n. Alors w = f(x) = alpha_1.f(u_1) + ... + alpha_p.f(u_p) + alpha_{p+1}.f(v_{p+1}) + ... + alpha_n.f(v_n). Comme les u_i sont dans Ker(f), f(u_i) = 0, donc w = alpha_{p+1}.f(v_{p+1}) + ... + alpha_n.f(v_n).

**Libre :** Si alpha_{p+1}.f(v_{p+1}) + ... + alpha_n.f(v_n) = 0, alors f(alpha_{p+1}.v_{p+1} + ... + alpha_n.v_n) = 0, donc alpha_{p+1}.v_{p+1} + ... + alpha_n.v_n est dans Ker(f). On peut ecrire alpha_{p+1}.v_{p+1} + ... + alpha_n.v_n = beta_1.u_1 + ... + beta_p.u_p, soit beta_1.u_1 + ... + beta_p.u_p - alpha_{p+1}.v_{p+1} - ... - alpha_n.v_n = 0. Comme {u_1, ..., u_p, v_{p+1}, ..., v_n} est une base (libre), tous les coefficients sont nuls, en particulier alpha_{p+1} = ... = alpha_n = 0.

Donc dim(Im(f)) = n - p = dim(E) - dim(Ker(f)). QED.

**Corollaire 4.22.** Si dim(E) = dim(F) = n et f : E -> F est lineaire, alors les assertions suivantes sont equivalentes :
1. f est injective.
2. f est surjective.
3. f est bijective (isomorphisme).

*Preuve.* (1) => (3) : si f est injective, Ker(f) = {0}, donc rg(f) = n - 0 = n = dim(F), donc f est surjective, donc bijective. (2) => (3) : si f est surjective, rg(f) = n, donc dim(Ker(f)) = n - n = 0, donc f est injective, donc bijective. QED.

**Exercice de comprehension 2.** Soit f : R^3 -> R^2 definie par f(x, y, z) = (x + y, y + z). Determiner Ker(f) et Im(f), et verifier le theoreme du rang.

---

## III. Matrices

### 1. Matrice d'une application lineaire

**Definition 4.23.** Soient E et F de dimensions finies avec bases B_E = {e_1, ..., e_n} et B_F = {f_1, ..., f_m}. La *matrice* de l'application lineaire phi : E -> F dans les bases B_E et B_F est la matrice M dans M_{m,n}(K) dont la j-eme colonne contient les coordonnees de phi(e_j) dans la base B_F.

Si v a pour vecteur colonne de coordonnees X dans B_E, alors phi(v) a pour coordonnees Y = MX dans B_F.

**Exemple.** Soit f : R^2 -> R^3 definie par f(x, y) = (x + y, 2x, x - y). Dans les bases canoniques, la matrice de f est :

```
    | 1   1 |
M = | 2   0 |
    | 1  -1 |
```

Car f(e_1) = f(1,0) = (1, 2, 1) et f(e_2) = f(0,1) = (1, 0, -1).

### 2. Operations matricielles

**Definition 4.24.** Soient A = (a_{ij}) dans M_{m,n}(K) et B = (b_{ij}) dans M_{n,p}(K).

- **Addition :** (A + B)_{ij} = a_{ij} + b_{ij} (pour des matrices de meme taille).
- **Multiplication scalaire :** (lambda.A)_{ij} = lambda * a_{ij}.
- **Produit matriciel :** C = AB dans M_{m,p}(K) avec c_{ij} = Somme(k=1 a n) a_{ik} * b_{kj}.

**Proprietes.**
- Le produit matriciel est associatif : (AB)C = A(BC).
- Il est distributif : A(B + C) = AB + AC.
- Il n'est *pas* commutatif en general : AB != BA.
- La matrice identite I_n est le neutre : A.I_n = I_m.A = A (pour les tailles adequates).

**Proposition 4.25.** La matrice de la composee g o f est le produit des matrices : Mat(g o f) = Mat(g) x Mat(f).

**Attention a l'ordre :** la composee g o f (d'abord f, puis g) correspond au produit Mat(g) x Mat(f) (et pas l'inverse).

### 3. Matrice inversible et rang

**Definition 4.26.** Une matrice carree A dans M_n(K) est *inversible* s'il existe B dans M_n(K) telle que AB = BA = I_n. On note B = A^{-1}.

**Proposition 4.27.** A est inversible si et seulement si l'application lineaire associee est un isomorphisme, si et seulement si det(A) != 0 (voir section IV), si et seulement si rg(A) = n.

**Definition 4.28.** Le *rang* d'une matrice A dans M_{m,n}(K) est la dimension de l'espace engendre par ses colonnes (ou de maniere equivalente, par ses lignes). On le note rg(A). C'est aussi le rang de l'application lineaire associee.

**Calcul pratique du rang.** On effectue des operations elementaires sur les lignes (ou colonnes) pour amener la matrice sous forme echelonnee. Le rang est le nombre de pivots non nuls.

**Inverse d'une matrice 2x2.** Si A = (a b ; c d) avec det(A) = ad - bc != 0, alors :

A^{-1} = 1/(ad - bc) * (d -b ; -c a)

### 4. Changement de base

**Theoreme 4.29.** Soient B et B' deux bases de E, et P la *matrice de passage* de B a B' (dont les colonnes sont les coordonnees des vecteurs de B' dans B). Si X et X' sont les coordonnees d'un meme vecteur v dans B et B' respectivement :

X = P X'

Si M est la matrice d'un endomorphisme f dans B et M' sa matrice dans B' :

M' = P^{-1} M P

**Remarque.** Deux matrices M et M' sont dites *semblables* s'il existe P inversible telle que M' = P^{-1} M P. Etre semblable signifie representer le meme endomorphisme dans des bases differentes. Des matrices semblables ont meme determinant, meme trace, memes valeurs propres, meme polynome caracteristique.

**Exercice de comprehension 3.** Dans R^2, la base canonique est B = {e_1, e_2} et B' = {v_1 = (1,1), v_2 = (1,-1)}. Ecrire la matrice de passage P de B a B'. Calculer P^{-1}.

---

## IV. Determinants

### 1. Definition

**Definition 4.30.** Le *determinant* d'une matrice carree A = (a_{ij}) dans M_n(K) est le scalaire :

det(A) = Somme(sigma dans S_n) epsilon(sigma) * a_{1,sigma(1)} * a_{2,sigma(2)} * ... * a_{n,sigma(n)}

ou la somme porte sur toutes les permutations sigma de S_n et epsilon(sigma) est la signature de sigma. C'est la *formule de Leibniz*.

**Cas n = 2 :** det(a b ; c d) = ad - bc.

**Cas n = 3 (regle de Sarrus) :** det(a b c ; d e f ; g h i) = aei + bfg + cdh - ceg - bdi - afh.

**Attention.** La regle de Sarrus ne se generalise *pas* aux matrices de taille >= 4.

### 2. Proprietes fondamentales

**Theoreme 4.31.** Le determinant verifie les proprietes suivantes :

1. **Multilinearite :** det est lineaire par rapport a chaque colonne (ou ligne), les autres etant fixees.
2. **Alternance :** Si deux colonnes (ou lignes) sont egales, det(A) = 0. Echanger deux colonnes (ou lignes) change le signe du determinant.
3. **Normalisation :** det(I_n) = 1.
4. **Multiplicativite :** det(AB) = det(A) x det(B).
5. **Transposee :** det(A^T) = det(A).
6. **Inversibilite :** A est inversible si et seulement si det(A) != 0.
7. **Inverse :** Si A est inversible, det(A^{-1}) = 1/det(A).
8. **Triangulaire :** Le determinant d'une matrice triangulaire est le produit des elements diagonaux.

**Consequences pour les operations elementaires :**
- Ajouter a une ligne un multiple d'une autre : ne change pas le determinant.
- Echanger deux lignes : multiplie le determinant par -1.
- Multiplier une ligne par lambda : multiplie le determinant par lambda.

### 3. Developpement par cofacteurs

**Definition 4.32.** Le *cofacteur* de l'element a_{ij} est C_{ij} = (-1)^{i+j} * M_{ij}, ou M_{ij} (le *mineur*) est le determinant de la sous-matrice obtenue en supprimant la i-eme ligne et la j-eme colonne.

**Theoreme 4.33 (Developpement selon la i-eme ligne).**

det(A) = Somme(j=1 a n) a_{ij} * C_{ij} = Somme(j=1 a n) (-1)^{i+j} * a_{ij} * M_{ij}

On peut aussi developper selon une colonne. En pratique, on choisit la ligne ou colonne contenant le plus de zeros.

**Exemple.** Calculer le determinant de :

```
A = | 2  1  3 |
    | 0  4  1 |
    | 1  0  2 |
```

Developpement selon la premiere colonne (un zero) :

det(A) = 2 * det(4 1 ; 0 2) - 0 * det(1 3 ; 0 2) + 1 * det(1 3 ; 4 1)

= 2 * (8 - 0) - 0 + 1 * (1 - 12) = 16 - 11 = 5.

### 4. Formules de Cramer

**Theoreme 4.34 (Cramer).** Soit AX = B un systeme lineaire de n equations a n inconnues avec det(A) != 0. Alors le systeme admet une unique solution donnee par :

x_j = det(A_j) / det(A)

ou A_j est la matrice obtenue en remplacant la j-eme colonne de A par B.

**Exemple.** Resoudre le systeme :
```
2x + y  = 5
 x + 3y = 7
```

A = (2 1 ; 1 3), B = (5 ; 7). det(A) = 6 - 1 = 5.

x = det(5 1 ; 7 3) / 5 = (15 - 7) / 5 = 8/5.

y = det(2 5 ; 1 7) / 5 = (14 - 5) / 5 = 9/5.

**Remarque pratique.** Les formules de Cramer sont elegantes mais inefficaces pour n grand (complexite O(n * n!)). Pour resoudre des systemes en pratique, on utilise l'elimination de Gauss (O(n^3)).

**Exercice de comprehension 4.** Calculer le determinant de la matrice 4x4 :

```
| 1  2  0  1 |
| 0  1  3  0 |
| 2  0  1  4 |
| 1  1  0  2 |
```

(Indication : developper selon la deuxieme ligne, qui contient deux zeros.)

---

## V. Reduction des endomorphismes

### 1. Valeurs propres et vecteurs propres

**Definition 4.35.** Soit f dans L(E) un endomorphisme d'un K-espace vectoriel E de dimension finie. Un scalaire lambda dans K est une *valeur propre* de f s'il existe un vecteur v != 0 tel que :

f(v) = lambda.v

Le vecteur v est alors appele *vecteur propre* associe a lambda.

**Definition 4.36.** Le *sous-espace propre* associe a lambda est :

E_lambda = Ker(f - lambda.id) = {v dans E | f(v) = lambda.v}

C'est un sous-espace vectoriel de E (non reduit a {0} si lambda est valeur propre). Sa dimension est la *multiplicite geometrique* de lambda.

En termes matriciels, si A est la matrice de f dans une base, lambda est valeur propre de A si et seulement si det(A - lambda.I) = 0.

### 2. Polynome caracteristique

**Definition 4.37.** Le *polynome caracteristique* de f (ou de sa matrice A) est :

chi_A(lambda) = det(A - lambda.I)

C'est un polynome de degre n en lambda. (Certains auteurs utilisent det(lambda.I - A), qui donne un polynome unitaire.)

**Theoreme 4.38.** Les valeurs propres de f sont exactement les racines du polynome caracteristique.

**Proprietes du polynome caracteristique.**
- Le coefficient de (-lambda)^n est 1 (si on prend det(lambda.I - A)) ou (-1)^n (si on prend det(A - lambda.I)).
- La somme des valeurs propres (comptees avec multiplicite) vaut tr(A) (la trace).
- Le produit des valeurs propres (comptees avec multiplicite) vaut det(A).

**Definition 4.39.** La *multiplicite algebrique* de la valeur propre lambda est son ordre de multiplicite comme racine de chi_A. On a toujours :

1 <= multiplicite geometrique <= multiplicite algebrique

**Exemple.** Soit A = (2 1 ; 0 3). Le polynome caracteristique est :

chi_A(lambda) = det(2 - lambda, 1 ; 0, 3 - lambda) = (2 - lambda)(3 - lambda) = lambda^2 - 5*lambda + 6

Racines : lambda_1 = 2 et lambda_2 = 3. Ce sont les valeurs propres.

Vecteurs propres :
- Pour lambda_1 = 2 : (A - 2I)v = 0, soit (0 1 ; 0 1)(x ; y) = 0, d'ou y = 0. E_2 = Vect((1, 0)).
- Pour lambda_2 = 3 : (A - 3I)v = 0, soit (-1 1 ; 0 0)(x ; y) = 0, d'ou x = y. E_3 = Vect((1, 1)).

### 3. Diagonalisation

**Definition 4.40.** Un endomorphisme f (ou une matrice A) est *diagonalisable* s'il existe une base de E formee de vecteurs propres de f.

Matriciellement, A est diagonalisable s'il existe une matrice inversible P et une matrice diagonale D telles que A = PDP^{-1}, c'est-a-dire D = P^{-1}AP.

**Theoreme 4.41 (Critere de diagonalisabilite).** Soit f un endomorphisme de E (dim(E) = n). Les conditions suivantes sont equivalentes :

1. f est diagonalisable.
2. La somme des dimensions des sous-espaces propres vaut n.
3. chi_f est scinde (toutes ses racines sont dans K) et pour chaque valeur propre, la multiplicite geometrique egale la multiplicite algebrique.

**Corollaire 4.42.** Si A dans M_n(K) possede n valeurs propres *distinctes*, alors A est diagonalisable.

*Preuve.* Des vecteurs propres associes a des valeurs propres distinctes sont lineairement independants. Montrons-le par recurrence. Le cas n = 1 est trivial. Supposons la propriete vraie pour n - 1 valeurs propres et montrons-la pour n. Soit lambda_1.v_1 + ... + lambda_n.v_n = 0 avec v_i vecteur propre pour la valeur propre mu_i (les mu_i sont distincts). Appliquons f : lambda_1.mu_1.v_1 + ... + lambda_n.mu_n.v_n = 0. Soustrayons mu_n fois la premiere equation : lambda_1.(mu_1 - mu_n).v_1 + ... + lambda_{n-1}.(mu_{n-1} - mu_n).v_{n-1} = 0. Par hypothese de recurrence, lambda_i.(mu_i - mu_n) = 0 pour i = 1, ..., n-1. Comme mu_i != mu_n, lambda_i = 0. Puis lambda_n.v_n = 0 avec v_n != 0 donne lambda_n = 0. QED.

**Methode pratique de diagonalisation :**
1. Calculer chi_A(lambda) = det(A - lambda.I).
2. Trouver les racines lambda_1, ..., lambda_k (valeurs propres).
3. Pour chaque lambda_i, resoudre (A - lambda_i.I)v = 0 pour trouver une base de E_{lambda_i}.
4. Si la reunion des bases des sous-espaces propres forme une base de E, la matrice est diagonalisable. La matrice P est formee de ces vecteurs propres en colonnes.

**Exemple complet.** Diagonaliser A = (4 1 ; 2 3).

chi_A(lambda) = (4 - lambda)(3 - lambda) - 2 = lambda^2 - 7*lambda + 10 = (lambda - 2)(lambda - 5).

Valeurs propres : lambda_1 = 2, lambda_2 = 5.

Pour lambda_1 = 2 : (A - 2I) = (2 1 ; 2 1). Noyau : 2x + y = 0, soit v_1 = (1, -2).

Pour lambda_2 = 5 : (A - 5I) = (-1 1 ; 2 -2). Noyau : -x + y = 0, soit v_2 = (1, 1).

P = (1 1 ; -2 1), D = diag(2, 5). On a A = PDP^{-1}.

**Verification :** P^{-1} = 1/3 * (1 -1 ; 2 1). PDP^{-1} = (1 1 ; -2 1)(2 0 ; 0 5) * 1/3 * (1 -1 ; 2 1) = (2 5 ; -4 5) * 1/3 * (1 -1 ; 2 1) = 1/3 * (12 3 ; 6 9) = (4 1 ; 2 3) = A. Correct.

**Application : puissance d'une matrice.** Si A = PDP^{-1}, alors A^k = PD^kP^{-1}, et D^k est trivial a calculer (puissances des elements diagonaux).

### 4. Trigonalisation

**Definition 4.43.** Un endomorphisme f est *trigonalisable* s'il existe une base dans laquelle sa matrice est triangulaire superieure.

**Theoreme 4.44.** f est trigonalisable si et seulement si son polynome caracteristique est scinde dans K.

**Corollaire.** Toute matrice a coefficients complexes est trigonalisable (car C est algebriquement clos). Une matrice reelle est trigonalisable sur R si et seulement si toutes ses valeurs propres sont reelles.

**Remarque.** Les elements diagonaux de la forme triangulaire sont les valeurs propres (comptees avec multiplicite).

### 5. Theoreme de Cayley-Hamilton

**Theoreme 4.45 (Cayley-Hamilton).** Toute matrice carree A dans M_n(K) annule son propre polynome caracteristique :

chi_A(A) = 0

Autrement dit, si chi_A(lambda) = (-1)^n * lambda^n + c_{n-1} * lambda^{n-1} + ... + c_1 * lambda + c_0, alors :

(-1)^n * A^n + c_{n-1} * A^{n-1} + ... + c_1 * A + c_0 * I = 0

**Exemple.** Pour A = (2 1 ; 0 3), chi_A(lambda) = lambda^2 - 5*lambda + 6. Verifions :

A^2 - 5A + 6I = (4 5 ; 0 9) - (10 5 ; 0 15) + (6 0 ; 0 6) = (0 0 ; 0 0). Correct.

**Application : calcul de A^{-1} comme polynome en A.** Cayley-Hamilton permet d'exprimer A^{-1} comme un polynome en A (de degre <= n - 1), sans calculer de determinant explicitement. En effet, si chi_A(A) = 0 et c_0 = det(A) != 0, on peut isoler I et exprimer A^{-1}.

Pour l'exemple ci-dessus : A^2 - 5A + 6I = 0, donc 6I = 5A - A^2, soit I = A(5I - A)/6, d'ou A^{-1} = (5I - A)/6 = (3 -1 ; 0 2)/6 = (1/2, -1/6 ; 0, 1/3).

**Application : calcul de puissances.** Cayley-Hamilton permet de ramener le calcul de A^k (pour k >= n) a un polynome de degre <= n - 1 en A, en effectuant la division euclidienne de X^k par chi_A(X).

**Exercice de comprehension 5.** Verifier le theoreme de Cayley-Hamilton pour la matrice A = (1 2 ; 3 4). En deduire l'expression de A^{-1} comme polynome en A.

---

## VI. Endomorphismes symetriques et theoreme spectral

### 1. Produit scalaire et orthogonalite

**Definition 4.46.** Un *produit scalaire* sur un R-espace vectoriel E est une forme bilineaire <., .> : E x E -> R qui est :
- symetrique : <u, v> = <v, u>,
- definie positive : <u, u> > 0 pour tout u != 0.

Un espace vectoriel muni d'un produit scalaire est un *espace euclidien* (si dim finie sur R).

**Exemple.** Sur R^n, le produit scalaire canonique est <x, y> = Somme_i x_i * y_i = x^T * y.

**Definition 4.47.** Deux vecteurs u et v sont *orthogonaux* si <u, v> = 0. Une base est *orthonormee* (ou orthonormale, BON) si <e_i, e_j> = delta_{ij} (symbole de Kronecker : 1 si i = j, 0 sinon).

**Theoreme 4.48 (Gram-Schmidt).** Toute famille libre finie peut etre orthonormalisee par le procede de Gram-Schmidt, qui produit une famille orthonormee engendrant le meme sous-espace.

**Algorithme de Gram-Schmidt.** A partir d'une famille libre (v_1, ..., v_n) :
1. w_1 = v_1, puis e_1 = w_1 / ||w_1||.
2. Pour k = 2, ..., n : w_k = v_k - Somme(i=1 a k-1) <v_k, e_i> * e_i, puis e_k = w_k / ||w_k||.

A chaque etape, on soustrait la projection de v_k sur l'espace deja construit, puis on normalise.

### 2. Matrices symetriques et endomorphismes auto-adjoints

**Definition 4.49.** Une matrice A dans M_n(R) est *symetrique* si A^T = A. L'endomorphisme associe f est dit *auto-adjoint* (ou *symetrique*) : <f(u), v> = <u, f(v)> pour tous u, v.

**Definition 4.50.** Une matrice A dans M_n(R) est *orthogonale* si A^T * A = A * A^T = I_n, c'est-a-dire A^{-1} = A^T. L'ensemble des matrices orthogonales forme le groupe orthogonal O(n). Les colonnes d'une matrice orthogonale forment une base orthonormee de R^n.

### 3. Theoreme spectral

**Theoreme 4.51 (Theoreme spectral reel).** Soit A dans M_n(R) une matrice symetrique. Alors :

1. Toutes les valeurs propres de A sont *reelles*.
2. Les sous-espaces propres associes a des valeurs propres distinctes sont *orthogonaux*.
3. A est *diagonalisable dans une base orthonormee*, c'est-a-dire qu'il existe une matrice orthogonale P (P^T = P^{-1}) et une matrice diagonale D telles que A = PDP^T.

*Preuve de (1) -- Valeurs propres reelles.*

Soit lambda une valeur propre (a priori dans C) et v dans C^n un vecteur propre associe (non nul). On a Av = lambda.v. Prenons le conjugue transpose : v_barre^T * A^T = lambda_barre * v_barre^T. Comme A est reelle et symetrique, A^T = A, donc v_barre^T * A = lambda_barre * v_barre^T.

Calculons v_barre^T * A * v de deux manieres :
- v_barre^T * (Av) = v_barre^T * (lambda.v) = lambda * v_barre^T * v = lambda * ||v||^2
- (v_barre^T * A) * v = (lambda_barre * v_barre^T) * v = lambda_barre * ||v||^2

Comme v != 0, ||v||^2 > 0, donc lambda = lambda_barre, ce qui signifie lambda dans R. QED.

*Preuve de (2) -- Orthogonalite des sous-espaces propres.*

Soient lambda != mu deux valeurs propres et u, v des vecteurs propres associes. On a :

lambda * <u, v> = <lambda.u, v> = <Au, v> = <u, A^T.v> = <u, Av> = <u, mu.v> = mu * <u, v>

Donc (lambda - mu) * <u, v> = 0. Comme lambda != mu, on a <u, v> = 0. QED.

**Exemple.** Diagonaliser A = (2 1 ; 1 2) dans une BON.

chi_A(lambda) = (2 - lambda)^2 - 1 = lambda^2 - 4*lambda + 3 = (lambda - 1)(lambda - 3).

Valeurs propres : lambda_1 = 1, lambda_2 = 3.

Sous-espaces propres :
- E_1 : (A - I)v = 0, soit (1 1 ; 1 1)(x ; y) = 0. Noyau : x + y = 0. v_1 = (1, -1)/sqrt(2).
- E_3 : (A - 3I)v = 0, soit (-1 1 ; 1 -1)(x ; y) = 0. Noyau : x = y. v_2 = (1, 1)/sqrt(2).

P = 1/sqrt(2) * (1 1 ; -1 1) est orthogonale. A = PDP^T avec D = diag(1, 3).

**Verification de l'orthogonalite :** <v_1, v_2> = (1*1 + (-1)*1)/2 = 0. Correct.

---

## VII. Applications en IA et cryptographie

### 1. Algebre lineaire et IA/ML

L'algebre lineaire est le langage fondamental de l'intelligence artificielle et du machine learning :

- **Reseaux de neurones.** Les couches d'un reseau de neurones sont des applications affines : y = Wx + b, ou W est une matrice de poids et b un vecteur de biais. L'entrainement (retropropagation) optimise ces matrices par descente de gradient. Toute l'algebre du gradient est lineaire.

- **Analyse en Composantes Principales (ACP/PCA).** On diagonalise la matrice de covariance (symetrique !) des donnees. Les vecteurs propres donnent les directions principales de variance, et les valeurs propres mesurent la variance dans chaque direction. Le theoreme spectral garantit que cette diagonalisation est toujours possible dans une BON. On projette ensuite les donnees sur les k premiers vecteurs propres (ceux de plus grande valeur propre) pour reduire la dimension.

- **Decomposition en Valeurs Singulieres (SVD).** Toute matrice A dans M_{m,n}(R) se decompose en A = U * Sigma * V^T, ou U et V sont orthogonales et Sigma est "diagonale" (rectangulaire). C'est une generalisation de la diagonalisation, fondamentale en compression d'images, systemes de recommandation (Netflix), et NLP (Latent Semantic Analysis).

- **Espaces de plongement (embeddings).** Les representations vectorielles de mots (Word2Vec, GloVe) ou de phrases (BERT) vivent dans des espaces vectoriels de grande dimension (typiquement R^300 ou R^768). La similarite entre mots est mesuree par le cosinus de l'angle entre vecteurs : cos(u, v) = <u, v> / (||u|| * ||v||).

### 2. Algebre lineaire et cryptographie

- **Codes correcteurs d'erreurs.** Les codes lineaires (comme les codes de Hamming) sont des sous-espaces vectoriels de F_2^n. La matrice generatrice G definit le code : C = {Gx | x dans F_2^k}. La matrice de controle de parite H verifie Hc = 0 pour tout mot de code c. La detection et la correction d'erreurs se ramenent a du calcul matriciel sur F_2.

- **Cryptographie basee sur les reseaux (lattice-based crypto).** La cryptographie post-quantique utilise la difficulte de certains problemes d'algebre lineaire sur Z : trouver le plus court vecteur d'un reseau (SVP), ou resoudre un systeme lineaire bruite (LWE : Learning With Errors). Ces problemes resistent aux algorithmes quantiques. Des schemas comme Kyber (CRYSTALS-Kyber, selectionne par le NIST) reposent sur ces fondements.

- **Hill cipher.** Chiffrement classique par blocs utilisant la multiplication matricielle dans Z/26Z : C = K * P mod 26, dechiffrement P = K^{-1} * C mod 26. La cle est une matrice inversible dans M_n(Z/26Z).

---

## VIII. Exercices de synthese

**Exercice 6.** Soit A = (0 1 1 ; 1 0 1 ; 1 1 0).
1. Calculer det(A).
2. Trouver les valeurs propres de A et les sous-espaces propres.
3. A est-elle diagonalisable ? Si oui, diagonaliser.

*Indication :* chi_A(lambda) = -lambda^3 + 3*lambda + 2 = -(lambda - 2)(lambda + 1)^2.

**Exercice 7.** Soit f : R^4 -> R^3 definie par f(x_1, x_2, x_3, x_4) = (x_1 + x_2 - x_3, 2x_1 + x_2 + x_4, x_1 - x_3 + x_4). Ecrire la matrice de f dans les bases canoniques. Calculer le rang de f et la dimension du noyau par le theoreme du rang. Donner une base de Ker(f).

**Exercice 8.** Montrer que si A est diagonalisable avec des valeurs propres toutes strictement positives, alors il existe une matrice B telle que B^2 = A (racine carree matricielle). (Indication : si A = PDP^{-1} avec D = diag(lambda_1, ..., lambda_n) et lambda_i > 0, poser B = P * diag(sqrt(lambda_1), ..., sqrt(lambda_n)) * P^{-1}.)

**Exercice 9.** Calculer A^{10} ou A = (1 1 ; 0 1). (Attention : A n'est pas diagonalisable. Ecrire A = I + N avec N = (0 1 ; 0 0) nilpotent (N^2 = 0). Alors A^{10} = (I + N)^{10} = Somme(k=0 a 10) C(10,k) * N^k = I + 10N = (1 10 ; 0 1), car N^k = 0 pour k >= 2.)

**Exercice 10 (Crypto -- Hill cipher).** On travaille dans Z/26Z. La matrice cle est K = (3 5 ; 7 2).
1. Verifier que K est inversible dans Z/26Z en calculant det(K) et en verifiant que det(K) est inversible mod 26.
2. Calculer K^{-1} mod 26.
3. Chiffrer le bigramme "HI" (H=7, I=8) avec K. Dechiffrer le resultat et verifier.

*Aide :* det(K) = 6 - 35 = -29 = -3 = 23 (mod 26). pgcd(23, 26) = 1, donc K est inversible. 23^{-1} mod 26 : 23 x 17 = 391 = 15 x 26 + 1, donc 23^{-1} = 17. K^{-1} = 17 * (2 -5 ; -7 3) mod 26 = (34 -85 ; -119 51) mod 26 = (8 19 ; 11 25).

---

## References

- S. Lang, *Introduction to Linear Algebra*, Springer.
- D. Perrin, *Cours d'algebre*, Ellipses (chapitres algebre lineaire).
- G. Strang, *Linear Algebra and Its Applications*, Thomson Brooks/Cole.
- G. Strang, *Introduction to Linear Algebra*, Wellesley-Cambridge Press.
- X. Gourdon, *Les maths en tete -- Algebre*, Ellipses.
- 3Blue1Brown, *Essence of Linear Algebra*, serie video (excellente visualisation geometrique).
- I. Goodfellow, Y. Bengio, A. Courville, *Deep Learning*, MIT Press (chapitre 2 sur l'algebre lineaire pour le ML).
- C. D. Meyer, *Matrix Analysis and Applied Linear Algebra*, SIAM.
- O. Regev, *On Lattices, Learning with Errors, Random Linear Codes, and Cryptography*, STOC 2005 (crypto post-quantique).
