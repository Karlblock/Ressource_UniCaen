# Chapitre 8 -- Series entieres et series de Fourier

## Objectifs du chapitre

- Maitriser les series entieres : rayon de convergence, proprietes sur le disque ouvert.
- Connaitre et appliquer le lemme d'Abel et le theoreme d'Abel radial.
- Savoir developper les fonctions usuelles en series entieres (DSE classiques).
- Resoudre des equations differentielles par la methode des series entieres.
- Comprendre les series de Fourier : coefficients, convergence ponctuelle (Dirichlet), convergence L^2.
- Enoncer et appliquer l'identite de Parseval et l'inegalite de Bessel.
- Voir les applications au traitement du signal, a la compression, a la FFT et a la cryptanalyse.

---

## 1. Series entieres

### 1.1 Definitions

**Definition 1.1 (Serie entiere)**
Une *serie entiere* est une serie de fonctions de la forme :

    sum_{n=0}^{+infini} a_n z^n

ou (a_n)_{n >= 0} est une suite de nombres complexes (les *coefficients*) et z est une variable complexe (ou reelle).

La *fonction somme*, definie la ou la serie converge, est :

    f(z) = sum_{n=0}^{+infini} a_n z^n

> Les series entieres generalisent les polynomes : un polynome de degre n est une serie entiere dont les coefficients a_k sont nuls pour k > n.

### 1.2 Rayon de convergence

**Definition 1.2 (Rayon de convergence)**
Le *rayon de convergence* de la serie entiere sum a_n z^n est :

    R = 1 / limsup_{n -> +infini} |a_n|^{1/n}

