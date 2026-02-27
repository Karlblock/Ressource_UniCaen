# Introduction au Bash Scripting

## Bourne Again Shell

Les scripts permettent de conditionner et automatiser l'exécution de tâches (énumération, tests d'arguments, chaînes de commandes).

## Bases

### Shebang

Toujours en première ligne :

```bash
#!/bin/bash
```

Autres interpréteurs :
```python
#!/usr/bin/env python
```
```perl
#!/usr/bin/env perl
```

### Exécution conditionnelle (if-else-fi)

```bash
if [ $# -eq 0 ]
then
    echo "You need to specify the target domain."
    echo ""
    echo "Usage:"
    echo "   $0 <domain>"
    exit 1
else
    domain=$1
fi
```

## Arguments, Variables et Arrays

### Variables spéciales

| Variable | Description |
| --- | --- |
| `$#` | Nombre d'arguments passés au script |
| `$@` | Liste de tous les arguments |
| `$n` | Argument par position ($1, $2, ...) |
| `$$` | PID du processus en cours |
| `$?` | Code de sortie (0 = succès, 1 = échec) |

### Déclaration de variable

```bash
#!/bin/bash
variable="Declared without an error."
```

### Arrays

```bash
#!/bin/bash
domains=(domaine1.com domaine2.com domaine3.com domaine4.com)
echo ${domains[0]}
```

## Opérateurs

### Comparaison de chaînes

| Opérateur | Description |
| --- | --- |
| `==` | Égal à |
| `!=` | Différent de |
| `<` | Inférieur (ordre ASCII) |
| `>` | Supérieur (ordre ASCII) |
| `-z` | Chaîne vide (null) |
| `-n` | Chaîne non nulle |

### Comparaison d'entiers

| Opérateur | Description |
| --- | --- |
| `-eq` | Égal à |
| `-ne` | Différent de |
| `-lt` | Inférieur à |
| `-le` | Inférieur ou égal à |
| `-gt` | Supérieur à |
| `-ge` | Supérieur ou égal à |

### Opérateurs de fichiers

| Opérateur | Description |
| --- | --- |
| `-e` | Le fichier existe |
| `-f` | C'est un fichier |
| `-d` | C'est un répertoire |
| `-L` | C'est un lien symbolique |
| `-N` | Modifié après dernière lecture |
| `-O` | L'utilisateur courant est propriétaire |
| `-G` | Le GID correspond à l'utilisateur courant |
| `-s` | Taille > 0 |
| `-r` | Permission lecture |
| `-w` | Permission écriture |
| `-x` | Permission exécution |

### Opérateurs logiques

| Opérateur | Description |
| --- | --- |
| `!` | NON logique |
| `&&` | ET logique |
| `\|\|` | OU logique |

### Opérateurs arithmétiques

| Opérateur | Description |
| --- | --- |
| `+` | Addition |
| `-` | Soustraction |
| `*` | Multiplication |
| `/` | Division |
| `%` | Modulo |
| `variable++` | Incrémenter de 1 |
| `variable--` | Décrémenter de 1 |

## Contrôle de flux

### Boucles

- **For**
- **While** (tant qu'une condition est remplie)
- **Until** (jusqu'à ce qu'une condition soit remplie)

### Branches

- **If-Else**
- **Case**

```bash
echo -e "Options disponibles :"
echo -e "\t1) Identifier la plage réseau du domaine cible."
echo -e "\t2) Ping des hôtes découverts."
echo -e "\t3) Tous les checks."
echo -e "\t*) Quitter.\n"

read -p "Sélectionnez votre option : " opt

case $opt in
    "1") network_range ;;
    "2") ping_host ;;
    "3") network_range && ping_host ;;
    "*") exit 0 ;;
esac
```

## Fonctions & Debug

```bash
# Debug d'un script
bash -x -v script.sh
```

## Exercice : Boucle For avec déchiffrement

```bash
#!/bin/bash

function decrypt {
    MzSaas7k=$(echo $hash | sed 's/988sn1/83unasa/g')
    Mzns7293sk=$(echo $MzSaas7k | sed 's/4d298d/9999/g')
    MzSaas7k=$(echo $Mzns7293sk | sed 's/3i8dqos82/873h4d/g')
    Mzns7293sk=$(echo $MzSaas7k | sed 's/4n9Ls/20X/g')
    MzSaas7k=$(echo $Mzns7293sk | sed 's/912oijs01/i7gg/g')
    Mzns7293sk=$(echo $MzSaas7k | sed 's/k32jx0aa/n391s/g')
    MzSaas7k=$(echo $Mzns7293sk | sed 's/nI72n/YzF1/g')
    Mzns7293sk=$(echo $MzSaas7k | sed 's/82ns71n/2d49/g')
    MzSaas7k=$(echo $Mzns7293sk | sed 's/JGcms1a/zIm12/g')
    Mzns7293sk=$(echo $MzSaas7k | sed 's/MS9/4SIs/g')
    MzSaas7k=$(echo $Mzns7293sk | sed 's/Ymxj00Ims/Uso18/g')
    Mzns7293sk=$(echo $MzSaas7k | sed 's/sSi8Lm/Mit/g')
    MzSaas7k=$(echo $Mzns7293sk | sed 's/9su2n/43n92ka/g')
    Mzns7293sk=$(echo $MzSaas7k | sed 's/ggf3iunds/dn3i8/g')
    MzSaas7k=$(echo $Mzns7293sk | sed 's/uBz/TT0K/g')
    flag=$(echo $MzSaas7k | base64 -d | openssl enc -aes-128-cbc -a -d -salt -pass pass:$salt)
}

var="9M"
salt=""
hash="VTJGc2RHVmtYMTl2ZnYyNTdUeERVRnBtQWVGNmFWWVUySG1wTXNmRi9rQT0K"

counter=0
for i in {1..28}; do
    var=$(echo $var | base64)
done
salt=$(echo $var | wc -c | tr -d ' ')

if [[ ! -z "$salt" ]]; then
    decrypt
    echo $flag
else
    exit 1
fi
```
