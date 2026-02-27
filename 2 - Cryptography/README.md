# Module 2 — Cryptographie

Principes cryptographiques, du chiffrement symétrique aux attaques offensives.

## Prérequis

- Module 0 (CS50) — bases de la programmation
- Module 1 — logique booléenne, notions de complexité

## Sommaire

### Cours

| Fichier | Sujet |
| --- | --- |
| `cours/fondamentaux.md` | Terminologie, principes de Kerckhoffs, classification |
| `cours/symetrique.md` | AES, DES, modes (CBC, CTR, GCM) |
| `cours/asymetrique.md` | RSA, ECDSA, Diffie-Hellman |
| `cours/hash.md` | MD5, SHA, bcrypt — usage en pentest |
| `cours/pki_certificats.md` | TLS, x509, chaîne de confiance |
| `cours/crypto_offensive.md` | Padding oracle, hash length extension, WEP |

### Labs

| Dossier | Contenu |
| --- | --- |
| `labs/challenges/` | Challenges CryptoPals (Set 1+) |
| `labs/scripts/` | Implémentations Python |

## Objectifs

- Comprendre la différence entre chiffrement symétrique et asymétrique
- Identifier le bon algorithme de hachage selon le contexte
- Exploiter les faiblesses cryptographiques courantes
- Comprendre le fonctionnement de TLS et des certificats

## Ressources

- [CryptoPals](https://cryptopals.com/) — Challenges crypto progressifs
- [secp256k1-py](https://github.com/rustyrussell/secp256k1-py) — Courbes elliptiques Python
- [Bitcoin addresses in C](https://nickfarrow.com/Cryptography-in-Bitcoin-with-C/#creating-bitcoin-addresses-in-c)