avec les conventions 1/0 = +infini et 1/(+infini) = 0. (C'est la *formule de Hadamard*.)

**Theoreme 1.1 (Lemme d'Abel)**
Si la suite (a_n * r_0^n) est bornee pour un certain r_0 > 0, alors la serie sum a_n z^n converge *absolument* pour tout |z| < r_0.

*Preuve :* Il existe M > 0 tel que |a_n * r_0^n| <= M pour tout n. Pour |z| < r_0, posons q = |z|/r_0 < 1. Alors :

    |a_n z^n| = |a_n r_0^n| * (|z|/r_0)^n <= M * q^n

La serie sum M*q^n est une serie geometrique convergente (q < 1). Par comparaison, sum |a_n z^n| converge. CQFD.

> **Remarque :** Le lemme d'Abel est le resultat fondateur de la theorie des series entieres. Il montre que la convergence "se propage" vers l'interieur : si on a convergence (ou meme simple bornitude du terme general) en un point, on a convergence absolue dans tout le disque ouvert correspondant.

**Theoreme 1.2 (Convergence et rayon)**
Soit R le rayon de convergence de sum a_n z^n.

- Pour |z| < R : la serie converge *absolument*.
- Pour |z| > R : la serie *diverge grossierement* (le terme general ne tend pas vers 0).
- Pour |z| = R : on ne peut pas conclure en general (etude au cas par cas).

L'ensemble {z in C : |z| < R} est le *disque ouvert de convergence*. Le cercle |z| = R est le *cercle de convergence*, ou tous les comportements sont possibles.

### 1.3 Calcul pratique du rayon de convergence

**Regle de d'Alembert :** Si a_n != 0 pour n assez grand et si |a_{n+1}/a_n| admet une limite L (finie ou infinie), alors R = 1/L.

*Preuve :* limsup |a_n|^{1/n} = lim |a_n|^{1/n} = L (quand le rapport converge, la racine aussi). CQFD.

**Regle de Cauchy-Hadamard :** R = 1/limsup |a_n|^{1/n}. C'est la definition exacte, toujours applicable.

> En pratique, la regle de d'Alembert est la plus utilisee car elle est facile a calculer. On utilise Hadamard quand le rapport n'a pas de limite.

**Exemple 1.1 :** sum z^n/n!.

    |a_{n+1}/a_n| = 1/(n+1) -> 0

Donc R = +infini. La serie converge pour tout z dans C, et sa somme est e^z.

**Exemple 1.2 :** sum n! * z^n.

    |a_{n+1}/a_n| = n+1 -> +infini

Donc R = 0. La serie ne converge qu'en z = 0.

**Exemple 1.3 :** sum z^n/n.

    |a_{n+1}/a_n| = n/(n+1) -> 1

Donc R = 1. Etude sur le cercle :
- z = 1 : sum 1/n diverge (serie harmonique).
- z = -1 : sum (-1)^n/n converge (Leibniz).
- z = e^{i*theta}, theta != 0 : converge (theoreme d'Abel-Dirichlet).

**Exemple 1.4 :** sum z^n/n^2. R = 1, et sum 1/n^2 converge, donc convergence absolue sur *tout* le cercle |z| = 1.

**Exemple 1.5 :** sum (2^n + 3^n) * z^n.

    a_n = 2^n + 3^n, donc |a_n|^{1/n} = (2^n + 3^n)^{1/n} -> 3

(car 3^n domine). Donc R = 1/3.

### 1.4 Operations sur les series entieres

**Proposition 1.1 (Somme et produit)**
Soient f(z) = sum a_n z^n (rayon R_a) et g(z) = sum b_n z^n (rayon R_b).

- *Somme :* sum (a_n + b_n) z^n a un rayon R >= min(R_a, R_b), et sa somme est f + g sur |z| < min(R_a, R_b).

- *Produit de Cauchy :* sum c_n z^n avec c_n = sum_{k=0}^{n} a_k * b_{n-k} a un rayon R >= min(R_a, R_b), et sa somme est f * g.

- *Multiplication par un scalaire :* sum (lambda * a_n) z^n a le meme rayon R_a.

**Proposition 1.2 (Composition)**
Si g(0) = 0 et |g(z)| < R_f pour |z| < R_g, alors f(g(z)) = sum a_n g(z)^n est une serie entiere.

### 1.5 Proprietes de la fonction somme

**Theoreme 1.3 (Regularite de la somme)**
Si R > 0, la fonction f(z) = sum_{n=0}^{+infini} a_n z^n est :

1. *Continue* sur le disque ouvert |z| < R.
2. De *classe C^infini* (indefiniment derivable) sur l'intervalle ]-R, R[ (cas reel).
3. Les derivees se calculent par *derivation terme a terme* :

        f'(z) = sum_{n=1}^{+infini} n * a_n * z^{n-1}

    et la serie derivee a le *meme rayon de convergence* R.

4. On peut *integrer terme a terme* :

        int_0^x f(t) dt = sum_{n=0}^{+infini} a_n * x^{n+1}/(n+1)

    et la serie integree a le meme rayon R.

*Preuve du meme rayon pour la derivee :*

    limsup |n * a_n|^{1/n} = limsup (n^{1/n} * |a_n|^{1/n}) = 1 * limsup |a_n|^{1/n}

car n^{1/n} -> 1. Donc le rayon est le meme. CQFD.

**Corollaire 1.1 (Identification des coefficients)**
Si f(z) = sum a_n z^n pour |z| < R, alors :

    a_n = f^{(n)}(0) / n!

C'est l'analogue de la formule de Taylor : les coefficients d'une serie entiere *sont* les coefficients de Taylor de sa somme.

> Consequence fondamentale : si f(z) = sum a_n z^n = sum b_n z^n sur un disque ouvert non vide, alors a_n = b_n pour tout n. Le developpement en serie entiere d'une fonction est *unique*.

### 1.6 Theoreme d'Abel radial

**Theoreme 1.4 (Abel radial)**
Si la serie sum a_n converge (c'est-a-dire si la serie entiere converge en z = 1), alors :

    lim_{x -> 1^-} sum_{n=0}^{+infini} a_n x^n = sum_{n=0}^{+infini} a_n

Autrement dit, la fonction somme f est continue a gauche en 1 si la serie converge en 1.

Plus generalement, si sum a_n z_0^n converge pour un z_0 avec |z_0| = R, alors f(z) -> sum a_n z_0^n quand z -> z_0 *radialement* (par l'interieur du disque).

*Preuve (esquisse) :* On pose R_n = sum_{k=n+1}^{+infini} a_k (restes de la serie). Par convergence, R_n -> 0. On ecrit :

    sum a_n x^n - sum a_n = sum a_n (x^n - 1) = ...

et on utilise une transformation d'Abel (sommation par parties) pour ramener l'estimation a la majoration des R_n. CQFD.

**Application classique 1 :** ln(1+x) = sum_{n=1}^{+infini} (-1)^{n+1} x^n/n pour |x| < 1. La serie converge en x = 1 (Leibniz). Par Abel radial :

    ln(2) = sum_{n=1}^{+infini} (-1)^{n+1}/n = 1 - 1/2 + 1/3 - 1/4 + ...

**Application classique 2 :** arctan(x) = sum_{n=0}^{+infini} (-1)^n x^{2n+1}/(2n+1) pour |x| < 1. Convergence en x = 1 (Leibniz). Par Abel :

    pi/4 = 1 - 1/3 + 1/5 - 1/7 + ...    (formule de Leibniz pour pi)

### 1.7 Series entieres et equations differentielles

**Methode :** On pose y(x) = sum a_n x^n, on substitue dans l'equation differentielle, on identifie les coefficients, et on obtient une relation de recurrence sur les a_n.

**Exemple 1.6 :** Resoudre y' = y avec y(0) = 1.

Posons y = sum a_n x^n. Alors y' = sum (n+1) a_{n+1} x^n. L'equation y' = y donne :

    (n+1) a_{n+1} = a_n, soit a_{n+1} = a_n/(n+1)

Avec a_0 = y(0) = 1, on obtient a_n = 1/n!. Donc y = sum x^n/n! = e^x. (Rayon R = +infini.)

**Exemple 1.7 :** Resoudre y'' + y = 0 avec y(0) = 1, y'(0) = 0.

Posons y = sum a_n x^n. Alors y'' = sum (n+2)(n+1) a_{n+2} x^n. L'equation donne :

    (n+2)(n+1) a_{n+2} + a_n = 0, soit a_{n+2} = -a_n / ((n+1)(n+2))

Avec a_0 = 1, a_1 = 0 : a_{2k} = (-1)^k/(2k)!, a_{2k+1} = 0.

Donc y = sum (-1)^k x^{2k}/(2k)! = cos(x). (Rayon R = +infini.)

---

## 2. Developpements en series entieres classiques

### 2.1 Exponentielle

    e^x = sum_{n=0}^{+infini} x^n / n! = 1 + x + x^2/2 + x^3/6 + ...    (R = +infini)

*Preuve :* f(x) = e^x verifie f^{(n)}(0) = 1 pour tout n. Le developpement de Taylor est sum x^n/n!. Le reste de Taylor-Lagrange : |R_n(x)| <= e^{|x|} * |x|^{n+1}/(n+1)! -> 0 pour tout x. Donc la serie converge vers e^x pour tout x. CQFD.

Plus generalement : e^{alpha*x} = sum (alpha*x)^n/n! = sum alpha^n * x^n/n!.

### 2.2 Sinus et cosinus

    cos(x) = sum_{n=0}^{+infini} (-1)^n x^{2n} / (2n)! = 1 - x^2/2 + x^4/24 - ...    (R = +infini)

    sin(x) = sum_{n=0}^{+infini} (-1)^n x^{2n+1} / (2n+1)! = x - x^3/6 + x^5/120 - ...    (R = +infini)

*Preuve :* Par les formules d'Euler : cos(x) = Re(e^{ix}) et sin(x) = Im(e^{ix}). En separant parties reelles et imaginaires dans e^{ix} = sum (ix)^n/n!, on retrouve ces developpements. CQFD.

### 2.3 Logarithme

    ln(1+x) = sum_{n=1}^{+infini} (-1)^{n+1} x^n / n = x - x^2/2 + x^3/3 - ...    (R = 1)

*Preuve :* On part de 1/(1+x) = sum_{n=0}^{+infini} (-1)^n x^n pour |x| < 1 (serie geometrique). On integre terme a terme de 0 a x :

    ln(1+x) = int_0^x 1/(1+t) dt = sum_{n=0}^{+infini} (-1)^n * x^{n+1}/(n+1) = sum_{n=1}^{+infini} (-1)^{n+1} x^n/n

CQFD. Convergence en x = 1 par Leibniz, et Abel radial donne ln(2) = 1 - 1/2 + 1/3 - ...

### 2.4 Serie geometrique et derivees

    1/(1-x) = sum_{n=0}^{+infini} x^n    (R = 1)

Par derivation :

    1/(1-x)^2 = sum_{n=1}^{+infini} n * x^{n-1} = sum_{n=0}^{+infini} (n+1) * x^n    (R = 1)

Par derivation k-ieme et division par k! :

    1/(1-x)^{k+1} = sum_{n=0}^{+infini} C(n+k, k) * x^n    (R = 1)

### 2.5 Arctangente

    arctan(x) = sum_{n=0}^{+infini} (-1)^n * x^{2n+1} / (2n+1) = x - x^3/3 + x^5/5 - ...    (R = 1)

*Preuve :* arctan'(x) = 1/(1+x^2) = sum_{n=0}^{+infini} (-1)^n x^{2n} pour |x| < 1. On integre de 0 a x. CQFD.

### 2.6 Serie du binome generalise

Pour alpha dans R (non entier naturel) :

    (1+x)^alpha = sum_{n=0}^{+infini} C(alpha, n) * x^n    (R = 1)

ou C(alpha, n) = alpha*(alpha-1)*...*(alpha-n+1)/n! est le *coefficient binomial generalise*.

**Cas particuliers importants :**
- alpha = -1 : 1/(1+x) = sum (-1)^n x^n.
- alpha = 1/2 : sqrt(1+x) = 1 + x/2 - x^2/8 + x^3/16 - ...
- alpha = -1/2 : 1/sqrt(1+x) = 1 - x/2 + 3x^2/8 - 5x^3/16 + ...

### 2.7 Fonctions hyperboliques

    ch(x) = sum_{n=0}^{+infini} x^{2n} / (2n)! = 1 + x^2/2 + x^4/24 + ...    (R = +infini)

    sh(x) = sum_{n=0}^{+infini} x^{2n+1} / (2n+1)! = x + x^3/6 + x^5/120 + ...    (R = +infini)

(Ce sont les parties paire et impaire de e^x, a normalisation pres.)

### 2.8 Tableau recapitulatif des DSE classiques

    | Fonction        | DSE en 0                              | Rayon  |
    |-----------------|---------------------------------------|--------|
    | e^x             | sum x^n/n!                            | +infini|
    | cos(x)          | sum (-1)^n x^{2n}/(2n)!              | +infini|
    | sin(x)          | sum (-1)^n x^{2n+1}/(2n+1)!          | +infini|
    | ch(x)           | sum x^{2n}/(2n)!                      | +infini|
    | sh(x)           | sum x^{2n+1}/(2n+1)!                  | +infini|
    | 1/(1-x)         | sum x^n                               | 1      |
    | ln(1+x)         | sum (-1)^{n+1} x^n/n                  | 1      |
    | arctan(x)       | sum (-1)^n x^{2n+1}/(2n+1)           | 1      |
    | (1+x)^alpha     | sum C(alpha,n) x^n                    | 1      |

> **Methode :** Pour trouver le DSE d'une fonction, on ne developpe presque jamais directement par Taylor. On part des DSE classiques et on utilise les operations : somme, produit, composition, derivation, integration, substitution x -> x^2, etc.

---

## 3. Series de Fourier

### 3.1 Motivation et contexte

**Idee centrale :** Toute fonction periodique "raisonnable" peut etre decomposee en somme (infinie) de fonctions sinusoidales. C'est la *decomposition en serie de Fourier*, outil fondamental en traitement du signal, en physique et en mathematiques.

Historiquement, Fourier a affirme (vers 1807) que toute fonction pouvait etre representee ainsi. Preciser les conditions exactes de convergence a necessite plus d'un siecle de travaux (Dirichlet, Riemann, Lebesgue, Carleson).

### 3.2 Fonctions periodiques et produit scalaire L^2

**Definition 3.1**
On note C_{2pi} l'ensemble des fonctions f : R -> C continues et 2pi-periodiques. Plus generalement, on considere les fonctions 2pi-periodiques *continues par morceaux* (CPM).

**Definition 3.2 (Produit scalaire hermitien)**
Sur l'espace des fonctions 2pi-periodiques CPM, on definit le produit scalaire :

    <f, g> = (1/2pi) * int_{-pi}^{pi} f(t) * conjugue(g(t)) dt

La norme associee est :

    ||f||_2 = sqrt(<f, f>) = sqrt((1/2pi) * int_{-pi}^{pi} |f(t)|^2 dt)

> ||f||_2 a une interpretation physique : c'est la *valeur efficace* du signal f (racine de la puissance moyenne).

### 3.3 Systeme trigonometrique

Les fonctions e_n(t) = e^{i*n*t} pour n dans Z forment un *systeme orthonorme* pour le produit scalaire ci-dessus :

    <e_n, e_m> = (1/2pi) * int_{-pi}^{pi} e^{i*(n-m)*t} dt = delta_{n,m}

(delta de Kronecker : 1 si n = m, 0 sinon).

*Preuve :* Si n != m, int_{-pi}^{pi} e^{i*(n-m)*t} dt = [e^{i*(n-m)*t}/(i*(n-m))]_{-pi}^{pi} = 0 (car e^{i*k*pi} = e^{-i*k*pi} pour k entier). Si n = m, int = 2pi. CQFD.

**Forme reelle :** Le systeme {1, cos(nt), sin(nt) : n >= 1} est orthogonal pour le produit scalaire reel (1/pi) * int_{-pi}^{pi} f(t)*g(t) dt, avec les normes :

    ||1||^2 = 2,    ||cos(nt)||^2 = 1,    ||sin(nt)||^2 = 1

### 3.4 Coefficients de Fourier

**Definition 3.3 (Coefficients de Fourier complexes)**
Soit f une fonction 2pi-periodique integrable. Les *coefficients de Fourier* de f sont :

    c_n(f) = <f, e_n> = (1/2pi) * int_{-pi}^{pi} f(t) * e^{-i*n*t} dt    pour n dans Z

**Definition 3.4 (Coefficients de Fourier reels)**

    a_0 = (1/pi) * int_{-pi}^{pi} f(t) dt = 2*c_0

    a_n = (1/pi) * int_{-pi}^{pi} f(t) * cos(n*t) dt    pour n >= 1

    b_n = (1/pi) * int_{-pi}^{pi} f(t) * sin(n*t) dt    pour n >= 1

**Relation entre les deux :** c_n = (a_n - i*b_n)/2 et c_{-n} = (a_n + i*b_n)/2 pour n >= 1, et c_0 = a_0/2.

**Definition 3.5 (Serie de Fourier)**
La *serie de Fourier* de f est :

    S(f)(t) = sum_{n=-infini}^{+infini} c_n * e^{i*n*t} = a_0/2 + sum_{n=1}^{+infini} (a_n*cos(n*t) + b_n*sin(n*t))

La question fondamentale : cette serie converge-t-elle, et si oui, vers f ?

### 3.5 Proprietes des coefficients de Fourier

**Proposition 3.1 (Linearite)**
c_n(alpha*f + beta*g) = alpha*c_n(f) + beta*c_n(g).

**Proposition 3.2 (Parite)**
- Si f est *paire* : b_n = 0 pour tout n (serie en cosinus uniquement).
- Si f est *impaire* : a_n = 0 pour tout n, y compris a_0 (serie en sinus uniquement).

> La parite simplifie considerablement les calculs : il suffit d'integrer sur [0, pi] au lieu de [-pi, pi].

**Proposition 3.3 (Translation et derivation)**
- Si g(t) = f(t - t_0), alors c_n(g) = e^{-i*n*t_0} * c_n(f). (Decalage temporel = dephasage.)
- Si f est C^1 et 2pi-periodique, alors c_n(f') = i*n * c_n(f).

*Preuve (derivation) :* Par integration par parties :

    c_n(f') = (1/2pi) * int_{-pi}^{pi} f'(t) * e^{-int} dt
            = [f(t)*e^{-int}/(2pi)]_{-pi}^{pi} + (in/2pi) * int_{-pi}^{pi} f(t) * e^{-int} dt

Le crochet s'annule par periodicite (f(pi) = f(-pi) et e^{-in*pi} = e^{in*pi}). Donc c_n(f') = in * c_n(f). CQFD.

**Corollaire 3.1 (Decroissance des coefficients)**
Si f est C^k et 2pi-periodique, alors c_n(f^{(k)}) = (in)^k * c_n(f), donc :

    |c_n(f)| = |c_n(f^{(k)})| / |n|^k

Par Riemann-Lebesgue (c_n -> 0), on a c_n(f) = o(1/|n|^k) quand |n| -> +infini.

> **Interpretation :** Plus une fonction est reguliere, plus ses coefficients de Fourier decroissent vite. C'est le fondement mathematique de la compression de signaux lisses.

**Theoreme 3.1 (Lemme de Riemann-Lebesgue)**
Si f est integrable et 2pi-periodique, alors c_n(f) -> 0 quand |n| -> +infini.

### 3.6 Calcul de coefficients : exemples detailles

**Exemple 3.1 : Fonction creneau (signal carre).**
f(t) = 1 si 0 < t < pi, f(t) = -1 si -pi < t < 0 (prolongee par periodicite).

f est impaire, donc a_n = 0 pour tout n.

    b_n = (1/pi) * int_{-pi}^{pi} f(t)*sin(n*t) dt
        = (2/pi) * int_0^{pi} sin(n*t) dt     (f paire * sin impaire)
        = (2/pi) * [-cos(n*t)/n]_0^{pi}
        = (2/(n*pi)) * (1 - cos(n*pi))
        = (2/(n*pi)) * (1 - (-1)^n)

Donc b_n = 0 si n pair, et b_n = 4/(n*pi) si n impair.

    S(f)(t) = (4/pi) * sum_{k=0}^{+infini} sin((2k+1)*t) / (2k+1)
            = (4/pi) * (sin(t) + sin(3t)/3 + sin(5t)/5 + ...)

En evaluant en t = pi/2 : f(pi/2) = 1, et sin((2k+1)*pi/2) = (-1)^k. Donc :

    1 = (4/pi) * sum_{k=0}^{+infini} (-1)^k/(2k+1)

soit pi/4 = 1 - 1/3 + 1/5 - 1/7 + ... (on retrouve la formule de Leibniz).

**Exemple 3.2 : Fonction dent de scie.**
f(t) = t sur ]-pi, pi[ (prolongee par periodicite).

f est impaire, donc a_n = 0. Par IPP :

    b_n = (2/pi) * int_0^{pi} t*sin(n*t) dt = (2/pi) * ([-t*cos(nt)/n]_0^{pi} + int_0^{pi} cos(nt)/n dt)
        = (2/pi) * (-pi*cos(n*pi)/n + [sin(nt)/n^2]_0^{pi})
        = (2/pi) * (-pi*(-1)^n/n + 0)
        = 2*(-1)^{n+1}/n

    S(f)(t) = 2 * sum_{n=1}^{+infini} (-1)^{n+1} * sin(n*t) / n

**Exemple 3.3 : Fonction |t|.**
f(t) = |t| sur [-pi, pi] (prolongee par periodicite). f est paire, donc b_n = 0.

    a_0 = (1/pi) * int_{-pi}^{pi} |t| dt = (2/pi) * int_0^{pi} t dt = pi

    a_n = (2/pi) * int_0^{pi} t*cos(nt) dt     (pour n >= 1)
        = (2/pi) * ([t*sin(nt)/n]_0^{pi} - int_0^{pi} sin(nt)/n dt)
        = (2/pi) * (0 + [cos(nt)/n^2]_0^{pi})
        = (2/(pi*n^2)) * ((-1)^n - 1)

Donc a_n = 0 si n pair, a_n = -4/(pi*n^2) si n impair.

    S(f)(t) = pi/2 - (4/pi) * sum_{k=0}^{+infini} cos((2k+1)*t) / (2k+1)^2

En evaluant en t = 0 : f(0) = 0 = pi/2 - (4/pi) * sum 1/(2k+1)^2, d'ou :

    sum_{k=0}^{+infini} 1/(2k+1)^2 = pi^2/8

Et comme sum 1/n^2 = sum 1/(2k)^2 + sum 1/(2k+1)^2 = (1/4)*sum 1/n^2 + pi^2/8, on trouve :

    sum_{n=1}^{+infini} 1/n^2 = pi^2/6    (formule de Bale)

---

## 4. Convergence des series de Fourier

### 4.1 Theoreme de Dirichlet

**Theoreme 4.1 (Dirichlet)**
Soit f une fonction 2pi-periodique, continue par morceaux, admettant en tout point des *limites laterales* f(t^-) et f(t^+) et des *derivees laterales*. Alors la serie de Fourier de f converge en tout point t, et :

    S(f)(t) = (f(t^+) + f(t^-)) / 2

En particulier :
- Aux points de *continuite* : S(f)(t) = f(t).
- Aux points de *discontinuite* : S(f)(t) = la *moyenne* des limites laterales.

> Les conditions de Dirichlet sont satisfaites par toutes les fonctions "raisonnables" en pratique (signaux physiques, fonctions construites par morceaux a partir de fonctions derivables).

### 4.2 Phenomene de Gibbs

Aux points de discontinuite, les sommes partielles de la serie de Fourier presentent un depassement (*overshoot*) d'environ **9%** de l'amplitude du saut. Ce depassement ne diminue pas quand on augmente le nombre de termes : il se rapproche simplement du point de discontinuite.

Plus precisement, si le saut est de hauteur h, le depassement maximal est :

    h/pi * int_0^{pi} sin(t)/t dt - h/2 ≈ 0.0895 * h

C'est le *phenomene de Gibbs*, important en traitement du signal (il explique le *ringing* aux bords vifs dans les images compressees, et les artefacts dans les filtres numeriques).

### 4.3 Convergence en norme L^2

**Theoreme 4.2 (Convergence en moyenne quadratique)**
Si f est 2pi-periodique et CPM, alors :

    ||f - S_N(f)||_2 -> 0 quand N -> +infini

ou S_N(f) = sum_{n=-N}^{N} c_n * e^{int} est la somme partielle d'ordre N.

> La convergence L^2 est *plus faible* que la convergence ponctuelle partout, mais *plus forte* que la convergence en probabilite (au sens de la norme). Elle signifie que l'erreur quadratique moyenne tend vers 0.

### 4.4 Convergence normale

**Theoreme 4.3**
Si f est 2pi-periodique et de classe C^1 (ou plus generalement si sum |c_n| < +infini), alors la serie de Fourier converge *normalement* (donc uniformement) vers f.

*Preuve :* ||c_n * e^{int}||_infini = |c_n|. Si sum |c_n| < +infini, la convergence normale est immediate.

Pour f de classe C^1 : par la relation c_n(f') = in*c_n(f), on a |c_n(f)| = |c_n(f')|/|n| pour n != 0. Par Parseval (applique a f'), sum |c_n(f')|^2 < +infini. Par Cauchy-Schwarz :

    sum_{n != 0} |c_n(f)| = sum |c_n(f')|/|n| <= (sum |c_n(f')|^2)^{1/2} * (sum 1/n^2)^{1/2} < +infini

CQFD.

---

## 5. Identite de Parseval

### 5.1 Egalite de Bessel-Parseval

**Theoreme 5.1 (Identite de Parseval)**
Si f est 2pi-periodique et CPM :

    (1/2pi) * int_{-pi}^{pi} |f(t)|^2 dt = sum_{n=-infini}^{+infini} |c_n|^2

En termes de coefficients reels (pour f a valeurs reelles) :

    (1/pi) * int_{-pi}^{pi} f(t)^2 dt = a_0^2/2 + sum_{n=1}^{+infini} (a_n^2 + b_n^2)

**Interpretation physique :** L'*energie totale* du signal f est egale a la somme des *energies* de ses composantes frequentielles. Aucune energie n'est perdue dans la decomposition. C'est un theoreme de *conservation de l'energie spectrale*.

> En termes de la norme L^2 : ||f||_2^2 = sum |c_n|^2. C'est l'analogue du theoreme de Pythagore dans un espace de dimension infinie : la norme au carre d'un vecteur est la somme des carres de ses composantes dans une base orthonormee.

### 5.2 Inegalite de Bessel

**Theoreme 5.2 (Bessel)**
Pour toute fonction integrable 2pi-periodique et pour tout N :

    sum_{n=-N}^{N} |c_n|^2 <= (1/2pi) * int_{-pi}^{pi} |f(t)|^2 dt

C'est une consequence de ||f - S_N(f)||_2^2 >= 0 et de l'orthogonalite. L'egalite a la limite N -> +infini est precisement Parseval.

### 5.3 Applications numeriques

**Application 1 (somme des 1/n^2) :** A partir du developpement de f(t) = t sur ]-pi, pi[ (Exemple 3.2) : b_n = 2*(-1)^{n+1}/n, a_n = 0.

Par Parseval :

    (1/pi) * int_{-pi}^{pi} t^2 dt = sum_{n=1}^{+infini} b_n^2 = sum 4/n^2

Or (1/pi) * int_{-pi}^{pi} t^2 dt = (1/pi) * 2*pi^3/3 = 2*pi^2/3.

Donc sum 4/n^2 = 2*pi^2/3, soit **sum 1/n^2 = pi^2/6**.

**Application 2 (somme des 1/n^4) :** A partir du developpement de f(t) = t^2 sur [-pi, pi] (exercice), on peut montrer par Parseval que **sum 1/n^4 = pi^4/90**.

---

## 6. Applications

### 6.1 Traitement du signal

La decomposition de Fourier est au coeur du traitement numerique du signal.

**Spectre :** Le graphe de |c_n|^2 en fonction de n est le *spectre de puissance* du signal. Il indique la repartition de l'energie par frequence.

**Filtrage :** Un filtre lineaire invariant dans le temps (LIT) modifie les coefficients de Fourier multiplicativement : si l'entree est f avec coefficients c_n, la sortie a pour coefficients H(n)*c_n, ou H est la *fonction de transfert* du filtre.

- *Filtre passe-bas :* H(n) = 0 pour |n| > N. Supprime les hautes frequences (bruit).
- *Filtre passe-haut :* H(n) = 0 pour |n| < N. Supprime les basses frequences.
- *Filtre passe-bande :* H(n) != 0 seulement pour N_1 <= |n| <= N_2.

**Theoreme de Shannon-Nyquist :** Pour echantillonner un signal de bande passante B Hz sans perte d'information, il faut echantillonner a une frequence >= 2B (frequence de Nyquist). En dessous, il y a *aliasing* (repliement de spectre).

### 6.2 Compression de donnees

La plupart des signaux naturels (son, image) ont un spectre ou l'essentiel de l'energie est concentre dans un petit nombre de coefficients. Le principe de la compression par transformation :

1. Calculer la decomposition spectrale (Fourier, DCT, ondelettes).
2. Ne garder que les K coefficients les plus significatifs (seuillage).
3. Quantifier et encoder ces coefficients.
4. Pour la decompression, reconstituer une approximation du signal.

**JPEG :** Utilise la *transformee en cosinus discrete* (DCT), variante de la serie de Fourier adaptee aux signaux non periodiques, sur des blocs 8x8 pixels.

**MP3 :** Decomposition du signal audio en bandes de frequences par banc de filtres, quantification adaptative basee sur un modele psychoacoustique (les frequences inaudibles sont supprimees).

> **Lien avec Parseval :** La compression fonctionne parce que Parseval garantit que l'energie negligee (les petits coefficients) est petite. L'erreur de reconstruction en norme L^2 est sum des |c_n|^2 des coefficients supprimes.

### 6.3 Transformee de Fourier discrete (DFT) et FFT

Pour un signal discret (x_0, x_1, ..., x_{N-1}), la *transformee de Fourier discrete* est :

    X_k = sum_{n=0}^{N-1} x_n * e^{-2*pi*i*k*n/N}    pour k = 0, ..., N-1

L'inverse :

    x_n = (1/N) * sum_{k=0}^{N-1} X_k * e^{2*pi*i*k*n/N}

Le calcul direct de la DFT coute O(N^2) operations.

**FFT (Fast Fourier Transform, Cooley-Tukey 1965).**

L'idee geniale : decomposer la DFT de taille N = 2^m en deux DFT de taille N/2 (indices pairs et impairs), puis recombiner.

Posons W = e^{-2*pi*i/N}. Alors :

    X_k = sum_{n pair} x_n * W^{kn} + sum_{n impair} x_n * W^{kn}
        = sum_{j=0}^{N/2-1} x_{2j} * W^{2kj} + W^k * sum_{j=0}^{N/2-1} x_{2j+1} * W^{2kj}
        = E_k + W^k * O_k

ou E_k et O_k sont des DFT de taille N/2. Par recurrence :

    Complexite : T(N) = 2*T(N/2) + O(N), donc T(N) = O(N * log N)

Le gain est enorme : pour N = 2^{20} ≈ 10^6, la FFT est environ 50000 fois plus rapide que la DFT directe.

### 6.4 Cryptanalyse et analyse frequentielle

**Analyse frequentielle classique :** Le chiffrement par substitution monoalphabetique preserve la distribution des frequences des lettres. En comparant le spectre des frequences du texte chiffre au spectre connu de la langue claire, on retrouve la substitution.

**Chiffre de Vigenere :** La cle de longueur L introduit une periodicite. L'*indice de coincidence* mesure cette periodicite. On peut aussi voir l'analyse comme une detection de frequence dans un signal periodique :

- On calcule la frequence d'apparition de chaque lettre en ne gardant qu'une lettre sur k.
- Pour k = L (longueur de la cle), le spectre ressemble a celui de la langue claire.
- Pour k != L, le spectre est plat (melange de plusieurs distributions decalees).

C'est une application directe de l'analyse de Fourier discrete aux suites de symboles.

**Attaques par canaux auxiliaires (SCA) :**

L'analyse de courant (DPA, Differential Power Analysis) et l'analyse electromagnetique (EMA) utilisent massivement la FFT :

1. On collecte N traces de consommation de courant pendant des operations cryptographiques.
2. On calcule la FFT de chaque trace pour passer dans le domaine frequentiel.
3. On isole les composantes correlees a l'activite cryptographique (frequence d'horloge et harmoniques).
4. On filtre le bruit haute frequence et les interferences basse frequence.
5. On calcule la correlation entre les traces filtrees et un modele de consommation lie a une hypothese de cle.

La FFT est aussi utilisee dans les attaques par *templates* pour reduire la dimensionnalite des traces.

### 6.5 Sequences periodiques et LFSR

Les sequences generees par les LFSR (chapitre 5) sont periodiques. Leur spectre de Fourier discret (sur F_2 ou plus generalement sur F_q) est directement lie aux proprietes du polynome de retroaction.

La *complexite lineaire* d'une sequence periodique de periode T est la taille du plus petit LFSR qui la genere. En termes spectraux, c'est le nombre de composantes frequentielles non nulles dans la DFT de la sequence.

---

## 7. Exercices de comprehension

**Exercice 1 (Rayon de convergence)**
Determiner le rayon de convergence et le domaine de convergence des series entieres :
a) sum n^2 * x^n.
b) sum x^n / (n^2 + 1).
c) sum (2^n + 3^n) * x^n.
d) sum (n! / n^n) * x^n. (Utiliser Stirling : n! ~ sqrt(2*pi*n) * (n/e)^n.)

