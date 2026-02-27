# Chapitre 5 -- Logique, langages formels et automates

## Objectifs du chapitre

- Maitriser le calcul propositionnel : syntaxe, semantique, tables de verite, formes normales
- Comprendre le probleme SAT et les algorithmes de resolution (Quine, DPLL)
- Connaitre les regles de deduction naturelle
- Maitriser les expressions regulieres et leur lien avec les automates
- Comprendre les automates finis deterministes (DFA) et non deterministes (NFA)
- Savoir determiniser et minimiser un automate
- Connaitre les grammaires non contextuelles et les arbres de derivation
- Appliquer ces concepts au parsing et a la validation

---

## 1. Calcul propositionnel

### 1.1 Syntaxe

Le calcul propositionnel manipule des **formules** construites a partir de :

- **Variables propositionnelles** : p, q, r, ... (chacune vaut vrai ou faux)
- **Connecteurs logiques** :
  - Negation : non p (note ~p)
  - Conjonction : p ET q (note p /\ q)
  - Disjonction : p OU q (note p \/ q)
  - Implication : p => q
  - Equivalence : p <=> q

**Grammaire BNF :**

```text
formule ::= variable
           | ~formule
           | formule /\ formule
           | formule \/ formule
           | formule => formule
           | formule <=> formule
           | (formule)
```

**Priorite des connecteurs** (du plus fort au plus faible) : ~, /\, \/, =>, <=>

Ainsi `p \/ q /\ r` se lit `p \/ (q /\ r)` et non `(p \/ q) /\ r`.

### 1.2 Semantique

Une **valuation** (ou interpretation) est une fonction v : Variables -> {Vrai, Faux}.

La valeur de verite d'une formule sous une valuation est definie recursivement :

- v(~F) = Vrai ssi v(F) = Faux
- v(F /\ G) = Vrai ssi v(F) = Vrai et v(G) = Vrai
- v(F \/ G) = Vrai ssi v(F) = Vrai ou v(G) = Vrai
- v(F => G) = Faux ssi v(F) = Vrai et v(G) = Faux (equivalemment : ~F \/ G)
- v(F <=> G) = Vrai ssi v(F) = v(G)

**Point important :** l'implication `F => G` est **vraie** quand F est faux, quelle que soit la valeur de G. C'est l'implication materielle, qui differe de l'intuition quotidienne.

### 1.3 Tables de verite

```python
from itertools import product

def table_verite(variables, formule):
    """
    Genere la table de verite d'une formule propositionnelle.
    variables : liste de noms de variables
    formule : fonction Python prenant un dict {var: bool} et retournant bool
    """
    n = len(variables)
    print(" | ".join(variables) + " | Resultat")
    print("-" * (6 * n + 12))

    for valeurs in product([False, True], repeat=n):
        valuation = dict(zip(variables, valeurs))
        resultat = formule(valuation)
        vals = " | ".join(["V" if v else "F" for v in valeurs])
        res = "V" if resultat else "F"
        print(f"{vals} |    {res}")

# Exemple : verifier que (p => q) <=> (~p \/ q)
def equiv_impl(v):
    p, q = v['p'], v['q']
    impl = (not p) or q         # p => q
    disj = (not p) or q         # ~p \/ q
    return impl == disj         # <=>

table_verite(['p', 'q'], equiv_impl)
```

Resultat : toutes les lignes donnent Vrai. C'est une **tautologie** : l'implication est bien equivalente a ~p \/ q.

### 1.4 Concepts fondamentaux

- **Tautologie** : formule vraie sous toute valuation. Ex : p \/ ~p (tiers exclu)
- **Contradiction** : formule fausse sous toute valuation. Ex : p /\ ~p
- **Satisfaisable** : vraie sous au moins une valuation
- **Consequence logique** : G est consequence de F1, ..., Fn si toute valuation satisfaisant toutes les Fi satisfait aussi G. On note F1, ..., Fn |= G.
- **Equivalence logique** : F et G sont equivalentes (F <=> G est une tautologie) ssi elles ont les memes valuations satisfaisantes

### 1.5 Equivalences fondamentales

```text
Lois de De Morgan :    ~(p /\ q)  <=>  ~p \/ ~q
                       ~(p \/ q)  <=>  ~p /\ ~q

Double negation :      ~~p  <=>  p

Distributivite :       p /\ (q \/ r)  <=>  (p /\ q) \/ (p /\ r)
                       p \/ (q /\ r)  <=>  (p \/ q) /\ (p \/ r)

Absorption :           p /\ (p \/ q)  <=>  p
                       p \/ (p /\ q)  <=>  p

Implication :          p => q  <=>  ~p \/ q

Contraposee :          p => q  <=>  ~q => ~p

Exportation :          (p /\ q) => r  <=>  p => (q => r)
```

Ces equivalences sont fondamentales pour les transformations en formes normales.

### 1.6 Formes normales

**Litteraux :** une variable p ou sa negation ~p.

**Clause** : disjonction de litteraux. Ex : p \/ ~q \/ r.

**Forme Normale Conjonctive (CNF)** : conjonction de clauses.
Ex : (p \/ ~q) /\ (~p \/ r) /\ (q \/ r).

**Forme Normale Disjonctive (DNF)** : disjonction de conjonctions de litteraux.
Ex : (p /\ q) \/ (~p /\ r) \/ (q /\ ~r).

**Toute formule est equivalente a une formule en CNF et a une formule en DNF.**

**Conversion en CNF par tables de verite :**

