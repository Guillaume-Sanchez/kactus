import React from 'react';

const KactusDashboard = () => {
  // --- 1. Configuration ---
  const colors = {
    primary: '#78a34d',   // Vert Kactus
    maintenance: "#d68a27",
    background: '#1a1a1a', // Noir charbon
    cardBg: '#252525',     // Gris foncé
    text: '#ffffff',
    textSecondary: '#a0a0a0'
  };

  // --- 2. Données (Avec ta 4ème carte ajoutée) ---
  const services = [
    {
      title: "Site Web Corporate",
      desc: "Accès au CMS WordPress pour la gestion du contenu marketing et vitrine.",
      link: "http://localhost:8080", // Port WordPress
      status: "En ligne",
      statusColor: colors.primary
    },
    {
      title: "Monitoring & Logs",
      desc: "Supervision de l'infrastructure via Grafana. Visualisation des métriques Docker.",
      link: "http://localhost:3000", // Port Grafana
      status: "Actif",
      statusColor: colors.primary
    },
    {
      title: "Gestion IP (phpIPAM)",
      desc: "Outil d'administration des adresses IP et du plan d'adressage réseau.",
      link: "#",
      status: "Active",
      statusColor: colors.primary
    },
    {
      title: "Portail de Gestion d'infrastructure",
      desc: "Interface d'administration des services Docker et de l'infrastructure serveur (Portainer).",
      link: "http://localhost:9443", // Port Portainer (exemple)
      status: "Actif",
      statusColor: colors.primary
    }
  ];

  // --- 3. Styles Structurels (Javascript) ---
  const styles = {
    // Le conteneur principal qui prend tout l'écran
    appContainer: {
      minHeight: '100vh',        // Force la hauteur min à 100% de la vue
      display: 'flex',
      flexDirection: 'column',   // Empilement Vertical (Header -> Main -> Footer)
      backgroundColor: colors.background,
      color: colors.text,
      fontFamily: "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif",
      width: '100%' // Force la largeur
    },
    
    header: {
      backgroundColor: colors.cardBg,
      borderBottom: `3px solid ${colors.primary}`,
      padding: '1rem 2rem',
      display: 'flex',
      justifyContent: 'space-between',
      alignItems: 'center',
      boxShadow: '0 4px 12px rgba(0,0,0,0.2)'
    },

    // Le wrapper qui contient le corps de page
    // FLEX: 1 est la clé : il va grandir pour occuper tout l'espace vide
    // et pousser le footer vers le bas.
    mainWrapper: {
      flex: 1, 
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      width: '100%',
      paddingBottom: '4rem' // Marge de sécurité avant le footer
    },

    contentArea: {
      width: '100%',
      maxWidth: '1200px',
      padding: '3rem 2rem',
      boxSizing: 'border-box'
    },

    titleSection: {
      textAlign: 'center',
      marginBottom: '3rem'
    },

    // Remplacement de GRID par FLEX pour centrer les orphelins
    cardsContainer: {
      display: 'flex',
      flexWrap: 'wrap',           // Permet de passer à la ligne
      justifyContent: 'center',   // Centre les éléments sur la ligne (Magic !)
      gap: '2rem',
      width: '100%'
    },

    card: {
      backgroundColor: colors.cardBg,
      border: '1px solid #333',
      borderRadius: '12px',
      padding: '2rem',
      display: 'flex',
      flexDirection: 'column',
      justifyContent: 'space-between',
      transition: 'all 0.3s ease',
      // Flex intelligent :
      // grow: 1 (peut grandir), shrink: 1 (peut réduire), basis: 300px (taille idéale)
      flex: '1 1 300px', 
      maxWidth: '380px', // Largeur max pour ne pas faire des cartes géantes
      width: '100%'      // Pour le mobile
    },

    button: {
      backgroundColor: colors.primary,
      color: 'white',
      textDecoration: 'none',
      padding: '0.8rem 1.5rem',
      borderRadius: '6px',
      textAlign: 'center',
      fontWeight: '600',
      display: 'block',
      marginTop: '1rem'
    },

    footer: {
      textAlign: 'center',
      padding: '2rem',
      color: '#555',
      fontSize: '0.85rem',
      borderTop: '1px solid #333',
      backgroundColor: colors.background, // S'assure que le footer n'est pas transparent
      width: '100%',
      boxSizing: 'border-box'
    }
  };

  return (
    <>
      {/* CSS Global pour les Resets et Animations */}
      <style>{`
        :root {
          font-family: 'Segoe UI', system-ui, sans-serif;
        }
        /* Reset vital pour que le flex:1 fonctionne */
        html, body, #root {
          margin: 0 !important;
          padding: 0 !important;
          width: 100% !important;
          min-height: 100vh !important;
          background-color: ${colors.background};
        }
        
        /* Animations Hover gérées en CSS pur */
        .service-card:hover {
          transform: translateY(-5px);
          border-color: ${colors.primary} !important;
          box-shadow: 0 10px 20px rgba(0,0,0,0.4);
        }
        .btn-access:hover {
          background-color: #668c41 !important;
        }
      `}</style>

      {/* Structure de l'application */}
      <div style={styles.appContainer}>
        
        {/* EN-TÊTE */}
        <header style={styles.header}>
          <div style={{ fontSize: '1.5rem', fontWeight: 'bold', color: colors.primary, letterSpacing: '1px' }}>
            KACTUS <span style={{ color: 'white' }}>// INTRANET</span>
          </div>
          <div style={{
            padding: '0.25rem 0.8rem',
            borderRadius: '20px',
            fontSize: '0.8rem',
            border: `1px solid ${colors.primary}`,
            color: colors.primary
          }}>
            Système Opérationnel
          </div>
        </header>

        {/* CORPS PRINCIPAL (qui pousse le footer) */}
        <div style={styles.mainWrapper}>
          <div style={styles.contentArea}>
            
            <div style={styles.titleSection}>
              <h1 style={{ fontSize: '2.5rem', margin: '0 0 0.5rem 0' }}>Hub Kactus</h1>
              <p style={{ color: colors.textSecondary }}>Portail centralisé de gestion des services internes</p>
            </div>

            {/* Conteneur des cartes en Flexbox */}
            <div style={styles.cardsContainer}>
              {services.map((service, index) => (
                <div key={index} style={styles.card} className="service-card">
                  <div>
                    <h3 style={{ color: colors.primary, marginTop: 0, marginBottom: '1rem', borderBottom: '1px solid #444', paddingBottom: '0.5rem' }}>
                      {service.title}
                    </h3>
                    <p style={{ color: colors.textSecondary, lineHeight: '1.5' }}>
                      {service.desc}
                    </p>
                  </div>
                  <div>
                    <div style={{ margin: '1rem 0', fontSize: '0.9rem', color: '#888' }}>
                      État : <span style={{ color: service.statusColor }}>● {service.status}</span>
                    </div>
                    <a href={service.link} style={styles.button} className="btn-access">
                      Accéder au service
                    </a>
                  </div>
                </div>
              ))}
            </div>

          </div>
        </div>

        {/* PIED DE PAGE */}
        <footer style={styles.footer}>
          &copy; 2026 Kactus Marketing. Infrastructure Dockerisée par la DSI.
        </footer>

      </div>
    </>
  );
};

export default KactusDashboard;