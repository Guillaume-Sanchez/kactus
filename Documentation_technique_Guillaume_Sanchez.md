# Documentation technique Guillaume Sanchez
| Version | Date | Commentaire |
|:--:|:--:|:--|
| 1.0 | 17/12/2025 | Première version de la documentation |
| 1.1 | 22/01/2026 | Remplacement des scripts par des repos git |
| 1.2 | 02/02/2026 | Ajout de la configuration Wordpress |
| 1.3 | 04/02/2026 | Mise en place des utilisateurs et des Teams la configuration Portainer |
| 1.4 | 09/02/2026 | Ajout de la configuration Grafana |
| 1.5 | 25/03/2026 | Ajout de la configuration phpIPAM |
| 1.6 | 31/03/2026 | Ajout de la sauvegardes des BDD et du Firewall |
```
1 - Primo-Installation - page 2
	1.1 - Prérequis - page 2
		1.1.1 - Mise à jour et installation des outils divers - page 2
		1.1.2 - Création d'un utilisateur et restriction de l'utilisation
		du compte	root à la connexion ssh - page 2
		1.1.3 - Installation de Docker - page 3
	  	1.1.3.1 - Installez le Référentiel apt de Docker - page 3
	  	1.1.3.2 - Installez les paquets Docker - page 3
			1.1.3.3 - Gestion du service Docker - page 4
		1.1.4 - Installation de Portainer - page 4
			1.1.4.1 - Prérequis - page 4
			1.1.4.2 - Installez Portainer avec Docker - page 4
			1.1.4.3 - Accéder au portail Portainer - page 5
			1.1.4.4 - Créer des comptes utilisateurs et des Teams - page 5
		1.1.5 - Initialisation de l'environnement kactus - page 6
	1.2 - Mise en place des Stacks - page 6
		1.2.1 - Stack kactus-bdd - page 7
		1.2.2 - Stack kactus-inta - page 7
		1.2.3 - Stack kactus-web - page 8
		1.2.4 - Stack monitoring - page 8
		1.2.5 - Stack php_ip_am - page 9
	1.3 -  Configuration du Site Web Kactus - page 9
		1.3.1 - Prérequis - page 9
		1.3.2 - Mise en place de Wordpress - page 10
		1.3.3 - Mise en place d'un utilisateur Administrateur - page 13
	1.4 -  Configuration de la suppervision - page 14
	  1.4.1 - Première connexion à Grafana - page 14
		1.4.2 - Ajouter un utilisateur administrateur - page 14
		1.4.3 - Ajouter le Dashboard avec les metriques de 
		l'hyperviseur - page 15
		1.4.4 - Ajouter le Dashboard Cadvisor exporter - page 17
		1.4.5 - Ajouter le Dashboard Trivy - page 19
	1.5 -  Configuration de phpIPAM - page 22
		1.5.1 - Installation de la base de données phpIPAM - page 22
		1.5.2 - Mise en place du compte administrateur - page 24
		1.5.3 - Mise en place de du Lab Kactus - page 25
	1.6 -  Sauvegarde des bases de données - page 29
	1.7 - Mise en place du firewall - page 29
		1.7.1 - Installation de firewalld - page 30
		1.7.2 - Mise en place de la configuration - page 30
```

Mise en place d'un environnement docker des services de l'entreprise Kactus
> Cette Documentation est valable sur une machine sous la distribution Debian 13
> Ressource : CPU 4 - Mémoire 8Go - Disque 30Go  

