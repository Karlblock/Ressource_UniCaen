# Network Traffic Analyse

## introduction

Identifier le traffic rapidement

**Unités de Données de Protocole (PDU)**
Un PDU est un paquet de données composé d'informations de contrôle et de données encapsulées à partir de chaque couche du modèle OSI.

### Layer 1 - 4

| Caractéristique            | TCP                                                                           | UDP                                                      |
|----------------------------|-------------------------------------------------------------------------------|----------------------------------------------------------|
| Transmission               | Orienté connexion                                                             | Inconnecté. Feu et oublier.                              |
| Connection Establishment   | TCP utilise une poignée de main à trois voies pour s'assurer qu'une connexion est établie. | UDP ne garantit pas que la destination écoute.           |
| Data Delivery              | Conversations basées sur des flux                                             | Paquet par paquet, la source ne se soucie pas si la destination est active. |
| Receipt of data            | Les numéros de séquence et d'accusé de réception sont utilisés pour comptabiliser les données. | UDP s'en fiche.                                          |
| Speed                      | TCP a plus de frais généraux et est plus lent en raison de ses fonctions intégrées. | UDP est rapide mais peu fiable.|

### Layer 5 - 7

## Analyse

### Procédure d'analyse

#### Couche Network

#### Couche App

Discussion avec un serveur Web

### Analyse Pratique

1) Quel est la volonté de l'attaque ?
2) Quel est la taille d'infection ( 1 postes ou l'ensemble des postes national ou internation de l'entreprise ) et depuis quand ? toujours actif et en propagation ?
3) Qui est affecté ? segment machine compte base apps routage dns ad ?...
4) Capturer du traffic sur un segment infecteé.
5) Identifier les flux inexpliqué sur ce segment avec l'aide du soc ou des admins. Vous aurez besoin de tout le monde qui connais le metier.
6) Une fois le flux identifier, creuser... comprennez est ce isolé sur celui qui ou ça appel d'autre flus ?
exemple si ça get sur du http ou autre...
1) Prenez des notes tout au long du pressésus.
2) Faite un résumé de ce que vous avez trouvé.

Les composantes clé pour réussir votre Analyse :

connaitre votre environement
savoir ce positionner sur le reseau pour extraire le traffic qui vous apportera la cause
persistance
ouverture d'esprit, ce n'est pas forcement là ou vous avez envi que ce soit. ( le "C'est pas normal" doit être banni de votre vocabulaire)

## TCPDUMP

### Fondamentaux

### Capturer avec TCPDUMP

### Filtrage


