# Chapitre 7 — Bases de donnees relationnelles

## Objectifs du chapitre

- Concevoir un schema entite-association et le transformer en modele relationnel
- Maitriser les concepts du modele relationnel (relations, cles, integrite referentielle)
- Connaitre les operateurs de l'algebre relationnelle
- Ecrire des requetes SQL de complexite intermediaire a avancee
- Comprendre les formes normales (1NF, 2NF, 3NF) et savoir normaliser un schema
- Identifier et prevenir les injections SQL
- Pratiquer avec SQLite en ligne de commande et en Python

---

## 1. Modele entite-association (E/A)

### 1.1 Concepts fondamentaux

Le modele entite-association (aussi appele modele entite-relation, E/R en anglais) est un formalisme de conception graphique qui permet de decrire la structure des donnees avant toute implementation. Il a ete introduit par Peter Chen en 1976.

**Entite** : Un objet du monde reel identifiable de maniere unique. Represente par un rectangle.

**Attribut** : Propriete d'une entite. L'attribut souligne est l'**identifiant** (cle).

**Association** (ou relation) : Lien logique entre deux ou plusieurs entites. Represente par un losange.

**Cardinalites** : Contraintes sur le nombre de participations d'une entite dans une association.

- `1,1` : exactement une participation
- `0,1` : zero ou une participation
- `1,N` : au moins une participation
- `0,N` : zero ou plusieurs participations

### 1.2 Exemple : gestion d'une bibliotheque

```text
+----------+      +----------+      +----------+
|  LECTEUR  |      | EMPRUNT  |      |   LIVRE  |
|----------|      |----------|      |----------|
| id_lect  |0,N--<>--1,1| id_livre |
| nom       |      | date_emp |      | titre    |
| prenom    |      | date_ret |      | auteur   |
| email     |      +----------+      | isbn     |
+----------+                         | genre    |
                                     +----------+
```

Lecture : un lecteur peut emprunter 0 a N livres ; chaque emprunt concerne exactement 1 livre.

### 1.3 Passage au modele relationnel

**Regles de transformation** :

1. **Entite -> Relation** : chaque entite devient une table, l'identifiant devient la cle primaire.

