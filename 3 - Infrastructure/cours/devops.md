# DevOps

###### DevOps ######

##### La Méthode #####

-> Délivrer avec méthode et éfficacité

## Section 1 ##

1.  Objectif :
2.  Le CBOK
3.  histoire du DevOps
4.  Les Autres méthodes
5.  La valeur apportée par DevOps
6.  l'importantce du DevOps
7.  DevOps vu de l'extérieur

# Le CBOK :

-   Collective body of knowledge 
    - Evenement :
        Devopscon
        Devops enterprise summit
        les devOps days
    - DevOps Institute
        Certification DevOps
            DevOps Foundation
            DevOps Leader
            DevsecOps engineer
    - Dasa : DevOps agile Skills Association 
        Certification 
            Dasa Founda
            D   Pro
            D   Leader / coach

-   DevOps :
    -   Create 
    -   Vérify
    -   package
    -   Release
    -   Configure
    -   Monitor
    -   Plan
        
-   La mission d'un dev : 
    -   Nouveau produit
    -   Nouvelle function
    -   Correctifs des apps
    -   Mise à jour sécu

Les problemes du Bob :
    Longueur de mise en prod des correctifs

Pourquoi bob ne pouvais pas déployer 

La mission de l'ops : 
    Admin réseau & system
    Sécu du SI
    Assister user
    Faire évoluer l'infrastructure actuelle 


The DevOps HandBook hos to create world class agility reliability & security in technology organizations 

Ce que le DevOps n'est pas ! 
    Ce n'est pas un titre
    Une équipe
    Outil
    Une culture
    De l'automatisation

    C'est vouloir réunir les DEV et les OPS au sein d'un même but !

    Crée une méthode qui s'appuie sur des outils afin de répondre au besoin des DEV & OPS 

Gestion de projets
    Scrum
    lean
    kanban
        Workflow ( backlog > To Do > In Progress > Test > Done )

Personne
    -> Processus
        -> Automation

# Objectif : 

Les Objectifs du DevOps : 

    Deploiement plus petit et plus fréquent
    Réduction des risques et de l'effort necessaire
    Réduction des couts des itérations et des delais
    Culture de communiation et de collaboration
    Constance et radpidité grave à l'automatisation

Amélioration le Time to Value
    Intégration des pratiques avec le business
    Réactivité accrue des équipes 
    Code et déploiement de meilleurs qualités
    Grave au technique et outil
    Productivité plus importante
    Visibilité des actions menées par les équipes

# CALMS
 
    -   Culture > Focus sur les gens les changements dans l'équipe et l'expérimentation
    -   Automatisation > Deploiement Continu & Infra as code IaC
    -   Lean Focus sur la production de la valeur et la faible taille des release Meusures tout mesurer    monter l'amélioration et la progression
    -   Sharing Partage ouvert de toutes les informations => Collaboration et Communication

L'automatisation au coeur du Devops :
    Docker
    Ansible
    Puppet
    Chef
    SaltStack
    CF Engine
    Vagrant
    ETC........................................

# L'importance du DevOps 
Acceleration State of DevOps de 2019 ( Statisque ) Via Google : 
    208 fois plus de deploi de code
    106 plus rapide du commit
    2604 fois plus rapide pour une retour après incident

    7 fois moins d'incidents en cas de changement

Les DevOps vu par le Business et la Technique


# Le DevOps vu de l'exterieur : 

Le business
    The Golden Circle 
        Why
            Ne fait pas référence à l'argent, il s'agit d'un résultat, un but ou une croyance.
            La raison pour laquelle la société existe !

        How
            il s'agit des choses qui rendent spéciales ou qui distinguent de la concurrence
        What
            il s'agit des produits vendus ou des services offerts

Les gens n'achetent pas ce que vous vendez mais ce pourquoi vous le vendez !

La Technique : 
    Les méthodes agiles ont joué un role déterminant dans l'amélioration du dev et la confiance 
    des services

    Les Challenges de L'IT
        Qualité l'it doit toujours aller plus vite sans augmenter le risque et diminuer la qualité
    Investissements:
        les inves ne suffisent pas à eux seuls à apporter de la valeur sur l'ensemble de spectre d l'it
    Culture
        la culture en silos limite la capacité


        
## Section 2 : les 5 piliers : ##

1.   First Way
2.   Second Way
3.   Third Way
4.   Chaos engineering

# First Way :

    Souligne l'importance de la performance de tout le système et non pas d'un département ou d'un service Spécifique

        Implications du First Way :

            Augmenter ce Flux grâce à la compréhension de l'ensemble des contraintes qui existent ( de la gauche vers la droite)

            un défaut connu ne sera jamais ignoré et ne pourra pas passer en aval sans être traité

            Interdiction des optimisations locale qui pourraient causer une dégradation globale
        
        La théorie des contraintes (livre the Goal de M. Goldratt) :

            La Toc ( identifier les facteurs limitant )
                => Amélirer la contrainte

            Gerer les goulots d'étranglement 

        La stratégie :

            identification
            exploit la contrainte
            subordonner l'organication et toute l'acion à l'aper 2
            résoudre ou réduire la contrainte
            Retour à la premier Etape
        
        Exemple de contrainte dans l'IT : 

            Maintenant le FORMATION et les Expertisent 
            Delais de dev
            création des ENV
            Insta des exe des test
            Archi obsolete
            Gestion trop complexe des process admin..............;