**Exercice 2 (DSE par operations)**
A partir des DSE classiques, determiner le DSE en 0 et le rayon de convergence de :
a) f(x) = x / (1 + x^2).
b) f(x) = ln((1+x)/(1-x)).
c) f(x) = arctan(x) / x.
d) f(x) = 1/(1-x)^3.

**Exercice 3 (Abel radial)**
a) En utilisant le DSE de ln(1+x) et le theoreme d'Abel, prouver que ln(2) = 1 - 1/2 + 1/3 - 1/4 + ...
b) En utilisant le DSE de arctan(x), prouver la formule de Leibniz : pi/4 = 1 - 1/3 + 1/5 - 1/7 + ...
c) En utilisant le DSE de (1+x)^{-1/2} et l'integration, montrer que arcsin(x) = sum C(2n,n) x^{2n+1} / (4^n*(2n+1)).

**Exercice 4 (Resolution d'EDO par DSE)**
a) Resoudre y'' + y = 0, y(0) = 1, y'(0) = 0 par la methode des series entieres. Retrouver y = cos(x).
b) Resoudre y'' - y = 0, y(0) = 0, y'(0) = 1. Retrouver y = sh(x).
c) Resoudre l'equation d'Airy y'' - x*y = 0 par DSE. Determiner le rayon de convergence.

