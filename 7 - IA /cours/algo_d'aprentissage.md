# 🤖 Algorithmes d’Apprentissage Supervisé

L'apprentissage supervisé est au cœur de nombreuses applications en machine learning (ML). Il repose sur l'utilisation de **données étiquetées** pour entraîner un modèle capable de **prédire** des résultats sur de nouvelles données.

---

## 🧠 Principe général

L’objectif est d’**apprendre une fonction de cartographie** entre des variables d’entrée (features) et des résultats attendus (labels).

Exemple : montrer à un enfant une **pomme** et une **orange** avec leurs noms. À force d’observation, il apprend à les reconnaître par leurs **caractéristiques** (couleur, forme, taille).

---

## 🧪 Types de problèmes

- **Classification** : prédire une **catégorie** (ex. : spam / non spam)
- **Régression** : prédire une **valeur continue** (ex. : prix d’une maison)

---

## 🧱 Concepts clés

### 📊 Données de formation (Training Data)
Ensemble étiqueté utilisé pour apprendre. La qualité et la quantité ont un **impact direct** sur les performances.

### 🧩 Caractéristiques (Features)
Variables d'entrée (taille, localisation, âge d'une maison, etc.)

### 🎯 Étiquettes (Labels)
Résultats attendus (ex. : prix de la maison)

### 🧮 Modèle (Model)
Fonction mathématique apprenant à partir des données.

### 🏗️ Entraînement (Training)
Phase où l’algorithme ajuste ses paramètres pour **minimiser l’erreur** de prédiction.

### 🔍 Prédiction (Prediction)
Utilisation du modèle sur de **nouvelles données** pour prédire l’étiquette.

### 🧠 Inférence (Inference)
Comprendre les **relations internes** du modèle : importance des features, structure de la décision, etc.

---

## 🧪 Évaluation du modèle

| 📏 Mesure       | Description |
|----------------|-------------|
| **Accuracy**    | Proportion de prédictions correctes |
| **Precision**   | % de vraies positives parmi les prédictions positives |
| **Recall**      | % de vraies positives parmi toutes les positives réelles |
| **F1-score**    | Moyenne harmonique entre precision et recall |

---

## 🧬 Capacité de généralisation

- **Généralisation** : bonne capacité à prédire sur des **données inconnues**.
- **Overfitting (surapprentissage)** : le modèle **mémorise** trop les données d'entraînement.
- **Underfitting (sous-apprentissage)** : le modèle est trop **simple** pour capturer les schémas.

---

## 🔄 Techniques avancées

### ✅ Validation croisée (Cross-Validation)
Diviser les données en **k sous-ensembles** pour tester la robustesse du modèle.

### 📉 Régularisation (Regularization)
Réduire le surajustement en **pénalisant la complexité** du modèle.

- **L1 (Lasso)** : pénalise la somme des valeurs absolues des coefficients
- **L2 (Ridge)** : pénalise la somme des carrés des coefficients

---

## 📌 Résumé

L'apprentissage supervisé permet aux machines d’**apprendre à partir d’exemples**. C’est un pilier du ML appliqué à :
- La détection de fraude
- La reconnaissance d’images
- Les prévisions financières
- Le traitement des emails (spam)

👉 Maîtriser ces bases est essentiel avant d’aborder les modèles plus complexes comme les réseaux de neurones ou les LLM.

---