# Second Way : 

    souligne l'importante du Feedback. On peut ainsi réduire le délai en effectuant des boucles de feedback plus courtes.

    Cette boucle incite à comprendre et répondre aux besoins de tous les clients, internes comme externes

        Exemples de boucles de feedback :

            Tests Automatiques:
                Effectués lors du push du codes vers le dépot GitHub.
                Vérifier que le code fonctionne correctement, qu'il ne présente pas de failles de sécurité, qu'il est compatible avec l'environnement de production, etc..

            Peer Review
                Demander à une collégue de vérifier les changement effectués sur le code
                et qu'il les valide avant de l'utiliser ce code en production
            
            Supervision
                Utiliser des monitoring ( kibana )


# Third Way :

-   Souligne l'idée de créer une culture qui favorise l'exp continue incluant de prendre des risques et d'apprendre de ses échecs

    -   La répétiton et la pratique, et donc les échecs potientiels qui en découlent sont des prérequis indispensable à la maitrise

    -   Allouer du temps spécifiquement dédié pou améliorer le travail quotidien

    -   Créer des rituels permettant de récompenser l'équipe lordqu'elle prend des risques

    -   Planifier du temps pour effectuer des expérimentations en toute sécurité et participer à l'innovation (hackathons).

# L'ingénierie du Chaos :

-   Consiste à mettre en place  un outil en production qui va volontairement causer des panes 

    -   La résilience des logiciels conçus devient une obligation et non plus une option

    -   Ces robots codes et concepts ont été rendus openSource en 2012 et disponible pour à l'adresse github => chaosmonkey 
        -   La Simian Army
                Chaos Gorilla : rend hors service une zone compléte de disponiblité AWS
                Chaos Kong : Rend hors service une région compléte de dispo AWS
                Janitor Monkey :  Rend hors service toutes instances non utilisées afin d'éviter la surconsommation des ressources
                Latency Monkey

                Github => netflix Simiam Army
        -   Les Chaos Monkey contribuent directement à la Toolchain

##### La Technique : #####

#### Section 3 Les pratiquent Techniques du Devops :  ##

1.   Objectif
2.   Continuous Testing
3.   Intégraton Continu (CI)
4.   Continous Delivery
5.   Ingénieurs SRE
6.   Les autres métiers du DevOps

### Objectif : 
    
Aborde les aspects techniques du DevOps notamment en traitant les différentes couches techniques qui sont nécessaires aux "Thee Ways" abordées précédemment.

## Continous Testing :

 Correspond au processus d'éxécution de test automatiques

    Continous integration > continunous delivery > deploy
                          Le Continunous Delivery fait partie du CONTINUOUS DEPLOYMENT

 # Le Shift Lelt :

 -  Ces test doivent être intégrés au pipeline de déploiement du code pour obtenir un feedback le plus rapidement possible 
 
 -  Shift Left to Shift Right : 
    -   Of New code
    -   Of Every Build
    -   Of Every Deploiemnt
    -   in Production

 # Les Tests Fonctonnels :

 -  Ce sont les tests pour lesquels jusqu'à récemment, une action manuelle était nécessaire.

    -  Tests Unitaires
    -  Test D'API
    -  Test D'intégration
    -  Test système


 # les Tests non Fonctionnels :

 -  Ce sont les test qui permettent de tester les performances de la fonctionnalité : 

    - Les types de tests non funct :
        -   Performance
        -   Sécurité
        -   Capacitaires
        -   Compatibilité
        -   Documentation testing
        -   User interface Testing
        -   Load Testing
        -   Volume Testing
        -   Stress testing

# Intégration Continue ( CI ) : https://www.youtube.com/watch?v=cG9iymSS3II&t=1s

-   L'intégration continue correspond à des pratiques de développement, impliquant le commit du code dans un dépot partagé par les développeurs : 

    Developer
    Source Control
    Build
    Test
    Report
    Release