**Exercice 5 (Coefficients de Fourier)**
Calculer les coefficients de Fourier de :
a) f(t) = t^2 sur [-pi, pi] (prolongee par periodicite). (f paire, donc serie en cosinus.)
b) f(t) = |sin(t)|. (f paire et pi-periodique.)
En deduire, par Parseval applique a la question a), la valeur de sum 1/n^4.

**Exercice 6 (Dirichlet et convergence)**
Soit f la fonction 2pi-periodique definie par f(t) = e^t sur ]-pi, pi].
a) Calculer les coefficients de Fourier c_n(f).
b) En quels points la serie de Fourier converge-t-elle vers f(t) ? Vers quelle valeur converge-t-elle en t = pi ?
c) Appliquer Parseval pour calculer sum 1/(1+n^2).

**Exercice 7 (Parseval et sommation)**
a) A partir du developpement de f(t) = t sur ]-pi, pi[, retrouver sum 1/n^2 = pi^2/6.
b) A partir du developpement de f(t) = t^2, montrer que sum 1/n^4 = pi^4/90.
c) Peut-on calculer sum 1/n^6 par la meme methode ? (Indication : utiliser f(t) = t^3.)

**Exercice 8 (FFT et complexite)**
a) Calculer a la main la DFT du signal x = (1, 0, 1, 0) (N = 4).
b) Verifier le resultat en calculant la DFT inverse pour retrouver x.
c) Expliquer le principe de decomposition de Cooley-Tukey pour N = 8 = 2^3. Combien d'operations elementaires economise-t-on par rapport au calcul direct ?

