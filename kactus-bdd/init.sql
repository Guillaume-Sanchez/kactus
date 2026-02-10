-- Création de la base et user WordPress
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'kactus'@'%' IDENTIFIED BY 'ZySS#gFcYR5AcOUr';
GRANT ALL PRIVILEGES ON wordpress.* TO 'kactus'@'%';

-- Création de la base et user PhpIPAM
CREATE DATABASE IF NOT EXISTS phpipam;
CREATE USER IF NOT EXISTS 'phpipam'@'%' IDENTIFIED BY 'mk!vT6PVYtmXPYAe';
GRANT ALL PRIVILEGES ON phpipam.* TO 'phpipam'@'%';

FLUSH PRIVILEGES;