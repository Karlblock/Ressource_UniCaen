
# Analyse des Composantes Principales (ACP)


## Définition

**Principal Component Analysis (PCA)** est une technique de réduction de dimensionnalité qui transforme des données de grande dimension en une représentation de dimension inférieure tout en préservant autant d'informations originales que possible. Il y parvient en identifiant les **composantes principales** (principal components), nouvelles variables issues de combinaisons linéaires des variables d’origine, capturant la variance maximale.

**Utilisation :**
- Extraction de fonctionnalités
- Visualisation
- Réduction du bruit

## Exemple : Données d’images faciales

Imaginez une base d’images de visages. PCA extrait les variations majeures (forme des yeux, nez, bouche), et permet de projeter les images dans un espace réduit pour identifier des visages similaires.

## Concepts clés

- **Variance** : Dispersion autour de la moyenne. PCA maximise cette variance.
- **Covariance** : Relation entre variables. PCA en tient compte.
- **Vecteurs propres et valeurs propres** : 
  - Les vecteurs propres indiquent les directions principales.
  - Les valeurs propres indiquent l’importance de chaque direction.

## Étapes de l’algorithme PCA

1. **Standardiser** les données
2. **Calculer la matrice de covariance**
3. **Calculer les vecteurs/vecteurs propres**
4. **Trier** les vecteurs propres (ordre décroissant des valeurs propres)
5. **Choisir les k premiers vecteurs propres**
6. **Projeter** les données :

```python
Y = X * V
```

## Visualisation d’un vecteur propre

```python
A = [[2, 0],
     [0, 1]]
v = [1, 0]

A * v = [2, 0] → vecteur propre v = [1, 0], valeur propre λ = 2
```

## Équation des valeurs propres

```python
C * v = λ * v
```

- C : matrice de covariance
- v : vecteur propre
- λ : valeur propre

## Sélection des composants

Tracer le **ratio de variance expliquée** en fonction du nombre de composants. Exemple : on conserve les composantes qui capturent ≥ 95% de la variance.

## Hypothèses

- Relations **linéaires** entre les variables
- Corrélations significatives
- Données **normalisées**

## Applications

- Visualisation
- Traitement d’image
- Réduction du bruit
- Prétraitement pour d’autres modèles

