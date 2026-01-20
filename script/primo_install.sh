#!/bin/bash
# Copyright (c) 2021-2025 Guillaume Sanchez
# Author: Guillaume Sanchez
# License: MIT | https://github.com/Guillaume-Sanchez/kactus
# version: 1.1.1

echo "============================"
echo "🚀 Clonage du dépôt GitHub de Kactus dans ~/kactus"
echo "============================"
git clone https://github.com/Guillaume-Sanchez/kactus.git
if [ $? -ne 0 ]; then
    echo "❌ Échec du clonage du dépôt GitHub. Le répertoire ~/kactus existe-t-il déjà ?"
    exit 1
else
    echo "✅ Dépôt cloné avec succès."
fi
cd kactus
echo "============================"
echo "🚀 Mise en place de la crontab pour les scans Trivy"
echo "============================"
crontab -l > kactus_crontab
echo "0 2 * * * cd ~/kactus/trivy && ./trivy-crontab.sh" >> kactus_crontab
crontab kactus_crontab
rm kactus_crontab
echo "✅ Crontab mise à jour."
echo "============================"
echo "🚀 Création du réseau Docker kactus-network"
echo "============================"
docker network create kactus-network
echo "============================"
echo "🚀 Installation de Grafana, Loki, Prometheus et Promtail"
echo "============================"
grafana/install.sh
echo "============================"
echo "🚀 Installation de PhpIPAM"
echo "============================"
phpIPAM/install.sh
echo "============================"
echo "🚀 Installation de Kactus Web"
echo "============================"
kactus-web/install.sh
