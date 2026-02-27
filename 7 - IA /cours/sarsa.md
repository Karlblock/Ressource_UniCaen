
# SARSA (State-Action-Reward-State-Action)

SARSA est un algorithme de reinforcement learning **sans modèle** et **on-policy**. Contrairement à Q-learning (off-policy), SARSA met à jour ses valeurs en fonction **de l’action réellement prise** dans l’état suivant selon la politique suivie.

## Règle de mise à jour

```python
Q(s, a) = Q(s, a) + α * [r + γ * Q(s', a') - Q(s, a)]
```

- `s` : état courant
- `a` : action courante
- `r` : récompense
- `s'` : prochain état
- `a'` : prochaine action
- `α` : taux d’apprentissage
- `γ` : facteur de remise

## Étapes de l’algorithme SARSA

1. **Initialisation** du Q-table (valeurs initiales à 0)
2. **Choix d’une action** `a` selon une stratégie d’exploration (ex: epsilon-greedy)
3. **Exécution de l’action** `a`, observation de l’état `s'` et récompense `r`
4. **Choix de la prochaine action** `a'` dans `s'` (avec même stratégie)
5. **Mise à jour de la Q-value** pour `(s, a)`
6. **Mise à jour** de `s ← s'` et `a ← a'`
7. **Itération** jusqu'à convergence

## SARSA vs Q-Learning

| Point de comparaison         | SARSA (on-policy)                             | Q-Learning (off-policy)                     |
|-----------------------------|-----------------------------------------------|---------------------------------------------|
| Type d'apprentissage         | On-policy                                    | Off-policy                                  |
| Mise à jour Q(s,a) basée sur | Q(s', a') suivant politique actuelle         | max(Q(s', a'')) (action optimale)           |
| Nature                      | Prudente (respect de la politique suivie)     | Ambitieuse (apprentissage de la politique optimale) |
| Sécurité / Stabilité        | Favorisée                                     | Moins priorisée                             |

## Stratégies Exploration-Exploitation

### Epsilon-Greedy

Probabilité `ε` d’explorer, `1-ε` d’exploiter :

```python
if random() < epsilon:
    action = random.choice(actions)
else:
    action = argmax(Q[state])
```

### Softmax

Utilise les probabilités basées sur les Q-values (température) :

```python
P(a) = exp(Q(s,a)/T) / Σ exp(Q(s,b)/T)
```

Favorise une exploration plus douce que epsilon-greedy.

## Convergence et Paramètres

- `α` (learning rate) : haut = apprentissage rapide mais instable ; bas = lent mais stable
- `γ` (discount factor) : haut = récompenses futures ; bas = court terme
- ε (exploration) diminue souvent avec le temps

## Hypothèses

- **Propriété de Markov** : l’état suivant dépend seulement de l’état actuel et de l’action.
- **Environnement stationnaire** : les règles de transition ne changent pas dans le temps.

## Quand utiliser SARSA ?

- Lorsque la **sécurité**, **stabilité** ou **respect strict d’une politique exploratoire** sont essentiels
- En environnements dynamiques ou partiellement connus
