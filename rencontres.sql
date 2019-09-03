/* # creer un base de données rencontre
# créer une table user avec champs : 
# Nom
# Prenom
# pseudo
# date de naissante
# sexe
# interesse par ? (F/M/Les deux)
# ville 
# couleur des yeux
# coueur des cheveux
# taille
# poids 

# créer une table "Interet" 
# et permettre de joindre un ou plusieurs interets à la personne */

CREATE TABLE ville(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    code_postal CHAR(5) NOT NULL,
    nom VARCHAR(100) NOT NULL
);

CREATE TABLE yeux(
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    couleur VARCHAR(80) NOT NULL
);

CREATE TABLE cheveux(
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    couleur VARCHAR(80) NOT NULL
);

CREATE TABLE user(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    pseudo VARCHAR(30) NOT NULL,
    date_naiss DATE NOT NULL,
    sexe CHAR(1) NOT NULL
        CONSTRAINT sexe CHECK (sexe = 'M' OR sexe = 'F'),
    cherche CHAR(1) NOT NULL,
        CONSTRAINT cherche CHECK (cherche = 'M' OR cherche = 'F' OR cherche = 'X'),
    id_ville SMALLINT UNSIGNED NOT NULL,        
    id_yeux TINYINT UNSIGNED,
    id_cheveux TINYINT UNSIGNED,
    taille TINYINT UNSIGNED,
    poids TINYINT UNSIGNED,
    UNIQUE INDEX ind_pseudo (pseudo),
    CONSTRAINT fk_user_id_ville
        FOREIGN KEY (id_ville) REFERENCES ville(id),
    CONSTRAINT fk_user_id_yeux
        FOREIGN KEY (id_yeux) REFERENCES yeux(id),
    CONSTRAINT fk_user_id_cheveux
        FOREIGN KEY (id_cheveux) REFERENCES cheveux(id)
);

CREATE TABLE interet(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);

CREATE TABLE user_interet(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_user INT UNSIGNED NOT NULL,
    id_interet SMALLINT UNSIGNED NOT NULL,
    CONSTRAINT fk_user_interet_id_user
        FOREIGN KEY (id_user) REFERENCES user(id),
    CONSTRAINT fk_user_interet_id_interet
        FOREIGN KEY (id_interet) REFERENCES interet(id)
);

INSERT INTO yeux(couleur) VALUES
    ('N/A'), ('bleu'), ('gris'), ('marron'), ('noir'), ('vairon'), ('vert');

INSERT INTO cheveux(couleur) VALUES
    ('N/A'), ('auburn'), ('blanc'), ('blond'), ('brun'), ('chatain'), ('noir'), ('roux');

INSERT INTO interet(libelle) VALUES
    ('N/A'),
    ('animaux'),
    ('auto'),
    ('cinéma'),
    ('cuisine'),
    ('histoire'),
    ('informatique'), 
    ('jardinage'),
    ('moto'),
    ('musique'),
    ('politique'),
    ('séries tv'),
    ('sport'),
    ('voyages');

/* INSERT INTO ville(code_postal, nom) VALUES
    ('49000', 'Angers'),
    ('41000', 'Blois'),
    ('45000', 'Orléans'),
    ('86000', 'Poitiers'),
    ('37000', 'Tours'),
    ('41100', 'Vendôme');

INSERT INTO user(
    nom,
    prenom,
    pseudo,
    date_naiss,
    sexe,
    cherche,
    id_ville,
    id_yeux,
    id_cheveux,
    taille,
    poids
    ) VALUES
    ('Abra', 'Antonin', 'aaa', '1978-05-01', 'M', 'F', 5, 4, 5, 175, 75),
    ('Bricou', 'Barbara', 'bbb', '1975-11-12', 'F', 'M', 4, 7, 3, 170, 62),
    ('Croche', 'Charles', 'ccc', '1970-01-29', 'M', 'F', 1, 4, 6, 178, 80),
    ('Daubert', 'David', 'ddd', '1985-06-15', 'M', 'F', 2, 2, 4, 180, 80),
    ('Erlich', 'Eric', 'eee', '1983-12-02', 'M', 'F', 3, 2, 8, 174, 72),
    ('Faure', 'Faustine', 'fff', '1990-02-09', 'F', 'M', 2, 5, 2, 176, 66),
    ('Grognon', 'Geraldine', 'ggg', '1989-07-30', 'F', 'M', 6, 1, 1, 180, 70),
    ('Harman', 'Henri', 'hhh', '1976-03-03', 'M', 'X', 4, 3, 3, 177, 79);

INSERT INTO user_interet(id_user, id_interet) VALUES
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)),
    ((SELECT id FROM user ORDER BY RAND() LIMIT 1), (SELECT id FROM interet WHERE libelle <> 'N/A' ORDER BY RAND() LIMIT 1)); */

