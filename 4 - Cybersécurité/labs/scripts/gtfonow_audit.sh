#!/bin/bash

# ====== CONFIGURATION ======
OUTPUT="$HOME/gtfonow-audit.md"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
SCAN_OUTPUT=$(mktemp)

# ====== LANCEMENT DE GTFONOW ======
echo "[*] Lancement de GTFONow audit..."
gtfonow --auto --level 2 --risk 2 > "$SCAN_OUTPUT" 2>&1

# ====== EXTRACTION DES DONNÉES ======
exploit=$(grep -A2 "Exploits available" "$SCAN_OUTPUT" | grep "ssh-agent")
permission_denied=$(grep -m1 "Permission denied" "$SCAN_OUTPUT")

suid_list=$(grep "no known GTFOBin exploit" "$SCAN_OUTPUT" | awk -F: '{print $2}' | sort -u)

# ====== GÉNÉRATION DU RAPPORT ======
echo "Génération du rapport : $OUTPUT"

cat <<EOF > "$OUTPUT"
# Audit Local Privilege Escalation - GTFONow

**Date :** $TIMESTAMP  
**Outil :** [GTFONow](https://github.com/Frissi0n/GTFONow)  
**Mode :** \`--auto --level 2 --risk 2\`

---

## 🔍 Résultats

### ✅ Exploitable :

EOF

if [[ -n "$exploit" ]]; then
cat <<EOF >> "$OUTPUT"
- **/usr/bin/ssh-agent**
  - SGID avec groupe \`_ssh\`
  - Exploit détecté via GTFONow
  - **Statut :** $( [[ -n "$permission_denied" ]] && echo "Tentative échouée → \`Permission denied\`" || echo "À confirmer")
EOF
else
  echo "- Aucun binaire exploitable automatiquement détecté." >> "$OUTPUT"
fi

cat <<EOF >> "$OUTPUT"

---

### ⚠️ Binaires SUID/SGID détectés sans exploit GTFOBin connu :
EOF

if [[ -n "$suid_list" ]]; then
  echo -e "\n| Binaire | Type |" >> "$OUTPUT"
  echo "|---------|------|" >> "$OUTPUT"
  for bin in $suid_list; do
    echo "| $bin | SUID/SGID |" >> "$OUTPUT"
  done
else
  echo "- Aucun SUID/SGID suspect trouvé." >> "$OUTPUT"
fi

cat <<EOF >> "$OUTPUT"

---

## ❌ Limitations observées :

- $( [[ -n "$permission_denied" ]] && echo "/bin/: \`Permission denied\` → Environnement restreint ou sandboxé" || echo "Aucune erreur critique détectée")

---

## 🔎 Recommandations :

- 🔧 Vérifier les droits de groupe \`_ssh\`
- 🧠 Analyser manuellement les binaires listés (CVE, version, permissions)
- 🔁 Compléter avec \`linpeas.sh\`, \`pspy\`, ou \`sudo -l\`
- 🔐 Supprimer ou restreindre les droits inutiles sur les binaires détectés

---

**Ce rapport est généré automatiquement depuis Exegol avec GTFONow.**

EOF

echo "[✔] Rapport généré : $OUTPUT"
