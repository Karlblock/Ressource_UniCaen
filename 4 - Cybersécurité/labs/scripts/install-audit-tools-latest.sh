#!/bin/bash

set -e
echo "[*] Installation dynamique des outils d'audit"

# ----------- INSTALL DEPENDANCES ----------
echo "[*] Mise à jour & dépendances..."
sudo apt update && sudo apt install -y \
    curl \
    wget \
    whois \
    nmap \
    dnsutils \
    ruby \
    git \
    make \
    g++ \
    jq

echo "[✔] Dépendances système installées."

# ----------- INSTALL WHATWEB ----------
echo "[*] Installation de WhatWeb..."
git clone https://github.com/urbanadventurer/WhatWeb.git /opt/WhatWeb
cd /opt/WhatWeb || exit 1
sudo gem install bundler
bundle install
sudo ln -sf /opt/WhatWeb/whatweb /usr/local/bin/whatweb
echo "[✔] WhatWeb installé."

# ----------- INSTALL SSLSCAN (FORK STABLE) ----------
echo "[*] Installation de SSLScan (ssllabs fork)..."
cd /opt || exit 1
git clone https://github.com/ssllabs/ssllabs-scan.git
cd sslscan || exit 1
make
sudo make install
echo "[✔] SSLScan installé."

# ----------- INSTALL GO (dernière version stable) ----------
echo "[*] Recherche de la dernière version stable de Go..."
LATEST_GO=$(curl -s https://go.dev/dl/?mode=json | jq -r '[.[] | select(.stable == true)][0].version')
GO_VERSION=${LATEST_GO//go/}  # ex: go1.22.4 → 1.22.4
echo "[+] Dernière version Go : $GO_VERSION"

cd /tmp || exit 1
wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
export PATH=$PATH:/usr/local/go/bin
go version

# ----------- INSTALL SUBFINDER (dernière version stable compatible Go) ----------
echo "[*] Téléchargement de la dernière version de Subfinder..."
LATEST_SUBFINDER=$(curl -s https://api.github.com/repos/projectdiscovery/subfinder/releases/latest | jq -r '.tag_name')
echo "[+] Dernière version subfinder : $LATEST_SUBFINDER"

go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@$LATEST_SUBFINDER
echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
export PATH=$PATH:$HOME/go/bin

echo "[✔] Subfinder installé."

# ----------- FIN -----------

echo -e "\n[✅] Environnement d'audit mis à jour avec les dernières versions stables !"
