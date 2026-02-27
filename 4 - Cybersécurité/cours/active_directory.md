# Active Directory

## Presentation

ADFS rationalise la connexion des utlisateurs sur divers appli (SSO)

## Principes Fondamentaux

### Structure AD

### Terminologie AD

**Objet :**

Un objet peut être défini comme N'IMPORTE QUELLE ressource présente dans un environnement Active Directory tels que OUs, imprimantes, utilisateurs, contrôleurs de domaine, etc.

**Attributs :**

Chaque objet dans Active Directory a un ensemble associé de attributs utilisé pour définir les caractéristiques de l'objet donné. Un objet informatique contient des attributs tels que le nom d'hôte et le nom DNS. Tous les attributs dans AD ont un nom LDAP associé qui peut être utilisé lors de l'exécution de requêtes LDAP, telles que displayName pour Full Name et given name pour First Name.

**Schéma :**

Le Active Directory schéma est essentiellement le modèle de tout environnement d'entreprise. Il définit quels types d'objets peuvent exister dans la base de données AD et leurs attributs associés. Il répertorie les définitions correspondant aux objets AD et contient des informations sur chaque objet. Par exemple, les utilisateurs dans AD appartiennent à la classe "user," et les objets informatiques à "computer," et ainsi de suite. Chaque objet a ses propres informations (certaines doivent être définies et d'autres facultatives) qui sont stockées dans des attributs. Lorsqu'un objet est créé à partir d'une classe, cela s'appelle l'instanciation, et un objet créé à partir d'une classe spécifique s'appelle une instance de cette classe. Par exemple, si nous prenons l'ordinateur RDS01. Cet objet informatique est une instance de la classe "ordinateur" dans Active Directory.

**Domaine :**

Un domaine est un groupe logique d'objets tels que des ordinateurs, des utilisateurs, des OU, des groupes, etc. Nous pouvons considérer chaque domaine comme une ville différente dans un État ou un pays. Les domaines peuvent fonctionner indépendamment les uns des autres ou être connectés via des relations de confiance.

**Forêt :**

Une forêt est une collection de domaines Active Directory. C'est le conteneur le plus haut et contient tous les objets AD présentés ci-dessous, y compris, mais sans s'y limiter, les domaines, les utilisateurs, les groupes, les ordinateurs et les objets Stratégie de groupe. Une forêt peut contenir un ou plusieurs domaines et être considérée comme un État aux États-Unis ou un pays de l'UE. Chaque forêt fonctionne indépendamment, mais peut avoir diverses relations de confiance avec d'autres forêts.

**Arbre :**

Une arborescence est une collection de domaines Active Directory qui commence à un seul domaine racine. Une forêt est une collection d'arbres AD. Chaque domaine d'un arbre partage une frontière avec les autres domaines. Une relation de confiance parent-enfant est formée lorsqu'un domaine est ajouté sous un autre domaine dans une arborescence. Deux arbres d'une même forêt ne peuvent pas partager un nom (espace de noms). Disons que nous avons deux arbres dans une forêt AD: inlanefreight.local et ilfreight.local. Un domaine enfant du premier serait corp.inlanefreight.local alors qu'un domaine enfant du second pourrait être corp.ilfreight.local. Tous les domaines d'une arborescence partagent un Catalogue Global standard qui contient toutes les informations sur les objets qui appartiennent à l'arborescence.

**Conteneur :**

Les objets conteneurs contiennent d'autres objets et ont une place définie dans la hiérarchie des sous-arborescences de répertoires.

**Feuille :**

Les objets Leaf ne contiennent pas d'autres objets et se trouvent à la fin de la hiérarchie des sous-arbres.

**Global Unique Identifier (GUID) :**

A GUID est une valeur unique de 128 bits attribuée lors de la création d'un utilisateur ou d'un groupe de domaine. Cette valeur GUID est unique dans toute l'entreprise, semblable à une adresse MAC. Chaque objet créé par Active Directory se voit attribuer un GUID, pas seulement les objets utilisateur et de groupe. Le GUID est stocké dans le ObjectGUID attribut. Lors de l'interrogation d'un objet AD (tel qu'un utilisateur, un groupe, un ordinateur, un domaine, un contrôleur de domaine, etc.), nous pouvons interroger pour son objectGUID valeur à l'aide de PowerShell ou recherchez-la en spécifiant son nom distinctif, son GUID, son SID ou son nom de compte SAM. Les GUID sont utilisés par AD pour identifier les objets en interne. La recherche dans Active Directory par la valeur GUID est probablement le moyen le plus précis et le plus fiable de trouver l'objet exact que vous recherchez, surtout si le catalogue global peut contenir des correspondances similaires pour un nom d'objet. Spécifier le ObjectGUID valeur lors de l'exécution de l'énumération AD veillera à ce que nous obtenons les résultats les plus précis concernant l'objet que nous recherchons des informations sur. Le ObjectGUID propriété never change et est associé à l'objet tant que cet objet existe dans le domaine.

**Principes de sécurité :**

Principes de sécurité tout ce que le système d'exploitation peut authentifier, y compris les utilisateurs, les comptes d'ordinateur ou même les threads/processus qui s'exécutent dans le contexte d'un compte d'utilisateur ou d'ordinateur (c'est-à-dire., une application telle que Tomcat s'exécutant dans le contexte d'un compte de service dans le domaine). Dans AD, les principes de sécurité sont des objets de domaine qui peuvent gérer l'accès à d'autres ressources dans le domaine. Nous pouvons également utiliser des comptes d'utilisateurs locaux et des groupes de sécurité pour contrôler l'accès aux ressources sur cet ordinateur spécifique uniquement. Ceux-ci ne sont pas gérés par AD mais plutôt par le Gestionnaire de Comptes de Sécurité (SAM).

**Identifiant de sécurité (SID) :**

A identifiant de sécurité, ou SID est utilisé comme identifiant unique pour un principal de sécurité ou un groupe de sécurité. Chaque compte, groupe ou processus a son propre SID unique, qui, dans un environnement AD, est émis par le contrôleur de domaine et stocké dans une base de données sécurisée. Un SID ne peut être utilisé qu'une seule fois. Même si le principe de sécurité est supprimé, il ne peut plus jamais être utilisé dans cet environnement pour identifier un autre utilisateur ou groupe. Lorsqu'un utilisateur se connecte, le système crée un jeton d'accès qui contient le SID de l'utilisateur, les droits qui lui ont été accordés, et les SID pour tous les groupes dont l'utilisateur est membre. Ce jeton est utilisé pour vérifier les droits chaque fois que l'utilisateur effectue une action sur l'ordinateur. Il y a aussi SID bien connus qui sont utilisés pour identifier les utilisateurs et groupes génériques. Ce sont les mêmes pour tous les systèmes d'exploitation. Un exemple est le Everyone groupe.

**Nom distingué ( DN ) :**
A Nom distingué ( DN ) décrit le chemin complet vers un objet dans AD ( tel que cn=bjones, ou=IT, ou=Employees, dc=inlanefreight, dc=local). Dans cet exemple, l'utilisateur bjones travaille au service informatique de la société Inlanefreight, et son compte est créé dans une unité organisationnelle ( OU ) qui détient des comptes pour les employés de l'entreprise. Le nom commun ( CN ) bjones est une seule façon de rechercher ou d'accéder à l'objet utilisateur dans le domaine.