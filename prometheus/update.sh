#!/bin/bash
# Copyright (c) 2021-2025 Guillaume Sanchez
# Author: Guillaume Sanchez
# License: MIT | https://github.com/Guillaume-Sanchez/kactus
# version: 1.0.0

# --- Configuration ---
PROJECT_NAME="prometheus"
COMPOSE_FILE="docker-compose.yml"
ENV_FILE=".env"

echo "🚀 Mise à jour du projet $PROJECT_NAME..."

# 1. Aller dans le répertoire du projet
cd $HOME/dockers/$PROJECT_NAME

# 4. Exécuter Docker Compose pour mettre à jour les services
echo "▶️ Lancement de 'docker compose up'"
# On n'utilise pas -d pour voir la sortie immédiatement
sudo docker compose up -d --force-recreate --pull always

echo "✨ Terminé ! Prometheus a été mis à jour."