```python
def vers_cnf(variables, formule):
    """
    Convertit une formule en CNF par la methode des tables de verite.
    Pour chaque ligne FALSE, on cree une clause qui l'interdit.
    """
    clauses = []
    for valeurs in product([False, True], repeat=len(variables)):
        valuation = dict(zip(variables, valeurs))
        if not formule(valuation):
            # Creer une clause qui interdit cette valuation
            clause = []
            for var, val in zip(variables, valeurs):
                if val:
                    clause.append(f"~{var}")   # variable est True => nier
                else:
                    clause.append(var)          # variable est False => garder
            clauses.append(" \\/ ".join(clause))

    if not clauses:
        return "TAUTOLOGIE"
    return " /\\ ".join([f"({c})" for c in clauses])

# Exemple : p => q
def impl(v):
    return (not v['p']) or v['q']

print("CNF de (p => q):", vers_cnf(['p', 'q'], impl))
# (~p \/ q) -- une seule clause
```

---

## 2. Satisfaisabilite (SAT)

### 2.1 Le probleme SAT

**Entree :** une formule propositionnelle en CNF.

**Question :** existe-t-il une valuation qui rend la formule vraie ?

SAT est le premier probleme prouve **NP-complet** (theoreme de Cook-Levin, 1971). Cela signifie que :

