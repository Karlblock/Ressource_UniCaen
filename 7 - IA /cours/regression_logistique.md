
# 🔐 Régression Logistique — Classification Binaire en Machine Learning

La **régression logistique** est un algorithme supervisé utilisé pour la **classification binaire**. Elle prédit une variable cible **catégorique** avec deux issues possibles (ex. : 0 ou 1, vrai ou faux).

---

## 🧭 Objectif

Elle estime la **probabilité** qu’un point de données appartienne à la **classe positive**. Le modèle utilise une **fonction sigmoïde** pour transformer une combinaison linéaire des features en une probabilité comprise entre 0 et 1.

---

## ❓ Classification vs Régression

| Classification              | Régression                     |
|-----------------------------|--------------------------------|
| Sortie discrète (classe)    | Sortie continue (valeur)       |
| Exemple : spam ou non spam  | Exemple : prix d’une maison    |

---

## ⚙️ Fonctionnement

Contrairement à la régression linéaire, la régression logistique ne produit pas une valeur continue mais une **probabilité**. Cette probabilité est calculée à l’aide de la **fonction sigmoïde** :

```python
P(x) = 1 / (1 + e^-z)
```

- `P(x)` : probabilité prédite
- `e` : base des logarithmes naturels (~2.718)
- `z` : combinaison linéaire des features (z = m₁x₁ + ... + mₙxₙ + c)

---

## 🧪 Exemple : Détection de spam

Le modèle peut analyser :
- Le contenu de l’email
- L’adresse de l’expéditeur
- La présence de mots-clés

Il produit une **probabilité** (ex. : 0.85) → l’email est classé comme spam si cette proba dépasse un **seuil** prédéfini.

---

## 🧱 Decision Boundary & Hyperplan

- La **frontière de décision** est le seuil qui sépare les classes.
- En 2D, c’est une **ligne** ; en N dimensions, c’est un **hyperplan**.
- Le **seuil** est souvent 0.5, mais peut être ajusté.

---

## ✂️ Seuil de décision

- Si `P(x) ≥ seuil` → classe 1 (positive)
- Si `P(x) < seuil` → classe 0 (négative)

Par exemple : avec un seuil de 0.6, une probabilité de 0.8 → classé comme spam.

---

## 🧠 Hypothèses du modèle

| Hypothèse                         | Description |
|----------------------------------|-------------|
| **Issue binaire**                 | Deux classes possibles (0 ou 1) |
| **Linéarité des log-odds**       | Relation linéaire entre features et log(odds) |
| **Faible multicolinéarité**      | Les variables ne doivent pas être fortement corrélées |
| **Taille d’échantillon suffisante** | Améliore la précision du modèle |

---

## ✅ À retenir

- Utilisée pour les tâches de **classification binaire**
- Modélise la **probabilité** via une **fonction sigmoïde**
- Produit une **frontière de décision** (ligne ou hyperplan)
- Nécessite une **bonne préparation des données**

👉 Applications : détection de fraude, diagnostic médical, filtres anti-spam, scoring crédit, etc.
