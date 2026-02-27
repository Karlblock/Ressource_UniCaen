
# 📊 Naive Bayes — Classification Probabiliste en Machine Learning

**Naive Bayes** est un algorithme de classification basé sur le **théorème de Bayes**. Il est simple, rapide, robuste, et fonctionne étonnamment bien dans de nombreuses situations réelles (spam, sentiment analysis, etc.).

---

## 🧠 Théorème de Bayes

```python
P(A|B) = [P(B|A) * P(A)] / P(B)
```

- `P(A|B)` : proba de A sachant B (postérieure)
- `P(B|A)` : proba de B sachant A (vraisemblance)
- `P(A)` : proba antérieure de A
- `P(B)` : proba de B (évidence)

📌 Ex : si 1% de la population a une maladie (P(A) = 0.01) et que le test est fiable à 95% (P(B|A) = 0.95), mais qu'il y a 5% de faux positifs (P(B|¬A) = 0.05), alors :

```python
P(B) = (0.95 * 0.01) + (0.05 * 0.99) = 0.059
P(A|B) = (0.95 * 0.01) / 0.059 ≈ 16.1%
```

---

## ⚙️ Comment fonctionne Naive Bayes ?

1. **Calcul des probabilités a priori** : fréquence de chaque classe
2. **Calcul des vraisemblances** : proba des features dans chaque classe
3. **Application du théorème de Bayes** pour obtenir la proba postérieure
4. **Prédiction** : classe avec la proba postérieure maximale

💡 Hypothèse : les **caractéristiques sont indépendantes conditionnellement à la classe**, d’où le nom “naive”.

---

## 🔬 Types de Naive Bayes

| Type                    | Caractéristiques | Usage typique |
|-------------------------|------------------|---------------|
| **Gaussian**            | Variables continues (normales) | âge, revenu |
| **Multinomial**         | Variables discrètes (comptage) | fréquence de mots |
| **Bernoulli**           | Variables binaires (présence/absence) | texte booléen |

---

## 📦 Exemple : Filtrage de spam

- `P(spam) = 0.2`, `P(ham) = 0.8`
- Vraisemblance : `P("gratuit"|spam)`, `P("réunion"|ham)`
- Calcul : `P(spam|email)`, `P(ham|email)`
- Classe finale : celle avec la plus haute proba

---

## 📐 Hypothèses sur les données

| Hypothèse                         | Description |
|----------------------------------|-------------|
| **Indépendance des features**     | Conditionnelle à la classe |
| **Distribution des données**     | Dépend du type de Naive Bayes |
| **Taille d’échantillon suffisante** | Pour estimer les proba correctement |

---

## ✅ À retenir

- Basé sur **Bayes** + hypothèse d’indépendance
- Très **rapide**, **interprétable**, peu gourmand en données
- Choisir le bon modèle selon la **nature des features**
- Très efficace en **NLP**, **filtrage de spam**, **détection de fraude**, etc.
