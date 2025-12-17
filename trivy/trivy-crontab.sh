#!/usr/bin/env bash
# Copyright (c) 2021-2025 Guillaume Sanchez
# Author: Guillaume Sanchez
# License: MIT | https://github.com/Guillaume-Sanchez/kactus
# version: 1.0.1

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
TRIVY_IMAGE="aquasec/trivy:latest"
REPORT_DIR="./trivy-reports"

cd ~/kactus/trivy

echo "--- Début du scan de sécurité du $TIMESTAMP ---"
IMAGES=$(docker ps --format "{{.Image}}")

for IMAGE in $IMAGES; do
    echo "Scanning image: $IMAGE"
    ./trivy-scan.sh image "$IMAGE"
done

CONTAINERS=$(docker ps --format "{{.ID}}")

for CONTAINER in $CONTAINERS; do
    echo "Scanning container: $CONTAINER"
    ./trivy-scan.sh container "$CONTAINER"
done

find $REPORT_DIR -name "*.log" -type f -mtime +7 -delete
echo "--- Fin du scan ---"