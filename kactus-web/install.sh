#!/bin/bash
# Copyright (c) 2021-2025 Guillaume Sanchez
# Author: Guillaume Sanchez
# License: MIT | https://github.com/Guillaume-Sanchez/kactus
# version: 2.0.5

# --- Configuration ---
PROJECT_NAME="kactus-web"
COMPOSE_FILE="docker-compose.yml"
ENV_FILE=".env"

echo "🚀 Préparation du projet Docker Compose..."

# 1. Créer le répertoire du projet s'il n'existe pas et mise en place des fichiers nécessaires
mkdir -p ~/dockers/$PROJECT_NAME
cd ~/dockers/$PROJECT_NAME

cp -r wp-content ~/dockers/$PROJECT_NAME/wp-content
cp wp-config.php ~/dockers/$PROJECT_NAME/wp-config.php

# 2. Créer le fichier docker-compose.yml
cat << EOF > $COMPOSE_FILE
services:
   db:
     image: mariadb:latest
     volumes:
       - db_data:/var/lib/mysql
     network:
       - kactus-network
     restart: always
     environment:
       MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
       MYSQL_DATABASE: ${MYSQL_DATABASE}
       MYSQL_USER: ${MYSQL_USER}
       MYSQL_PASSWORD: ${MYSQL_PASSWORD}

   wordpress:
     image: wordpress:latest
     ports:
       - 80:80
     network:
       - kactus-network
     restart: always
     environment:
       WORDPRESS_DB_HOST: db:3306
       WORDPRESS_DB_USER: ${WORDPRESS_DB_USER}
       WORDPRESS_DB_PASSWORD: ${WORDPRESS_DB_PASSWORD}
     volumes:
       - ./wp-content/themes/Kactus:/var/www/html/wp-content/themes/Kactus
       - ./wp-config.php:/var/www/html/wp-config.php

volumes:
    db_data:
    
networks:
  kactus-network:
EOF
echo "✅ Fichier $COMPOSE_FILE créé dans $(pwd) :"

cat $COMPOSE_FILE
echo "---"

# 3. Créer le fichier .env
#Demander à l'utilisateur de saisir le mot de passe root de la base de données
echo 'Veuillez entrer le mot de passe root de la base de données 🔐 : '
read -s MOT_DE_PASSE_SAISI

#Génération d'un mot de passe aléatoire
LONGUEUR_PASS=30
CHARSET='a-zA-Z0-9!@#$%^&*()_+-='
MOT_DE_PASSE=$(cat /dev/urandom | tr -dc "$CHARSET" | head -c $LONGUEUR_PASS)

sudo rm -f $ENV_FILE

cat << EOF > $ENV_FILE
MYSQL_ROOT_PASSWORD=$MOT_DE_PASSE_SAISI
MYSQL_DATABASE=wordpress
MYSQL_USER=kactus
MYSQL_PASSWORD=$MOT_DE_PASSE
WORDPRESS_DB_USER=kactus
WORDPRESS_DB_PASSWORD=$MOT_DE_PASSE
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