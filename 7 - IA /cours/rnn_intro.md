
# Réseaux Neuraux Récurrents (RNN)

## Introduction

Les Recurrent Neural Networks (RNNs) sont conçus pour gérer des données séquentielles où l'ordre est important. Contrairement aux réseaux neuronaux classiques, les RNN maintiennent une "mémoire" des entrées passées grâce à leurs connexions récurrentes.

## Gestion des Données Séquentielles

Les RNN traitent chaque élément d'une séquence en tenant compte de l'entrée actuelle et de l'état caché précédent.

### Exemple

Phrase : "Le chat était assis sur le tapis."  
À chaque mot, l'état caché s'actualise avec les nouvelles informations.

## Problème du Gradient de Disparition

Le **vanishing gradient** survient lors de la rétropropagation dans le temps (BPTT) : les gradients diminuent à chaque étape, empêchant l’apprentissage des dépendances à long terme.

## LSTM et GRU

Pour résoudre ce problème, deux variantes populaires :

### LSTM (Long Short-Term Memory)

Utilise des cellules mémoire et 3 portes :
- **Input gate**
- **Forget gate**
- **Output gate**

### GRU (Gated Recurrent Unit)

Plus simple, avec 2 portes :
- **Update gate**
- **Reset gate**

## RNN Bidirectionnels

Les **bidirectional RNNs** traitent la séquence dans les deux sens (gauche à droite et droite à gauche) pour améliorer le contexte global.

## Applications Typiques

- Traduction automatique
- Reconnaissance vocale
- Analyse de sentiments
- Prédiction de séries temporelles

---

**Note** : Les LSTM et GRU permettent de conserver le contexte sur de longues séquences, une avancée clé pour le traitement du langage naturel.
