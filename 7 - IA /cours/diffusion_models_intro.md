
# Modèles de Diffusion

## Introduction

Les diffusion models sont des modèles génératifs qui utilisent un processus d'ajout et de suppression de bruit pour apprendre et générer des données, notamment des **images de haute qualité**.

## Fonctionnement Général

1. **Ajout progressif de bruit** aux données jusqu'à obtenir du bruit pur.
2. **Processus inverse** : apprentissage d'un modèle pour supprimer le bruit étape par étape.
3. **Conditionnement** possible sur du texte ou d'autres données pour guider la génération.

## Génération d'Image à partir de Texte

- **Text Encoding** : Le texte est encodé en vecteur latent (e.g., via CLIP).
- **Conditionnement du débruitage** : Le réseau de débruitage est guidé par l’encodage texte.
- **Sampling Process** : Le débruitage est conditionné à chaque étape.
- **Image Finale** : Une image cohérente avec l'invite textuelle est produite.

## Processus de Diffusion (Ajout de bruit)

```python
x_T = q(x_T | x_0)
x_t = q(x_t | x_{t-1})
```

- \( x_0 \) : donnée originale
- \( x_T \) : bruit pur

## Processus Inverse (Débruitage)

```python
x_{t-1} = p_θ(x_{t-1} | x_t)
L = E[||ε - ε_pred||^2]
```

- Le modèle apprend à prédire le bruit ajouté.

## Planning de Bruit (Noise Schedule)

```python
β_t = β_min + (t / T) * (β_max - β_min)
```

- Contrôle le niveau de bruit par étape.

## Réseau de Débruitage

- Typiquement un CNN ou un Transformer
- Entrée : \( x_t \)
- Sortie : \( \hat{ε} \)

## Formation

1. Ajouter du bruit avec le planning
2. Former le réseau de débruitage
3. Calculer la perte
4. Mettre à jour les paramètres (descente de gradient)
5. Répéter jusqu’à convergence

## Échantillonnage

```python
x_0 = p_θ(x_0 | x_T)
```

1. Démarrer avec du bruit pur
2. Appliquer \( T \) étapes de débruitage
3. Obtenir \( x_0 \) : l'échantillon généré

## Hypothèses sur les Données

- **Markov Property** : dépendance uniquement à l'étape précédente
- **Distribution Statique**
- **Hypothèse de Continuité** : variations douces dans les données favorisent l’apprentissage

---

Les modèles de diffusion sont aujourd’hui au cœur de nombreux générateurs d’image modernes comme **DALL·E 2**, **Stable Diffusion**, ou **Imagen**.
