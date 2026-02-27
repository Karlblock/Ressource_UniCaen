
# Réseaux Neuraux Convolutionnels

## Introduction

Convolutional Neural Networks (CNNs) sont des réseaux neuronaux spécialisés conçus pour traiter des données de type grille, telles que des images. Ils excellent dans la capture de hiérarchies spatiales de fonctionnalités, ce qui les rend très efficaces pour des tâches telles que la reconnaissance d'images, la détection d'objets et la segmentation d'images.

## Architecture Typique

Un CNN typique se compose de trois principaux types de couches :

- **Convolutional Layers** : Effectuent des convolutions sur les données d'entrée en utilisant un ensemble de filtres apprenables.
- **Pooling Layers** : Réduisent la dimensionnalité des cartes de caractéristiques.
- **Fully Connected Layers** : Similaires aux MLPs, elles effectuent un raisonnement de haut niveau.

Ces couches sont empilées alternativement pour apprendre des hiérarchies complexes.

## Feature Maps et Apprentissage Hiérarchique

Les couches convolutives produisent des *feature maps* qui détectent des motifs comme des bords ou des textures. Ce processus est hiérarchique :

- **Initial Layers** : Détection de bords et blobs.
- **Intermediate Layers** : Détection de motifs et coins.
- **Deeper Layers** : Détection de structures de haut niveau comme objets.

## Exemple : Reconnaissance d’image

CNN pour classifier une image d'animal :

- **Input Layer** : Image brute.
- **Convolutional Layers** : Extraction de caractéristiques visuelles.
- **Pooling Layers** : Réduction de la dimension spatiale.
- **Fully Connected Layers** : Prédiction (chat, chien, oiseau, etc).

## Hypothèses de Données

### Structure en Grille

Les CNN attendent des données structurées comme des images (2D) ou vidéos (3D).

### Hiérarchie Spatiale des Caractéristiques

Les caractéristiques sont supposées organisées de manière hiérarchique (bords -> motifs -> objets).

### Localité des Caractéristiques

Les CNN exploitent la localité en utilisant des filtres sur des régions locales.

### Stationnarité des Caractéristiques

Les mêmes filtres sont utilisés sur toute l’image, pour reconnaître une caractéristique indépendamment de sa position.

### Besoins en Données et Normalisation

- **Données suffisantes** : Grands ensembles étiquetés nécessaires.
- **Normalisation** : Mise à l’échelle des valeurs (ex. entre 0 et 1).

---

Ces principes rendent les CNN efficaces pour la vision par ordinateur, avec des applications dans de nombreux domaines.
