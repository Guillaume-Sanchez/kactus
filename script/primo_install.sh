#!/bin/bash
# Copyright (c) 2021-2025 Guillaume Sanchez
# Author: Guillaume Sanchez
# License: MIT | https://github.com/Guillaume-Sanchez/kactus
# version: 1.1.2

echo "============================"
echo "🚀 Clonage du dépôt GitHub de Kactus dans ~/kactus"
echo "============================"
git clone https://github.com/Guillaume-Sanchez/kactus.git
if [ $? -ne 0 ]; then
    echo "❌ Échec du clonage du dépôt GitHub."
    exit 1
else
    echo "✅ Dépôt cloné avec succès."
fi
cd kactus
echo "============================"
echo "🚀 Mise en place de fichiers de configuration"
echo "============================"
sudo mkdir -p /opt/kactus/grafana/
sudo mkdir -p /opt/kactus/kactus-web/
sudo cp grafana/*-config.yml /opt/kactus/grafana/
sudo cp kactus-web/wp-config.php /opt/kactus/kactus-web/
sudo cp -r kactus-web/wp-content /opt/kactus/kactus-web/
echo "============================"
echo "🚀 Mise en place de la crontab pour les scans Trivy"
echo "============================"
crontab -l > kactus_crontab
echo "0 2 * * * cd ~/kactus/trivy && ./trivy-crontab.sh" >> kactus_crontab
crontab kactus_crontab
rm kactus_crontab
echo "============================"
echo "✅ Crontab mise à jour."
echo "============================"
echo "🚀 Création du réseau Docker kactus-network"
echo "============================"
docker network create kactus-network
echo "============================"
echo "✨ Installation de la Primo-Install terminée"
echo "============================"