- Verifier une solution est polynomial (il suffit d'evaluer la formule)
- Trouver une solution est (probablement) exponentiel dans le pire cas
- Tout probleme NP se reduit polynomialement a SAT

### 2.2 Representation d'une formule CNF

```python
class FormuleCNF:
    """
    Represente une formule en CNF.
    Un litteral positif est 'x', un litteral negatif est '-x'.
    Clauses : liste de sets de litteraux.
    """
    def __init__(self):
        self.variables = set()
        self.clauses = []

    def ajouter_clause(self, litteraux):
        """Ajoute une clause (liste de litteraux)."""
        clause = set()
        for lit in litteraux:
            if lit.startswith('-'):
                self.variables.add(lit[1:])
            else:
                self.variables.add(lit)
            clause.add(lit)
        self.clauses.append(clause)

    def evaluer(self, valuation):
        """Evalue la formule sous une valuation {var: bool}."""
        for clause in self.clauses:
            clause_vraie = False
            for lit in clause:
                if lit.startswith('-'):
                    if not valuation.get(lit[1:], False):
                        clause_vraie = True
                        break
                else:
                    if valuation.get(lit, False):
                        clause_vraie = True
                        break
            if not clause_vraie:
                return False
        return True

    def __str__(self):
        parties = []
        for clause in self.clauses:
            parties.append("(" + " \\/ ".join(sorted(clause)) + ")")
        return " /\\ ".join(parties)
```

### 2.3 Algorithme de Quine (enumeration)

L'algorithme de Quine est un backtracking simple qui enumere toutes les valuations.

```python
def quine(formule):
    """
    Algorithme de Quine : enumeration avec backtracking.
    Complexite : O(2^n) dans le pire cas.
    Retourne une valuation satisfaisante ou None.
    """
    variables = list(formule.variables)

    def resoudre(valuation, idx):
        if idx == len(variables):
            return formule.evaluer(valuation)

        var = variables[idx]

        # Essayer True
        valuation[var] = True
        if resoudre(valuation, idx + 1):
            return True

        # Essayer False
        valuation[var] = False
        if resoudre(valuation, idx + 1):
            return True

        del valuation[var]
        return False

    valuation = {}
    if resoudre(valuation, 0):
        return valuation
    return None

# Test
f = FormuleCNF()
f.ajouter_clause(['p', 'q'])       # p \/ q
f.ajouter_clause(['-p', 'r'])      # ~p \/ r
f.ajouter_clause(['-q', '-r'])     # ~q \/ ~r

resultat = quine(f)
if resultat:
    print(f"Satisfaisable : {resultat}")
else:
    print("Insatisfaisable")
```

### 2.4 Algorithme DPLL

DPLL (Davis-Putnam-Logemann-Loveland) ameliore Quine avec deux optimisations :

1. **Propagation unitaire** : si une clause ne contient qu'un seul litteral, sa valeur est forcee. On simplifie ensuite toutes les clauses.
2. **Elimination des litteraux purs** : si un litteral n'apparait que positivement (ou que negativement) dans toutes les clauses, on peut le fixer a la valeur qui satisfait toutes ses clauses.

```python
def dpll(clauses, valuation=None):
    """
    Algorithme DPLL pour SAT.
    clauses : liste de sets de litteraux
    valuation : dictionnaire partiel {variable: bool}
    """
    if valuation is None:
        valuation = {}

    # Simplifier les clauses selon la valuation courante
    clauses = simplifier(clauses, valuation)

    # Toutes les clauses satisfaites
    if len(clauses) == 0:
        return valuation

    # Clause vide = contradiction
    if any(len(c) == 0 for c in clauses):
        return None

    # Propagation unitaire
    for clause in clauses:
        if len(clause) == 1:
            lit = next(iter(clause))
            if lit.startswith('-'):
                valuation[lit[1:]] = False
            else:
                valuation[lit] = True
            return dpll(clauses, valuation)

    # Elimination des litteraux purs
    tous_litteraux = set()
    for clause in clauses:
        tous_litteraux.update(clause)

    for lit in list(tous_litteraux):
        if lit.startswith('-'):
            var = lit[1:]
            if var not in tous_litteraux:   # ~var sans var
                valuation[var] = False
                return dpll(clauses, valuation)
        else:
            neg = '-' + lit
            if neg not in tous_litteraux:   # var sans ~var
                valuation[lit] = True
                return dpll(clauses, valuation)

    # Choix d'une variable (heuristique : premiere non assignee)
    variables_libres = set()
    for clause in clauses:
        for lit in clause:
            v = lit[1:] if lit.startswith('-') else lit
            if v not in valuation:
                variables_libres.add(v)

    if not variables_libres:
        return None

    var = next(iter(variables_libres))

    # Branche True
    val_copie = valuation.copy()
    val_copie[var] = True
    resultat = dpll([c.copy() for c in clauses], val_copie)
    if resultat is not None:
        return resultat

    # Branche False
    val_copie = valuation.copy()
    val_copie[var] = False
    return dpll([c.copy() for c in clauses], val_copie)


def simplifier(clauses, valuation):
    """Simplifie les clauses en appliquant la valuation partielle."""
    nouvelles = []
    for clause in clauses:
        clause_satisfaite = False
        nouvelle_clause = set()
        for lit in clause:
            if lit.startswith('-'):
                var = lit[1:]
                if var in valuation:
                    if not valuation[var]:       # ~var est vrai
                        clause_satisfaite = True
                        break
                    # sinon ~var est faux, on retire le litteral
                else:
                    nouvelle_clause.add(lit)
            else:
                if lit in valuation:
                    if valuation[lit]:            # var est vrai
                        clause_satisfaite = True
                        break
                    # sinon var est faux, on retire le litteral
                else:
                    nouvelle_clause.add(lit)
        if not clause_satisfaite:
            nouvelles.append(nouvelle_clause)
    return nouvelles


# Test DPLL
clauses = [
    {'p', 'q', 'r'},
    {'-p', 'q'},
    {'-q', 'r'},
    {'-r', 'p'},
]

resultat = dpll(clauses)
if resultat:
    print(f"DPLL - Satisfaisable : {resultat}")
else:
    print("DPLL - Insatisfaisable")
```

**Complexite :** O(2^n) dans le pire cas, mais souvent bien meilleur en pratique grace a la propagation unitaire et l'elimination des litteraux purs. Les solveurs SAT modernes (MiniSat, CaDiCaL) traitent des instances a des millions de variables.

---

## 3. Deduction naturelle

### 3.1 Principe

La deduction naturelle est un systeme formel pour prouver des theoremes logiques. Chaque connecteur possede une **regle d'introduction** (pour le construire) et une **regle d'elimination** (pour l'utiliser).

### 3.2 Regles principales

```text
--- CONJONCTION ---

Introduction /\ :            Elimination /\ :
  F    G                      F /\ G          F /\ G
  ------                      ------          ------
  F /\ G                        F               G


--- DISJONCTION ---

Introduction \/ :            Elimination \/ (raisonnement par cas) :
    F            G             F \/ G    [F]..H    [G]..H
  ------      ------           --------------------------------
  F \/ G      F \/ G                      H


--- IMPLICATION ---

Introduction => :            Elimination => (modus ponens) :
  [F]                          F    F => G
   :                           -----------
   G                               G
  ------
  F => G


--- NEGATION ---

Introduction ~ :             Elimination ~ :
  [F]                          F    ~F
   :                           ------
  absurdite                     absurdite
  -----------
     ~F


--- ABSURDITE ---

Elimination de l'absurdite (ex falso quodlibet) :
   absurdite
   ---------
      F       (de l'absurde, on deduit n'importe quoi)


--- RAISONNEMENT PAR L'ABSURDE ---

   [~F]
    :
   absurdite
   ---------
      F       (si supposer ~F mene a l'absurde, alors F est vrai)
```

### 3.3 Exemples de preuves

**Prouver : p /\ (p => q) |- q** (modus ponens applique)

```text
1. p /\ (p => q)      [hypothese]
2. p                   [elimination /\, de 1]
3. p => q              [elimination /\, de 1]
4. q                   [elimination =>, modus ponens, de 2 et 3]
```

**Prouver : |- p => (q => p)** (affaiblissement)

```text
1. [p]                  [hypothese temporaire]
2.   [q]                [hypothese temporaire]
3.   p                  [reiteration de 1]
4. q => p               [introduction =>, de 2-3, decharge q]
5. p => (q => p)        [introduction =>, de 1-4, decharge p]
```

**Prouver : |- (p => q) => (~q => ~p)** (contraposee)

```text
1. [p => q]                [hypothese]
2.   [~q]                  [hypothese]
3.     [p]                 [hypothese]
4.     q                   [elimination =>, de 3 et 1]
5.     absurdite           [elimination ~, de 4 et 2]
6.   ~p                    [introduction ~, de 3-5, decharge p]
7. ~q => ~p                [introduction =>, de 2-6, decharge ~q]
8. (p => q) => (~q => ~p)  [introduction =>, de 1-7, decharge p => q]
```

---

## 4. Langages reguliers et expressions regulieres

### 4.1 Alphabets et mots

- **Alphabet** (Sigma) : ensemble fini de symboles. Ex : {0, 1}, {a, b, c}
- **Mot** : suite finie de symboles de l'alphabet. Ex : "abba", "010110"
- **Mot vide** (epsilon) : mot de longueur 0
- **Langage** : ensemble (possiblement infini) de mots sur un alphabet

### 4.2 Expressions regulieres

Les expressions regulieres (regex) definissent des langages reguliers par les operations :

| Operation | Notation | Signification |
|-----------|----------|---------------|
| Concatenation | RS | Mots de R suivis de mots de S |
| Union | R\|S | Mots de R ou de S |
| Etoile de Kleene | R* | Zero ou plus repetitions de R |
| Plus | R+ | Une ou plus repetitions (= RR*) |
| Option | R? | Zero ou une occurrence |

**Exemples formels :**

- `(a|b)*` : tous les mots sur {a, b}, y compris le mot vide
- `a*b` : zero ou plus 'a' suivis d'un 'b' : {b, ab, aab, aaab, ...}
- `(ab)*` : repetitions de "ab" : {epsilon, ab, abab, ababab, ...}
- `a(a|b)*b` : mots commencant par 'a' et finissant par 'b'

### 4.3 Expressions regulieres en Python

```python
import re

# Validation d'une adresse email (simplifiee)
motif_email = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'

emails = [
    "alice@example.com",
    "bob.martin@univ-caen.fr",
    "invalide@",
    "@manque.local",
    "ok+tag@gmail.com"
]

for email in emails:
    if re.match(motif_email, email):
        print(f"  VALIDE   : {email}")
    else:
        print(f"  INVALIDE : {email}")
```

```python
# Validation d'une adresse IPv4
motif_ipv4 = r'^((25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)\.){3}(25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)$'

ips = ["192.168.1.1", "10.0.0.1", "256.1.2.3", "1.2.3", "172.16.0.255"]

for ip in ips:
    if re.match(motif_ipv4, ip):
        print(f"  VALIDE   : {ip}")
    else:
        print(f"  INVALIDE : {ip}")
```

```python
# Extraction d'informations dans un log
log = """
Feb 25 10:15:32 sshd[1234]: Failed password for root from 192.168.1.100 port 22
Feb 25 10:15:35 sshd[1235]: Failed password for admin from 10.0.0.50 port 22
Feb 25 10:16:01 sshd[1236]: Accepted password for alice from 172.16.0.1 port 22
Feb 25 10:16:45 sshd[1237]: Failed password for root from 192.168.1.100 port 22
"""

motif = r'Failed password for (\S+) from ([\d.]+) port (\d+)'
echecs = re.findall(motif, log)

print("Tentatives echouees:")
for user, ip, port in echecs:
    print(f"  Utilisateur: {user}, IP: {ip}, Port: {port}")

# Compter les echecs par IP
from collections import Counter
ips_echecs = Counter(ip for _, ip, _ in echecs)
print(f"\nEchecs par IP: {dict(ips_echecs)}")
```

---

## 5. Automates finis deterministes (DFA)

### 5.1 Definition formelle

Un **automate fini deterministe** (DFA) est un quintuplet M = (Q, Sigma, delta, q0, F) ou :

- Q : ensemble fini d'**etats**
- Sigma : **alphabet** d'entree
- delta : **fonction de transition** Q x Sigma -> Q (totale et deterministe)
- q0 : **etat initial** (q0 dans Q)
- F : ensemble d'**etats acceptants** (F inclus dans Q)

Un mot w = a1 a2 ... an est **accepte** si la suite d'etats q0, q1, ..., qn (ou qi = delta(q_{i-1}, ai)) aboutit dans un etat qn appartenant a F.

Le **langage reconnu** par M est L(M) = {w dans Sigma* | M accepte w}.

### 5.2 Implementation Python

```python
class DFA:
    def __init__(self, etats, alphabet, transitions, initial, acceptants):
        """
        etats : set d'etats
        alphabet : set de symboles
        transitions : dict {(etat, symbole): etat_suivant}
        initial : etat initial
        acceptants : set d'etats acceptants
        """
        self.etats = etats
        self.alphabet = alphabet
        self.transitions = transitions
        self.initial = initial
        self.acceptants = acceptants

    def accepter(self, mot):
        """Teste si le mot est accepte par l'automate. O(|mot|)."""
        etat = self.initial
        for symbole in mot:
            if symbole not in self.alphabet:
                return False
            cle = (etat, symbole)
            if cle not in self.transitions:
                return False  # Pas de transition : rejet
            etat = self.transitions[cle]
        return etat in self.acceptants

    def afficher(self):
        print(f"Etats: {self.etats}")
        print(f"Alphabet: {self.alphabet}")
        print(f"Initial: {self.initial}")
        print(f"Acceptants: {self.acceptants}")
        print("Transitions:")
        for (e, s), dest in sorted(self.transitions.items()):
            marque = " *" if dest in self.acceptants else ""
            print(f"  delta({e}, {s}) = {dest}{marque}")
```

**Exemple : DFA qui accepte les mots contenant un nombre pair de 'a' :**

```python
# Etats : q0 (pair, initial, acceptant), q1 (impair)
dfa_pair_a = DFA(
    etats={'q0', 'q1'},
    alphabet={'a', 'b'},
    transitions={
        ('q0', 'a'): 'q1',    # pair -> impair
        ('q0', 'b'): 'q0',    # pair -> pair
        ('q1', 'a'): 'q0',    # impair -> pair
        ('q1', 'b'): 'q1',    # impair -> impair
    },
    initial='q0',
    acceptants={'q0'}
)

mots_test = ["", "a", "aa", "ab", "ba", "aab", "bab", "aabb", "abba"]
for mot in mots_test:
    resultat = "ACCEPTE" if dfa_pair_a.accepter(mot) else "REJETE"
    nb_a = mot.count('a')
    print(f"  '{mot}' ({nb_a} a) : {resultat}")
```

**Exemple : DFA pour les multiples de 3 en binaire :**

```python
# Etats : r0 (reste 0), r1 (reste 1), r2 (reste 2)
# Transition : lire un bit b depuis l'etat reste r -> nouveau reste (2r + b) mod 3
dfa_mult3 = DFA(
    etats={'r0', 'r1', 'r2'},
    alphabet={'0', '1'},
    transitions={
        ('r0', '0'): 'r0',  # 2*0+0 = 0 mod 3
        ('r0', '1'): 'r1',  # 2*0+1 = 1 mod 3
        ('r1', '0'): 'r2',  # 2*1+0 = 2 mod 3
        ('r1', '1'): 'r0',  # 2*1+1 = 0 mod 3
        ('r2', '0'): 'r1',  # 2*2+0 = 1 mod 3
        ('r2', '1'): 'r2',  # 2*2+1 = 2 mod 3
    },
    initial='r0',
    acceptants={'r0'}
)

for n in range(16):
    binaire = bin(n)[2:] if n > 0 else "0"
    accepte = dfa_mult3.accepter(binaire)
    mult = "oui" if n % 3 == 0 else "non"
    print(f"  {n:2d} = {binaire:>4s} : {'ACCEPTE' if accepte else 'REJETE'} (mult 3 : {mult})")
```

---

## 6. Automates finis non deterministes (NFA)

### 6.1 Definition

Un **NFA** differe d'un DFA en ce que :

- La fonction de transition est delta : Q x (Sigma union {epsilon}) -> P(Q) (renvoie un **ensemble** d'etats)
- Depuis un etat, plusieurs transitions sont possibles pour un meme symbole
- Les **epsilon-transitions** (transitions spontanees sans lire de symbole) sont autorisees

Un mot est accepte s'il **existe** au moins un chemin menant a un etat acceptant.

### 6.2 Implementation

```python
class NFA:
    def __init__(self, etats, alphabet, transitions, initial, acceptants):
        """
        transitions : dict {(etat, symbole): set d'etats}
        Le symbole peut etre '' (epsilon-transition).
        """
        self.etats = etats
        self.alphabet = alphabet
        self.transitions = transitions
        self.initial = initial
        self.acceptants = acceptants

    def epsilon_fermeture(self, etats):
        """Calcule l'epsilon-fermeture d'un ensemble d'etats.
        = ensemble de tous les etats atteignables par epsilon-transitions."""
        pile = list(etats)
        fermeture = set(etats)
        while pile:
            etat = pile.pop()
            for suivant in self.transitions.get((etat, ''), set()):
                if suivant not in fermeture:
                    fermeture.add(suivant)
                    pile.append(suivant)
        return frozenset(fermeture)

    def accepter(self, mot):
        """Teste si le mot est accepte (simulation de tous les chemins)."""
        etats_courants = self.epsilon_fermeture({self.initial})

        for symbole in mot:
            etats_suivants = set()
            for etat in etats_courants:
                for suivant in self.transitions.get((etat, symbole), set()):
                    etats_suivants.add(suivant)
            etats_courants = self.epsilon_fermeture(etats_suivants)

        return bool(etats_courants & self.acceptants)


# Exemple : NFA pour les mots se terminant par "ab"
nfa_ab = NFA(
    etats={'q0', 'q1', 'q2'},
    alphabet={'a', 'b'},
    transitions={
        ('q0', 'a'): {'q0', 'q1'},   # Non-determinisme : deux choix
        ('q0', 'b'): {'q0'},
        ('q1', 'b'): {'q2'},
    },
    initial='q0',
    acceptants={'q2'}
)

for mot in ["ab", "aab", "bab", "abb", "ba", "a", "abab"]:
    resultat = "ACCEPTE" if nfa_ab.accepter(mot) else "REJETE"
    print(f"  '{mot}' : {resultat}")
```

### 6.3 Avantages du non-determinisme

Le non-determinisme rend la conception d'automates plus simple et intuitive. Par exemple, pour reconnaitre les mots se terminant par "ab", le NFA ci-dessus n'a que 3 etats, tandis que le DFA equivalent en necessite 4.

Cependant, NFA et DFA reconnaissent exactement la meme classe de langages (les langages reguliers). La conversion NFA -> DFA peut en revanche provoquer une explosion exponentielle du nombre d'etats.

---

## 7. Equivalence NFA/DFA et determinisation

### 7.1 Theoreme de Rabin-Scott

**Theoreme :** pour tout NFA N, il existe un DFA D tel que L(D) = L(N). La construction est appelee **construction des sous-ensembles** (subset construction).

**Principe :** chaque etat du DFA correspond a un **ensemble d'etats** du NFA. Si le NFA a n etats, le DFA peut en avoir jusqu'a 2^n (mais souvent beaucoup moins en pratique).

### 7.2 Algorithme de determinisation

```python
def determiniser(nfa):
    """
    Convertit un NFA en DFA par la construction des sous-ensembles.
    Complexite : O(2^|Q|) dans le pire cas.
    """
    etat_initial_dfa = nfa.epsilon_fermeture({nfa.initial})

    etats_dfa = {etat_initial_dfa}
    transitions_dfa = {}
    a_traiter = [etat_initial_dfa]
    acceptants_dfa = set()

    if etat_initial_dfa & nfa.acceptants:
        acceptants_dfa.add(etat_initial_dfa)

    while a_traiter:
        etat_courant = a_traiter.pop()

        for symbole in nfa.alphabet:
            # Calculer l'ensemble des etats atteignables
            etats_suivants = set()
            for e in etat_courant:
                for suivant in nfa.transitions.get((e, symbole), set()):
                    etats_suivants.add(suivant)

            # Appliquer l'epsilon-fermeture
            etat_suivant = nfa.epsilon_fermeture(etats_suivants)

            if not etat_suivant:
                continue

            transitions_dfa[(etat_courant, symbole)] = etat_suivant

            if etat_suivant not in etats_dfa:
                etats_dfa.add(etat_suivant)
                a_traiter.append(etat_suivant)
                if etat_suivant & nfa.acceptants:
                    acceptants_dfa.add(etat_suivant)

    return DFA(etats_dfa, nfa.alphabet, transitions_dfa,
               etat_initial_dfa, acceptants_dfa)


# Test : determiniser le NFA precedent
dfa_depuis_nfa = determiniser(nfa_ab)
print(f"\nDFA obtenu par determinisation : {len(dfa_depuis_nfa.etats)} etats")
for mot in ["ab", "aab", "bab", "abb", "ba", "a", "abab"]:
    r_nfa = "ACCEPTE" if nfa_ab.accepter(mot) else "REJETE"
    r_dfa = "ACCEPTE" if dfa_depuis_nfa.accepter(mot) else "REJETE"
    assert r_nfa == r_dfa, f"Divergence pour '{mot}'"
    print(f"  '{mot}' : {r_dfa}")
print("NFA et DFA donnent les memes resultats.")
```

### 7.3 Minimisation d'un DFA

Un DFA peut contenir des etats redondants (indistinguables). L'algorithme de **minimisation** fusionne les etats equivalents.

**Deux etats sont equivalents** s'il est impossible de les distinguer par un mot quelconque (ils menent au meme resultat accepte/rejete pour tout mot).

**Algorithme de Moore (partition) :**

```python
def minimiser_dfa(dfa):
    """
    Minimisation d'un DFA par l'algorithme de partition iterative.
    Fusionne les etats indistinguables.
    """
    # Partition initiale : acceptants vs non-acceptants
    non_acceptants = dfa.etats - dfa.acceptants

    partitions = []
    if dfa.acceptants:
        partitions.append(frozenset(dfa.acceptants))
    if non_acceptants:
        partitions.append(frozenset(non_acceptants))

    def partition_de(etat, parts):
        for i, p in enumerate(parts):
            if etat in p:
                return i
        return -1

    # Raffinement iteratif
    change = True
    while change:
        change = False
        nouvelles_partitions = []

        for partition in partitions:
            sous_groupes = {}
            for etat in partition:
                # Signature = tuple des partitions atteintes par chaque symbole
                signature = []
                for symbole in sorted(dfa.alphabet):
                    cle = (etat, symbole)
                    if cle in dfa.transitions:
                        dest = dfa.transitions[cle]
                        signature.append(partition_de(dest, partitions))
                    else:
                        signature.append(-1)  # Pas de transition
                signature = tuple(signature)

                if signature not in sous_groupes:
                    sous_groupes[signature] = set()
                sous_groupes[signature].add(etat)

            for groupe in sous_groupes.values():
                nouvelles_partitions.append(frozenset(groupe))

            if len(sous_groupes) > 1:
                change = True

        partitions = nouvelles_partitions

    print(f"DFA minimal : {len(partitions)} etats (avant : {len(dfa.etats)})")
    return partitions
```

**Theoreme de Myhill-Nerode :** pour tout langage regulier, il existe un DFA minimal unique (a renommage des etats pres).

---

## 8. Grammaires non contextuelles (CFG)

### 8.1 Definition

Une **grammaire non contextuelle** (Context-Free Grammar, CFG) est un quadruplet G = (V, Sigma, R, S) ou :

- V : ensemble fini de **variables** (non-terminaux)
- Sigma : **alphabet terminal**
- R : ensemble de **regles de production** de la forme A -> alpha
- S : **symbole de depart** (dans V)

### 8.2 Exemples

**Grammaire des expressions arithmetiques :**

```text
E -> E + T | T
T -> T * F | F
F -> ( E ) | id | nombre
```

Cette grammaire genere des expressions comme `id + id * nombre`, `(id + id) * id`. La structure des regles encode naturellement la priorite des operateurs (* avant +).

**Grammaire des parentheses equilibrees :**

```text
S -> ( S ) S | epsilon
```

Genere : "", "()", "()()", "(())", "(()())", ...

**Grammaire du langage a^n b^n :**

```text
S -> a S b | epsilon
```

Ce langage n'est **pas regulier** (prouvable par le lemme de pompage), mais il est non contextuel.

### 8.3 Arbres de derivation

Un **arbre de derivation** (parse tree) represente la structure syntaxique d'un mot derive par la grammaire. Les noeuds internes sont des non-terminaux, les feuilles sont des terminaux.

```python
class NoeudParse:
    def __init__(self, symbole, enfants=None):
        self.symbole = symbole
        self.enfants = enfants or []

    def afficher(self, prefix="", est_dernier=True):
        connecteur = "`-- " if est_dernier else "|-- "
        print(prefix + connecteur + str(self.symbole))
        prefix_enfant = prefix + ("    " if est_dernier else "|   ")
        for i, enfant in enumerate(self.enfants):
            enfant.afficher(prefix_enfant, i == len(self.enfants) - 1)


# Arbre de derivation pour "3 + 4 * 2"
# E -> E + T -> T + T -> F + T -> 3 + T -> 3 + T * F -> 3 + F * F -> 3 + 4 * 2
arbre = NoeudParse('E', [
    NoeudParse('E', [
        NoeudParse('T', [
            NoeudParse('F', [NoeudParse('3')])
        ])
    ]),
    NoeudParse('+'),
    NoeudParse('T', [
        NoeudParse('T', [
            NoeudParse('F', [NoeudParse('4')])
        ]),
        NoeudParse('*'),
        NoeudParse('F', [NoeudParse('2')])
    ])
])

print("Arbre de derivation de '3 + 4 * 2':")
arbre.afficher()
```

**Ambiguite :** une grammaire est **ambigue** si un mot admet deux arbres de derivation differents. Par exemple, la grammaire `E -> E + E | E * E | id` est ambigue car `id + id * id` a deux arbres possibles.

### 8.4 Parser recursif descendant

Un **parser recursif descendant** analyse un mot selon une CFG en creant une fonction par non-terminal. Il fonctionne pour les grammaires **LL(1)** (sans recursion a gauche, avec lookahead de 1 symbole).

```python
class Parser:
    """
    Parser recursif descendant pour les expressions arithmetiques.
    Grammaire (sans recursion a gauche) :
    E  -> T E'
    E' -> + T E' | - T E' | epsilon
    T  -> F T'
    T' -> * F T' | / F T' | epsilon
    F  -> ( E ) | nombre
    """

    def __init__(self, texte):
        self.texte = texte
        self.pos = 0

    def caractere_courant(self):
        if self.pos < len(self.texte):
            return self.texte[self.pos]
        return None

    def consommer(self, attendu):
        if self.caractere_courant() == attendu:
            self.pos += 1
        else:
            raise SyntaxError(
                f"Attendu '{attendu}', trouve '{self.caractere_courant()}' "
                f"a la position {self.pos}")

    def nombre(self):
        debut = self.pos
        while self.pos < len(self.texte) and self.texte[self.pos].isdigit():
            self.pos += 1
        if self.pos == debut:
            raise SyntaxError(f"Nombre attendu a la position {self.pos}")
        return int(self.texte[debut:self.pos])

    def ignorer_espaces(self):
        while self.pos < len(self.texte) and self.texte[self.pos] == ' ':
            self.pos += 1

    def expression(self):
        """E -> T (('+' | '-') T)*"""
        resultat = self.terme()
        self.ignorer_espaces()
        while self.caractere_courant() in ('+', '-'):
            op = self.caractere_courant()
            self.pos += 1
            self.ignorer_espaces()
            droite = self.terme()
            if op == '+':
                resultat += droite
            else:
                resultat -= droite
            self.ignorer_espaces()
        return resultat

    def terme(self):
        """T -> F (('*' | '/') F)*"""
        resultat = self.facteur()
        self.ignorer_espaces()
        while self.caractere_courant() in ('*', '/'):
            op = self.caractere_courant()
            self.pos += 1
            self.ignorer_espaces()
            droite = self.facteur()
            if op == '*':
                resultat *= droite
            else:
                resultat //= droite
            self.ignorer_espaces()
        return resultat

    def facteur(self):
        """F -> '(' E ')' | nombre"""
        self.ignorer_espaces()
        if self.caractere_courant() == '(':
            self.consommer('(')
            resultat = self.expression()
            self.ignorer_espaces()
            self.consommer(')')
            return resultat
        return self.nombre()

    def evaluer(self):
        resultat = self.expression()
        if self.pos < len(self.texte):
            raise SyntaxError(
                f"Caractere inattendu '{self.texte[self.pos]}' "
                f"a la position {self.pos}")
        return resultat


# Tests
expressions = [
    "3 + 4 * 2",               # 11 (pas 14, * est prioritaire)
    "(3 + 4) * 2",             # 14
    "10 - 2 * 3",              # 4
    "100 / 5 / 4",             # 5
    "2 * (3 + 4 * (5 - 1))",   # 2 * (3 + 16) = 38
]

for expr in expressions:
    try:
        resultat = Parser(expr).evaluer()
        print(f"  {expr} = {resultat}")
    except SyntaxError as e:
        print(f"  {expr} : ERREUR - {e}")
```

---

## 9. Applications

### 9.1 Compilation : lexer avec automates

Un **lexer** (analyseur lexical) est la premiere phase d'un compilateur. Il transforme le texte source en une sequence de tokens. Chaque type de token est defini par une expression reguliere.

```python
import re

def lexer(code):
    """
    Analyseur lexical simple pour un mini-langage.
    Chaque regle est une expression reguliere associee a un type de token.
    """
    regles = [
        ('NOMBRE',    r'\d+(\.\d+)?'),
        ('IDENT',     r'[a-zA-Z_]\w*'),
        ('PLUS',      r'\+'),
        ('MOINS',     r'-'),
        ('FOIS',      r'\*'),
        ('DIVISE',    r'/'),
        ('EGAL',      r'='),
        ('PAREN_G',   r'\('),
        ('PAREN_D',   r'\)'),
        ('NEWLINE',   r'\n'),
        ('ESPACE',    r'[ \t]+'),
        ('ERREUR',    r'.'),
    ]

    motif_combine = '|'.join(f'(?P<{nom}>{motif})' for nom, motif in regles)
    tokens = []

    for match in re.finditer(motif_combine, code):
        type_token = match.lastgroup
        valeur = match.group()
        if type_token == 'ESPACE':
            continue
        if type_token == 'ERREUR':
            raise SyntaxError(f"Caractere illegal: '{valeur}'")
        tokens.append((type_token, valeur))

    return tokens

code_source = "x = 3 + 4 * (y - 1)"
tokens = lexer(code_source)
print(f"Tokens de '{code_source}':")
for type_t, valeur in tokens:
    print(f"  {type_t:10} : {valeur}")
```

### 9.2 Validation d'entrees

Les expressions regulieres sont fondamentales pour la validation d'entrees utilisateur :

```python
import re

def valider_entree(entree, type_entree):
    """Validation stricte d'entrees utilisateur."""
    motifs = {
        'username':     r'^[a-zA-Z][a-zA-Z0-9_]{2,19}$',
        'telephone_fr': r'^(\+33|0)[1-9](\d{2}){4}$',
        'code_postal':  r'^\d{5}$',
        'date_iso':     r'^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$',
        'hex_color':    r'^#[0-9a-fA-F]{6}$',
    }

    motif = motifs.get(type_entree)
    if motif is None:
        return False, "Type d'entree inconnu"

    if re.match(motif, entree):
        return True, "Valide"
    return False, f"Ne correspond pas au format {type_entree}"

tests = [
    ("alice_42", "username"),
    ("A", "username"),
    ("0612345678", "telephone_fr"),
    ("+33612345678", "telephone_fr"),
    ("14000", "code_postal"),
    ("2026-02-25", "date_iso"),
    ("#FF00AA", "hex_color"),
]

for entree, type_e in tests:
    valide, msg = valider_entree(entree, type_e)
    statut = "OK" if valide else "REJETE"
    print(f"  [{statut}] {type_e}: '{entree}' -- {msg}")
```

---

## 10. Hierarchie de Chomsky

| Type | Nom | Reconnaisseur | Exemple |
|------|-----|---------------|---------|
| 3 | Regulier | Automate fini (DFA/NFA) | a*b, (a\|b)*ab |
| 2 | Non contextuel | Automate a pile (PDA) | a^n b^n, parentheses equilibrees |
| 1 | Contextuel | Machine de Turing bornee | a^n b^n c^n |
| 0 | Recursif enumerable | Machine de Turing | Probleme de l'arret (indecidable) |

**Resultats importants :**

- **Lemme de pompage (langages reguliers) :** pour tout langage regulier L, il existe un entier p tel que tout mot w de L avec |w| >= p peut s'ecrire w = xyz avec |y| >= 1, |xy| <= p, et pour tout i >= 0, xy^i z appartient a L. En "pompant" y (repetant ou supprimant), on reste dans L.
- **Equivalence DFA <=> NFA <=> regex :** les trois formalismes reconnaissent exactement les memes langages (les langages reguliers).
- **Les langages non contextuels sont strictement plus expressifs** que les reguliers : a^n b^n est non contextuel mais pas regulier.

**Preuve par le lemme de pompage que a^n b^n n'est pas regulier :**

Supposons L = {a^n b^n | n >= 0} regulier. Soit p la constante du lemme. Le mot w = a^p b^p est dans L et |w| = 2p >= p. Decomposons w = xyz avec |xy| <= p et |y| >= 1. Comme |xy| <= p, y est compose uniquement de 'a'. Alors xy^2z = a^(p + |y|) b^p avec |y| >= 1, donc le nombre de 'a' differe du nombre de 'b'. Contradiction : xy^2z n'est pas dans L. Donc L n'est pas regulier.

---

## Exercices

### Exercice 1 -- Tables de verite

Construire la table de verite de la formule (p => q) /\ (q => r) => (p => r) et montrer que c'est une tautologie (syllogisme hypothetique).

### Exercice 2 -- Forme normale

Mettre la formule (p => q) /\ (r \/ ~q) en CNF. Verifier l'equivalence avec une table de verite.

### Exercice 3 -- SAT

La formule suivante est-elle satisfaisable ? Si oui, donner une valuation. Si non, prouver l'insatisfaisabilite.
(p \/ q) /\ (~p \/ r) /\ (~q \/ ~r) /\ (~p \/ ~q)

### Exercice 4 -- Deduction naturelle

Prouver en deduction naturelle : ~(p /\ q) |- ~p \/ ~q (premiere loi de De Morgan). Indication : utiliser le raisonnement par l'absurde.

### Exercice 5 -- Expressions regulieres

Ecrire des expressions regulieres pour :

1. Les mots binaires contenant exactement deux 1
2. Les mots sur {a, b} ne contenant pas "aa"
3. Les identifiants C valides (lettre ou _ suivis de lettres, chiffres ou _)

### Exercice 6 -- Construction d'automates

Construire un DFA qui reconnait les mots binaires representant un multiple de 3 (en base 2). Indication : 3 etats correspondant aux restes 0, 1, 2. Verifier pour les nombres de 0 a 15.

### Exercice 7 -- Determinisation

Determiniser le NFA suivant :

- Etats : {q0, q1, q2}
- Alphabet : {a, b}
- Transitions : delta(q0, a) = {q0, q1}, delta(q0, b) = {q0}, delta(q1, b) = {q2}
- Initial : q0
- Acceptants : {q2}

Combien d'etats le DFA resultant a-t-il ? Est-il minimal ?

### Exercice 8 -- Grammaire et parsing

1. Ecrire une grammaire non contextuelle pour le langage des expressions booleennes avec AND, OR, NOT et parentheses.
2. Construire l'arbre de derivation de `NOT (a AND b) OR c`.
3. Implementer un evaluateur de ces expressions en Python (parser recursif descendant).

### Exercice 9 -- Lemme de pompage

Utiliser le lemme de pompage pour prouver que le langage L = {w dans {a,b}* | w est un palindrome} n'est pas regulier.

---

## References

- **Introduction to Automata Theory, Languages, and Computation** -- Hopcroft, Motwani, Ullman
- **Logic in Computer Science** -- Michael Huth, Mark Ryan
- **Comp