#!/bin/bash
# Copyright (c) 2021-2025 Guillaume Sanchez
# Author: Guillaume Sanchez
# License: MIT | https://github.com/Guillaume-Sanchez/kactus

# --- Configuration ---
PROJECT_NAME="grafana"
COMPOSE_FILE="docker-compose.yml"
ENV_FILE=".env"

echo "🚀 Préparation du projet Docker Compose..."

# 1. Créer le répertoire du projet s'il n'existe pas
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

# 2. Créer le fichier docker-compose.yml
# Cette image exécute un binaire qui affiche le message et s'arrête.
cat << EOF > $COMPOSE_FILE
version: "3.3"

networks:
  grafana:

services:
  loki:
    image: grafana/loki:latest
    ports:
      - "3100:3100"
    command: -config.file=/etc/loki/local-config.yaml
    networks:
      - grafana

  promtail:
    image: grafana/promtail:latest
    volumes:
      - /var/log:/var/log
    command: -config.file=/etc/promtail/config.yml
    networks:
      - grafana

   grafana:
    image: grafana/grafana
    container_name: grafana
    restart: unless-stopped
    networks:
      - grafana
    environment:
      - GF_SECURITY_ADMIN_USER=${grafana_admin}
      - GF_SECURITY_ADMIN_PASSWORD=${grafana_password}
      - GF_INSTALL_PLUGINS=
    ports:
      - '3000:3000'
    volumes:
      - grafana_data:/var/lib/grafana
EOF

echo "✅ Fichier $COMPOSE_FILE créé dans $(pwd) :"
cat $COMPOSE_FILE
echo "---"

# 3. Créer le fichier .env
#Demander à l'utilisateur de saisir le mot de passe root de la base de données
read -p "Veuillez entrer l'ad : " USER_SAISI
read -p "Veuillez entrer le mot de passe root de la base de données : " MOT_DE_PASSE_SAISI
cat << EOF > $ENV_FILE
grafana_admin=\"$USER_SAISI"\
grafana_password=\"$MOT_DE_PASSE_SAISI\"
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

echo "✨ Terminé ! Grafana et Loki ont été configurés et les ressources sont nettoyées."