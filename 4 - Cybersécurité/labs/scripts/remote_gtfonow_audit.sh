#!/bin/bash

# === CONFIGURATION ===
USER="user1"
HOST="192.168.1.100"
REMOTE_DIR="/tmp/gtfonow"
LOCAL_REPORT_DIR="$HOME/gtfonow-reports"
REMOTE_REPORT="$REMOTE_DIR/gtfonow-audit.md"
LOCAL_REPORT="$LOCAL_REPORT_DIR/gtfonow-audit-$(date +%Y%m%d-%H%M%S).md"

# === PRÉPARATION ===
echo "[*] Préparation du dossier local..."
mkdir -p "$LOCAL_REPORT_DIR"

echo "[*] Envoi des fichiers GTFONow..."
ssh $USER@$HOST "mkdir -p $REMOTE_DIR"
scp -r ~/GTFONow-main/* $USER@$HOST:$REMOTE_DIR/

# === SCRIPT DE LANCEMENT DISTANT ===
echo "[*] Lancement distant de GTFONow..."
ssh $USER@$HOST "bash -s" <<'EOF'
cd /tmp/gtfonow
chmod -R a+rX .
echo "0" | python3 gtfonow/gtfonow.py --auto --level 2 --risk 2 > gtfonow-raw.txt 2>&1

# Générer Markdown depuis la sortie
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
echo "# Audit GTFONow - $TIMESTAMP" > gtfonow-audit.md
echo >> gtfonow-audit.md

grep "Found exploitable" gtfonow-raw.txt >> gtfonow-audit.md
grep "Found suid" gtfonow-raw.txt | sort -u >> gtfonow-audit.md
echo >> gtfonow-audit.md
grep "Permission denied" gtfonow-raw.txt >> gtfonow-audit.md
EOF

# === RÉCUPÉRATION DU RAPPORT ===
echo "[*] Téléchargement du rapport..."
scp $USER@$HOST:$REMOTE_REPORT "$LOCAL_REPORT"

echo "[✔] Rapport récupéré : $LOCAL_REPORT"
