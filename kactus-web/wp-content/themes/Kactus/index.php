<!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
    <meta charset="<?php bloginfo('charset'); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kactus | Solutions Digitales Résilientes</title>
    <?php wp_head(); ?>
</head>
<body <?php body_class(); ?>>

    <header class="site-header">
        <div class="container">
            <div class="logo">
                <img src="<?php echo get_template_directory_uri(); ?>/images/kactus_ico.png" alt="Kactus Logo">
                <span>Kactus</span>
            </div>
            <nav class="main-nav">
                <ul>
                    <li><a href="#services">Services</a></li>
                    <li><a href="#about">A Propos</a></li>
                    <li><a href="#contact" class="btn-contact">Contact</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <section class="hero">
        <div class="container hero-grid">
            <div class="hero-content">
                <h1>Des solutions IT qui <span>ne manquent pas de piquant.</span></h1>
                <p>Spécialiste en infrastructure Cloud, Cybersécurité et Développement Web robuste. Nous aidons votre entreprise à croître sereinement dans l'écosystème numérique.</p>
                <a href="#services" class="btn-primary">Découvrir nos services</a>
            </div>
            <div class="hero-image">
                <img src="<?php echo get_template_directory_uri(); ?>/images/kactus_logo.png" alt="Illustration Kactus">
            </div>
        </div>
    </section>

    <section id="services" class="services">
        <div class="container">
            <h2 class="section-title">Nos expertises</h2>
            <div class="services-grid">
                <div class="service-card">
                    <div class="icon">☁️</div>
                    <h3>Solutions Cloud</h3>
                    <p>Migration, gestion et optimisation de vos infrastructures serveur pour une scalabilité totale.</p>
                </div>
                <div class="service-card">
                    <div class="icon">🔒</div>
                    <h3>Cybersécurité</h3>
                    <p>Audit, protection de données et mise en place de protocoles de défense contre les menaces.</p>
                </div>
                <div class="service-card">
                    <div class="icon">💻</div>
                    <h3>Développement Web</h3>
                    <p>Création d'applications web modernes, rapides et optimisées pour le SEO et l'expérience utilisateur.</p>
                </div>
            </div>
        </div>
    </section>

    <footer class="site-footer">
        <div class="container">
            <p>&copy; <?php echo date('Y'); ?> Kactus - Tous droits réservés.</p>
        </div>
    </footer>

    <?php wp_footer(); ?>
</body>
</html>
