#!/usr/bin/env bash
# Copyright (c) 2021-2025 Guillaume Sanchez
# Author: Guillaume Sanchez
# License: MIT | https://github.com/Guillaume-Sanchez/kactus

#!/usr/bin/env bash

set -e

TRIVY_IMAGE="aquasec/trivy:latest"
CACHE_DIR="$HOME/.cache/trivy"
REPORT_DIR="./trivy-reports"

usage() {
  echo "Trivy Remote Runner"
  echo
  echo "Usage:"
  echo "  curl -sL <URL>/trivy-scan.sh | bash -- <command>"
  echo
  echo "Commands:"
  echo "  image <image_name>         - Scan une image Docker"
  echo "  container <container_id>   - Scan un conteneur en cours d'exécution"
  echo "  help                       - Affiche cette aide"
  echo
  echo "Exemples :"
  echo "  curl -sL https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/trivy/trivy-scan.sh | bash -s -- image nginx:latest"
  echo "  curl -sL https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/trivy/trivy-scan.sh | bash -s -- container my-app"
  exit 0
}

# Pas d’arguments → aide
if [ $# -eq 0 ] || [ "$1" = "help" ]; then
  usage
fi

# Vérifier docker
if ! command -v docker >/dev/null 2>&1; then
  echo "[ERREUR] Docker n'est pas installé." >&2
  exit 1
fi

mkdir -p "$CACHE_DIR"
mkdir -p "$REPORT_DIR"

COMMAND="$1"
TARGET="$2"

if [ -z "$TARGET" ]; then
  echo "[ERREUR] Il manque la cible" >&2
  usage
fi

# Date du rapport
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Safe filename (remplacer / par _)
SAFE_TARGET=$(echo "$TARGET" | sed 's#[/ ]#_#g')

# Nom du fichier
REPORT_FILE="$REPORT_DIR/trivy-report-$COMMAND-$SAFE_TARGET-$TIMESTAMP.txt"


run_scan() {
  docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$CACHE_DIR:/root/.cache/trivy" \
    "$TRIVY_IMAGE" "$@" | tee "$REPORT_FILE"

  echo
  echo "[OK] Rapport sauvegardé dans : $REPORT_FILE"
}

case "$COMMAND" in
  image)
    echo "[INFO] Scan de l'image : $TARGET"
    run_scan image "$TARGET"
    ;;

  container)
    echo "[INFO] Scan du conteneur : $TARGET"
    
    IMG=$(docker inspect --format='{{.Config.Image}}' "$TARGET")

    if [ -z "$IMG" ]; then
      echo "[ERREUR] Impossible de récupérer l'image du conteneur." >&2
      exit 1
    fi

    echo "[INFO] Image détectée : $IMG"
    run_scan image "$IMG"
    ;;

  *)
    echo "[ERREUR] Commande inconnue : $COMMAND" >&2
    usage
    ;;
esac
