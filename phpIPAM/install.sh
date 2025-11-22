#!/bin/bash
# Copyright (c) 2021-2025 Guillaume Sanchez
# Author: Guillaume Sanchez
# License: MIT | https://github.com/Guillaume-Sanchez/kactus

# --- Configuration ---
PROJECT_NAME="phpipam"
COMPOSE_FILE="docker-compose.yml"
ENV_FILE=".env"

echo "🚀 Préparation du projet Docker Compose..."

# 1. Créer le répertoire du projet s'il n'existe pas
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

# 2. Créer le fichier docker-compose.yml
# Cette image exécute un binaire qui affiche le message et s'arrête.
cat << EOF > $COMPOSE_FILE
services:
   phpipam-web:
     image: phpipam/phpipam-www:latest
     ports:
      - "8080:8080"
     environment:
       - TZ=Europe/London
       - IPAM_DATABASE_HOST=phpipam-mariadb
       - IPAM_DATABASE_PASS=${PASSWORD_DB}
       - IPAM_DATABASE_WEBHOST=%
     restart: unless-stopped
     volumes:
       - phpipam-logo:/phpipam/css/images/logo
       - phpipam-ca:/usr/local/share/ca-certificates:ro
     depends_on:
       - phpipam-mariadb
     cap_add:
       - NET_ADMIN
       - NET_RAW

   phpipam-cron:
     image: phpipam/phpipam-cron:latest
     environment:
       - TZ=Europe/London
       - IPAM_DATABASE_HOST=phpipam-mariadb
       - IPAM_DATABASE_PASS=${PASSWORD_DB}
       - SCAN_INTERVAL=1h
     restart: unless-stopped
     volumes:
       - phpipam-ca:/usr/local/share/ca-certificates:ro
     depends_on:
       - phpipam-mariadb
     cap_add:
       - NET_ADMIN
       - NET_RAW

   phpipam-mariadb:
     image: mariadb:latest
     environment:
       - MYSQL_ROOT_PASSWORD=${PASSWORD_DB}
     restart: unless-stopped
     volumes:
       - phpipam-db-data:/var/lib/mysql

volumes:
   phpipam-db-data:
   phpipam-logo:
   phpipam-ca:
EOF

echo "✅ Fichier $COMPOSE_FILE créé dans $(pwd) :"
cat $COMPOSE_FILE
echo "---"

# 3. Créer le fichier .env
#Demander à l'utilisateur de saisir le mot de passe root de la base de données
read -p "Veuillez entrer le mot de passe root de la base de données : " MOT_DE_PASSE_SAISI

cat << EOF > $ENV_FILE
PASSWORD_DB=\"$MOT_DE_PASSE_SAISI\"
EOF

# 4. Exécuter Docker Compose
# -d pour détacher (pas nécessaire ici pour hello-world, mais bonne pratique)
# --rm pour nettoyer le conteneur après l'arrêt (utile pour ce cas simple)

echo "▶️ Lancement de 'docker compose up'"
# On n'utilise pas -d pour voir la sortie immédiatement
docker compose up --force-recreate --build --no-start
docker compose start

# 5. Nettoyage
echo "🧹 Nettoyage des ressources ..."
# Revenir au répertoire précédent et supprimer le répertoire de travail
cd ..
rm -rf $PROJECT_NAME

echo "✨ Terminé ! PhpIPAM a bien été configurés et les ressources sont nettoyées."