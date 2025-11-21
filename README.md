# kactus
Repos des differents scripts d'installation de la platforme Kactus

## Commande d'installation

### Hello World

```
bash -c "$(curl https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/hello-world/install.sh)"
```

### Kactus Web

```
bash -c "$(curl https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/kactus-web/install.sh)"
```

### Grafana & Loki

```
bash -c "$(curl https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/grafana/install.sh)"
```

### Trivy

Usage :

```  
curl -sL <URL>/trivy-scan.sh | bash -- <command>
```
  
"Commands:
```
image <image_name>         - Scan une image Docker"
container <container_id>   - Scan un conteneur en cours d'exécution"
help                       - Affiche cette aide"
```
Exemples :

```
curl -sL https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/trivy/trivy-scan.sh | bash -s -- image nginx:latest"
```
```
curl -sL https://raw.githubusercontent.com/Guillaume-Sanchez/kactus/refs/heads/main/trivy/trivy-scan.sh | bash -s -- container my-app"
```