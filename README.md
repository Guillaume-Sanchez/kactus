# kactus
Repos des differents scripts d'installation de la platforme Kactus

## Commande d'installation

### Primo Install :

```bash
bash -c "$(curl https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/script/primo_install.sh)"
```

### Hello World

```bash
bash -c "$(curl https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/hello-world/install.sh)"
```

### Kactus Web

```bash
bash -c "$(curl https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/kactus-web/install.sh)"
```

### Grafana & Loki & Prometheus

```bash
bash -c "$(curl https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/grafana/install.sh)"
```

### phpIPAM

```bash
bash -c "$(curl https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/phpIPAM/install.sh)"
```

### Trivy

Usage :

```bash  
curl -sL https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/trivy/trivy-scan.sh | bash -- <command>
```
  
Commandes :
```yml
image <image_name>         - Scan une image Docker"
container <container_id>   - Scan un conteneur en cours d'exécution"
help                       - Affiche cette aide"
```
Exemples :

```bash
curl -sL https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/trivy/trivy-scan.sh | bash -s -- image nginx:latest"
```
```bash
curl -sL https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/trivy/trivy-scan.sh | bash -s -- container my-app"
```
