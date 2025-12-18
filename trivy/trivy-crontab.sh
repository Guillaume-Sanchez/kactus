#!/bin/bash

# Copyright (c) 2021-2025 Guillaume Sanchez
# Author: Guillaume Sanchez
# License: MIT | https://github.com/Guillaume-Sanchez/kactus
# version: 1.0.2

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
TRIVY_IMAGE="aquasec/trivy:latest"
HOME="/home/admkactus"

cd ~/kactus/trivy

# Répertoire du script (résoudre le chemin absolu pour permettre l'exécution depuis n'importe où)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd || pwd)"
REPORT_DIR="$HOME/trivy-reports"

echo "--- Début du scan de sécurité du $TIMESTAMP ---"
IMAGES=$(docker ps --format "{{.Image}}")

for IMAGE in $IMAGES; do
    echo "Scanning image: $IMAGE"
    "$SCRIPT_DIR/trivy-scan.sh" image "$IMAGE"
done

CONTAINERS=$(docker ps --format "{{.ID}}")

for CONTAINER in $CONTAINERS; do
    echo "Scanning container: $CONTAINER"
    "$SCRIPT_DIR/trivy-scan.sh" container "$CONTAINER"
done

find $REPORT_DIR -name "*.log" -type f -mtime +7 -delete
echo "--- Fin du scan ---"