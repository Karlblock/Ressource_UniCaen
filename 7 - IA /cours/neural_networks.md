
# Réseaux Neuronaux

## Introduction

Pour surmonter les limitations des perceptrons monocouches, nous introduisons le concept de réseaux neuronaux (neural networks) avec plusieurs couches, aussi appelés **multi-layer perceptrons (MLPs)**.

Ces réseaux sont composés de :
- Une couche d'entrée
- Une ou plusieurs couches cachées
- Une couche de sortie

---

## Neurones

Un **neurone** est une unité de calcul fondamentale dans les réseaux neuronaux. Il :
- Reçoit des entrées
- Applique des poids et un biais
- Applique une fonction d'activation pour produire une sortie

Fonctions d'activation courantes : sigmoid, ReLU, tanh.

---

## Couche d'Entrée

- Reçoit les données
- Transmet chaque caractéristique à la première couche cachée

---

## Couches Cachées

Chaque neurone :
- Reçoit l’entrée des neurones précédents
- Calcule une somme pondérée + biais
- Applique une fonction d’activation
- Envoie sa sortie à la couche suivante

Les couches cachées permettent l’apprentissage de **représentations complexes**.

---

## Couche de Sortie

- Produit le résultat final du réseau
- Un neurone pour une tâche binaire
- Plusieurs neurones pour classification multi-classe (softmax)

---

## Pourquoi les MLPs sont puissants ?

- Apprennent des **limites de décision non linéaires**
- Peuvent **approximer n’importe quelle fonction**
- Résolvent des problèmes comme XOR

---

## Fonctions d’Activation

Les fonctions d’activation **introduisent la non-linéarité**.

- **Sigmoid** : (0,1), utilisé historiquement
- **ReLU** : 0 si négatif, sinon valeur brute
- **Tanh** : (-1,1), centré
- **Softmax** : utilisée pour multi-classe

---

## Entraînement des MLP

Deux concepts clés :
- **Backpropagation**
- **Gradient Descent**

### Backpropagation

1. Propagation avant (forward pass)
2. Calcul de l’erreur avec la sortie cible
3. Propagation arrière (calcul du gradient via la chaîne)
4. Mise à jour des poids et biais

### Descente de Gradient

Algorithme d’optimisation :
- Se déplace dans la direction du **gradient négatif**
- Utilise le **learning rate** pour ajuster la vitesse d’apprentissage

Étapes :
1. Initialiser poids et biais
2. Calculer le gradient
3. Mettre à jour paramètres
4. Répéter jusqu’à convergence

---

## Conclusion

Les MLP combinent rétropropagation et descente de gradient pour **apprendre des modèles complexes**. Chaque couche apprend des niveaux de représentation de plus en plus abstraits, rendant les réseaux neuronaux adaptés à un large éventail de tâches complexes.