CREATE VIEW v_user AS SELECT
    user.id,
    user.nom AS nom,
    user.prenom,
    user.pseudo,
    user.date_naiss,
    user.sexe,
    user.cherche,
    ville.nom AS ville,        
    yeux.couleur AS yeux,
    cheveux.couleur AS cheveux,
    user.taille,
    user.poids,
    X.libelle AS interet
FROM user
INNER JOIN ville ON ville.id = user.id_ville
INNER JOIN yeux ON yeux.id = user.id_yeux
INNER JOIN cheveux ON cheveux.id = user.id_cheveux
LEFT JOIN (SELECT id_user, interet.libelle FROM user_interet
            INNER JOIN interet ON user_interet.id_interet = interet.id) AS X
            ON X.id_user = user.id;

SELECT * FROM v_user;

-- Gender,GivenName,City,ZipCode,EmailAddress,Username,Birthday,Kilograms,Centimeters,Latitude,Longitude
DROP TABLE TEMP_USER;
CREATE TABLE TEMP_USER(
    sexe VARCHAR(10),
    prenom VARCHAR(70),
    ville VARCHAR(70),
    code_postal CHAR(5),
    email VARCHAR(50),
    pseudo VARCHAR(50),
    date_naiss VARCHAR(10),
    poids CHAR(5),
    taille CHAR(5),
    lat VARCHAR(10),
    longi VARCHAR(10)
);

SET GLOBAL local_infile = 'ON';

LOAD DATA LOCAL INFILE 'D:/Git/CoursMySql/rencontre_data.csv'
INTO TABLE TEMP_USER
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

ALTER TABLE TEMP_USER ADD id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT  PRIMARY KEY FIRST;

UPDATE TEMP_USER SET ville = REPLACE(ville, '"', '');

INSERT INTO ville(code_postal, nom) SELECT
    code_postal, ville
    FROM TEMP_USER
    GROUP BY ville
    ORDER BY ville;

INSERT INTO user(
    nom,
    prenom,
    pseudo,
    date_naiss,
    sexe,
    cherche,
    id_ville,
    id_yeux,
    id_cheveux,
    taille,
    poids
)
SELECT
    x.prenom,
    x.prenom,
    x.pseudo,
    STR_TO_DATE(x.date_naiss,'%m/%e/%Y'),
    UPPER(SUBSTR(x.sexe, 1, 1)),
    CASE x.sexe
    WHEN 'male' THEN
        CASE WHEN RAND() < 0.8 THEN 'F'
        WHEN RAND() < 0.5 THEN 'M'
        ELSE 'X' END
    ELSE
        CASE WHEN RAND() < 0.8 THEN 'M'
        WHEN RAND() < 0.5 THEN 'F'
        ELSE 'X' END
    END,
    -- CASE WHEN rand() < 0.46 THEN 'M' WHEN rand() > 0.54 THEN 'F' ELSE 'X' END,
    (SELECT ville.id FROM ville WHERE ville.nom = x.ville LIMIT 1),
    (SELECT yeux.id FROM yeux ORDER BY RAND() LIMIT 1),
    (SELECT cheveux.id FROM cheveux ORDER BY RAND() LIMIT 1),
    CAST(x.taille AS DECIMAL(6,0)),
    ROUND(CAST(x.poids AS DECIMAL(6,1)), 0)
FROM TEMP_USER AS x;

SELECT * FROM user;

-- corriger les doublons de pseudo
/* drop table doublons_pseudo;
create table doublons_pseudo as select pseudo, count(*) as nb
from temp_user group by pseudo;
select * from doublons_pseudo where nb>1;

UPDATE TEMP_USER SET nb = (Select nb
from doublons_pseudo where doublons_pseudo.pseudo = temp_user.pseudo
limit 1);

Update Temp_user set pseudo = CONCAT(pseudo, SUBSTR(pseudo, FLOOR(RAND()*4+1), 1))
WHERE nb > 1;

select pseudo, count(*) as nb2
from temp_user group by pseudo having nb2 > 1; */
