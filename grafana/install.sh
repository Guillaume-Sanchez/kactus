#!/bin/bash
# Copyright (c) 2021-2025 Guillaume Sanchez
# Author: Guillaume Sanchez
# License: MIT | https://github.com/Guillaume-Sanchez/kactus
# version: 2.0.0

# --- Configuration ---
PROJECT_NAME="grafana"
COMPOSE_FILE="docker-compose.yml"
ENV_FILE=".env"

echo "🚀 Préparation du projet Docker Compose..."

# 1. Créer le répertoire du projet s'il n'existe pas
mkdir -p ~/dockers/$PROJECT_NAME
cd ~/dockers/$PROJECT_NAME

# 2. Créer le fichier docker-compose.yml
# Cette image exécute un binaire qui affiche le message et s'arrête.
cat << EOF > $COMPOSE_FILE
services:
  grafana:
    image: grafana/grafana
    restart: unless-stopped
    networks:
      - grafana
    environment:
      - GF_SECURITY_ADMIN_USER=${GRAFANA_ADMIN}
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_PASSWORD}
    ports:
      - "3000:3000"
    volumes:
      - grafana_data:/var/lib/grafana
    depends_on:
      - loki

  loki:
    image: grafana/loki
    restart: unless-stopped
    ports:
      - "3100:3100"
    networks:
      - grafana

  promtail:
    image: grafana/promtail
    restart: unless-stopped
    volumes:
      - /var/log:/var/log
    networks:
      - grafana

volumes:
  grafana_data:

networks:
  grafana:
EOF

echo "✅ Fichier $COMPOSE_FILE créé dans $(pwd) :"

cat $COMPOSE_FILE
echo "---"

# 3. Créer le fichier .env
#Demander à l'utilisateur de saisir le mot de passe
echo 'Veuillez entrer le mot de passe root de la base de données 🔐 : '
read -s MOT_DE_PASSE_SAISI

cat << EOF > $ENV_FILE
GRAFANA_ADMIN=admin
GRAFANA_PASSWORD=$MOT_DE_PASSE_SAISI
EOF

chmod 600 $ENV_FILE

# 4. Exécuter Docker Compose
# -d pour détacher (pas nécessaire ici pour hello-world, mais bonne pratique)
# --rm pour nettoyer le conteneur après l'arrêt (utile pour ce cas simple)

echo "▶️ Lancement de 'docker compose up'"
# On n'utilise pas -d pour voir la sortie immédiatement
sudo docker compose up --force-recreate --build --no-start
sudo docker compose start

echo "✨ Terminé ! Grafana et Loki ont été configurés et les ressources sont nettoyées."