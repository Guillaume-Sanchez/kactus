#!/bin/bash
# Copyright (c) 2021-2025 Guillaume Sanchez
# Author: Guillaume Sanchez
# License: MIT | https://github.com/Guillaume-Sanchez/kactus
# version: 2.0.1

# --- Configuration ---
PROJECT_NAME="phpipam"
COMPOSE_FILE="docker-compose.yml"
ENV_FILE=".env"

echo "🚀 Préparation du projet Docker Compose..."

# 1. Créer le répertoire du projet s'il n'existe pas
mkdir -p $HOME/dockers/$PROJECT_NAME
cd $HOME/dockers/$PROJECT_NAME

# 2. Créer le fichier docker-compose.yml
# Cette image exécute un binaire qui affiche le message et s'arrête.
cat << EOF > $COMPOSE_FILE
services:
   web:
     image: phpipam/phpipam-www:latest
     network:
       - kactus-network
     ports:
       - "8080:80"
     environment:
       - TZ=Europe/London
       - IPAM_DATABASE_HOST=db
       - IPAM_DATABASE_PASS=aucuneidee
       - IPAM_DATABASE_WEBHOST=%
     restart: unless-stopped
     volumes:
       - phpipam-logo:/phpipam/css/images/logo
       - phpipam-ca:/usr/local/share/ca-certificates:ro
     depends_on:
       - db
     cap_add:
       - NET_ADMIN
       - NET_RAW

   cron:
     image: phpipam/phpipam-cron:latest
     network:
       - kactus-network
     environment:
       - TZ=Europe/London
       - IPAM_DATABASE_HOST=db
       - IPAM_DATABASE_PASS=aucuneidee
       - SCAN_INTERVAL=1h
     restart: unless-stopped
     volumes:
       - phpipam-ca:/usr/local/share/ca-certificates:ro
     depends_on:
       - db
     cap_add:
       - NET_ADMIN
       - NET_RAW

   db:
     image: mariadb:latest
     network:
       - kactus-network
     environment:
       MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
     restart: unless-stopped
     volumes:
       - phpipam-db-data:/var/lib/mysql

volumes:
   phpipam-db-data:
   phpipam-logo:
   phpipam-ca:

networks:
  kactus-network:
  external: true
EOF

echo "✅ Fichier $COMPOSE_FILE créé dans $(pwd) :"
cat $COMPOSE_FILE
echo "---"

# 3. Créer le fichier .env
#Demander à l'utilisateur de saisir le mot de passe root de la base de données
echo 'Veuillez entrer le mot de passe root de la base de données 🔐 : '
read -s MOT_DE_PASSE_SAISI

sudo rm -f $ENV_FILE

cat << EOF > $ENV_FILE
MYSQL_ROOT_PASSWORD=$MOT_DE_PASSE_SAISI
EOF

chmod 600 $ENV_FILE
chown root:root $ENV_FILE

# 4. Exécuter Docker Compose
# -d pour détacher (pas nécessaire ici pour hello-world, mais bonne pratique)
# --rm pour nettoyer le conteneur après l'arrêt (utile pour ce cas simple)

echo "▶️ Lancement de 'docker compose up'"
# On n'utilise pas -d pour voir la sortie immédiatement
sudo docker compose up --force-recreate --build --no-start
sudo docker compose start

echo "✨ Terminé ! PhpIPAM a bien été configurés et les ressources sont nettoyées."