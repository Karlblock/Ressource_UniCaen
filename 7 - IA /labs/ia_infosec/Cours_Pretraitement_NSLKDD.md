
# 📘 Prétraitement et Préparation du Dataset NSL-KDD pour la Détection d'Anomalies

## 🎯 Objectif
Transformer le dataset brut NSL-KDD en un format exploitable pour entraîner un modèle de Machine Learning, comme une Forêt Aléatoire (Random Forest), pour détecter des comportements anormaux dans le trafic réseau.

---

## 1. 🔁 Classification Binaire

**But :** Distinguer le trafic *normal* du trafic *anormal (attaque)*.

```python
df['attack_flag'] = df['attack'].apply(lambda a: 0 if a == 'normal' else 1)
```

> `attack_flag = 0` ⟶ trafic normal  
> `attack_flag = 1` ⟶ attaque

---

## 2. 🌈 Classification Multi-Classes

**But :** Identifier le *type* d’attaque parmi 4 catégories :

| Classe | Type d’attaque                 |
|--------|-------------------------------|
| 0      | Normal                         |
| 1      | DoS (Denial of Service)       |
| 2      | Probe (Scan de réseau)        |
| 3      | Privilege Escalation          |
| 4      | Access (Violation accès)      |

Extrait :
```python
df['attack_map'] = df['attack'].apply(map_attack)
```

---

## 3. 🔠 Encodage des variables catégorielles

Certaines colonnes comme `protocol_type` ou `service` sont des textes (`tcp`, `http`, etc.).

🔧 On les transforme avec **one-hot encoding** :

```python
encoded = pd.get_dummies(df[['protocol_type', 'service']])
```

> Cela crée une colonne binaire pour chaque valeur unique (ex: `protocol_type_tcp`, `protocol_type_udp`, etc.)

---

## 4. 🔢 Sélection des Features Numériques

Ce sont des indicateurs statistiques sur le trafic (durée, octets échangés, taux d’erreurs, etc.).

```python
numeric_features = ['duration', 'src_bytes', 'dst_bytes', ..., 'dst_host_srv_rerror_rate']
```

---

## 5. 🔗 Assemblage du dataset

On **combine** les données encodées et les features numériques pour obtenir un dataset complet prêt à l'entraînement.

```python
train_set = encoded.join(df[numeric_features])
multi_y = df['attack_map']
```

---

## 6. ✂️ Split : Entraînement / Test / Validation

On sépare les données en 3 sous-ensembles :

| Ensemble     | Rôle                           |
|--------------|--------------------------------|
| `train`      | Apprentissage du modèle        |
| `val`        | Réglage des hyperparamètres    |
| `test`       | Évaluation finale              |

Extrait :

```python
train_X, test_X, train_y, test_y = train_test_split(...)
multi_train_X, multi_val_X, multi_train_y, multi_val_y = train_test_split(...)
```

---

## 🧠 En résumé

| Étape                        | Objectif                               |
|-----------------------------|----------------------------------------|
| Binaire & Multi-Classe      | Créer des cibles                       |
| Encodage catégoriel         | Transformer les textes en chiffres     |
| Sélection de features       | Garder les colonnes utiles             |
| Fusion données              | Créer un DataFrame exploitable         |
| Découpage                   | Évaluer correctement le modèle         |

> ✅ Prêt pour entraîner un modèle de détection (Random Forest, etc.)

---

## ✍️ Auteur
Formation HTB Academy – Adapté pour `IT_Formation`

