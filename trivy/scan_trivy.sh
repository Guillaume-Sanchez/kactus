#!/bin/bash

# Copyright (c) 2021-2025 Guillaume Sanchez
# Author: Guillaume Sanchez
# License: MIT | https://github.com/Guillaume-Sanchez/kactus
# version: 1.0.1

LOG_FILE="/var/log/trivy.log"

# On met un en-tête pour savoir quand ça a tourné
echo "=== Rapport de sécurité du $(date) ===" > $LOG_FILE

# On scanne tes images critiques
# On utilise --light pour aller vite, et on redirige (>>) la sortie dans le fichier
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image --scanners vuln --severity HIGH,CRITICAL wordpress:latest >> $LOG_FILE

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image --scanners vuln --severity HIGH,CRITICAL phpipam/phpipam-www:latest >> $LOG_FILE

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image --scanners vuln --severity HIGH,CRITICAL phpipam/phpipam-cron:latest >> $LOG_FILE

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image --scanners vuln --severity HIGH,CRITICAL mariadb:latest >> $LOG_FILE

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image --scanners vuln --severity HIGH,CRITICAL grafana/grafana:latest >> $LOG_FILE

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image --scanners vuln --severity HIGH,CRITICAL grafana/loki:latest >> $LOG_FILE

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image --scanners vuln --severity HIGH,CRITICAL prom/prometheus:latest >> $LOG_FILE

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image --scanners vuln --severity HIGH,CRITICAL grafana/promtail:latest >> $LOG_FILE

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image --scanners vuln --severity HIGH,CRITICAL gcr.io/cadvisor/cadvisor:latest >> $LOG_FILE

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image --scanners vuln --severity HIGH,CRITICAL portainer/portainer-ce:latest >> $LOG_FILE

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image --scanners vuln --severity HIGH,CRITICAL jc21/nginx-proxy-manager:latest >> $LOG_FILE

echo "=== Fin du rapport ===" >> $LOG_FILE