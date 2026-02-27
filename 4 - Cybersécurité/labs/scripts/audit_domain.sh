#!/bin/bash

DOMAIN=$1

if [ -z "$DOMAIN" ]; then
    echo "Usage: $0 <domaine>"
    exit 1
fi

echo "[*] Reconnaissance passive sur $DOMAIN"

# 1. WHOIS
echo "[+] WHOIS"
whois $DOMAIN > whois_$DOMAIN.txt

# 2. DNS & sous-domaines
echo "[+] DNS & sous-domaines"
dig $DOMAIN any +noall +answer > dig_$DOMAIN.txt
nslookup $DOMAIN > nslookup_$DOMAIN.txt

# Subdomain enumeration (avec amass ou subfinder)
if command -v subfinder &> /dev/null; then
    echo "[+] Subfinder"
    subfinder -d $DOMAIN -silent > subdomains_$DOMAIN.txt
else
    echo "[!] Subfinder non installé"
fi

# 3. IP & Reverse DNS
IP=$(dig +short $DOMAIN | head -n 1)
echo "[+] IP : $IP"
host $IP > reverse_$DOMAIN.txt

# 4. Scan rapide ports/services
echo "[+] Scan rapide Nmap"
nmap -Pn -T4 -F $DOMAIN -oN nmap_fast_$DOMAIN.txt

# 5. Vérif HTTP(s)
echo "[+] Curl headers"
curl -I http://$DOMAIN > curl_http_$DOMAIN.txt 2>/dev/null
curl -I https://$DOMAIN > curl_https_$DOMAIN.txt 2>/dev/null

# 6. Infos SSL
if command -v sslscan &> /dev/null; then
    echo "[+] SSLScan"
    sslscan $DOMAIN > sslscan_$DOMAIN.txt
else
    echo "[!] sslscan non installé"
fi

# 7. Wappalyzer-like (techno détectées)
if command -v whatweb &> /dev/null; then
    echo "[+] WhatWeb"
    whatweb -v $DOMAIN > whatweb_$DOMAIN.txt
else
    echo "[!] whatweb non installé"
fi

echo "[✔] Audit rapide terminé. Résultats dans fichiers *_$DOMAIN.txt"
