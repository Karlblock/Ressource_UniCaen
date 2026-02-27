
# Perceptron

Le perceptron est un élément fondamental des réseaux de neurones. C'est un modèle simplifié d'un neurone biologique qui peut prendre des décisions de base. La compréhension des perceptrons est cruciale pour saisir les concepts derrière les réseaux de neurones plus complexes utilisés dans l'apprentissage profond.

## Structure d'un Perceptron

Un perceptron est constitué des composants suivants :

- **Input Values** (x₁, x₂, ..., xₙ) : Les points de données initiaux introduits dans le perceptron.
- **Weights** (w₁, w₂, ..., wₙ) : Pondèrent l'influence de chaque entrée.
- **Summation Function** (∑) : Combine les entrées pondérées.
- **Bias** (b) : Décale la fonction d'activation.
- **Activation Function** (f) : Applique une transformation non-linéaire.
- **Output** (y) : La sortie du perceptron, typiquement 0 ou 1.

## Exemple : Décider de Jouer au Tennis

Nous avons 4 caractéristiques :

- Outlook : Ensoleillé (0), Couvert (1), Pluie (2)
- Temperature : Chaud (0), Doux (1), Frais (2)
- Humidity : Élevé (0), Normal (1)
- Wind : Faible (0), Fort (1)

Poids et biais :

- w₁ = 0.3 (Outlook)
- w₂ = 0.2 (Température)
- w₃ = -0.4 (Humidité)
- w₄ = -0.2 (Vent)
- b = 0.1

Entrée : [0, 1, 0, 0] (Ensoleillé, Léger, Élevé, Faible)

```python
def step_activation(x):
    return 1 if x > 0 else 0

# Entrées
outlook = 0
temperature = 1
humidity = 0
wind = 0

# Poids et biais
w1, w2, w3, w4 = 0.3, 0.2, -0.4, -0.2
b = 0.1

# Somme pondérée
weighted_sum = (w1 * outlook) + (w2 * temperature) + (w3 * humidity) + (w4 * wind)
total_input = weighted_sum + b

# Activation
output = step_activation(total_input)
print(f"Output: {output}")  # Output: 1 (Play Tennis)
```

## Limites des Perceptrons

Les perceptrons monocouches ne peuvent pas résoudre les problèmes non-linéaires comme la fonction XOR. Ils ne peuvent tracer qu'une frontière de décision linéaire. Cela limite leur capacité à traiter des données complexes.

Un réseau multicouche (MLP) est nécessaire pour dépasser cette limite et apprendre des fonctions non-linéaires.

