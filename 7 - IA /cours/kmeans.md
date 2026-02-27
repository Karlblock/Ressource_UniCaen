
# 🔢 K-Means Clustering — Segmentation Non Supervisée

**K-Means** est un algorithme non supervisé populaire pour **regrouper** des données en `K` clusters distincts. Il vise à **minimiser la variance intra-cluster** et maximise la séparation entre clusters.

---

## 🧭 Principe

K-Means regroupe les données **selon leur similarité**, souvent mesurée par la **distance euclidienne** dans un espace à N dimensions.

---

## 🛠️ Étapes de l'algorithme

1. **Initialisation** : choix aléatoire de `K` centroïdes
2. **Attribution** : assigner chaque point au centroïde le plus proche
3. **Mise à jour** : recalculer les centroïdes (moyenne des points affectés)
4. **Itération** : répéter jusqu'à stabilisation ou max itérations

---

## 📏 Distance Euclidienne

```python
d(x, y) = sqrt(Σ (xᵢ - yᵢ)²)
```

Permet de mesurer la **proximité** entre deux points dans un espace multidimensionnel.

---

## 🔍 Choisir le bon K

### ✅ Méthode du Coude

1. Exécuter K-Means pour plusieurs `K`
2. Calculer **WCSS** (somme des distances intra-cluster)
3. Repérer le "coude" du graphe `WCSS vs K`  
   → Point où l'amélioration devient marginale

### ✅ Analyse de Silhouette

- Score entre -1 et 1
- Indique si un point est **proche de son cluster** et **éloigné des autres**
- Meilleur `K` = plus **haut score moyen**

---

## 🧠 Considérations complémentaires

- **Expertise métier** : déterminer un `K` exploitable
- **Interprétabilité** : éviter les clusters trop nombreux
- **Coût computationnel** : `K` trop élevé = temps + mémoire
- **Granularité souhaitée** : segmentation marketing, campagnes, etc.

---

## ⚠️ Hypothèses de K-Means

| Hypothèse              | Détail |
|------------------------|--------|
| **Forme sphérique**     | Les clusters sont supposés compacts et isotropes |
| **Échelle des features** | Nécessite une **normalisation** préalable |
| **Sensibilité aux outliers** | Les points extrêmes peuvent fausser les centroïdes |

---

## ✅ À retenir

- Rapide, scalable, facile à implémenter
- Très utilisé pour la **segmentation client**, **analyse de comportement**, **prétraitement NLP**
- Bien choisir `K` et **scaler les données** pour de meilleurs résultats

👉 Alternatives à explorer : **DBSCAN**, **GMM**, **Spectral Clustering**
