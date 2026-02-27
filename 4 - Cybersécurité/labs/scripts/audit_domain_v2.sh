
#!/bin/bash

# Enhanced Domain Reconnaissance Script

# Check for required argument
DOMAIN="${1:?Usage: $0 <domain>}"

# Logging and output directory
OUTPUT_DIR="recon_${DOMAIN}_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTPUT_DIR"

# Logging function
log() {
    echo "[*] $1"
}

# Error handling function
error() {
    echo "[!] ERROR: $1" >&2
}

# Check for required tools
REQUIRED_TOOLS=("whois" "dig" "nslookup" "nmap" "curl")
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        error "$tool is not installed"
        exit 1
    fi
done

# 1. WHOIS Information
log "Gathering WHOIS information"
whois "$DOMAIN" > "${OUTPUT_DIR}/whois_${DOMAIN}.txt" 2>&1

# 2. DNS & Subdomain Enumeration
log "Performing DNS enumeration"
dig "$DOMAIN" any +noall +answer > "${OUTPUT_DIR}/dig_${DOMAIN}.txt"
nslookup "$DOMAIN" > "${OUTPUT_DIR}/nslookup_${DOMAIN}.txt"

# Advanced Subdomain Enumeration
if command -v subfinder &> /dev/null; then
    log "Running Subfinder for subdomain discovery"
    subfinder -d "$DOMAIN" -silent > "${OUTPUT_DIR}/subdomains_${DOMAIN}.txt"
elif command -v amass &> /dev/null; then
    log "Running Amass for subdomain discovery"
    amass enum -d "$DOMAIN" > "${OUTPUT_DIR}/subdomains_${DOMAIN}.txt"
else
    log "No advanced subdomain enumeration tool found"
fi

# 3. IP & Reverse DNS
IP=$(dig +short "$DOMAIN" | head -n 1)
if [[ -n "$IP" ]]; then
    log "Resolving IP: $IP"
    host "$IP" > "${OUTPUT_DIR}/reverse_${DOMAIN}.txt"
else
    error "Could not resolve IP for $DOMAIN"
fi

# 4. Quick Nmap Scan
log "Performing quick Nmap scan"
nmap -Pn -T4 -F "$DOMAIN" -oN "${OUTPUT_DIR}/nmap_fast_${DOMAIN}.txt"

# 5. HTTP(S) Header Checks
log "Checking HTTP(S) headers"
curl -I -k "http://$DOMAIN" > "${OUTPUT_DIR}/curl_http_${DOMAIN}.txt" 2>/dev/null || true
curl -I -k "https://$DOMAIN" > "${OUTPUT_DIR}/curl_https_${DOMAIN}.txt" 2>/dev/null || true

# 6. SSL Certificate Information
if command -v sslscan &> /dev/null; then
    log "Running SSLScan"
    sslscan "$DOMAIN" > "${OUTPUT_DIR}/sslscan_${DOMAIN}.txt"
fi

# 7. Web Technology Detection
if command -v whatweb &> /dev/null; then
    log "Running WhatWeb"
    whatweb -v "$DOMAIN" > "${OUTPUT_DIR}/whatweb_${DOMAIN}.txt"
fi

# 8. Additional Security Checks
if command -v testssl.sh &> /dev/null; then
    log "Running TestSSL"
    testssl.sh "$DOMAIN" > "${OUTPUT_DIR}/testssl_${DOMAIN}.txt"
fi

# Final summary
log "Reconnaissance completed. Results stored in $OUTPUT_DIR"
