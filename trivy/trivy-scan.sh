#!/usr/bin/env bash
# Copyright (c) 2021-2025 Guillaume Sanchez
# Author: Guillaume Sanchez
# License: MIT | https://github.com/Guillaume-Sanchez/kactus

set -e

TRIVY_IMAGE="aquasec/trivy:latest"
CACHE_DIR="$HOME/.cache/trivy"

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
  echo "  curl -sL <URL>/trivy-scan.sh | bash -- image nginx:latest"
  echo "  curl -sL <URL>/trivy-scan.sh | bash -- container my-app"
  exit 0
}

if [ $# -eq 0 ] || [ "$1" = "help" ]; then
  usage
fi

# Vérification Docker
if ! command -v docker >/dev/null 2>&1; then
  echo "[ERREUR] Docker n'est pas installé ou accessible." >&2
  exit 1
fi

mkdir -p "$CACHE_DIR"

COMMAND="$1"
TARGET="$2"

if [ -z "$TARGET" ]; then
  echo "[ERREUR] Il manque un argument cible." >&2
  usage
fi

case "$COMMAND" in
  image)
    echo "[INFO] Scan de l'image : $TARGET"
    docker run --rm \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v "$CACHE_DIR:/root/.cache/trivy" \
      "$TRIVY_IMAGE" image "$TARGET"
    ;;

  container)
    echo "[INFO] Scan du conteneur : $TARGET"
    # Récupérer l’image du conteneur
    IMG=$(docker inspect --format='{{.Config.Image}}' "$TARGET")

    if [ -z "$IMG" ]; then
      echo "[ERREUR] Impossible de récupérer l'image du conteneur." >&2
      exit 1
    fi

    echo "[INFO] Image détectée : $IMG"
    docker run --rm \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v "$CACHE_DIR:/root/.cache/trivy" \
      "$TRIVY_IMAGE" image "$IMG"
    ;;

  *)
    echo "[ERREUR] Commande inconnue : $COMMAND" >&2
    usage
    ;;
esac
