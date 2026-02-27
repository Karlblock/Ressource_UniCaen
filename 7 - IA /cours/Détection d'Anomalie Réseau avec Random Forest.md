
# 📊 Détection d'Anomalies Réseau avec Random Forest

## 🧠 Objectif
Détecter des comportements réseau anormaux (potentiellement malveillants) en utilisant des algorithmes de machine learning, en particulier les **forêts aléatoires (Random Forest)**.

---

## 1. 🔍 Détection d’Anomalies
Une anomalie est un point de données qui s’écarte significativement des comportements normaux.
En cybersécurité, cela peut indiquer :
- Une intrusion
- Une attaque réseau
- Un comportement utilisateur suspect

---

## 2. 🌲 Random Forest — Rappel

Un **Random Forest** est une méthode d’**ensemble** basée sur plusieurs arbres de décision.

### ✅ Avantages :
- Réduction de l’overfitting
- Bonne généralisation sur données complexes
- Résilient et interprétable

### 🔑 Concepts clés :
- **Bootstrapping** : tirages aléatoires avec remise pour créer plusieurs jeux d'entraînement.
- **Random Subset of Features** : chaque arbre ne voit qu’une partie des colonnes.
- **Voting / Moyenne** : 
  - Classification → vote majoritaire
  - Régression → moyenne des prédictions

---

## 3. 🛡️ Détection d’Anomalies avec Random Forest
- Entraînement sur des données **normales uniquement**
- Les points nouveaux sont comparés à ce comportement appris
- Une prédiction **incertaine ou discordante** peut indiquer une **anomalie**

---

## 4. 📦 Dataset NSL-KDD

### ✅ Description :
- Variante améliorée de KDD’99
- Équilibré (moins de duplicatas)
- Représente des connexions normales et malveillantes

### ✅ Avantages :
- Compatible classification binaire et multi-classes
- Adopté comme benchmark en détection d’intrusion

---

## 5. ⚙️ Pipeline d’Analyse

### Étapes :

1. 📥 **Téléchargement du dataset**
```python
import requests, zipfile, io
url = "https://academy.hackthebox.com/storage/modules/292/KDD_dataset.zip"
response = requests.get(url)
z = zipfile.ZipFile(io.BytesIO(response.content))
z.extractall('.')  # extrait dans le répertoire courant
```

2. 📊 **Chargement dans un DataFrame**
```python
import pandas as pd

columns = [ ... ]  # liste des colonnes NSL-KDD
df = pd.read_csv("KDD+.txt", names=columns)
```

3. 🔧 **Prétraitement**
   - Encodage des variables catégorielles (`protocol_type`, `service`, `flag`)
   - Normalisation ou standardisation des features
   - Split train/test

4. 🌲 **Entraînement Random Forest**
```python
from sklearn.ensemble import RandomForestClassifier
model = RandomForestClassifier()
model.fit(X_train, y_train)
```

5. 📈 **Évaluation**
```python
from sklearn.metrics import classification_report
print(classification_report(y_test, y_pred))
```

---

## 6. 🔍 Visualisation
- Matrice de confusion
- Feature importance
- Analyse t-SNE ou PCA (optionnelle)

---

## 7. 📁 Fichier associé

- `random_forest_anomaly_detection.ipynb` – Notebook complet d'entraînement et analyse

---

## ✍️ Auteur
Hack The Box Academy — Adapté et résumé par [Tonot Cyber Normandie]
