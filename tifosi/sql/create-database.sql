-- Création de la base de données "tifosi"

CREATE DATABASE IF NOT EXISTS tifosi
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

-- Création de l'utilisateur "tifosi" et lui donner les droits d'administration sur la base de données "tifosi"

CREATE USER IF NOT EXISTS 'tifosi'@'localhost' IDENTIFIED BY 'tifosi_password';

GRANT ALL PRIVILEGES ON tifosi.* TO 'tifosi'@'localhost';
FLUSH PRIVILEGES;

-- Utilisation de la base de données "tifosi"

USE tifosi;

-- Création des tables

DROP TABLE IF EXISTS ingredient, focaccia, client, menu, marque, boisson, comprend, contient, achete;

CREATE TABLE ingredient (
        id_ingredient INT AUTO_INCREMENT PRIMARY KEY,
        nom_ingredient VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE focaccia (
        id_focaccia INT AUTO_INCREMENT PRIMARY KEY,
        nom_focaccia VARCHAR(50) NOT NULL UNIQUE,
        prix DECIMAL(5,2) NOT NULL,

        CONSTRAINT prix_focaccia_positive
                CHECK (prix > 0)
);

CREATE TABLE client (
        id_client INT AUTO_INCREMENT PRIMARY KEY,
        nom_client VARCHAR(50) NOT NULL,
        email VARCHAR(150) NOT NULL UNIQUE,
        code_postal INT NOT NULL
);

CREATE TABLE menu (
        id_menu INT AUTO_INCREMENT PRIMARY KEY,
        nom_menu VARCHAR(50) NOT NULL UNIQUE,
        prix DECIMAL(5,2) NOT NULL,
        id_focaccia INT NOT NULL,

        CONSTRAINT prix_menu_positive
                CHECK (prix > 0),

        CONSTRAINT fk_menu_focaccia
                FOREIGN KEY (id_focaccia)
                REFERENCES focaccia(id_focaccia)
                ON DELETE RESTRICT
                ON UPDATE CASCADE
);

CREATE TABLE marque (
        id_marque INT AUTO_INCREMENT PRIMARY KEY,
        nom_marque VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE boisson (
        id_boisson INT AUTO_INCREMENT PRIMARY KEY,
        nom_boisson VARCHAR(50) NOT NULL UNIQUE,
        id_marque INT NOT NULL,

        CONSTRAINT fk_boisson_marque
                FOREIGN KEY (id_marque)
                REFERENCES marque(id_marque)
                ON DELETE RESTRICT
                ON UPDATE CASCADE
);

-- Création des tables de liaison

CREATE TABLE comprend (
        id_focaccia INT NOT NULL,
        id_ingredient INT NOT NULL,
        quantite INT NOT NULL DEFAULT 1,

        PRIMARY KEY (id_focaccia, id_ingredient),

        CONSTRAINT fk_comprend_focaccia
                FOREIGN KEY (id_focaccia)
                REFERENCES focaccia(id_focaccia)
                ON DELETE CASCADE
                ON UPDATE CASCADE,

        CONSTRAINT fk_comprend_ingredient
                FOREIGN KEY (id_ingredient)
                REFERENCES ingredient(id_ingredient)
                ON DELETE RESTRICT
                ON UPDATE CASCADE,

        CONSTRAINT quantite_positive
                CHECK (quantite > 0)
);

CREATE TABLE contient (
        id_menu INT NOT NULL,
        id_boisson INT NOT NULL,

        PRIMARY KEY (id_menu, id_boisson),

        CONSTRAINT fk_contient_menu
                FOREIGN KEY (id_menu)
                REFERENCES menu(id_menu)
                ON DELETE CASCADE
                ON UPDATE CASCADE,

        CONSTRAINT fk_contient_boisson
                FOREIGN KEY (id_boisson)
                REFERENCES boisson(id_boisson)
                ON DELETE RESTRICT
                ON UPDATE CASCADE
);

CREATE TABLE achete (
        id_client INT NOT NULL,
        id_menu INT NOT NULL,
        date_achat DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

        PRIMARY KEY (id_client, id_menu, date_achat),

        CONSTRAINT fk_achete_client
                FOREIGN KEY (id_client)
                REFERENCES client(id_client)
                ON DELETE CASCADE
                ON UPDATE CASCADE,

        CONSTRAINT fk_achete_menu
                FOREIGN KEY (id_menu)
                REFERENCES menu(id_menu)
                ON DELETE RESTRICT
                ON UPDATE CASCADE
);