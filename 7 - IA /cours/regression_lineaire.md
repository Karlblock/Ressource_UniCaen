
# 📈 Régression Linéaire — Fondamentaux du Machine Learning

La **régression linéaire** est un algorithme central en **apprentissage supervisé**, utilisé pour prédire une **valeur continue** à partir d'une ou plusieurs variables explicatives. Il établit une **relation linéaire** entre les données d’entrée (features) et la variable cible (label).

---

## 🔍 Qu'est-ce que la régression ?

La **régression** vise à estimer une **valeur numérique** plutôt qu’à classifier. Exemples d’usage :

- Prédire le **prix d’une maison** en fonction de sa taille, localisation, etc.
- Estimer la **température** d’un jour à partir de l’historique météo.
- Prévoir le **trafic web** à partir des dépenses marketing.

---

## 📏 Régression Linéaire Simple

Relation entre **une seule variable prédictive** et une **cible continue** :

```python
y = m * x + c
```

- `y` : variable cible prédite  
- `x` : variable explicative  
- `m` : pente (impact de x sur y)  
- `c` : constante d’interception  

🎯 Objectif : trouver les meilleurs `m` et `c` pour **minimiser l’erreur** entre les prédictions et les valeurs réelles (via la méthode **des moindres carrés ordinaires**, OLS).

---

## 🧮 Régression Linéaire Multiple

Lorsque plusieurs variables prédictives sont utilisées :

```python
y = b0 + b1*x1 + b2*x2 + ... + bn*xn
```

- `x1, x2, ..., xn` : variables explicatives  
- `b0` : interception  
- `b1, ..., bn` : coefficients associés  

---

## ⚙️ OLS – Ordinary Least Squares

Méthode pour estimer les **coefficients optimaux** :

1. **Résidus** : différence entre valeur réelle et valeur prédite  
2. **Élévation au carré** des résidus  
3. **Somme des carrés des résidus (RSS)**  
4. **Minimisation de la RSS** → ligne de "meilleur ajustement"

📉 L’objectif est de **minimiser l’erreur globale** du modèle.

---

## 🧠 Hypothèses de la régression linéaire

Pour garantir la validité du modèle, certaines hypothèses doivent être respectées :

| Hypothèse           | Description |
|---------------------|-------------|
| **Linéarité**        | Relation linéaire entre variables |
| **Indépendance**     | Les observations sont indépendantes |
| **Homoscédasticité** | Variance constante des erreurs |
| **Normalité**        | Distribution normale des résidus |

⚠️ Si ces hypothèses sont violées, les **inférences statistiques** ou les **prédictions** peuvent être biaisées.

---

## ✅ Pourquoi utiliser la régression linéaire ?

- Simplicité et **interprétabilité**
- Rapide à entraîner
- Base pour des modèles plus complexes (ex. : régression polynomiale, ridge, lasso)

---

## 📌 À retenir

La régression linéaire est une **brique essentielle** en machine learning pour :

- Comprendre la **relation entre variables**
- Prédire des valeurs continues
- Construire des modèles robustes pour l'analyse prédictive

👉 À explorer ensuite : **régression logistique**, **régularisation (L1/L2)**, et **modèles non linéaires**.
