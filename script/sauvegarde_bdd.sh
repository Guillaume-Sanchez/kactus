#!/bin/bash

source /home/admkactus/.env

# --- CONFIGURATION ---
CONTAINER_NAME="kactus-bdd"           
BACKUP_DIR="/opt/kactus/kactus-bdd/backups"
DATE=$(date +%Y-%m-%d_%Hh%M)
# Créer le dossier s'il n'existe pas
mkdir -p $BACKUP_DIR
echo "Début de la sauvegarde pour Kactus..."
# --- EXECUTION ---
docker exec $CONTAINER_NAME /usr/bin/mariadb-dump -u$DB_USER -p$DB_PASSWORD --all-databases > $BACKUP_DIR/backup_all_$DATE.sql
gzip $BACKUP_DIR/backup_all_$DATE.sql
# --- NETTOYAGE ---
find $BACKUP_DIR -type f -mtime +7 -name "*.gz" -delete
echo "Sauvegarde terminée dans $BACKUP_DIR/backup_all_$DATE.sql.gz"