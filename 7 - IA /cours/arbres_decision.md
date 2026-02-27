
# 🌳 Arbres de Décision — Classification et Régression en Machine Learning

Les **arbres de décision** sont des algorithmes d’apprentissage supervisé utilisés pour la **classification** et la **régression**. Leur structure en arbre les rend **intuitifs, explicables** et faciles à interpréter.

---

## 🧠 Principe

Un arbre de décision apprend à **prendre des décisions** en posant une série de **questions simples** basées sur les attributs des données.

Exemple : jouer au tennis ?
- Est-ce ensoleillé ?
- Est-ce venteux ?
- Est-ce humide ?
→ Réponse : oui / non

---

## 🌲 Structure d’un Arbre

- **Nœud racine** : point de départ, contient tout l’ensemble de données
- **Nœuds internes** : critères de décision (features)
- **Feuilles** : décisions finales ou prédictions

---

## 🛠️ Construction de l’Arbre

À chaque nœud, l’arbre choisit le **meilleur attribut** pour diviser les données. Cette décision est basée sur :

- **Gini impurity**
- **Entropie**
- **Gain d’information**

🎯 Objectif : créer des sous-ensembles les plus **purs** possibles.

---

## 📉 Gini Impurity

```python
Gini(S) = 1 - Σ (p_i)^2
```

- Plus Gini est faible, plus le sous-ensemble est pur.
- Exemple : 30 A, 20 B → Gini = 0.48

---

## 🌀 Entropie

```python
Entropy(S) = - Σ p_i * log2(p_i)
```

- Mesure l’**incertitude**
- Exemple : même dataset → Entropy ≈ 0.97

---

## 📊 Gain d’Information

```python
InfoGain(S, A) = Entropy(S) - Σ (|S_v| / |S|) * Entropy(S_v)
```

- Mesure la **réduction d’entropie**
- Le meilleur split = plus grand gain d'information

---

## 🌿 Croissance de l'Arbre

L’arbre grandit récursivement tant que :

- 🏁 **Profondeur maximale** non atteinte
- 📉 **Nombre minimum** de données par nœud respecté
- ✅ **Pureté** d’un nœud atteinte (tous les points d’une classe)

---

## 🏸 Exemple : Jouer au tennis

Features :
- Outlook (Sunny, Overcast, Rainy)
- Température (Hot, Mild, Cool)
- Humidité (High, Normal)
- Vent (Weak, Strong)

Cible : `Play Tennis` (Yes / No)

🔎 L’algorithme :
- Calcule le **gain d’information** pour chaque attribut
- Crée des **branches** pour chaque valeur possible
- Répète pour chaque sous-ensemble jusqu’au critère d’arrêt

---

## 📐 Hypothèses sur les données

Les arbres de décision ont très **peu d’hypothèses** :

| Hypothèse                       | Détail |
|--------------------------------|--------|
| **Pas de linéarité requise**   | Gère relations complexes |
| **Pas de normalité**           | Aucune distribution spécifique requise |
| **Tolérance aux outliers**     | Moins sensibles aux valeurs extrêmes |

---

## ✅ À retenir

- Modèle **interprétable**, visuel, explicable
- Convient à des données **catégorielles et continues**
- Sensible à l’**overfitting** (à réguler par `max_depth`, `min_samples_leaf`, etc.)

👉 Utilisations : analyse de risque, crédit, diagnostic, jeux de données avec structure logique.
