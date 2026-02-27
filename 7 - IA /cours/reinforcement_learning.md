# Renforcement Apprentissage Algorithmes

**Reinforcement learning (RL)** introduit un paradigme unique dans *machine learning* où un agent apprend en interagissant avec un environnement. Contrairement au *supervised learning*, qui repose sur des données étiquetées, ou *unsupervised learning*, qui explore les données non étiquetées, le RL se concentre sur l'apprentissage par essais et erreurs, guidé par des commentaires sous forme de récompenses ou de pénalités.

---

## Comment fonctionne le Renforcement de l'Apprentissage

L'agent agit sur l'environnement, observe les conséquences et reçoit une **récompense**. Le but est d'apprendre une **politique optimale** (policy) qui maximise les récompenses cumulées.

**Deux types principaux d'algorithmes :**
- **Model-Based RL** : l'agent modélise l'environnement.
- **Model-Free RL** : l'agent apprend directement par l’expérience.

---

## Concepts de base en Renforcement Apprentissage

### Agent
L'agent prend des décisions et apprend des expériences.

### Environnement
Le monde externe avec lequel l’agent interagit.

### État
La représentation actuelle du monde que perçoit l'agent.

### Action
La décision prise par l’agent à un instant donné.

### Récompense
Le retour scalaire reçu par l'agent (positif, négatif ou nul).

### Politique
Stratégie pour choisir les actions selon l'état.

### Fonction de Valeur
Estime de la récompense cumulative attendue :

- **State-value function** : V(s)
- **Action-value function** : Q(s,a)

### Facteur de Réduction (Discount Factor γ)
Poids donné aux récompenses futures :
- γ = 0 : uniquement immédiat
- γ = 1 : long terme entièrement pris en compte

---

## Tâches Episodiques vs Continues

- **Tâches épisodiques** : L’agent atteint un état terminal.
- **Tâches continues** : Pas d’état terminal, apprentissage continu.

---

Ce paradigme est essentiel pour résoudre des problèmes comme :
- Navigation robotique
- Jeux vidéo (AlphaGo, Dota2)
- Recommandations adaptatives
- Trading algorithmique
- Contrôle industriel