## 1 - Primo-Installation
### 1.1 - Prérequis
#### 1.1.1 - Mise à jour et installation des outils divers
Mise à jour du système :
```bash
apt update && apt upgrade -y
```
Installation de sudo, git, zip, vim, curl
```
apt install -y git sudo zip vim curl
```
#### 1.1.2 - Création d'un utilisateur et restriction de l'utilisation du compte root à la connexion ssh
Création du compte administrateur :
```bash
adduser admkactus
usermod -aG sudo admkactus
```
Modification du fichier `sshd_config` pour empêcher l'utilisation du compte root pour une connexion en ssh :
```bash
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart ssh
```
>Utiliser le compte `admkactus` pour tout le reste de cette documentation 
```bash
su - admkactus
```
#### 1.1.3 - Installation de Docker
##### 1.1.3.1 - Installez le Référentiel `apt` de Docker.
```bash
# Add Docker's official GPG key:
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o 
/etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
sudo apt update
```
##### 1.1.3.2 - Installez les paquets Docker
```bash
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin 
docker-compose-plugin
```
##### 1.1.3.3 - Gestion du service Docker
Pour vérifier le status des services docker :
```bash
sudo systemctl status docker
```
Pour démarrer les services docker :
```bash
sudo systemctl start docker
```
Pour stopper les services docker :
```bash
sudo systemctl stop docker
```
Pour redémarrer les services docker :
```bash
sudo systemctl restart docker
```
Pour désactiver le lancement des services docker au démarrage de la :
```bash
sudo systemctl disable docker
```
Pour activer le lancement des services docker au démarrage de la :
```bash
sudo systemctl enable docker
```
#### 1.1.4 - Installation de Portainer
##### 1.1.4.1 - Prérequis
Avoir Docker
##### 1.1.4.2 - Installez Portainer avec Docker
Pour installer Portainer, exécutez les commandes suivantes :
```bash
sudo docker volume create portainer_data
sudo docker run -d -p 9000:9000 \
--name=portainer \
--restart=always \
-v /var/run/docker.sock:/var/run/docker.sock \
-v portainer_data:/data portainer/portainer-ce
```
Voici ce que cette commande fait :
- Crée un volume Docker portainer_data pour stocker les données de Portainer de manière persistante.
- Démarre un nouveau conteneur Docker nommé portainer qui exécute Portainer, configuré pour redémarrer automatiquement.
- Expose le port 9000, sur lequel l’interface utilisateur web de Portainer sera accessible.
- Montre le socket Docker dans le conteneur, permettant à Portainer de gérer les conteneurs sur l’hôte Docker.
##### 1.1.4.3 - Accéder au portail Portainer
Une fois Portainer lancé, vous pouvez accéder à l’interface utilisateur :
[http://votre_adresse_ip_serveur:9000](http://localhost:9000)
Sur la page d’accueil de Portainer, vous serez invité à créer un utilisateur administrateur. Remplissez les détails demandés et connectez-vous.
##### 1.1.4.4 - Créer des comptes utilisateurs et des Teams
Chaques stacks sera gérées depuis des comptes et des rôle particuliés.

- Dans l'onglet `User-related > Teams` ajouter cette liste :
	-  `Administrateur`
	- `Supervision`
	- `Support`
	- `Team-Web`
	- `Dba`
- Dans l'onglet `User-related > Users` ajouter cette liste d'utilisateurs :
	-  `web_kactus` ajouter le à la team `Team-Web`
	- `supervision_kactus` ajouter le à la team `Supervision`
	- `support_kactus` ajouter le à la team `Support`
	- `administrateur_kactus` ajouter le à la team `Administrateur`
	- `dba_kactus` ajouter le à la team `Dba`
- Se rendre dans l'onglet `Environement-related > Environments`
- Cliquer sur ***local***, changer son nom en `kactus-env` et cliquer sur `Update environment` 
-  Se rendre dans l'onglet `Environement-related > Groups`
- Cliquer sur `Add Group` dans ***name*** mettre `kactus-env` dans ***Available environments*** cliquer sur `kactus-env` et cliquer sur `Create the group`
#### 1.1.5 - Initialisation de l'environnement kactus
>sur l'hyperviseur, en tant que admkactus :
Lancer la commande de là primo-installation du script à distance disponible sur le repo Git du projet.
```bash
cd ~
bash -c "$(curl https://raw.githubusercontent.com/Guillaume-Sanchez/
kactus/refs/heads/main/script/primo_install.sh)"
```
Voici ce que ce script fait :
- Il clone le repo git du projet dans `/home/admkactus/`.
- Si le clonage, c'est bien déroulé, il place les fichiers de configurations de prometheus, promail, phpIPAM et wordpress dans `/opt/kactus/`.
- Il met en place une crontab pour générer des rapports trivy et la sauvegarde des base de données.
- Il créer les réseaux du lab kactus.
- Il change le réseau de portainer sur kactus-monitoring
>En cas d'impossibilité de lancer la commande à distance, récupérer le script [ici](https://github.com/Guillaume-Sanchez/kactus/blob/main/script/primo_install.sh), le placer sur l'hyperviseur et le lancer. 

En cas de problème, une documentation primaire est présente sur le repos Git : [Repos Kactus](https://github.com/Guillaume-Sanchez/kactus)
### 1.2 - Mise en place des Stacks
L'infra est séparé en plusieurs Stacks qu'il faut mettre en place et relier au repot git afin de pouvoir gérer le CI/CD de l'infra. Se connecter sur portainer avec un compte administrateur.
Pour créer les stacks, il faut se rendre dans l'onglet `Stacks` 
Puis cliquer sur `+ Add stack`
#### 1.2.1 - Stack `kactus-bdd`
Dans l'onglet `build method`, cliquer sur `Repository`.
Rentrer les informations suivantes pour lier le repo Git à cette stack :
- ***Name*** : `kactus-bdd`
- ***Repository URL*** : `https://github.com/Guillaume-Sanchez/kactus.git`
- ***Repository reference*** : `refs/heads/main`
- ***Compose path*** : `kactus-bdd/docker-compose.yml`
- Activer `GitOps updates` et laisser sur `polling`
- Ajouter 1 variables d’environnement en cliquant sur `+ Add an environment variable` :
	-  MYSQL_ROOT_PASSWORD : `Mot_de_passe_root_de_la_BDD`
- ***Access control*** : Authorized teams -> `Dba`

Pour finir, cliquer sur `Deploy the stcak`
> Si un problème survient, vérifier les informations entrées et que les fichiers de configuration soit bien placé dans `/opt/kactus/` sur l'hypervisor suite au passage du script de primo-install (se référer au point 1.1.5 de cette documentation).
#### 1.2.2 - Stack `kactus-intra`
Dans l'onglet `build method`, cliquer sur `Repository`.
Rentrer les informations suivantes pour lier le repo Git à cette stack :
- ***Name*** : `kactus-intra`
- ***Repository URL*** : `https://github.com/Guillaume-Sanchez/kactus.git`
- ***Repository reference*** : `refs/heads/main`
- ***Compose path*** : `kactus-intra/docker-compose.yml`
- Activer `GitOps updates` et laisser sur `polling`
- ***Access control*** : Authorized teams -> `Team-Web`

Pour finir, cliquer sur `Deploy the stcak`
> Si un problème survient, vérifier les informations entrées et que les fichiers de configuration soit bien placé dans `/opt/kactus/` sur l'hypervisor suite au passage du script de primo-install (se référer au point 1.1.5 de cette documentation).

#### 1.2.3 - Stack `kactus-web`
Dans l'onglet `build method`, cliquer sur `Repository`.
Rentrer les informations suivantes pour lier le repo Git à cette stack :
- ***Name*** : `kactus-web`
- ***Repository URL*** : `https://github.com/Guillaume-Sanchez/kactus.git`
- ***Repository reference*** : `refs/heads/main`
- ***Compose path*** : `kactus-web/docker-compose.yml`
- Activer `GitOps updates` et laisser sur `polling`
- Ajouter 6 variables d’environnement en cliquant sur `+ Add an environment variable` :
	-  MYSQL_ROOT_PASSWORD : `Mot_de_passe_root_de_la_BDD`
	- MYSQL_DATABASE : `wordpress`
	- MYSQL_USER : `kactus`
	- MYSQL_PASSWORD : `Mot_de_passe_de_la_BDD`
	- WORDPRESS_DB_USER : `kactus`
	- WORDPRESS_DB_PASSWORD : `Mot_de_passe_de_la_BDD`
- ***Access control*** : Authorized teams -> `Team-Web`

Pour finir, cliquer sur `Deploy the stcak`
> Si un problème survient, vérifier les informations entrées et que les fichiers de configuration soit bien placé dans `/opt/kactus/` sur l'hypervisor suite au passage du script de primo-install (se référer au point 1.1.5 de cette documentation).
Pour finir, cliquer sur `Deploy the stcak`
#### 1.2.4 - Stack `monitoring`
Dans l'onglet `build method`, cliquer sur `Repository`.
Rentrer les informations suivantes pour lier le repo Git à cette stack :
- ***Name*** : `monitoring`
- ***Repository URL*** : `https://github.com/Guillaume-Sanchez/kactus.git`
- ***Repository reference*** : `refs/heads/main`
- ***Compose path*** : `monitoring/docker-compose.yml`
- Activer `GitOps updates` et laisser sur `polling`
- Ajouter 2 variables d’environnement en cliquant sur `+ Add an environment variable` :
	-  GRAFANA_ADMIN : `admin`
	- GRAFANA_PASSWORD : `Mot_de_passe_admin`
- ***Access control*** : Authorized teams -> `Supervision`

Pour finir, cliquer sur `Deploy the stcak`
> Si un problème survient, vérifier les informations entrées et que les fichiers de configuration soit bien placé dans `/opt/kactus/` sur l'hyperviseur suite au passage du script de primo-install (se référer au point 1.1.5 de cette documentation).
#### 1.2.5 - Stack `php_ip_am`
Dans l'onglet `build method`, cliquer sur `Repository`.
Rentrer les informations suivantes pour lier le repo Git à cette stack :
- ***Name*** : `php_ip_am`
- ***Repository URL*** : `https://github.com/Guillaume-Sanchez/kactus.git`
- ***Repository reference*** : `refs/heads/main`
- ***Compose path*** : `php_ip_am/docker-compose.yml`
- Activer `GitOps updates` et laisser sur `polling`
- Ajouter une variable d’environnement en cliquant sur `+ Add an environment variable` :
	-  MYSQL_ROOT_PASSWORD : `Mot_de_passe_root_de_la_BDD`
- ***Access control*** : Authorized teams -> `Support`

Pour finir, cliquer sur `Deploy the stcak`
> Si un problème survient, vérifier les informations entrées et que les fichiers de configuration soit bien placé dans `/opt/kactus/` sur l'hyperviseur suite au passage du script de primo-install (se référer au point 1.1.5 de cette documentation).
### 1.3 -  Configuration du Site Web Kactus
#### 1.3.1 - Prérequis
- Avoir mis en place la stack "kactus-web" (Point 1.2.3 de cette documentation).
- Avoir les conteneurs `kactus-web-wordpress-1` et `kactus-web-db-wp-1` de lancés.
#### 1.3.2 - Mise en place de Wordpress
- Se connecter au site web de kactus : [https://kactus.guillaume-sanchez.fr/](https://kactus.guillaume-sanchez.fr/)
- Choisir la langue (Francais dans notre cas).

![wordpress1](https://guillaume-sanchez.fr/images/kactus/wordpress/1.png)

- Entrer les Informations nécessaires :
	- ***Titre du site*** : `Kactus`
	- ***Identifiant*** : `kactus_adm`
	- ***Mot de passe*** : Mot de passe robuste généré
	- ***Votre e-mail*** : Email administrateur, dans notre cas : `guigeek116@gmail.com` 
	- Cliquer sur Installer Wordpress

![wordpress2](https://guillaume-sanchez.fr/images/kactus/wordpress/2.png)

- Dans le menu à gauche, se rendre dans la rubrique `Apparence > Thèmes` :

![wordpress3](https://guillaume-sanchez.fr/images/kactus/wordpress/3.png)

- Cliquer sur le thème Kactus et activer le :

![wordpress4](https://guillaume-sanchez.fr/images/kactus/wordpress/4.png)

- Se rendre dans la rubrique `Extentions`, sélectionner toutes les extensions et cliquer sur `Supprimer` :



![wordpress5](https://guillaume-sanchez.fr/images/kactus/wordpress/5.png)

- Dans la recherche d'extension, chercher `WPS Hidde Login`, cliquer sur `installer maintenant` et activer l'extension :

![wordpress6](https://guillaume-sanchez.fr/images/kactus/wordpress/6.png)

- Se rendre dans les options de l'extension et changer l'URL de connexion par `kactus-supervision` :

![wordpress7](https://guillaume-sanchez.fr/images/kactus/wordpress/7.png)

Grâce à cela, le lien de connexion au panel administrateur WordPress ne sera plus `wp-admin` mais `kactus-supervision`.
#### 1.3.3 - Mise en place d'un utilisateur Administrateur
Afin d'éviter d'utiliser le compte administrateur du Wordpress pour des raisons de sécurité, il faut créer un compte administrateur :
 
- Dans la rubrique `Comptes > Ajouter un compte`, Renseigner les coordonnées de la personne qui sera responsable de l'administration du site :

![wordpress8](https://guillaume-sanchez.fr/images/kactus/wordpress/8.png)

### 1.4 -  Configuration de la supervision
#### 1.4.1 - Première connexion à Grafana
Se rendre sur Grafana, se connecter avec le ***compte*** `admin` qui a pour ***mot de passe*** `admin`.
Un changement de mot de passe vous sera demander, renseigner un mot de passe administrateur.
#### 1.4.2 - Ajouter un utilisateur administrateur
Par sécurité, pour éviter d'utiliser le compte admin, on créer un autre compte administrateur.
- Avec le compte ***admin***, se rendre dans `Administration > Users and access`.
- Cliquer sur ***New user*** renseigner les champs comme ceci :
	- ***Name*** : `administrator`
	- ***Email*** : `admin@kactus.guillaume-sanchez.fr`
	- ***Username*** : `kactus_adm`
	- ***Password*** : mot de passe administrateur
- Cliquer sur ***Create user***
- Sélectionner `kactus_adm` dans la liste
- Dans ***Permissions > Grafana Admin*** cliquer sur `Change` -> `yes` -> `Change`
- Dans ***Permissions > Main Org*** cliquer sur `Change role` -> `Admin` -> `Save`

#### 1.4.3 - Ajouter le Dashboard avec les metriques de l'hyperviseur
Ce rendre sur Grafana et dans le menu droite cliquer sur `Connections > Add new connection`
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/1.png)
Chercher dans la bar de recherche `Prometheus` et cliquer dessus
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/2.png)
En haut à droite cliquer sur `Add new data source`
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/3.png)
Dans la partie ***Connection*** ajouter `http://prometheus:9090`
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/4.png)
Cliquer sur ***Save and Test***, ce message devrait apparètre :
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/5.png)
Dans le menu droite, ce rendre dans ***Dashboard***
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/6.png)
Dans le menu ***New*** cliquer sur `import`
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/8.png)
Dans la bar de recherche, taper  `19268` et cliquer sur ***Load***
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/22.png)
Cliquer sur `Import`
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/23.png)
Maintenant dans l'onglet DashBoard, il y a `Prometheus All Metrics` qui renseigne toutes les données nécessaire à la surveillance de l’hyperviseur.
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/24.png)
#### 1.4.4 - Ajouter le Dashboard Cadvisor exporter
Afin de pouvoir surveiller la consommation de notre environnement, un container `Cadvisor` tourne sur un réseau et réalise des vérifications de consommation du CPU de la Ram et du Réseau consommé par les différents containers

Dans le menu droite, ce rendre dans ***Dashboard***
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/6.png)
Dans le menu ***New*** cliquer sur `import`
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/8.png)
Dans la bar de recherche, taper  `14282` et cliquer sur ***Load***
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/9.png)
Dans ***DS_PROMETHEUS*** selectionner `prometheus` et cliquer sur `Import`
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/10.png)
Maintenant dans l'onglet DashBoard, il y a `Cadvisor exporter` qui renseigne toutes les données nécessaire à la surveillance de l’environnement Kactus
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/11.png)
#### 1.4.5 - Ajouter le Dashboard Trivy
Afin de pouvoir surveiller la consommation de notre environnement, un container `Cadvisor` tourne sur un réseau et réalise des vérifications de consommation du CPU de la Ram et du Réseau consommé par les différents containers

