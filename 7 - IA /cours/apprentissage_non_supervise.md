
# 🔍 Apprentissage Non Supervisé — Explorer les Données Sans Étiquettes

Les **algorithmes d’apprentissage non supervisé** analysent des **données non étiquetées** pour découvrir des **modèles cachés**, des **groupes naturels**, ou des **anomalies** sans connaître les "bonnes réponses".

---

## 🧠 Principe

Comme **explorer une ville sans carte**, l’algorithme observe, mesure et relie les éléments pour détecter des structures internes aux données.

---

## 📂 Types de tâches

| Type                     | Description |
|--------------------------|-------------|
| **Clustering**           | Regrouper des points similaires (ex. : clients, livres) |
| **Réduction de dimension** | Réduire le nombre de variables sans perdre d'information |
| **Détection d’anomalies** | Identifier les points rares ou suspects |

---

## 🧾 Concepts clés

### 📉 Données non étiquetées
Pas de label. L’algorithme apprend **seul**, à partir des **features** uniquement.

### 📏 Mesures de similarité

| Méthode               | Utilité |
|-----------------------|---------|
| **Distance Euclidienne** | Distance directe |
| **Cosine Similarity**    | Angle entre vecteurs |
| **Distance Manhattan**   | Somme des écarts absolus |

---

## 🧲 Tendance au clustering

Évalue si les données **ont une propension naturelle** à former des groupes. Si non, un algorithme de clustering ne sera pas efficace.

---

## 🧪 Validité des clusters

| Mesure    | Description |
|-----------|-------------|
| **Cohésion** | Points proches au sein d’un cluster |
| **Séparation** | Clusters bien distincts entre eux |

👉 Indices : **Silhouette score**, **Davies-Bouldin Index**

---

## 📐 Notion de dimension

- **Dimensionalité** : nombre total de features
- **Dimension intrinsèque** : complexité réelle des données

🎯 Réduction de dimension = simplification sans perte significative

---

## 🚨 Anomalies & Outliers

- **Anomalie** : observation rare ou suspecte (ex. : fraude, attaque réseau)
- **Valeur aberrante** : point distant de la majorité, peut indiquer une erreur ou un pattern caché

---

## ⚖️ Feature Scaling

Important pour les distances, souvent utilisées :

| Technique           | Description |
|---------------------|-------------|
| **Min-Max Scaling** | Ramène les valeurs entre 0 et 1 |
| **Standardisation** | Moyenne = 0, variance = 1 (z-score) |

---

## ✅ À retenir

- Pas besoin de **labels**
- Utilisé pour **exploration**, **prétraitement**, **clustering**, **visualisation**
- Méthodes célèbres : **K-Means**, **PCA**, **DBSCAN**, **t-SNE**, **Isolation Forest**

👉 Idéal pour découvrir des **segments cachés**, réduire la **complexité**, ou détecter l’**inhabituel**
