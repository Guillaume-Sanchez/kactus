#!/bin/bash
# Copyright (c) 2021-2025 Guillaume Sanchez
# Author: Guillaume Sanchez
# License: MIT | https://github.com/Guillaume-Sanchez/kactus

# --- Configuration ---
PROJECT_NAME="traefik"
COMPOSE_FILE="docker-compose.yml"

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
    container_name: traefik
    command:
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"

      # Dashboard
      - "--api.dashboard=true"
      - "--certificatesresolvers.le.acme.email=sanchez.guillaume116@gmail.com"
      - "--certificatesresolvers.le.acme.storage=/letsencrypt/acme.json"
      - "--certificatesresolvers.le.acme.tlschallenge=true"

    ports:
      - "80:80"
      - "443:443"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
      - "./letsencrypt:/letsencrypt"

    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.traefik.rule=Host(`traefik.192.16.1.242.nip.io`)"
      - "traefik.http.routers.traefik.entrypoints=websecure"
      - "traefik.http.routers.traefik.tls=true"
      - "traefik.http.routers.traefik.service=api@internal"

    networks:
      - web

networks:
  web:
    driver: bridge
EOF

echo "✅ Fichier $COMPOSE_FILE créé dans $(pwd) :"
cat $COMPOSE_FILE
echo "---"
# 3. Exécuter Docker Compose
# -d pour détacher (pas nécessaire ici pour hello-world, mais bonne pratique)
# --rm pour nettoyer le conteneur après l'arrêt (utile pour ce cas simple)

echo "▶️ Lancement de 'docker compose up'"
# On n'utilise pas -d pour voir la sortie immédiatement
docker compose up --force-recreate --build --no-start
docker compose start

# 4. Nettoyage
echo "🧹 Nettoyage des ressources ..."
# Revenir au répertoire précédent et supprimer le répertoire de travail
cd ..
rm -rf $PROJECT_NAME

echo "✨ Terminé ! Traefik a bien été configurés et les ressources sont nettoyées."