Pour le mettre en place, ce rendre sur Grafana et dans le menu droite cliquer sur `Connections > Add new connection`
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/1.png)
Chercher dans la bar de recherche `Prometheus` et cliquer dessus
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/13.png)
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/14.png)
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/15.png)

![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/16.png)
Dans le menu droite, ce rendre dans ***Dashboard***
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/6.png)
Dans le menu ***New*** cliquer sur `New dashboard`
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/8.png)
Cliquer sur `+ Add visualization`
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/12.png)
Dans ***Data Source***, selectionner `Loki`
Dans ***Label Filter***, selectionner `service_name` `=` `security_scan`
Dans le menu de Droite, dans ***Visualization*** selectionner `Logs` 
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/18.png)
Cliquer sur ***Run query*** pour voir si le rappot trivy receptionné par Loki apparait :
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/19.png)
Sauvegarder le DashBoard :
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/20.png)
Rajouter des filtre afin de mettre en avant des notions utiles comme "High" ou "Critical" :
![wordpress8](https://guillaume-sanchez.fr/images/kactus/grafana/21.png)

### 1.5 -  Configuration de phpIPAM
#### 1.5.1 - Installation de la base de données phpIPAM
Cliquer sur `New phpipam installation`
![wordpress8](https://guillaume-sanchez.fr/images/kactus/phpipam/1.png)
Cliquer sur `Automatic database installation`
![wordpress8](https://guillaume-sanchez.fr/images/kactus/phpipam/2.png)
Renseigner l'utilisateur root de la base de données et cliquer sur `Install phpipam database`
![wordpress8](https://guillaume-sanchez.fr/images/kactus/phpipam/3.png)
La base de données est en cours de création si ce logo de chargement apparait :
![wordpress8](https://guillaume-sanchez.fr/images/kactus/phpipam/4.png)
Une fois la base de données créé, cliquer sur `Continue`
![wordpress8](https://guillaume-sanchez.fr/images/kactus/phpipam/5.png)
#### 1.5.2 - Mise en place du compte administrateur
Renseigner le mot de passe du compte ***admin***, ***le nom du site*** et ***l'URL du site*** 
![wordpress8](https://guillaume-sanchez.fr/images/kactus/phpipam/6.png)
Une fois fait, cliquer sur `Proceed to login` 
![wordpress8](https://guillaume-sanchez.fr/images/kactus/phpipam/7.png)
Ce message apparait sur la page de connexion :
![wordpress8](https://guillaume-sanchez.fr/images/kactus/phpipam/8.png)
Pour désactiver le message, passer cette commande sur l'hyperviseur kactus :
```bash
docker exec -u root php_ip_am-web-1 sed -i 's/^\$disable_installer.*/
$disable_installer = true;/'/phpipam/config.php
```
#### 1.5.3 - Mise en place de du Lab Kactus
Ce rendre dans ![wordpress8](https://guillaume-sanchez.fr/images/kactus/phpipam/9.png)  et cliquer sur  ![wordpress8](https://guillaume-sanchez.fr/images/kactus/phpipam/10.png)
- Dans ***Name*** taper : `Lab Kactus`
- Dans *** Description*** taper : `infrastructure Docker pour projet Kactus`
- Cliquer sur `+ Add`

![wordpress8](https://guillaume-sanchez.fr/images/kactus/phpipam/11.png)

Se rendre dans ***Subnets*** -> ***Lab kactus***

Il y a 3 subnets à créer :

##### Réseau Principal  :
- Cliquer sur `Add subnet`
- Dans ***Subnet*** : `172.18.0.0/16`
- Dans ***Description*** : `Réseau Principal Kactus`
- Cliquer sur `+ Add`

##### Réseau Privé  :
- Cliquer sur `Add subnet`
- Dans ***Subnet*** : `172.19.0.0/16`
- Dans ***Description*** : `Réseau Privé Kactus`
- Cliquer sur `+ Add`

##### Réseau Monitoring :
- Cliquer sur `Add subnet`
- Dans ***Subnet*** : `172.20.0.0/16`
- Dans ***Description*** : `Réseau Monitoring Kactus`
- Cliquer sur `+ Add`

![wordpress8](https://guillaume-sanchez.fr/images/kactus/phpipam/12.png)

>Voici le résultat attendu une fois les 3 subnet mis en place : 
>![wordpress8](https://guillaume-sanchez.fr/images/kactus/phpipam/13.png)

Ensuite, il faut ajouter chaque IP utilisé dans les différents subnet. 
Pour se faire, cliquer sur le subnet et cliquer sur `Add new IP address` comme sur la photo ci dessous.

Ajouter toutes les IP utiliser  :

| Réseau | **IP adrdress**  | **Hostname** | **Description** |
|:--:|:--:|:---:|:---|
| **Réseau Principal** |
|| 172.18.0.2 | kactus-intra | Serveur intranet - Port NAT 8081 |
|| 172.18.0.3 | php_ip_am_cron-1 | Serveur phpIPAM cron |
|| 172.18.0.4 | php_ip_am_web-1 | Serveur phpIPAM web |
|| 172.18.0.5 | kactus-web | Serveur WordPress - Port NAT 80|
| **Réseau Privé** |
|| 172.19.0.2 | kactus-bdd | Serveur de base de données |
|| 172.19.0.3 | php_ip_am-web-1 | Serveur phpIPAM web privé |
|| 172.19.0.4 | kactus-web | Serveur phpIPAM cron privé |
|| 172.19.0.5 | php_ip_am-cron-1 | Serveur WordPress privé |
| **Réseau Monitoring** |
|| 172.20.0.2 | monitoring-loki-1 | Serveur loki - Port NAT 3001 |
|| 172.20.0.3 | monitoring-promtail-1 | Serveur promtail |
|| 172.20.0.4 | monitoring-grafana-1 | Serveur grafana - Port NAT 3000 |
|| 172.20.0.5 | monitoring-prometheus-1 | Serveur prometheus - Port NAT 9090|
|| 172.20.0.6 | monitoring-cadvisor-1 | Serveur cadvisor |
|| 172.20.0.7 | portainer | Serveur portainer  - Port NAT 9000|

Voici le résultat attendu (avec le Subnet Réseau Principal) :

![wordpress8](https://guillaume-sanchez.fr/images/kactus/phpipam/16.png)
### 1.6 -  Sauvegarde des bases de données
Pour prévoir de possible problème technique, réaliser une sauvegarde manuelle après avoir terminé **tous** les points précédent.
>Toujours avec l'utilisateur `admkactus`

Lancer la commande suivante 
```bash
kactus/script/sauvegarde_bdd.sh 
```
Résultat attendu :
```
Début de la sauvegarde pour Kactus...
Sauvegarde terminée dans /opt/kactus/kactus-bdd/backups/
backup_all_2026-03-31_22h04.sql.gz
```
### 1.7 - Mise en place du firewall
Pour sécurisé le réseau, mettre en place un firewall
#### 1.7.1 - Installation de firewalld
>Toujours avec l'utilisateur `admkactus`

Pour éviter l'utilisation de `iptable`, installer `firewalld` :
```bash
sudo apt install -y firewalld
```
Activer au démarrage et démarrer le service :
```bash
sudo systemctl enable firewalld
sudo systemctl start firewalld
```
#### 1.7.2 - Mise en place de la configuration
Ajouter les ports `80`, `8000`, `8080`, `8081`, `3000`, `3100`, `9000`, `9090` :
```bash
sudo firewall-cmd --zone=public --permanent --add-port 80/tcp \
--add-port 8081/tcp \
--add-port 3000/tcp \
--add-port 3100/tcp \
--add-port 9090/tcp \
--add-port 8080/tcp \
--add-port 8000/tcp \
--add-port 9000/tcp
```
Recharger la configuration pour qu'elle soit prise en compte :
```bash
sudo firewall-cmd --reload 
success
```
Docker utilise nativement iptable, donc il faut le redémarrer pour qu'il prenne ses changements en compte :
```bash
sudo systemctl restart docker.service
```
Vérifier que la configuration est bien en place :
```bash
sudo firewall-cmd --list-all
```
Résultat attendu :
```
public (default, active)
  target: default
  ingress-priority: 0
  egress-priority: 0
  icmp-block-inversion: no
  interfaces: 
  sources: 
  services: dhcpv6-client ssh
  ports: 80/tcp 8081/tcp 3000/tcp 3100/tcp 9090/tcp 8080/tcp 8000/tcp 9000/tcp
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
```

