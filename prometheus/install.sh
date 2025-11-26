#!/bin/bash
# Copyright (c) 2021-2025 Guillaume Sanchez
# Author: Guillaume Sanchez
# License: MIT | https://github.com/Guillaume-Sanchez/kactus
# version: 2.0.0

# --- Configuration ---
PROJECT_NAME="prometheus"
COMPOSE_FILE="docker-compose.yml"
CONF_FILE="prometheus.yml"

echo "🚀 Préparation du projet Docker Compose..."

# 1. Créer le répertoire du projet s'il n'existe pas
mkdir -p $HOME/dockers/$PROJECT_NAME
cd $HOME/dockers/$PROJECT_NAME

# 2. Créer le fichier docker-compose.yml
# Cette image exécute un binaire qui affiche le message et s'arrête.
cat << EOF > $COMPOSE_FILE
services:
   prometheus:
     image: prom/prometheus
     volumes:
       - "./prometheus.yml:/etc/prometheus/prometheus.yml"
     networks:
       - localprom
     ports:
       - 9090:9090
networks:
   localprom:
     driver: bridge
EOF
echo "✅ Fichier $COMPOSE_FILE créé dans $(pwd) :"

cat $COMPOSE_FILE
echo "---"

# 3. Créer le fichier prometheus.yml
cat << EOF > $CONF_FILE
global:
  scrape_interval: 10s
scrape_configs:
 - job_name: prometheus
   static_configs:
     - targets:
       - prometheus:9090
EOF

# 4. Exécuter Docker Compose
# -d pour détacher (pas nécessaire ici pour hello-world, mais bonne pratique)
# --rm pour nettoyer le conteneur après l'arrêt (utile pour ce cas simple)

echo "▶️ Lancement de 'docker compose up'"
# On n'utilise pas -d pour voir la sortie immédiatement
sudo docker compose up --force-recreate --build --no-start
sudo docker compose start

echo "✨ Terminé ! Prometheus a bien été configurés et les ressources sont nettoyées."