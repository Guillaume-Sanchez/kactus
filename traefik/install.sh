#!/bin/bash
# Copyright (c) 2021-2025 Guillaume Sanchez
# Author: Guillaume Sanchez
# License: MIT | https://github.com/Guillaume-Sanchez/kactus

echo "Bienvenue dans le script d'installation de Traefik avec Docker Compose !"
echo "NIQUE TA MERE"

# --- Configuration ---
PROJECT_NAME="traefik"
COMPOSE_FILE="docker-compose.yml"
CONFIG_FILE="traefik.yml"

echo "🚀 Préparation du projet Docker Compose..."

# 1. Créer le répertoire du projet s'il n'existe pas
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

# 2. Créer le fichier docker-compose.yml
# Cette image exécute un binaire qui affiche le message et s'arrête.
cat << EOF > $COMPOSE_FILE
services:
  traefik:
    image: traefik:latest
    command:
      - "--api.insecure=true"
      - "--providers.docker=true"
    ports:
      - "8080:8080"
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./traefik.yml:/etc/traefik/traefik.yml:ro
    networks:
      - frontend
    restart: unless-stopped
networks:
  frontend:
    external: true
EOF

echo "✅ Fichier $COMPOSE_FILE créé dans $(pwd) :"
cat $COMPOSE_FILE
echo "---"

cat << EOF > $CONFIG_FILE
global:
  checkNewVersion: false
  sendAnonymousUsage: false
log:
  level: DEBUG
api:
  dashboard: true
  insecure: true
entryPoints:
  traefik:
    address: ":8080"
  web:
    address: ":80"
  websecure:
    address: ":443"
EOF

# 3. Exécuter Docker Compose
# -d pour détacher (pas nécessaire ici pour hello-world, mais bonne pratique)
# --rm pour nettoyer le conteneur après l'arrêt (utile pour ce cas simple)

echo "▶️ Lancement de 'docker compose up'"
# On n'utilise pas -d pour voir la sortie immédiatement
docker compose up --force-recreate --build --no-start
docker compose start

echo "✨ Terminé ! Traefik a bien été configurés et les ressources sont nettoyées."

# push toujours pas pirs en compte