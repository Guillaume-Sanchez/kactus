#!/bin/bash
# Copyright (c) 2021-2025 Guillaume Sanchez
# Author: Guillaume Sanchez
# License: MIT | https://github.com/Guillaume-Sanchez/kactus

# === LISTE DES SCRIPTS DISTANTS ===
declare -A scripts

scripts=(
  ["Installer Kactus Web"]="https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/kactus-web/install.sh"
  ["Installer grafana et Loki"]="https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/grafana/install.sh"
  ["Installer Prometheus"]="https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/prometheus/install.sh"
  ["Installer PhpIPAM"]="https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/phpIPAM/install.sh"
  ["Installer Traefik"]="https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/traefik/install.sh"
)

# --- Fonction d'exécution d'un script distant ---
run_remote() {
    echo "----------------------------------------------------"
    echo "▶️  Exécution du script : $1"
    echo "----------------------------------------------------"
    sudo bash -c "$(curl -fsSL "$1")"
}

# ============================
#        MENU PRINCIPAL
# ============================
while true; do
    echo ""
    echo "===== MENU D'INSTALLATION DE KACTUS PRODUCTION ====="
    echo ""

    i=1
    for key in "${!scripts[@]}"; do
        echo "$i. $key"
        ((i++))
    done

    echo "A. Installer TOUS les scripts"
    echo "Q. Quitter"
    echo ""
    read -p "➡️  Votre choix : " choice

    # Lancer un script unique
    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#scripts[@]} )); then
        index=1
        for key in "${!scripts[@]}"; do
            if [[ $index -eq $choice ]]; then
                run_remote "${scripts[$key]}"
                break
            fi
            ((index++))
        done
        continue
    fi

    # Lancer tous les scripts
    if [[ "$choice" =~ ^[aA]$ ]]; then
        echo "🚀 Lancement de l'installation complète"
        for key in "${!scripts[@]}"; do
            run_remote "${scripts[$key]}"
        done
        continue
    fi

    # Quitter
    if [[ "$choice" =~ ^[qQ]$ ]]; then
        echo "👋 Fin du script."
        exit 0
    fi

    echo "❌ Option invalide, veuillez réessayer."
done