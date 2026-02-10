-- Création de la base et user WordPress
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'kactus'@'%' IDENTIFIED BY 'ZySS#gFcYR5AcOUr';
GRANT ALL PRIVILEGES ON wordpress.* TO 'kactus'@'%';

-- Création d'un'user PhpIPAM
CREATE USER IF NOT EXISTS 'phpipam'@'%' IDENTIFIED BY 'mk!vT6PVYtmXPYAe';

FLUSH PRIVILEGES;