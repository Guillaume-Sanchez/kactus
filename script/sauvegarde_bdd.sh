#!/bin/bash

# --- CONFIGURATION ---
CONTAINER_NAME="kactus-bdd"       
DB_USER="root"                    
DB_PASSWORD="TON_MOT_DE_PASSE"    
BACKUP_DIR="/opt/kactus-bdd/backups/kactus"
DATE=$(date +%Y-%m-%d_%Hh%M)

# Créer le dossier s'il n'existe pas
mkdir -p $BACKUP_DIR

echo "Début de la sauvegarde pour Kactus..."

# --- EXECUTION ---
# On utilise docker exec pour dumper toutes les bases
docker exec $CONTAINER_NAME /usr/bin/mariadb-dump -u$DB_USER -p$DB_PASSWORD --all-databases > $BACKUP_DIR/backup_all_$DATE.sql

# Optionnel : On compresse pour gagner de la place
gzip $BACKUP_DIR/backup_all_$DATE.sql

# --- NETTOYAGE ---
# Supprime les sauvegardes de plus de 7 jours pour ne pas saturer le disque
find $BACKUP_DIR -type f -mtime +7 -name "*.gz" -delete

echo "Sauvegarde terminée dans $BACKUP_DIR/backup_all_$DATE.sql.gz"