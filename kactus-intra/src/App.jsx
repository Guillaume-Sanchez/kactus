import React from 'react';

const KactusDashboard = () => {

  const anneeActuelle = new Date().getFullYear();

  const colors = {
    primary: '#78a34d',
    maintenance: "#d68a27",
    background: '#1a1a1a',
    cardBg: '#252525',
    text: '#ffffff',
    textSecondary: '#a0a0a0'
  };

  const services = [
    {
      title: "Site Web Corporate",
      desc: "Accès au CMS WordPress pour la gestion du contenu marketing et vitrine.",
      link: "https://kactus.guillaume-sanchez.fr/",
      status: "En ligne",
      statusColor: colors.primary
    },
    {
      title: "Monitoring & Logs",
      desc: "Supervision de l'infrastructure via Grafana. Visualisation des métriques Docker.",
      link: "http://192.168.1.242:3000",
      status: "Actif",
      statusColor: colors.primary
    },
    {
      title: "Gestion IP (phpIPAM)",
      desc: "Outil d'administration des adresses IP et du plan d'adressage réseau.",
      link: "http://192.168.1.242:8080",
      status: "Actif",
      statusColor: colors.primary
    },
    {
      title: "Portail de Gestion d'infrastructure",
      desc: "Interface d'administration des services Docker et de l'infrastructure serveur.",
      link: "http://192.168.1.242:9000",
      status: "Actif",
      statusColor: colors.primary
    }
  ];

  return (
    <>
      <style>{`
        :root {
          font-family: Inter, system-ui, Avenir, Helvetica, Arial, sans-serif;
          line-height: 1.5;
          font-weight: 400;
        }
        
        html, body {
          margin: 0 !important;
          padding: 0 !important;
          width: 100% !important;
          height: 100% !important;
          background-color: ${colors.background};
          max-width: none !important;
        }

        /* Le reste du design */
        .kactus-header {
          background-color: ${colors.cardBg};
          border-bottom: 3px solid ${colors.primary};
          padding: 1rem 2rem;
          display: flex;
          justify-content: space-between;
          align-items: center;
          width: 100%;
          box-sizing: border-box;
        }

        .kactus-container {
          width: 100%;
          min-height: 100vh;
          display: flex;
          flex-direction: column;
          align-items: center;
          color: ${colors.text};
        }

        .main-content {
          width: 100%;
          max-width: 1200px;
          padding: 3rem 2rem;
          box-sizing: border-box;
        }

        .services-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
          gap: 2rem;
          width: 100%;
        }

        .service-card {
          background-color: ${colors.cardBg};
          border: 1px solid #333;
          border-radius: 12px;
          padding: 2rem;
          display: flex;
          flex-direction: column;
          justify-content: space-between;
          transition: transform 0.2s;
        }
        
        .service-card:hover {
          transform: translateY(-5px);
          border-color: ${colors.primary};
        }

        .btn-access {
          background-color: ${colors.primary};
          color: white;
          text-decoration: none;
          padding: 0.8rem 1rem;
          border-radius: 6px;
          text-align: center;
          font-weight: bold;
          display: block;
          margin-top: 1rem;
        }
      `}</style>

      <div className="kactus-container">
        <header className="kactus-header">
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

        <div className="main-content">
          <div style={{ textAlign: 'center', marginBottom: '3rem' }}>
            <h1 style={{ fontSize: '2.5rem', margin: '0 0 0.5rem 0' }}>Hub Kactus</h1>
            <p style={{ color: colors.textSecondary }}>Portail centralisé de gestion des services internes</p>
          </div>

          <div className="services-grid">
            {services.map((service, index) => (
              <div key={index} className="service-card">
                <div>
                  <h3 style={{ color: colors.primary, borderBottom: '1px solid #444', paddingBottom: '0.5rem', marginTop: 0 }}>
                    {service.title}
                  </h3>
                  <p style={{ color: colors.textSecondary, lineHeight: '1.5' }}>{service.desc}</p>
                </div>
                <div>
                  <div style={{ margin: '1rem 0', fontSize: '0.9rem', color: '#888' }}>
                    État : <span style={{ color: service.statusColor }}>● {service.status}</span>
                  </div>
                  <a href={service.link} className="btn-access">Accéder au service</a>
                </div>
              </div>
            ))}
          </div>
        </div>
        
        <footer style={{ marginTop: 'auto', padding: '2rem', color: '#555', fontSize: '0.8rem', textAlign: 'center', width: '100%' }}>
          &copy; {anneeActuelle} Kactus Marketing. Infrastructure Dockerisée.
        </footer>
      </div>
    </>
  );
};

export default KactusDashboard;