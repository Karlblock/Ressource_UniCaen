
# Q-Learning

Q-learning est un algorithme de reinforcement learning **sans modèle** qui apprend une politique optimale en estimant la Q-value. Le Q-value représente la récompense cumulative attendue qu'un agent peut obtenir en prenant une action spécifique dans un état donné et en suivant la politique optimale par la suite.

## Principe

Il fonctionne par **essais-erreurs** en interagissant avec un environnement sans avoir besoin de modèle de celui-ci.

## La Q-Table

La Q-table contient pour chaque paire état/action une valeur Q indiquant l’utilité d’une action dans un état donné :

| État/Action | Up   | Down | Gauche | Droit |
|-------------|------|------|--------|-------|
| S1          | -1.0 | 0.0  | -0.5   | 0.2   |
| S2          | 0.0  | 1.0  | 0.0    | -0.3  |
| S3          | 0.5  | -0.5 | 1.0    | 0.0   |
| S4          | -0.2 | 0.0  | -0.3   | 1.0   |

## Mise à jour de la Q-value (règle de Bellman)

```python
Q(s, a) = Q(s, a) + α * [r + γ * max(Q(s', a')) - Q(s, a)]
```

- `α` : taux d’apprentissage
- `γ` : facteur d’escompte (importance des récompenses futures)
- `r` : récompense immédiate
- `s'` : état suivant

## Étapes de l’algorithme Q-learning

1. **Initialisation** de la Q-table.
2. **Choix d’une action** (exploration ou exploitation).
3. **Exécution de l’action** et **observation** de la récompense et du nouvel état.
4. **Mise à jour** de la Q-table.
5. **Répétition** jusqu’à convergence.

## Stratégie Exploration-Exploitation

### Epsilon-Greedy

```python
if random() < epsilon:
    action = random.choice(actions)  # exploration
else:
    action = max(Q[state])          # exploitation
```

- Valeur élevée de epsilon → + d’exploration
- Valeur faible → + d’exploitation
- Epsilon peut diminuer avec le temps

## Hypothèses

- **Markov Property** : l’état suivant dépend uniquement de l’état actuel et de l’action.
- **Environnement stationnaire** : les règles ne changent pas dans le temps.

## Avantages

- Ne nécessite pas de modèle de l’environnement
- Facile à implémenter
- Converge vers la politique optimale avec assez de temps et d’exploration

## Utilisations typiques

- Navigation robotique
- Jeux (ex. : Pac-Man, Labyrinthe)
- Contrôle de processus industriels