2. **Association 1,1 -- 0,N** : la cle etrangere va du cote "1,1" (l'entite qui participe exactement une fois).

3. **Association 0,N -- 0,N** : on cree une **table d'association** dont la cle primaire est la combinaison des cles etrangeres.

4. **Attribut d'association** : les attributs de l'association vont dans la table d'association.

5. **Association 1,1 -- 1,1** : la cle etrangere peut aller dans l'une ou l'autre table (choix de conception).

6. **Association ternaire** : toujours une table d'association avec les cles etrangeres des trois entites.

**Resultat pour notre exemple** :

```text
LECTEUR(id_lect, nom, prenom, email)
LIVRE(id_livre, titre, auteur, isbn, genre)
EMPRUNT(id_lect, id_livre, date_emp, date_ret)
         ^FK       ^FK
```

---

## 2. Modele relationnel

### 2.1 Definitions formelles

**Relation** (table) : un sous-ensemble du produit cartesien de domaines `D1 x D2 x ... x Dn`. Chaque element (ligne) est un **n-uplet** (tuple).

**Schema de relation** : `R(A1: D1, A2: D2, ..., An: Dn)` -- le nom de la relation suivi de ses attributs et leurs domaines.

**Cle primaire** : Ensemble minimal d'attributs qui identifie de maniere unique chaque tuple. Proprietes :

- Unicite : deux tuples ne peuvent pas avoir la meme valeur de cle
- Minimalite : aucun sous-ensemble strict de la cle n'est une cle
- Non-nullite : aucun attribut de la cle ne peut etre NULL

**Cle candidate** : Tout ensemble minimal d'attributs verifiant l'unicite. Il peut y en avoir plusieurs. La cle primaire est choisie parmi les cles candidates.

**Cle etrangere** : Un attribut (ou ensemble d'attributs) d'une relation qui reference la cle primaire d'une autre relation (ou de la meme relation).

**Integrite referentielle** : Toute valeur d'une cle etrangere doit correspondre a une valeur existante de la cle primaire referencee, ou etre NULL.

### 2.2 Contraintes d'integrite

| Type | Description | Exemple |
| ---- | ----------- | ------- |
| Domaine | Valeur dans un type defini | `age INTEGER CHECK(age >= 0)` |
| Entite | Cle primaire unique et non NULL | `PRIMARY KEY (id)` |
| Referentielle | FK reference une PK existante | `FOREIGN KEY (id_lect) REFERENCES LECTEUR(id_lect)` |
| Utilisateur | Contrainte metier | `CHECK (date_ret >= date_emp)` |

---

## 3. Algebre relationnelle

L'algebre relationnelle est le fondement theorique de SQL. Ses operateurs prennent une ou deux relations en entree et produisent une relation en sortie. C'est un langage **ferme** : le resultat d'une operation est toujours une relation.

### 3.1 Operateurs unaires

**Selection** `sigma_condition(R)` : Filtre les tuples satisfaisant une condition.

```text
sigma_{genre='Informatique'}(LIVRE)
-> Retourne tous les livres du genre "Informatique"
```

Correspondance SQL : `WHERE genre = 'Informatique'`

**Projection** `pi_{A1,A2,...}(R)` : Conserve uniquement certains attributs (supprime les doublons).

```text
pi_{titre, auteur}(LIVRE)
-> Retourne les paires (titre, auteur) sans doublon
```

Correspondance SQL : `SELECT DISTINCT titre, auteur`

**Renommage** `rho_{nouveau_nom}(R)` : Renomme une relation ou ses attributs.

Correspondance SQL : `AS nouveau_nom`

### 3.2 Operateurs binaires

**Union** `R union S` : Tuples presents dans R ou S (les schemas doivent etre compatibles, c'est-a-dire meme nombre d'attributs et memes domaines).

**Difference** `R - S` : Tuples presents dans R mais pas dans S.

**Produit cartesien** `R x S` : Toutes les combinaisons de tuples de R avec ceux de S. Si R a n tuples et S a m tuples, le resultat a n*m tuples.

**Jointure** `R join_{condition} S` : Produit cartesien suivi d'une selection. La **jointure naturelle** `R join S` effectue la jointure sur les attributs de meme nom.

```text
LECTEUR join_{LECTEUR.id_lect = EMPRUNT.id_lect} EMPRUNT
-> Combine chaque lecteur avec ses emprunts
```

**Intersection** `R inter S` = `R - (R - S)` : Tuples presents dans R et S.

**Division** `R / S` : Tuples de R qui sont associes a **tous** les tuples de S. Utile pour les requetes "pour tout".

```text
Exemple : "Quels lecteurs ont emprunte TOUS les livres d'informatique ?"
pi_{id_lect, id_livre}(EMPRUNT) / pi_{id_livre}(sigma_{genre='Info'}(LIVRE))
```

### 3.3 Equivalences importantes

```text
sigma_{c1 AND c2}(R) = sigma_{c1}(sigma_{c2}(R))          (decomposition de selection)
sigma_{c}(R join S) = sigma_{c}(R) join S                  (si c porte sur R uniquement)
pi_{A}(sigma_{c}(R)) = sigma_{c}(pi_{A union attrs(c)}(R)) (projection apres selection)
```

Ces equivalences sont utilisees par l'**optimiseur de requetes** du SGBD pour reordonner les operations et minimiser le cout d'execution.

### 3.4 Exercice d'algebre relationnelle

Avec le schema bibliotheque, exprimons en algebre relationnelle :

**"Titres des livres empruntes par Marie Dupont"** :

```text
pi_{titre}(
  sigma_{nom='Dupont' AND prenom='Marie'}(LECTEUR)
  join_{LECTEUR.id_lect = EMPRUNT.id_lect} EMPRUNT
  join_{EMPRUNT.id_livre = LIVRE.id_livre} LIVRE
)
```

**"Lecteurs qui n'ont jamais emprunte"** :

```text
pi_{nom, prenom}(LECTEUR) - pi_{nom, prenom}(LECTEUR join EMPRUNT)
```

---

## 4. SQL — Structured Query Language

### 4.1 Creation de tables

```sql
-- Creation de la base bibliotheque
CREATE TABLE LECTEUR (
    id_lect    INTEGER PRIMARY KEY AUTOINCREMENT,
    nom        TEXT NOT NULL,
    prenom     TEXT NOT NULL,
    email      TEXT UNIQUE NOT NULL,
    date_inscr DATE DEFAULT CURRENT_DATE
);

CREATE TABLE LIVRE (
    id_livre   INTEGER PRIMARY KEY AUTOINCREMENT,
    titre      TEXT NOT NULL,
    auteur     TEXT NOT NULL,
    isbn       TEXT UNIQUE,
    genre      TEXT,
    annee      INTEGER,
    nb_pages   INTEGER CHECK(nb_pages > 0)
);

CREATE TABLE EMPRUNT (
    id_emprunt INTEGER PRIMARY KEY AUTOINCREMENT,
    id_lect    INTEGER NOT NULL,
    id_livre   INTEGER NOT NULL,
    date_emp   DATE NOT NULL DEFAULT CURRENT_DATE,
    date_ret   DATE,
    FOREIGN KEY (id_lect) REFERENCES LECTEUR(id_lect),
    FOREIGN KEY (id_livre) REFERENCES LIVRE(id_livre),
    CHECK (date_ret IS NULL OR date_ret >= date_emp)
);
```

### 4.2 Insertion de donnees

```sql
INSERT INTO LECTEUR (nom, prenom, email)
VALUES ('Dupont', 'Marie', 'marie.dupont@mail.fr');

INSERT INTO LECTEUR (nom, prenom, email)
VALUES ('Martin', 'Jean', 'jean.martin@mail.fr');

INSERT INTO LECTEUR (nom, prenom, email)
VALUES ('Durand', 'Pierre', 'pierre.durand@mail.fr');

INSERT INTO LIVRE (titre, auteur, isbn, genre, annee, nb_pages)
VALUES ('Introduction aux algorithmes', 'Cormen et al.', '978-2100545261', 'Informatique', 2010, 1292);

INSERT INTO LIVRE (titre, auteur, isbn, genre, annee, nb_pages)
VALUES ('Les Miserables', 'Victor Hugo', '978-2070409228', 'Roman', 1862, 1900);

INSERT INTO LIVRE (titre, auteur, isbn, genre, annee, nb_pages)
VALUES ('Cryptography and Network Security', 'Stallings', '978-0134444284', 'Informatique', 2017, 752);

INSERT INTO LIVRE (titre, auteur, isbn, genre, annee, nb_pages)
VALUES ('Le Petit Prince', 'Saint-Exupery', '978-2070612758', 'Roman', 1943, 96);

INSERT INTO EMPRUNT (id_lect, id_livre, date_emp, date_ret)
VALUES (1, 1, '2025-01-15', '2025-02-01');

INSERT INTO EMPRUNT (id_lect, id_livre, date_emp, date_ret)
VALUES (1, 2, '2025-02-10', NULL);  -- pas encore rendu

INSERT INTO EMPRUNT (id_lect, id_livre, date_emp, date_ret)
VALUES (2, 3, '2025-01-20', '2025-02-05');

INSERT INTO EMPRUNT (id_lect, id_livre, date_emp, date_ret)
VALUES (2, 1, '2025-02-15', NULL);

INSERT INTO EMPRUNT (id_lect, id_livre, date_emp, date_ret)
VALUES (3, 4, '2025-03-01', '2025-03-10');
```

### 4.3 Modification et suppression

```sql
-- UPDATE : modifier des donnees existantes
UPDATE LECTEUR
SET email = 'marie.dupont@univ.fr'
WHERE id_lect = 1;

-- DELETE : supprimer des lignes
DELETE FROM EMPRUNT
WHERE date_ret IS NOT NULL AND date_ret < '2025-01-01';

-- ALTER TABLE : modifier le schema
ALTER TABLE LIVRE ADD COLUMN editeur TEXT;

-- DROP TABLE : supprimer une table (attention a l'integrite referentielle)
-- DROP TABLE EMPRUNT;  -- les FK vers LECTEUR et LIVRE seraient violees
```

### 4.4 SELECT — requetes de base

```sql
-- Tous les livres d'informatique
SELECT titre, auteur, annee
FROM LIVRE
WHERE genre = 'Informatique'
ORDER BY annee DESC;

-- Livres de plus de 500 pages publies apres 2000
SELECT titre, auteur, nb_pages
FROM LIVRE
WHERE nb_pages > 500 AND annee > 2000;

-- Les 3 livres les plus longs
SELECT titre, nb_pages
FROM LIVRE
ORDER BY nb_pages DESC
LIMIT 3;

-- Genres distincts presents dans la base
SELECT DISTINCT genre
FROM LIVRE;

-- Recherche par motif (LIKE)
SELECT titre FROM LIVRE
WHERE titre LIKE '%algo%';  -- contient "algo" (insensible a la casse en SQLite)

-- Recherche avec BETWEEN
SELECT titre, annee FROM LIVRE
WHERE annee BETWEEN 1900 AND 2000;
```

### 4.5 Jointures (JOIN)

```sql
-- INNER JOIN : lecteurs et leurs emprunts (seulement ceux qui ont emprunte)
SELECT L.nom, L.prenom, LI.titre, E.date_emp, E.date_ret
FROM LECTEUR L
INNER JOIN EMPRUNT E ON L.id_lect = E.id_lect
INNER JOIN LIVRE LI ON E.id_livre = LI.id_livre
ORDER BY E.date_emp;

-- LEFT JOIN : tous les lecteurs, meme ceux qui n'ont rien emprunte
SELECT L.nom, L.prenom, COUNT(E.id_emprunt) AS nb_emprunts
FROM LECTEUR L
LEFT JOIN EMPRUNT E ON L.id_lect = E.id_lect
GROUP BY L.id_lect, L.nom, L.prenom;

-- Livres actuellement empruntes (non rendus)
SELECT L.nom, L.prenom, LI.titre, E.date_emp
FROM LECTEUR L
INNER JOIN EMPRUNT E ON L.id_lect = E.id_lect
INNER JOIN LIVRE LI ON E.id_livre = LI.id_livre
WHERE E.date_ret IS NULL;

-- Self-join : trouver les livres du meme auteur
SELECT L1.titre AS livre1, L2.titre AS livre2, L1.auteur
FROM LIVRE L1
INNER JOIN LIVRE L2 ON L1.auteur = L2.auteur AND L1.id_livre < L2.id_livre;
```

**Types de jointures** :

| Type | Resultat |
| ---- | -------- |
| `INNER JOIN` | Seulement les lignes avec correspondance dans les deux tables |
| `LEFT JOIN` | Toutes les lignes de la table de gauche + correspondances a droite (ou NULL) |
| `RIGHT JOIN` | Toutes les lignes de la table de droite + correspondances a gauche (ou NULL) |
| `CROSS JOIN` | Produit cartesien (toutes les combinaisons) |

**Note** : SQLite ne supporte pas `RIGHT JOIN` ni `FULL OUTER JOIN` nativement. On peut simuler un `FULL OUTER JOIN` avec une union de `LEFT JOIN` et `RIGHT JOIN`.

### 4.6 Agregats et GROUP BY

```sql
-- Nombre d'emprunts par lecteur
SELECT L.nom, L.prenom, COUNT(*) AS nb_emprunts
FROM LECTEUR L
INNER JOIN EMPRUNT E ON L.id_lect = E.id_lect
GROUP BY L.id_lect;

-- Nombre moyen de pages par genre
SELECT genre, AVG(nb_pages) AS moy_pages, COUNT(*) AS nb_livres
FROM LIVRE
GROUP BY genre;

-- Genres ayant plus de 1 livre
SELECT genre, COUNT(*) AS nb_livres
FROM LIVRE
GROUP BY genre
HAVING COUNT(*) > 1;

-- Statistiques globales
SELECT
    COUNT(*) AS nb_livres,
    SUM(nb_pages) AS total_pages,
    AVG(nb_pages) AS moy_pages,
    MIN(annee) AS plus_ancien,
    MAX(annee) AS plus_recent
FROM LIVRE;
```

**Fonctions d'agregation** :

| Fonction | Description |
| -------- | ----------- |
| `COUNT(*)` | Nombre de lignes |
| `COUNT(col)` | Nombre de valeurs non NULL |
| `SUM(col)` | Somme des valeurs |
| `AVG(col)` | Moyenne des valeurs |
| `MIN(col)` | Valeur minimale |
| `MAX(col)` | Valeur maximale |
| `GROUP_CONCAT(col)` | Concatenation des valeurs (SQLite) |

**Ordre d'execution logique** d'une requete SQL :

```text
FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY -> LIMIT
```

C'est pour cela qu'on ne peut pas utiliser un alias defini dans le `SELECT` dans la clause `WHERE` (le `SELECT` est evalue apres le `WHERE`).

### 4.7 Requetes imbriquees

```sql
-- Lecteurs ayant emprunte au moins un livre d'informatique
SELECT nom, prenom
FROM LECTEUR
WHERE id_lect IN (
    SELECT E.id_lect
    FROM EMPRUNT E
    INNER JOIN LIVRE LI ON E.id_livre = LI.id_livre
    WHERE LI.genre = 'Informatique'
);

-- Livres jamais empruntes
SELECT titre, auteur
FROM LIVRE
WHERE id_livre NOT IN (
    SELECT DISTINCT id_livre
    FROM EMPRUNT
);

-- Lecteur ayant le plus grand nombre d'emprunts
SELECT nom, prenom, nb
FROM (
    SELECT L.nom, L.prenom, COUNT(*) AS nb
    FROM LECTEUR L
    INNER JOIN EMPRUNT E ON L.id_lect = E.id_lect
    GROUP BY L.id_lect
) AS sous_requete
ORDER BY nb DESC
LIMIT 1;

-- Livres plus longs que la moyenne de leur genre (sous-requete correlee)
SELECT L1.titre, L1.genre, L1.nb_pages
FROM LIVRE L1
WHERE L1.nb_pages > (
    SELECT AVG(L2.nb_pages)
    FROM LIVRE L2
    WHERE L2.genre = L1.genre
);

-- EXISTS : lecteurs ayant au moins un emprunt en cours
SELECT L.nom, L.prenom
FROM LECTEUR L
WHERE EXISTS (
    SELECT 1 FROM EMPRUNT E
    WHERE E.id_lect = L.id_lect AND E.date_ret IS NULL
);
```

### 4.8 Vues

Une **vue** est une requete nommee, stockee dans le schema. Elle se comporte comme une table virtuelle.

```sql
-- Creer une vue pour les emprunts en cours
CREATE VIEW emprunts_en_cours AS
SELECT L.nom, L.prenom, LI.titre, E.date_emp,
       julianday('now') - julianday(E.date_emp) AS jours_ecoules
FROM LECTEUR L
INNER JOIN EMPRUNT E ON L.id_lect = E.id_lect
INNER JOIN LIVRE LI ON E.id_livre = LI.id_livre
WHERE E.date_ret IS NULL;

-- Utiliser la vue comme une table
SELECT * FROM emprunts_en_cours
WHERE jours_ecoules > 30;  -- emprunts de plus d'un mois

-- Supprimer une vue
-- DROP VIEW emprunts_en_cours;
```

---

## 5. Normalisation

### 5.1 Pourquoi normaliser ?

La normalisation vise a eliminer les **anomalies** :

- **Anomalie d'insertion** : impossibilite d'inserer une information sans en inserer une autre
- **Anomalie de modification** : une mise a jour coherente necessite de modifier plusieurs lignes
- **Anomalie de suppression** : supprimer une information entraine la perte d'une autre

**Exemple** : dans une table `EMPLOYE(id, nom, id_dept, nom_dept, chef_dept)`, si on supprime le dernier employe d'un departement, on perd aussi le nom du departement et de son chef.

### 5.2 Dependances fonctionnelles

Une **dependance fonctionnelle** `A -> B` signifie que la connaissance de A determine de maniere unique la valeur de B.

**Exemple** : `isbn -> titre, auteur, annee` (un ISBN identifie un livre unique).

**Proprietes (axiomes d'Armstrong)** :

- **Reflexivite** : si B est inclus dans A, alors A -> B
- **Augmentation** : si A -> B, alors AC -> BC
- **Transitivite** : si A -> B et B -> C, alors A -> C

**Regles derivees** :

- **Union** : si A -> B et A -> C, alors A -> BC
- **Decomposition** : si A -> BC, alors A -> B et A -> C
- **Pseudo-transitivite** : si A -> B et CB -> D, alors AC -> D

### 5.3 Premiere forme normale (1NF)

Une relation est en 1NF si :

- Tous les attributs sont **atomiques** (pas de valeurs multiples, pas de groupes repetitifs)
- Chaque ligne est unique (il existe une cle primaire)

**Contre-exemple** :

```text
ETUDIANT(id, nom, telephones)
   1, Dupont, "0601020304, 0198765432"   <-- PAS atomique
```

**Correction** :

```text
ETUDIANT(id, nom)
TELEPHONE(id_etudiant, numero)
```

### 5.4 Deuxieme forme normale (2NF)

Une relation est en 2NF si :

- Elle est en 1NF
- Tout attribut non-cle depend **totalement** de la cle primaire (pas de dependance partielle)

La 2NF n'est pertinente que si la cle primaire est **composee** (plusieurs attributs).

**Contre-exemple** : `INSCRIPTION(id_etudiant, id_cours, nom_etudiant, note)`

- `nom_etudiant` depend de `id_etudiant` seul (dependance partielle par rapport a la cle `(id_etudiant, id_cours)`)

**Correction** :

```text
ETUDIANT(id_etudiant, nom_etudiant)
INSCRIPTION(id_etudiant, id_cours, note)
```

### 5.5 Troisieme forme normale (3NF)

Une relation est en 3NF si :

- Elle est en 2NF
- Aucun attribut non-cle ne depend **transitivement** de la cle primaire

Autrement dit : tout attribut non-cle depend directement de la cle, et de rien d'autre.

**Contre-exemple** : `EMPLOYE(id, nom, id_dept, nom_dept)`

- `id -> id_dept -> nom_dept` (dependance transitive)

**Correction** :

```text
EMPLOYE(id, nom, id_dept)
DEPARTEMENT(id_dept, nom_dept)
```

### 5.6 Forme normale de Boyce-Codd (BCNF)

Une relation est en BCNF si pour toute dependance fonctionnelle non triviale `X -> Y`, X est une super-cle.

La BCNF est plus stricte que la 3NF. Un schema en 3NF n'est pas toujours en BCNF (mais c'est rare en pratique).

### 5.7 Processus de normalisation en pratique

Considerons une table de gestion de commandes mal concue :

```text
COMMANDE(id_cmd, date_cmd, id_client, nom_client, adresse_client,
         id_produit, nom_produit, prix_unitaire, quantite)
```

**Dependances fonctionnelles** :

- `id_cmd -> date_cmd, id_client`
- `id_client -> nom_client, adresse_client`
- `id_produit -> nom_produit, prix_unitaire`
- `(id_cmd, id_produit) -> quantite`

**Passage en 3NF** :

```sql
CREATE TABLE CLIENT (
    id_client INTEGER PRIMARY KEY,
    nom_client TEXT NOT NULL,
    adresse_client TEXT
);

CREATE TABLE PRODUIT (
    id_produit INTEGER PRIMARY KEY,
    nom_produit TEXT NOT NULL,
    prix_unitaire REAL NOT NULL CHECK(prix_unitaire > 0)
);

CREATE TABLE COMMANDE (
    id_cmd INTEGER PRIMARY KEY,
    date_cmd DATE NOT NULL,
    id_client INTEGER NOT NULL,
    FOREIGN KEY (id_client) REFERENCES CLIENT(id_client)
);

CREATE TABLE LIGNE_COMMANDE (
    id_cmd INTEGER,
    id_produit INTEGER,
    quantite INTEGER NOT NULL CHECK(quantite > 0),
    PRIMARY KEY (id_cmd, id_produit),
    FOREIGN KEY (id_cmd) REFERENCES COMMANDE(id_cmd),
    FOREIGN KEY (id_produit) REFERENCES PRODUIT(id_produit)
);
```

---

## 6. Injection SQL

### 6.1 Principe

L'injection SQL est une vulnerabilite qui permet a un attaquant d'inserer du code SQL malveillant dans une requete, en exploitant une **construction dynamique de requetes** sans sanitisation. Elle figure regulierement dans le top 10 OWASP des vulnerabilites web.

### 6.2 Exemple vulnerable en Python

```python
import sqlite3

# CODE VULNERABLE -- NE JAMAIS FAIRE CELA EN PRODUCTION
def login_vulnerable(username, password):
    conn = sqlite3.connect('app.db')
    cursor = conn.cursor()

    # Concatenation directe : FAILLE CRITIQUE
    query = f"SELECT * FROM users WHERE username='{username}' AND password='{password}'"
    print(f"Requete executee : {query}")

    cursor.execute(query)
    result = cursor.fetchone()
    conn.close()
    return result is not None

# Utilisation normale
print(login_vulnerable("admin", "secret123"))
# Requete : SELECT * FROM users WHERE username='admin' AND password='secret123'

# ATTAQUE : injection SQL
print(login_vulnerable("admin' -- ", "nimportequoi"))
# Requete : SELECT * FROM users WHERE username='admin' -- ' AND password='nimportequoi'
# Le -- commente le reste : le mot de passe est ignore !

print(login_vulnerable("' OR 1=1 -- ", ""))
# Requete : SELECT * FROM users WHERE username='' OR 1=1 -- ' AND password=''
# 1=1 est toujours vrai : acces a tous les comptes !
```

### 6.3 Attaques classiques

| Payload | Effet |
| ------- | ----- |
| `' OR 1=1 --` | Contournement d'authentification |
| `'; DROP TABLE users; --` | Destruction de table |
| `' UNION SELECT username, password FROM users --` | Extraction de donnees |
| `' AND 1=2 UNION SELECT sql FROM sqlite_master --` | Dump du schema (SQLite) |
| `' AND (SELECT COUNT(*) FROM users) > 0 --` | Inference booleenne (blind SQLi) |
| `' AND SUBSTR(password,1,1)='a' --` | Extraction caractere par caractere (blind) |

### 6.4 Types d'injection SQL

**In-band** : le resultat de l'injection est visible dans la reponse.

- Union-based : `UNION SELECT` pour extraire des donnees d'autres tables
- Error-based : provoquer des erreurs SQL qui revelent des informations

**Blind** : aucun resultat visible, on infere l'information.

- Boolean-based : la page se comporte differemment selon que la condition est vraie ou fausse
- Time-based : `AND IF(condition, SLEEP(5), 0)` -- le temps de reponse revele l'information

**Out-of-band** : exfiltration via un canal externe (DNS, HTTP vers un serveur controle).

### 6.5 Prevention : requetes parametrees

```python
import sqlite3

# CODE SECURISE -- requetes parametrees (prepared statements)
def login_securise(username, password):
    conn = sqlite3.connect('app.db')
    cursor = conn.cursor()

    # Le ? est un placeholder, sqlite3 gere l'echappement
    query = "SELECT * FROM users WHERE username=? AND password=?"
    cursor.execute(query, (username, password))

    result = cursor.fetchone()
    conn.close()
    return result is not None

# L'injection ne fonctionne plus :
login_securise("' OR 1=1 --", "")
# Cherche litteralement un utilisateur nomme "' OR 1=1 --" -> pas trouve
```

**Regles de prevention** :

1. **Toujours** utiliser des requetes parametrees (prepared statements)
2. Valider et filtrer les entrees utilisateur (type, longueur, format)
3. Appliquer le **principe de moindre privilege** pour le compte de la base
4. Ne jamais afficher les erreurs SQL brutes a l'utilisateur
5. Utiliser un ORM (SQLAlchemy, Django ORM) qui genere des requetes parametrees
6. Utiliser un WAF (Web Application Firewall) comme couche supplementaire

---

## 7. Pratique avec SQLite

### 7.1 SQLite en ligne de commande

```bash
# Creer ou ouvrir une base
sqlite3 bibliotheque.db

# Commandes utiles dans le shell SQLite
.tables              # lister les tables
.schema LIVRE        # voir le schema d'une table
.headers on          # afficher les noms de colonnes
.mode column         # affichage en colonnes alignees
.mode csv            # mode CSV pour export
.output result.csv   # rediriger vers un fichier
.output stdout       # revenir a la sortie standard
.dump                # exporter toute la base en SQL
.quit                # quitter
```

### 7.2 Script complet en Python avec sqlite3

```python
import sqlite3

def creer_base():
    """Cree la base et les tables"""
    conn = sqlite3.connect('bibliotheque.db')
    conn.execute("PRAGMA foreign_keys = ON")  # activer les FK (desactive par defaut en SQLite)
    c = conn.cursor()

    c.executescript('''
        DROP TABLE IF EXISTS EMPRUNT;
        DROP TABLE IF EXISTS LIVRE;
        DROP TABLE IF EXISTS LECTEUR;

        CREATE TABLE LECTEUR (
            id_lect  INTEGER PRIMARY KEY AUTOINCREMENT,
            nom      TEXT NOT NULL,
            prenom   TEXT NOT NULL,
            email    TEXT UNIQUE NOT NULL
        );

        CREATE TABLE LIVRE (
            id_livre INTEGER PRIMARY KEY AUTOINCREMENT,
            titre    TEXT NOT NULL,
            auteur   TEXT NOT NULL,
            isbn     TEXT UNIQUE,
            genre    TEXT,
            annee    INTEGER,
            nb_pages INTEGER CHECK(nb_pages > 0)
        );

        CREATE TABLE EMPRUNT (
            id_emprunt INTEGER PRIMARY KEY AUTOINCREMENT,
            id_lect    INTEGER NOT NULL,
            id_livre   INTEGER NOT NULL,
            date_emp   DATE NOT NULL DEFAULT CURRENT_DATE,
            date_ret   DATE,
            FOREIGN KEY (id_lect) REFERENCES LECTEUR(id_lect),
            FOREIGN KEY (id_livre) REFERENCES LIVRE(id_livre)
        );
    ''')

    conn.commit()
    return conn

def peupler_base(conn):
    """Insere les donnees d'exemple"""
    c = conn.cursor()

    lecteurs = [
        ('Dupont', 'Marie', 'marie.dupont@mail.fr'),
        ('Martin', 'Jean', 'jean.martin@mail.fr'),
        ('Durand', 'Pierre', 'pierre.durand@mail.fr'),
        ('Leroy', 'Sophie', 'sophie.leroy@mail.fr'),
    ]
    c.executemany('INSERT INTO LECTEUR (nom, prenom, email) VALUES (?, ?, ?)', lecteurs)

    livres = [
        ('Introduction aux algorithmes', 'Cormen et al.', '978-2100545261', 'Informatique', 2010, 1292),
        ('Les Miserables', 'Victor Hugo', '978-2070409228', 'Roman', 1862, 1900),
        ('Cryptography and Network Security', 'Stallings', '978-0134444284', 'Informatique', 2017, 752),
        ('Le Petit Prince', 'Saint-Exupery', '978-2070612758', 'Roman', 1943, 96),
        ('Programmation en OCaml', 'Chailloux et al.', '978-2746225862', 'Informatique', 2005, 468),
    ]
    c.executemany(
        'INSERT INTO LIVRE (titre, auteur, isbn, genre, annee, nb_pages) VALUES (?, ?, ?, ?, ?, ?)',
        livres
    )

    emprunts = [
        (1, 1, '2025-01-15', '2025-02-01'),
        (1, 2, '2025-02-10', None),
        (2, 3, '2025-01-20', '2025-02-05'),
        (2, 1, '2025-02-15', None),
        (3, 4, '2025-03-01', '2025-03-10'),
    ]
    c.executemany(
        'INSERT INTO EMPRUNT (id_lect, id_livre, date_emp, date_ret) VALUES (?, ?, ?, ?)',
        emprunts
    )

    conn.commit()

def requetes_demonstration(conn):
    """Demontre plusieurs types de requetes"""
    c = conn.cursor()

    print("=== Livres d'informatique ===")
    for row in c.execute('''
        SELECT titre, auteur, annee
        FROM LIVRE
        WHERE genre = 'Informatique'
        ORDER BY annee
    '''):
        print(f"  {row[0]} -- {row[1]} ({row[2]})")

    print("\n=== Emprunts en cours (non rendus) ===")
    for row in c.execute('''
        SELECT L.nom, L.prenom, LI.titre, E.date_emp
        FROM LECTEUR L
        INNER JOIN EMPRUNT E ON L.id_lect = E.id_lect
        INNER JOIN LIVRE LI ON E.id_livre = LI.id_livre
        WHERE E.date_ret IS NULL
    '''):
        print(f"  {row[0]} {row[1]} : <<{row[2]}>> (depuis le {row[3]})")

    print("\n=== Nombre d'emprunts par lecteur ===")
    for row in c.execute('''
        SELECT L.nom, L.prenom, COUNT(E.id_emprunt) AS nb
        FROM LECTEUR L
        LEFT JOIN EMPRUNT E ON L.id_lect = E.id_lect
        GROUP BY L.id_lect
        ORDER BY nb DESC
    '''):
        print(f"  {row[0]} {row[1]} : {row[2]} emprunt(s)")

    print("\n=== Livres jamais empruntes ===")
    for row in c.execute('''
        SELECT titre FROM LIVRE
        WHERE id_livre NOT IN (SELECT DISTINCT id_livre FROM EMPRUNT)
    '''):
        print(f"  {row[0]}")

    print("\n=== Statistiques par genre ===")
    for row in c.execute('''
        SELECT genre, COUNT(*) AS nb, ROUND(AVG(nb_pages), 0) AS moy_pages
        FROM LIVRE
        GROUP BY genre
    '''):
        print(f"  {row[0]} : {row[1]} livre(s), ~{int(row[2])} pages en moyenne")

if __name__ == '__main__':
    conn = creer_base()
    peupler_base(conn)
    requetes_demonstration(conn)
    conn.close()
```

**Sortie attendue** :

```text
=== Livres d'informatique ===
  Programmation en OCaml -- Chailloux et al. (2005)
  Introduction aux algorithmes -- Cormen et al. (2010)
  Cryptography and Network Security -- Stallings (2017)

=== Emprunts en cours (non rendus) ===
  Dupont Marie : <<Les Miserables>> (depuis le 2025-02-10)
  Martin Jean : <<Introduction aux algorithmes>> (depuis le 2025-02-15)

=== Nombre d'emprunts par lecteur ===
  Dupont Marie : 2 emprunt(s)
  Martin Jean : 2 emprunt(s)
  Durand Pierre : 1 emprunt(s)
  Leroy Sophie : 0 emprunt(s)

=== Livres jamais empruntes ===
  Programmation en OCaml

=== Statistiques par genre ===
  Informatique : 3 livre(s), ~837 pages en moyenne
  Roman : 2 livre(s), ~998 pages en moyenne
```

### 7.3 Transactions

```sql
-- Les transactions garantissent l'atomicite (tout ou rien)
BEGIN TRANSACTION;

UPDATE LIVRE SET nb_pages = 1300 WHERE id_livre = 1;
INSERT INTO EMPRUNT (id_lect, id_livre, date_emp) VALUES (4, 5, '2025-04-01');

-- Si tout est OK :
COMMIT;

-- Si erreur, on annule tout :
-- ROLLBACK;
```

**Proprietes ACID** :

- **Atomicite** : une transaction est executee entierement ou pas du tout
- **Coherence** : la base passe d'un etat coherent a un autre etat coherent
- **Isolation** : les transactions concurrentes ne s'interferent pas
- **Durabilite** : une transaction validee est permanente, meme en cas de panne

### 7.4 Index

```sql
-- Creer un index pour accelerer les recherches par genre
CREATE INDEX idx_livre_genre ON LIVRE(genre);

-- Index composite
CREATE INDEX idx_emprunt_dates ON EMPRUNT(date_emp, date_ret);

-- Voir le plan d'execution d'une requete
EXPLAIN QUERY PLAN
SELECT * FROM LIVRE WHERE genre = 'Informatique';
-- Avec index : SEARCH TABLE LIVRE USING INDEX idx_livre_genre
-- Sans index : SCAN TABLE LIVRE
```

---

## 8. Exercices

### Exercice 1 -- Modelisation E/A

Concevoir le modele entite-association pour un systeme de gestion d'une ecole :

- Les etudiants sont inscrits dans des formations
- Les formations contiennent des matieres
- Chaque matiere a un enseignant responsable
- Les etudiants ont des notes pour chaque matiere

Preciser les cardinalites et les attributs pertinents.

### Exercice 2 -- Algebre relationnelle

Avec le schema bibliotheque defini plus haut, exprimer en algebre relationnelle :

1. Les titres des livres empruntes par Marie Dupont
2. Les lecteurs qui ont emprunte tous les livres d'informatique (utiliser la division)
3. Les lecteurs qui n'ont jamais emprunte

### Exercice 3 -- Requetes SQL

Ecrire les requetes SQL suivantes sur la base bibliotheque :

1. Nombre total de pages empruntees par chaque lecteur (somme des pages de tous les livres empruntes)
2. Le genre le plus populaire (le plus emprunte)
3. Les lecteurs ayant emprunte plus de livres que la moyenne
4. Pour chaque mois de 2025, le nombre d'emprunts effectues

### Exercice 4 -- Normalisation

La table suivante est-elle en 3NF ? Si non, la normaliser.

```text
STAGE(id_stage, nom_entreprise, adresse_entreprise, ville_entreprise,
      id_etudiant, nom_etudiant, promo_etudiant, date_debut, date_fin, note)
```

Dependances fonctionnelles :

- `id_stage -> tout`
- `id_etudiant -> nom_etudiant, promo_etudiant`
- `nom_entreprise -> adresse_entreprise, ville_entreprise`

### Exercice 5 -- Injection SQL

Analyser le code PHP suivant et identifier les vulnerabilites. Proposer une correction.

```php
$user = $_GET['user'];
$query = "SELECT * FROM comptes WHERE login = '$user'";
$result = mysqli_query($conn, $query);
```

### Exercice 6 -- Projet SQLite

Creer une base SQLite pour un systeme de gestion de tickets d'incidents :

- Tables : TECHNICIEN, CLIENT, TICKET, COMMENTAIRE
- Peupler avec au moins 10 tickets
- Ecrire 5 requetes d'analyse (tickets ouverts par technicien, delai moyen de resolution, clients les plus actifs, etc.)

### Exercice 7 -- Requetes avancees

Sur la base bibliotheque, ecrire les requetes suivantes :

1. Les lecteurs ayant emprunte au moins un livre de chaque genre (division relationnelle en SQL)
2. Le nombre cumule d'emprunts par mois (fenetre glissante avec fonctions de fenetrage si supportees)
3. Les paires de lecteurs qui ont emprunte au moins un livre en commun

---

## 9. References

- **Bases de donnees -- De la modelisation au SQL** (Laurent Audibert) -- Cours LIPN Paris 13
- **Database System Concepts** (Silberschatz, Korth, Sudarshan) -- Chapitres 1-8
- **SQL for Smarties** (Joe Celko) -- Reference avancee SQL
- **SQLite Documentation** : https://www.sqlite.org/docs.html
- **OWASP SQL Injection** : https://owasp.org/www-community/attacks/SQL_Injection
- **Programme MP2I/MPI** : BO special n. 30 du 29 juillet 2021 -- Informatique
- **SQL Tutorial** (W3Schools) : https://www.w3schools.com/sql/

---

*Cours prepare pour le niveau MP2I/MPI -- Fondamentaux d'informatique*
