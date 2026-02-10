#!/bin/bash

LOG_FILE="/var/log/trivy-results.log"

# Liste de tes images à scanner (mets celles que tu utilises vraiment)
IMAGES=("wordpress:latest" "mariadb:latest" "phpipam/phpipam-www:latest" "grafana/grafana:latest" "prom/prometheus:latest" "grafana/promtail:latest" "grafana/loki:latest" "cadvisor:latest" "npm:latest" "portainer/portainer-ce:latest") 
echo "--- Début du scan $(date) ---" >> $LOG_FILE

for img in "${IMAGES[@]}"; do
    # On lance Trivy (via docker) et on ne garde que la ligne de résumé "Total: ..."
    # On formate le log pour qu'il soit facile à lire par Loki : "image=wordpress results=..."
    RESULT=$(docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --scanners vuln --severity HIGH,CRITICAL --format json $img | jq -r '.Results[0].Vulnerabilities | length')
    
    # Si jq n'est pas installé, Trivy a un format table simple, mais le JSON est plus sûr pour les scripts.
    # Version simplifiée sans jq (affiche juste le texte brut) :
    SUMMARY=$(docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --severity HIGH,CRITICAL $img | grep "Total:")
    
    if [ -z "$SUMMARY" ]; then
        SUMMARY="Total: 0 (HIGH: 0, CRITICAL: 0)"
    fi

    echo "timestamp=$(date +%s) image=$img $SUMMARY" >> $LOG_FILE
done