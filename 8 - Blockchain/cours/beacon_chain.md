La Beacon Chain (en ligne)
La Beacon chain ne change rien à Ethereum que nous utilisons aujourd'hui. Elle permettra de coordonner le réseau en introduisant la preuve de l'enjeu (POS) dans l'écosystème Ethereum. Cette dernière dirigera et coordonnera le réseau élargi des shards et des stakers. Mais ce ne sera pas comme le réseau Ethereum d'aujourd'hui, elle ne peut pas gérer des comptes ou des smart contrats. Le rôle de la Beacon chain va évoluer au fil du temps, mais il s'agit d'un élément fondamental pour avoir une blockchain Ethereum plus sécurisée, durable et évolutive.

Data explorer https://beaconscan.com


Staking
La beacon chain introduit le concept de staking, donc qu'est ce que le staking et comment cela fonctionne ?

La Beacon chain est au coeur de la blockchain Ethereum 2.0. Elle est chargée de gérer l'algorithme de consensus, c'est-à-dire le protocole Casper Proof of Stake, pour elle-même et pour toutes les shards chains (que nous allons expliquer dans la suite).

Le réseau est géré par un groupe de validateurs. Pour devenir un validateur, le nœud envoie son staking dans le smart contract sur la blockchain Ethereum actuelle. La mise est bloquée et après contrôle de validité, un reçu est généré qui contient un ID indiquant le shard auquel le validateur sera affecté. Le statut du validateur passe à actif dès que sa clé publique atteint un solde de 32 ETH. Un validateur est activé lorsque la Beacon chain traite les reçus de dépôt de la blockchain Eth 1.0.

De nouveaux blocs sont proposés par les validateurs actifs pour chaque bloc et les autres validateurs actifs doivent voter sur sa validité. Les attestations sont la principale source de charge de la Beacon chain. Une attestation est généralement le vote du validateur, appuyé par le solde du validateur. Il s'agit des votes de disponibilité pour un bloc de shard et, simultanément, des votes de preuve de jeu pour un bloc de Beacon. Un nombre suffisant d'attestations pour un même bloc de shard crée un lien confirmant le segment de shard jusqu'à ce bloc de shard dans la Beacon chain. La Beacon chain utilise ces liens pour identifier l'état actualisé des shards chains.

 
Sharding (estimé pour 2021)
Le sharding est le processus qui consiste à diviser une base de données horizontalement pour répartir la charge - c'est un concept courant en informatique. Dans un contexte Ethereum, le sharding réduira l'encombrement du réseau et augmentera le nombre de transactions par seconde en créant de nouvelles chaînes, appelées "shards".


Les shards chains

Les shards dans le contexte de Ethereum 2.0 sont essentiellement 64 blockchain indépendantes qui fonctionnent en synchronisation avec la chaîne ETH1 existante. Ils communiquent et coordonnent à la fois les transactions et l'état du réseau via une blockchain racine - dans le cas de Ethereum 2.0, on parle de Beacon chain.

Comme chaque shard chain pourra faciliter autant de trafic que le réseau Ethereum 1.0 existant et que les transactions seront traitées en parallèle avec la chaîne 1.0, le sharding permet d'atteindre un potentiel d'extensibilité horizontale plus important en termes de capacité de transactions par seconde. Ceci, parmi d'autres caractéristiques 2.0 telles que la preuve de l'enjeu, permettra à l'écosystème Ethereum de se développer de manière beaucoup plus durable.

 
Docking (estimé pour 2022)
Il est important de se rappeler qu'au départ, les autres mises à niveau Eth2 sont expédiées séparément du réseau mainnet de la blockchain Ethereum que nous utilisons aujourd'hui. Le réseau principal Ethereum continuera à être sécurisé par la preuve de travail, même si la Beacon chain et ses shards chains fonctionneront en parallèle avec des preuves d'enjeu. Le docking se fera lorsque ces deux systèmes auront été fusionnés.

Lorsqu'il sera prêt, le réseau principal de Ethereum "dock" à la Beacon chain, devenant ainsi son propre shard qui utilise la preuve de l'enjeu plutôt que la preuve du travail.

Le réseau principal permettra l'interaction avec les smart contracts dans le système de preuve d'enjeu, ainsi que l'historique complet et l'état actuel de Ethereum, afin de garantir une transition en douceur pour tous les détenteurs et utilisateurs de l'ETH.

Une fois le docking fait, à ce stade, Ethereum aura l'envergure, la sécurité et la durabilité décrites dans sa vision Eth2.0.


La Beacon chain et ses tâches
La Beacon chain est différente de la chaîne Ethereum 1.0 et introduit des nouvelles responsabilités et tâches. Parmi lesquelles on peut citer :

La gestion des validateurs et de leurs stakes
Nommer le proposant de bloc choisi pour chaque shard à chaque étape
L'organisation des validateurs en groupes pour voter sur les blocs proposés
Application des règles de consensus
Appliquer les récompenses et les pénalités aux validateurs
Point d'ancrage sur lequel les shards enregistrent leur état pour faciliter les transactions entre shards