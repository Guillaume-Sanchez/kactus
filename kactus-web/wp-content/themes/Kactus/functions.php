<?php
/**
 * Fichier de fonctions pour le thÃ¨me Kactus
 */

function kactus_scripts() {
    // On enregistre et on charge le fichier style.css
    // Le 'time()' permet de vider le cache du navigateur   chaque refresh
    wp_enqueue_style( 'kactus-style', get_stylesheet_uri(), array(), time() );
}

add_action( 'wp_enqueue_scripts', 'kactus_scripts' );