- Phase de prérequis 

    -   Les regles de bases pour établir les standards de code qu'on souhaite utliser dans l'organisation ( PEP8,  FLAKE8, Pylint, etc...)

    -  Implémenter un dépôt de code permettant du versionning (Github & GitLab)

    -   Mettre en place des serveurs d'intégration Continue pour collecter, builder, et tester les codes ont été comités
        Exemple : jankins ( voir qui existe d'autre ) 

    -   Effectuer ces test sur des env proches de ceux de production

    -   Permettre la détection rapide des erreurs pour les rollback avant la production.



-   Phase de build :
    -   Quelqu'un vient de dépose du code dans le dépot

-   Phase de Test :
    -   Réalisation de tests auto d'inté et d'acceptance 


# Continunous SRE : 

-   Capacité à fournir un software ( ou du code) qui est toujours dans une releasable state ( disponible pour l'utilisation) à travers  sont cycle de vie.

    - Amène l'ingration continue à son niveau supérieur  

Les bénéfices du continous Delivry
    -   Founir rapidement des feedback automatique sur le systeme de préprod et de prod
    -   Garde une version logicielle releasable et déployble meme lorsque de nouvelles fonctionnalité sont en cours de dev
    -   Mise en place d'une pipeline qui permet de faire du déploiement à la demand
    -   Réduit les couts, le temps  et les risques inhérents ux changements incrémentaux réalisés
    https://www.youtube.com/watch?v=xSv_m3KhUO8&feature=youtu.be

# Ingénieur SRE :

-   Site Reliability engineering ( la résiliance engi).
    -   50 / 50 Opération / developpement
- La résilience Engineering
    -   un systeme résilient s'il peut être ajusté.

-   Les concetps associés
    -   Les Attaques 
    -   Tout indissociable
    -   L'humain
    -   Revues post-incidents
        -   Effectuer des revues post incidents agressives irréprochables et systémique
    -   Les Weakest Link
        -   Les systemes doivent être plus fort que leur lien le plus faible (weakest link)
    
#  Les branches du métier DevOps : 

-   DecSecOps ( créer un réel état d'esprit global dans lequel est responsable de la sécurité )
    -   Security by design
    -   Résolution au plus tôt du developpement
    -   Developper l'automatisation pour la résilience, les actions de tests, la détetion et les audits
    -   
-   ChatOps  
    -   le chatops est une méthode de collaboration contrée sur la communication, qui connecte les personnes, les outils, les fichiers et l'automatisation dans un flux de travail transparent.
    -   La transparence induite permet d'avoir des boucles de feedback plus courtes, d'améliorer le partage d'info, la colob et la réduit la  MTTR mean time to repair

Exemple : bot qui envoi de l'info sur ce qu'il peut ce passer !
    outils : mattermost ; slack : Teams Microsoft
    


### Section 4 : Frameworks biz et tec

1.   Objectif
2.   les méthodes agiles
3.   L'itsm
4.   Agile Service Management
5.   La méthode LEAN
6.   Learning organizations

# les objectifs :

-   Comment on articule les outils et le méthode :  
    -   les différents méthodes agile ; scrum Safe
    -   L'ITSM et la méthode Itil
    -   L'agilité rencontre l'ITSM pour le meilleur des deux mondes 
    -   La méthode LEAN et l'improvement KaTA du service du DevOps
    -   Les leanings Organisations et la bienveillance au coeur de l'entreprise

# La méthodes agiles : https://www.youtube.com/watch?v=4GK1NDTWbkY Agile chez Spotify

-  mieux dev logiciels par la pratique et en aidant les autres à le faire ! 

    -   Projet agiles : 
        -   individus et leurs interactions
        -   Logiciels opérationnels
        -   Collaboration avec les Clients
        -   Adaptation au changement
    
    -   Projet classique :
        -   Processus et outils
        -   Docuementation exhaustive
        -   Négociation Contractuelle
        -   Suivi d'un plan

-   La méthode Scrum : https://www.scrum.org/

-   La méthode SAFe ( Scaled agile FrameWork) https://www.scaledagileframework.com/
    -   correspond à un framwork permettant d'appliquer les principes et la pratique de l'agilité e du lean au service du dev d'une entreprise
    -   Intégre la philosophie Lean et Agile au dev logiciel
    -   Peut être appliqué aux grandes sociétés avec un grand nombre d'équipes et de membres.

# L'ITSM :

Rappel  :    - ITIL : On vous dit quoi faire !
                -   Stratégie
                -   Design
                -   Transition
                -   Opération
                -   Continual Service Improvement

-   IT service Management 
    -    L'implémentation et une gestion de la qualité des services IT qui correspond exactement aux besoins du business
    -   Il founit une structure des processus comme : 
        -   Change
        -   Configuration
        -   Release
        -   Incident
        -   Problem Management

    -   Les processus de l'itsm sous entend tout le cycle de vie des services partant de la statégie, la conception, la transition, les opérations, l'amélioration continue et la création de valeur.

    ITSM & DevOps : ( Itil et procédures)
    
    -   Etapes à effectuer
    -   Ordre chronologique des actions
    -   Responsabilités de chacun
    -   Delais et seuils
    -   Procédures d'escalades
    
# Agile Service Management :

 -   Assure que les processus ITSM reflètent les valeurs de l'agilité et sont conçus avec juste assez de controle et de structure pour fournir de maniere efficace et efficiente les résultats clients

    - Adaptation
        Adapter les pratiques agile à la conception des processus ITSM
    - Valeur de l'agilité
        S'assurer que les processus ITSM refletent les valeurs de l'agilité depuis l conception initale jusqu'au CSI continual service improvement
    -   Petit à petit
        Implémenter la gestion des services, dans de petits incréments intégrés
    -   MVP minimun Viable
        Encourager le Minimum viable et le juste asser pour améliorer la vitesse et la conformité

    




















                
        











