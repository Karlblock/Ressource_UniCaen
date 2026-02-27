# Introduction au Réseau

Un réseau permet à deux ou plusieurs équipements de communiquer entre eux.

## Modèle OSI

Les couches 2 à 4 sont orientées **transport**, les couches 5 à 7 orientées **application**.

## Adressage IPv4

### Classes

| Classe | Adresse réseau | Première adresse | Dernière adresse | Masque | CIDR |
| --- | --- | --- | --- | --- | --- |
| A | 1.0.0.0 | 1.0.0.1 | 127.255.255.255 | 255.0.0.0 | /8 |
| B | 128.0.0.0 | 128.0.0.1 | 191.255.255.255 | 255.255.0.0 | /16 |
| C | 192.0.0.0 | 192.0.0.1 | 223.255.255.255 | 255.255.255.0 | /24 |
| D | 224.0.0.0 | 224.0.0.1 | 239.255.255.255 | Multicast | — |
| E | 240.0.0.0 | 240.0.0.1 | 255.255.255.255 | Réservé | — |

### Calcul binaire

| Valeurs | 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |

Exemple : 192.168.10.39

| Octet | Binaire | Décimal |
| --- | --- | --- |
| 1er | 1100 0000 | 192 |
| 2e | 1010 1000 | 168 |
| 3e | 0000 1010 | 10 |
| 4e | 0010 0111 | 39 |

Masque 255.255.255.0 = tous les bits à 1 sur les 3 premiers octets.

## Adresse MAC

Formats : `DE:AD:BE:EF:13:37` / `DE-AD-BE-EF-13-37` / `DEAD.BEEF.1337`

| Représentation | Octet 1 | Octet 2 | Octet 3 | Octet 4 | Octet 5 | Octet 6 |
| --- | --- | --- | --- | --- | --- | --- |
| Hex | DE | AD | BE | EF | 13 | 37 |

## IPv6

| Caractéristique | IPv4 | IPv6 |
| --- | --- | --- |
| Longueur | 32 bits | 128 bits |
| Représentation | Binaire/Décimal | Hexadécimal |
| Adressage dynamique | DHCP | SLAAC / DHCPv6 |
| IPsec | Facultatif | Obligatoire |

Types : Unicast, Anycast, Multicast (pas de Broadcast en IPv6).

## Protocoles courants

### TCP (connection-oriented)

| Protocole | Port | Description |
| --- | --- | --- |
| SSH | 22 | Connexion sécurisée |
| Telnet | 23 | Connexion à distance (non chiffré) |
| DNS | 53 | Résolution de noms |
| HTTP | 80 | Web |
| Kerberos | 88 | Authentification/autorisation |
| POP3 | 110 | Récupération e-mails |
| NTP | 123 | Synchronisation horloges |
| IMAP | 143 | Accès e-mails |
| SNMP | 161-162 | Gestion réseau |
| LDAP | 389 | Services d'annuaire |
| HTTPS | 443 | Web sécurisé |
| SMB | 445 | Partage de fichiers |
| RDP | 3389 | Bureau à distance |
| FTP | 20-21 | Transfert de fichiers |
| SMTP | 25 | Envoi e-mails |
| NFS | 111, 2049 | Montage systèmes distants |
| MS-SQL | 1433 | SQL Server |
| Oracle TNS | 1521/1526 | Oracle DB |
| RADIUS | 1812, 1813 | Authentification |
| SIP | 5060 | VoIP |

### UDP (connectionless)

Pas de connexion virtuelle, pas de garantie de livraison.

### ICMP

| Type | Description |
| --- | --- |
| Echo Request | Teste l'accessibilité (ping) |
| Echo Reply | Réponse au ping |
| Destination Unreachable | Livraison impossible |
| Redirect | Redirection vers un autre routeur |
| Time Exceeded | TTL expiré |
| Parameter Problem | Erreur dans l'en-tête |

> Un Windows a un TTL de 128, un Linux de 64.

### VoIP (SIP)

| Méthode | Description |
| --- | --- |
| INVITE | Initier une session |
| ACK | Confirmer réception d'un INVITE |
| BYE | Terminer une session |
| CANCEL | Annuler un INVITE en attente |
| REGISTER | Enregistrer un UA auprès du serveur SIP |
| OPTIONS | Interroger les capacités du serveur |

## Réseaux sans fil (WiFi)

Attributs clés : MAC address, SSID, débits supportés, canaux, protocoles de sécurité (WPA2/WPA3)

## VPN

### IPsec

Deux modes :
- **Transport** : chiffrement hôte à hôte
- **Tunnel** : chiffrement réseau à réseau

### PPTP

Tunnel point à point — obsolète, sécurité faible.

## Établissement de connexion

### Échange de clés

| Algorithme | Acronyme | Notes |
| --- | --- | --- |
| Diffie-Hellman | DH | Sécurisé et efficace |
| RSA | RSA | Largement utilisé, intensif en calcul |
| Elliptic Curve DH | ECDH | Sécurité améliorée vs DH classique |
| ECDSA | ECDSA | Signatures numériques efficaces |

### Protocoles d'authentification

| Protocole | Description |
| --- | --- |
| Kerberos | Tickets via KDC, environnements de domaine |
| TLS | Successeur de SSL, sécurité des communications |
| OAuth | Autorisation déléguée sans partage de mot de passe |
| SAML | Échange XML d'authentification/autorisation |
| 2FA/MFA | Authentification multi-facteurs |
| PKI | Infrastructure à clé publique/privée |
| SSO | Authentification unique multi-applications |
| PAP | Mot de passe en clair (obsolète) |
| CHAP | Handshake à trois voies |
| EAP | Framework multi-méthodes d'authentification |
| PEAP | Tunnel TLS pour authentification réseau |

### En-tête IP

| Champ | Description |
| --- | --- |
| Version | Version du protocole IP |
| IHL | Taille de l'en-tête (mots de 32 bits) |
| Total Length | Longueur totale du paquet (octets) |
| TTL | Durée de vie sur le réseau |
| Protocol | Protocole de transport (TCP/UDP) |
| Checksum | Détection d'erreurs |
| Source/Destination | Adresses IP |

## Cryptographie réseau

### Chiffrement symétrique

- [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)
- [DES](https://en.wikipedia.org/wiki/Data_Encryption_Standard)

### Chiffrement asymétrique (clé publique)

- [RSA](https://en.wikipedia.org/wiki/RSA_(cryptosystem))
- [PGP](https://en.wikipedia.org/wiki/Pretty_Good_Privacy)
- [ECC](https://en.wikipedia.org/wiki/Elliptic-curve_cryptography)
