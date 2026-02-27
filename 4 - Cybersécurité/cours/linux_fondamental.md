# Linux Fondamental

## Lancer un serveur Web

- From apt : `apt install apache2`
- From python : `python3 -m http.server`
- From npm : `npm install http-server && http-server -p 8080`
- From php : `php -S 127.0.0.1:8080`

## Backup and Restore

Outils de sauvegarde : Rsync, Deja Dup, Duplicity

Outils de chiffrement : GnuPG, eCryptfs, LUKS

```bash
# Sauvegarde avec rsync
rsync -av /path/to/mydirectory user@backup_server:/path/to/backup/directory

# Rsync chiffré via SSH
rsync -avz -e ssh /path/to/mydirectory user@backup_server:/path/to/backup/directory
```

Automatiser via cron.

## File System Management

| Type  | Description |
| --- | --- |
| ext2  | Système de gestion de base |
| btrfs | Convient aux snapshots instantanés |
| NTFS  | Compatibilité Windows |

Outils de partitionnement : fdisk, gpart, GParted

Swap : zone temporaire de mémoire

## Conteneurs

### Docker

```bash
docker ps -a                    # Lister tous les conteneurs
docker images                   # Lister les images
docker rm <container_id>        # Supprimer un conteneur
docker rmi <image_id>           # Supprimer une image
docker stop <container_id>      # Arrêter un conteneur
docker start <container_id>     # Démarrer un conteneur
docker restart <container_id>   # Redémarrer
docker logs <container_id>      # Voir les journaux
```

### LXC

Exercices :
1. Installer LXC et créer un premier conteneur
2. Configurer le réseau du conteneur LXC
3. Créer une image LXC custom
4. Configurer les limites de ressources (CPU, mémoire, disque)
5. Explorer les commandes `lxc-*`
6. Créer un conteneur avec un serveur web (Apache, Nginx)
7. Configurer l'accès SSH au conteneur
8. Créer un conteneur avec persistance
9. Utiliser LXC pour tester des logiciels en environnement contrôlé

## Configuration Réseau

### NAC

- DAC, MAC, RBAC
- SELinux
- AppArmor (Linux Security Module)
- TCP Wrappers

### Outils d'analyse

```
ping, traceroute, netstat, tcpdump, wireshark, nmap, ss -plnt
```

### Exercices SELinux / AppArmor

1. Installer SELinux sur une VM
2. Empêcher un utilisateur d'accéder à un fichier spécifique (SELinux)
3. Autoriser un seul utilisateur sur un service réseau spécifique (SELinux)
4. Refuser l'accès à un groupe sur un service réseau (SELinux)
5. Empêcher un utilisateur d'accéder à un fichier (AppArmor)
6. Autoriser un seul utilisateur sur un service réseau (AppArmor)
7. Refuser l'accès à un groupe sur un service réseau (AppArmor)
8. Autoriser l'accès à un service depuis une IP spécifique (TCP Wrappers)
9. Refuser l'accès à un service depuis une IP (TCP Wrappers)
10. Autoriser l'accès depuis une plage d'IPs (TCP Wrappers)

### X11 sécurisé

Outils : xwd, xgrabsc

VNC (protocole RFB) : TigerVNC, TightVNC, RealVNC (chiffré), UltraVNC (chiffré)

## Linux Security

Outils : Snort, chkrootkit, rkhunter, Lynis

Bonnes pratiques :
- Supprimer/désactiver les services et logiciels inutiles
- Supprimer les services à authentification non chiffrée
- Activer NTP et Syslog
- Un compte par utilisateur
- Mots de passe forts + rotation
- Verrouillage après échecs de connexion
- Désactiver les binaires SUID/SGID non nécessaires

## Système de logs

- Kernel Logs
- System Logs
- Authentication Logs
- Application Logs
- Security Logs

## Solaris

Code source peu connu (cercle fermé).

| Composant | Rôle |
| --- | --- |
| ZFS | Système de fichiers |
| SMF | Service Management Facility |
| IPS | Packaging System |
| RBAC | Contrôle d'accès |

```bash
showrev -a
```

Diagnostic : `truss` (Solaris) / `strace` (Linux)

```bash
# Tracer les processus Apache
ps auxw | grep sbin/apache | awk '{print"-p " $2}' | xargs strace
```
