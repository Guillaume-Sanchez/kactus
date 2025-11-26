#!/bin/bash
# Copyright (c) 2021-2025 Guillaume Sanchez
# Author: Guillaume Sanchez
# License: MIT | https://github.com/Guillaume-Sanchez/kactus

# --- Configuration ---
PROJECT_NAME="hello-world"
COMPOSE_FILE="docker-compose.yml"

echo "🚀 Préparation du projet Docker Compose..."

# 1. Créer le répertoire du projet s'il n'existe pas
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

# 2. Créer le fichier docker-compose.yml
# On utilise l'image 'hello-world' de Docker Hub.
# Cette image exécute un binaire qui affiche le message et s'arrête.
cat << EOF > $COMPOSE_FILE
version: "3.8"
services:
  hello:
    image: hello-world
    container_name: hello-world-container
EOF

echo "✅ Fichier $COMPOSE_FILE créé dans $(pwd) :"
cat $COMPOSE_FILE
echo "---"

# 3. Exécuter Docker Compose
# -d pour détacher (pas nécessaire ici pour hello-world, mais bonne pratique)
# --rm pour nettoyer le conteneur après l'arrêt (utile pour ce cas simple)

echo "▶️ Lancement de 'docker compose up' pour afficher 'Hello World'..."
# On n'utilise pas -d pour voir la sortie immédiatement
docker compose up --force-recreate --build --no-start
docker compose start

# Voir les logs du conteneur (où le 'Hello World' sera affiché)
echo "--- Sortie du conteneur ---"
docker compose logs hello
echo "--- Fin de la sortie du conteneur ---"

# 4. Nettoyage
echo "🧹 Nettoyage des ressources (arrêt et suppression du conteneur)..."
# Arrête et supprime les conteneurs définis dans le fichier compose
docker compose down

# Revenir au répertoire précédent et supprimer le répertoire de travail
cd ..
rm -rf $PROJECT_NAME

echo "✨ Terminé ! 'Hello World' a été exécuté et les ressources sont nettoyées."