**Exercice 9 (Application a la cryptanalyse)**
Un texte chiffre par Vigenere a ete intercepte. On calcule la frequence de chaque lettre dans le sous-texte obtenu en ne gardant qu'une lettre sur k.
a) Pour quelle valeur de k le spectre des frequences ressemble-t-il a celui du francais ? Qu'en deduit-on sur la longueur de la cle ?
b) Expliquer le lien avec la periodicite et l'analyse de Fourier discrete.
c) L'indice de coincidence IC = sum p_i^2 (ou p_i est la frequence de la i-eme lettre) est lie a l'*energie* du spectre des frequences. Expliquer ce lien via Parseval.

**Exercice 10 (Phenomene de Gibbs)**
On considere la fonction creneau (Exemple 3.1).
a) Calculer et tracer les sommes partielles S_1(f), S_3(f), S_5(f) en quelques points.
b) Observer le depassement pres de t = 0. Montrer que le maximum de S_N(f) pres de 0 converge vers (2/pi) * int_0^{pi} sin(t)/t dt ≈ 1.179, soit un depassement d'environ 9% au-dessus de la valeur 1 de f.
c) Discuter l'impact du phenomene de Gibbs sur la compression d'images (artefacts JPEG aux bords vifs).

---

## 8. References

- **Gourdon, X.** *Les Maths en Tete -- Analyse.* Ellipses.
- **Zuily, C. & Queffelec, H.** *Analyse pour l'agregation.* Dunod.
- **Gasquet, C. & Witomski, P.** *Analyse de Fourier et applications.* Dunod. (Reference francophone majeure.)
- **Oppenheim, A. & Willsky, A.** *Signals and Systems.* Prentice Hall. (La reference en traitement du signal.)
- **Cooley, J.W. & Tukey, J.W.** *An Algorithm for the Machine Calculation of Complex Fourier Series.* Mathematics of Computation, 1965. (Article fondateur de la FFT.)
- **Kocher, P., Jaffe, J., Jun, B.** *Differential Power Analysis.* CRYPTO 1999. (Pour les applications en cryptanalyse par canaux auxiliaires.)
- **Strang, G.** *Computational Science and Engineering.* Wellesley-Cambridge Press. (Approche numerique de Fourier, excellente pedagogie.)
- Programme officiel MP2I/MPI pour les series entieres et de Fourier.
