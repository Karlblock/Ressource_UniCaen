
# Détection d'Anomalie

## Introduction

Anomaly detection, également connu sous le nom de détection des valeurs aberrantes, est crucial dans *unsupervised learning*. Il identifie les points de données qui s'écartent considérablement du comportement normal dans un ensemble de données.

## Types d'anomalies

- **Point Anomalies** : Un seul point se démarque fortement.
- **Contextual Anomalies** : Le point est anormal dans un certain contexte.
- **Collective Anomalies** : Un groupe de points dévie du comportement normal.

## Techniques de détection

### 1. Méthodes statistiques

- **Z-score** et **Z-score modifié**
- **Boxplots**

### 2. Méthodes basées sur le clustering

- **K-means clustering**
- **Clustering basé sur la densité**

### 3. Méthodes basées sur le machine learning

- **One-Class SVM**
- **Isolation Forest**
- **Local Outlier Factor (LOF)**

---

## One-Class SVM

Apprend une limite qui entoure les points de données normaux. Identifie tout ce qui tombe en dehors comme une anomalie.

## Isolation Forest

Partitionne les données de manière aléatoire. Les anomalies sont plus faciles à isoler donc ont des **chemins plus courts**.

```python
score(x) = 2^(-E(h(x)) / c(n))
```

- `E(h(x))` : longueur moyenne du chemin
- `c(n)` : normalisation liée à un BST

## Local Outlier Factor (LOF)

Compare la densité locale d'un point à celle de ses voisins.

```python
LOF(p) = (Σ lrd(o) / k) / lrd(p)
```

```python
lrd(p) = 1 / (Σ reach_dist(p, o) / k)
```

- `reach_dist(p, o)` = max(distance(p, o), distance_k(o))

## Hypothèses sur les données

- Distribution normale des données (pour certaines méthodes)
- Choix pertinent des caractéristiques
- Données étiquetées parfois nécessaires

---

## Conclusion

La détection des anomalies est essentielle pour identifier les événements critiques (fraude, défaillances, erreurs). Divers algorithmes permettent d’anticiper efficacement ces cas anormaux.
