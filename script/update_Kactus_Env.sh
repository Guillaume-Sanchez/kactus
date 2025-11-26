#!/bin/bash
# Copyright (c) 2021-2025 Guillaume Sanchez
# Author: Guillaume Sanchez
# License: MIT | https://github.com/Guillaume-Sanchez/kactus
# version: 1.0.0

# === LISTE DES SCRIPTS DISTANTS ===
declare -A scripts

# Si les scripts sont dejà présents localement, les utiliser au lieu de les télécharger
if [ -d "$HOME/kactus" ]; then
    echo "📂 Utilisation des scripts locaux dans $HOME/kactus"
    scripts=(
        ["Installer Kactus Web"]="$HOME/kactus/kactus-web/update.sh"
        ["Installer grafana et Loki"]="$HOME/kactus/grafana/update.sh"
        ["Installer Prometheus"]="$HOME/kactus/prometheus/update.sh"
        ["Installer PhpIPAM"]="$HOME/kactus/phpIPAM/update.sh"
    )
    # --- Fonction d'exécution d'un script local ---
    run_remote() {
        echo "----------------------------------------------------"
        echo "▶️  Exécution du script : $1"
        echo "----------------------------------------------------"
        $1
    }
else
    echo "🌐 Utilisation des scripts depuis le dépôt GitHub"
    scripts=(
        ["Installer Kactus Web"]="https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/kactus-web/update.sh"
        ["Installer grafana et Loki"]="https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/grafana/update.sh"
        ["Installer Prometheus"]="https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/prometheus/update.sh"
        ["Installer PhpIPAM"]="https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/phpIPAM/update.sh"
    )

    # --- Fonction d'exécution d'un script distant ---
    run_remote() {
        echo "----------------------------------------------------"
        echo "▶️  Exécution du script : $1"
        echo "----------------------------------------------------"
        bash -c "$(curl -fsSL "$1")"
    }
fi



# ============================
#        MENU PRINCIPAL
# ============================
while true; do
    echo ""
    echo "===== MENU DE MISE A JOURS DE KACTUS PRODUCTION ====="
    echo ""

    i=1
    for key in "${!scripts[@]}"; do
        echo "$i. $key"
        ((i++))
    done

    echo "A. Mettre à jour TOUS les scripts"
    echo "C. Cloner le dépôt GitHub de Kactus dans ~/kactus"
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
        echo "🚀 Lancement des mises a jours"
        for key in "${!scripts[@]}"; do
            run_remote "${scripts[$key]}"
        done
        continue
    fi

    # Cloner le dépôt GitHub
    if [[ "$choice" =~ ^[cC]$ ]]; then
        echo "🚀 Clonage du dépôt GitHub de Kactus dans ~/kactus"
        git clone https://github.com/Guillaume-Sanchez/kactus.git
        continue
    fi

    # Quitter
    if [[ "$choice" =~ ^[qQ]$ ]]; then
        echo "👋 Fin du script."
        exit 0
    fi

    echo "❌ Option invalide, veuillez réessayer."
done