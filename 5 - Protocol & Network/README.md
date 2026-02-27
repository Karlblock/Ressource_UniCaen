# Module 5 — Protocoles & Réseaux

Modèle OSI, pile TCP/IP, protocoles d'authentification et analyse de trafic.

## Prérequis

- Module 0 (CS50) — bases informatiques
- Module 3 — notions d'infrastructure Linux

## Sommaire

### Cours

| Fichier | Sujet |
| --- | --- |
| `cours/modele_osi.md` | 7 couches, encapsulation, PDU |
| `cours/tcp_ip.md` | TCP, UDP, 3-way handshake, flags |
| `cours/dns.md` | Résolution, zone transfer, DNS poisoning |
| `cours/http.md` | Méthodes, headers, HTTPS/TLS |
| `cours/protocoles_auth.md` | LDAP, Kerberos, NTLM, RADIUS |
| `cours/analyse_trafic.md` | tcpdump, Wireshark, filtres BPF |

### Labs

| Fichier | Exercice |
| --- | --- |
| `labs/capture_analyse.md` | Analyse de captures PCAP avec Wireshark |
| `labs/scripts/` | Scripts Scapy, sockets Python |

## Objectifs

- Situer un protocole dans le modèle OSI
- Analyser une capture réseau et identifier les anomalies
- Comprendre les mécanismes d'authentification réseau (Kerberos, NTLM)
- Utiliser tcpdump et Wireshark en contexte pentest
