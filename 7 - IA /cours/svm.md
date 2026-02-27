
# ⚔️ Support Vector Machines (SVM) — Classification & Régression

Les **SVM** sont des algorithmes d’apprentissage supervisé puissants pour la **classification** et la **régression**, capables de gérer des **données de haute dimension** et des **relations non linéaires** complexes.

---

## 📏 Principe

Les SVM cherchent à **maximiser la marge** entre deux classes à l’aide d’un **hyperplan optimal**. Les **vecteurs de support** sont les points les plus proches de la frontière : ils définissent l’hyperplan.

---

## 🧮 SVM Linéaire

Utilisé lorsque les données sont **linéairement séparables**.

### Équation de l'hyperplan :

```python
w * x + b = 0
```

- `w` : vecteur de poids (perpendiculaire à l’hyperplan)
- `x` : vecteur de caractéristiques
- `b` : biais (offset)

🎯 Objectif : **maximiser la marge** tout en classant correctement les points d'entraînement.

---

## 🔀 Hyperplan Optimal

Il maximise la distance entre les vecteurs de support de chaque classe :

```python
Minimize: 1/2 ||w||^2
Subject to: yᵢ(w * xᵢ + b) ≥ 1  ∀ i
```

---

## 🌀 SVM Non Linéaire & Kernel Trick

Quand les données **ne sont pas linéaires**, on utilise le **kernel trick** : transformer les données dans un espace de dimension supérieure pour les rendre linéairement séparables.

### Fonctions de noyau courantes :

| Noyau         | Description |
|---------------|-------------|
| **Polynomial**| Ajoute des termes de type x², x³... |
| **RBF (Gaussien)**| Capture les motifs non linéaires complexes |
| **Sigmoïde**  | Similaire à la fonction sigmoïde logistique |

---

## 🐾 Exemple : Classification d'Images

Les SVM non linéaires peuvent **capturer les motifs complexes** dans des images (forme, texture, contour) et classifier chats vs chiens.

---

## 🧠 Avantages des SVM

- ✅ **Pas d’hypothèses fortes** sur la distribution des données
- ✅ Efficaces dans les espaces **haute dimension**
- ✅ **Robustes** aux outliers (seuls les vecteurs de support comptent)

---

## 🧾 À retenir

- Algorithme **puissant et robuste**
- Adapté aux problèmes **linéaires et non linéaires**
- Nécessite le **choix d’un noyau approprié**
- Très utilisé pour : bioinformatique, texte, images, finance

👉 À explorer : **SVM multiclasses**, **SVM pour régression (SVR)**, **GridSearchCV pour les paramètres**
