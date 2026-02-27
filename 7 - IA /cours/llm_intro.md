
# Grands Modèles de Langage (LLM)

## Introduction

Les *Large Language Models* (LLM) sont une catégorie d’intelligences artificielles capables de comprendre et de générer du texte de manière similaire à un humain. Ils sont entraînés sur d’énormes quantités de données textuelles et utilisent une architecture appelée **Transformers**.

---

## Fonctionnement des LLM

| Concept                 | Description |
|------------------------|-------------|
| Transformer Architecture | Réseau neuronal parallèle pour traiter des phrases entières rapidement. |
| Tokenization             | Découpe le texte en unités appelées *tokens*. |
| Embeddings               | Représentations vectorielles des mots ou tokens dans un espace à haute dimension. |
| Encoders/Decoders        | Encoders pour comprendre le texte, Decoders pour le générer. |
| Self-Attention           | Mécanisme qui pondère l’importance des mots dans leur contexte. |
| Training                 | Entraînement non supervisé sur de grands corpus, optimisation par *gradient descent*. |

---

## Architecture Transformer

- Les Transformers traitent les phrases *en parallèle* (vs séquentiellement pour les RNN).
- Ils utilisent le **self-attention** pour identifier les relations entre tous les mots d’une phrase.
- Exemple : dans « Le chat était assis sur le tapis », l’attention comprend que "chat" est lié à "assis".

---

## Tokenization

Phrase : `J'aime l'intelligence artificielle`

Tokens possibles : `["J'", "aime", "l'", "intelligence", "artificielle"]`

---

## Embeddings

- Chaque token devient un vecteur numérique.
- Mots proches sémantiquement → embeddings proches.
- Exemple : `embedding("roi") ≈ embedding("reine")`

---

## Encodeurs / Décodeurs

- **Encodeur** : lit le texte d’entrée.
- **Décodeur** : génère du texte de sortie (traduction, résumé, etc.).
- Utilisés ensemble pour produire un langage naturel.

---

## Self-Attention

- Le modèle attribue un poids à chaque mot en fonction de tous les autres.
- Exemple : "le tapis, **qui** était bleu" → "qui" fait référence à "tapis".

---

## Entraînement

- Non supervisé.
- Objectif : prédire les mots manquants, corriger ou compléter le texte.
- Optimisation par **descente de gradient**.

---

## Exécution d’un LLM (Exemple)

Entrée : `"Il était une fois, un chat nommé Whiskers."`

Sortie possible :

```
Whiskers était curieux et aventureux. Un jour, il explora une forêt mystérieuse et découvrit un village secret de souris...
```

---

## Conclusion

Les LLM combinent architecture de pointe, données massives et capacités d’apprentissage avancées pour produire un texte cohérent, fluide et souvent créatif. Ils sont au cœur des assistants IA, des outils de traduction, et des moteurs de génération de contenu moderne.
