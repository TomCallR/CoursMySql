use cefim;

create table test(
    a varchar(20) unique,
    b integer not null default 0,
    c timestamp default CURRENT_TIMESTAMP
);

truncate table test;

insert into test (a, b, c) 
    values ('premier', 1, '2020-08-27 09:53:00');
select * from test;
select * from test where c is null;

insert into test (a,b)
    values ('deuxieme', 2);
insert into test (a,b,c)
    values ('troisieme', 3, '2020-08-28');    
insert into test (a,b,c)
    values ('quatrieme', 4, '2020-08-29 23:23:00');

/* // Ajouter une marque fictive 'CefimMotors'
   // Ajouter 4 modèles fictifs à cette marque
   // Créer un nouveau client Ayant plus de 28 ans dans la table client
   // Faire en sorte que ce client ai acheté 5 véhicules au cours des 4 dernières années
   // Contrainte : les dates d'achat doivent être rentrées en utilisant la fonction DATE_SUB et le mot clé INTERVAL */

insert into marque (id, label) values(NULL, 'CefimMotors');

insert into modele (id, id_marque, label,prix_catalogue)
    values(NULL, 271, 'Cef_velocipede', 10000),
    (NULL, 271, 'Cef_pedalo', 5878),
    (NULL, 271, 'Cef_trotinette', 2444),
    (NULL, 271, 'Cef_triporteur', 35000);

insert into client(ddn) values('1973-01-22 08:00:00');

set @client = (select id from client order by id desc limit 1);
-- select * from client where id=@client;

insert into vente(id, id_client, id_modele, prix_vente, date_vente)
    values(NULL, @client, 2596, 5800, DATE_SUB('2019-08-27', INTERVAL '3 6' YEAR_MONTH)),
    (NULL, @client, 2598, 34990, DATE_SUB('2019-08-27', INTERVAL '2 10' YEAR_MONTH)),
    (NULL, @client, 2597, 2444, DATE_SUB('2019-08-27', INTERVAL 24 MONTH)),
    (NULL, @client, 2595, 7900, DATE_SUB('2019-08-27', INTERVAL 400 DAY)),
    (NULL, @client, 2597, 2350, DATE_SUB('2019-08-27', INTERVAL 72 DAY));

/* # // Créer une table "vendeur"
# // la table doit comporter
#  * une clé primaire AUTO INCREMENT unsigned dont la valeur max prévisible est d'environ 1200,
#  *  Un champ nom et un champ prénom de type VARCHAR d'une taille adequate non null avec comme valeur par défaut ''.
# // Créer 3 vendeurs fictifs
# // Créer un champ dans la table vente permettant de "lier" chaque vente réalisée à un vendeur, ce champ sera NON NULL (ATTENTION il faudra modifier dans un deuxieme temps).
# // => Ce champ doit vérifier les contraintes d'intégrités suivantes : On doit interdire toute modification/ suppression d'un commercial si au moins une vente lui ai attachée
# // chaque vente doit être attachée à un commercial, afin de réaliser cette manip, utiliser la fonction UPDATE
# // INDICE : Utiliser la fonction RAND(), ainsi que les mots clés ORDER BY et WHERE afin de de rendre aléatoire l'association des IDs de commerciaux à chaque vente */
CREATE TABLE vendeur(
    id SMALLINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(60) NOT NULL DEFAULT '',
    prenom VARCHAR(50) NOT NULL DEFAULT ''
);

INSERT INTO vendeur(id, nom, prenom)
    VALUES(
        NULL, 'Soubirou', 'Bernadette'
    ), (
        NULL, 'Savonarole', 'Jérôme'
    ), (
        NULL, 'Gooddeal', 'Benny'
    );

ALTER TABLE vente ADD id_vendeur SMALLINT UNSIGNED;

-- Version pas très propre
/* UPDATE vente SET id_vendeur = (
    SELECT id FROM vendeur 
    WHERE id > MOD(RAND()*999999, 3)
    ORDER BY id
    LIMIT 1
) */

-- Bien mieux
UPDATE vente SET id_vendeur = (
    SELECT id FROM vendeur
    ORDER BY RAND() LIMIT 1
);

SET @MAX_ID_VENDEUR_IN_VENTE = (SELECT MAX(id_vendeur) FROM vente);
SET @MIN_ID_VENDEUR_IN_VENTE = (SELECT MIN(id_vendeur) FROM vente);
SELECT @MAX_ID_VENDEUR_IN_VENTE, @MIN_ID_VENDEUR_IN_VENTE;

ALTER TABLE vente MODIFY id_vendeur SMALLINT UNSIGNED NOT NULL;
DESC vente;

ALTER TABLE vente ADD CONSTRAINT fk_vendeur_id
FOREIGN KEY(id_vendeur) REFERENCES vendeur(id);

-- Test respect de clé étrangère
INSERT INTO vente(id_client,id_modele,id_vendeur,prix_vente,date_vente)
SELECT 50, 25, 10000, 0, '2018-08-08';

DESC vendeur;

-- Calculer âge du client aujourd'hui
SELECT TIMESTAMPDIFF(YEAR, ddn, CURDATE()) AS age FROM client LIMIT 100;

-- vues
CREATE VIEW v_client AS
SELECT
    c.id,
    c.ddn,
    TIMESTAMPDIFF(YEAR, c.ddn, CURDATE()) AS age
FROM
    client c;
SELECT * FROM v_client;
SHOW CREATE VIEW v_client;

-- CASE
SELECT
    CASE WHEN age > 60 THEN 'vieux'
         WHEN age <= 60 THEN 'pas vieux'
    END
    AS vieux_pas_vieux,
    age
FROM v_client LIMIT 10;

-- ajout sexe à la table client
ALTER TABLE client ADD sexe CHAR(1) NOT NULL;
UPDATE client SET sexe = CASE WHEN RAND() < 0.5 THEN 'M' ELSE 'F' END;

-- nouvelle vue
CREATE VIEW v_client2 AS
SELECT
    c.id,
    c.ddn,
    c.sexe,
    TIMESTAMPDIFF(YEAR, c.ddn, CURDATE()) AS age
FROM
    client c;

-- moyenne d'âge par sexe
SELECT sexe, AVG(age) AS age_moyen FROM v_client2 GROUP BY sexe;

-- colonne virtuelle
ALTER TABLE vendeur
    ADD nom_complet VARCHAR(111)
    GENERATED ALWAYS AS (CONCAT(prenom, ' ', nom)) STORED;
SELECT * FROM vendeur;

-- voir l'effet avec un update
UPDATE vendeur SET nom = 'Treschouette' WHERE ID = 1;

/* //  Calculer le prix moyen de vente de chaque modele
// - réaliser une requête qui affiche deux informations, une première colonne qui affiche la marque et le modele,
// et une deuxieme qui affiche le prix moyen  de vente pour ce modèle.
// On veut que le prix moyen soit arrondi */
SELECT  id_modele,
        CONCAT(marque.label, ' ', modele.label) AS modele,
        ROUND(AVG(prix_vente), 2) AS prix_moyen 
    FROM vente INNER JOIN modele    
    ON vente.id_modele = modele.id
    LEFT JOIN marque
    ON modele.id_marque = marque.id
    GROUP BY id_modele;

-- select count(*) from vente where id_modele=4;

/* On améliore un peu la requête précédente et on veut récupérer le prix catalogue, le prix min de vente et le prix max de vente */
SELECT  id_modele,
        CONCAT(marque.label, ' ', modele.label) AS modele,
        prix_catalogue,
        ROUND(AVG(prix_vente), 2) AS prix_moyen,
        MIN(prix_vente) AS prix_min,
        MAX(prix_vente) AS prix_max
    FROM vente INNER JOIN modele    
    ON vente.id_modele = modele.id
    LEFT JOIN marque
    ON modele.id_marque = marque.id
    GROUP BY id_modele;

/* On améliore encore un peu,
cette fois ci on veut en plus l'age moyen des acheteurs,
la répartition des achats par modèle pour la population féminine et masculine */
SELECT  id_modele,
        CONCAT(marque.label, ' ', modele.label) AS modele,
        prix_catalogue,
        ROUND(AVG(prix_vente), 2) AS prix_moyen,
        MIN(prix_vente) AS prix_min,
        MAX(prix_vente) AS prix_max,
        FLOOR(AVG(TIMESTAMPDIFF(YEAR, ddn, CURRENT_TIMESTAMP))) AS age,
        SUM(
            CASE WHEN sexe = 'M' THEN 1
            ELSE 0
            END
        ) AS ach_hommes,
        SUM(
            CASE WHEN sexe = 'F' THEN 1
            ELSE 0
            END
        ) AS ach_femmes
    FROM vente
    INNER JOIN modele    
    ON vente.id_modele = modele.id
    INNER JOIN marque
    ON modele.id_marque = marque.id
    INNER JOIN client
    ON vente.id_client = client.id
    GROUP BY id_modele;

/* OVER en utilisation le mot clé OVER, faire un select qui retourne
- marque/modele dans la premiere colonne
- prix_catalogue
- prix moyen par modele
- prix moyen par marque
- prix max par modele
- prix min par modele
- prix min par marque
- prix max par marque */
SELECT DISTINCT
    CONCAT(marque.label, ' ', modele.label) AS marque_modele,
    prix_catalogue,
    AVG(prix_vente) OVER(PARTITION BY id_modele) AS pm_modele,
    AVG(prix_vente) OVER(PARTITION BY id_marque) AS pm_marque,
    MAX(prix_vente) OVER(PARTITION BY id_modele) AS pv_max_modele,
    MIN(prix_vente) OVER(PARTITION BY id_modele) AS pv_min_modele,
    MAX(prix_vente) OVER(PARTITION BY id_marque) AS pv_max_marque,
    MIN(prix_vente) OVER(PARTITION BY id_marque) AS pv_min_marque  
FROM
    modele
    INNER JOIN marque ON modele.id_marque = marque.id
    INNER JOIN vente ON vente.id_modele = modele.id;

/* Ajout : pour chaque vente : calculer l’écart en %tage entre le prix moyen de vente de ce modele et le prix de vente */
SELECT 
    x.marque_modele,
    x.prix_catalogue,
    x.pm_modele,
    x.pm_marque,
    x.pv_max_modele,
    x.pv_min_modele,
    x.pv_max_marque,
    x.pv_min_marque,
    (prix_vente / x.pm_modele - 1) * 100 AS ecart_pct
FROM
    vente
    INNER JOIN
    (SELECT DISTINCT
        modele.id,
        CONCAT(marque.label, ' ', modele.label) AS marque_modele,
        prix_catalogue,
        AVG(prix_vente) OVER(PARTITION BY id_modele) AS pm_modele,
        AVG(prix_vente) OVER(PARTITION BY id_marque) AS pm_marque,
        MAX(prix_vente) OVER(PARTITION BY id_modele) AS pv_max_modele,
        MIN(prix_vente) OVER(PARTITION BY id_modele) AS pv_min_modele,
        MAX(prix_vente) OVER(PARTITION BY id_marque) AS pv_max_marque,
        MIN(prix_vente) OVER(PARTITION BY id_marque) AS pv_min_marque
    FROM
        modele
        INNER JOIN marque ON modele.id_marque = marque.id
        INNER JOIN vente ON vente.id_modele = modele.id) AS x
    ON vente.id_modele = x.id;

-- Triggers
-- EXemple recopié de https://dev.mysql.com/doc/refman/8.0/en/trigger-syntax.html
CREATE TABLE account (acct_num INT, amount DECIMAL(10,2));
CREATE TRIGGER ins_sum BEFORE INSERT ON account
    FOR EACH ROW SET @sum = @sum + NEW.amount;
SET @sum = 0;
SELECT @sum AS 'Total amount inserted';
INSERT INTO account VALUES(137,14.98),(141,1937.50),(97,-100.00);
SELECT @sum AS 'Total amount inserted';

/* Intégrer la notion de point de vente
Créer une nouvelle table afin de stocker les points de vente (appelez la p_vente)
la table doit contenir les champs : id, label).
la table contient environ 100 lignes
ensuite créer quelques lignes dedans
=> sachant qu'un commercial peut être muté vers un autre point de vente au cours de sa carrière, créez des liens entre les tables en ayant bien réfléchi aux différents cas de figure possibles et aux informations dont nous pourrions avoir besoin dans nos statistiques
=> on veut conserver l'historique des des mouvements des commerciaux au travers des
différents points de vente (historisation des données) */
CREATE TABLE p_vente(
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    label VARCHAR(60) NOT NULL
    ) ENGINE = InnoDB;

INSERT INTO p_vente(label)
    VALUES ('Tours'),
        ('Angers'),
        ('Orléans'),
        ('Poitiers'),
        ('Vendôme');

ALTER TABLE vendeur ADD id_p_vente TINYINT UNSIGNED NOT NULL;

ALTER TABLE vendeur ADD fk_p_vente_id
    FOREIGN KEY(id_p_vente) REFERENCES p_vente(id);

UPDATE vendeur
    SET id_p_vente = (
        SELECT id FROM p_vente
        ORDER BY RAND()
        LIMIT 1
    );

CREATE TABLE histo_vendeur(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_mouv DATE NOT NULL DEFAULT (CURRENT_DATE),
    id_vendeur SMALLINT UNSIGNED NOT NULL,
    nom VARCHAR(60) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    id_p_vente TINYINT UNSIGNED NOT NULL
) ENGINE = InnoDB;

ALTER TABLE histo_vendeur
    ADD CONSTRAINT fk_histo_vendeur_id
    FOREIGN KEY(id_vendeur) REFERENCES vendeur(id);

ALTER TABLE histo_vendeur
    ADD CONSTRAINT fk_histo_p_vente_id
    FOREIGN KEY(id_p_vente) REFERENCES p_vente(id);

CREATE TRIGGER update_vendeur BEFORE UPDATE
    ON vendeur FOR EACH ROW
    BEGIN
        INSERT INTO histo_vendeur(
            id, date_mouv, id_vendeur,
            id_p_vente, nom, prenom)
        VALUES (NULL,
        CURRENT_DATE,
        OLD.id,
        OLD.id_p_vente,
        OLD.nom,
        OLD.prenom);
    END;

-- test
UPDATE vendeur
    SET id_p_vente = 1 where id = 1;

-- visu des triggers
-- select * from information_schema.triggers;

-- Test chargement d'un fichier
CREATE TABLE personne(
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    date_naissance DATE NOT NULL
);

SET GLOBAL local_infile = 'ON';

LOAD DATA LOCAL INFILE 'D:/Git/CoursMySql/personne.csv'
INTO TABLE personne
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n' -- ou '\r\n' selon l'ordinateur et le programme utilisés pour créer le fichier
IGNORE 1 LINES;

SELECT * FROM personne;

-- Test téléchargement d'une table
-- Ne marche pas dans un autre répertoire, ou il faut modifier le fichier de config
-- pour fixer la valeur de SECURE_FILE_PRIV
-- https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_secure_file_priv
SHOW VARIABLES LIKE 'secure_file_priv';
SELECT *
FROM personne
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/personne2.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

/* CALCULER le chiffre d'affaire par point de vente, par mois, et par année classé par année et mois descendant */
ALTER TABLE vente
    ADD id_p_vente TINYINT UNSIGNED NOT NULL;

UPDATE vente SET id_p_vente = (
    SELECT p_vente.id
    FROM p_vente
    INNER JOIN vendeur ON p_vente.id = vendeur.id_p_vente
    WHERE vendeur.id = vente.id_vendeur
    limit 1
)

ALTER TABLE vente ADD CONSTRAINT fk_vente_id_p_vente
    FOREIGN KEY(id_p_vente) REFERENCES p_vente(id);

SELECT
    YEAR(date_vente) as annee,
    MONTH(date_vente) as mois,
    CONCAT(id_p_vente, ' ', label) as point_vente,
    FORMAT(SUM(prix_vente), 0, 'fr-FR') as chiffre_aff
FROM
    vente
    INNER JOIN p_vente ON p_vente.id = vente.id_p_vente
GROUP BY
    point_vente, annee, mois
ORDER BY
    annee, mois, id_p_vente;

/* Même chose avec en plus le CA annuel */
CREATE VIEW ca_mensuel_pvente AS
SELECT
    ssreq.*,
    SUM(chiffre_aff) 
        OVER (PARTITION BY annee, id_p_vente) 
        AS ca_annuel_pv
FROM
    (
        SELECT
            YEAR(date_vente) AS annee,
            MONTH(date_vente) AS mois,
            id_p_vente AS id_p_vente,
            SUM(prix_vente) AS chiffre_aff
        FROM
            vente
            INNER JOIN p_vente ON p_vente.id = vente.id_p_vente
        GROUP BY
            id_p_vente, annee, mois
        ORDER BY
            annee, mois, id_p_vente
    ) AS ssreq;

/* Même chose mais avec une colonne par agence */
SELECT * FROM ca_mensuel_pvente;

SELECT
    cles.annee,
    cles.mois,
    IFNULL(pv_tours.chiffre_aff, 0) AS ca_tours,
    IFNULL(pv_angers.chiffre_aff, 0) AS ca_angers, 
    IFNULL(pv_orleans.chiffre_aff, 0) AS ca_orleans,   
    IFNULL(pv_poitiers.chiffre_aff, 0) AS ca_poitiers,
    IFNULL(pv_vendome.chiffre_aff, 0) AS ca_vendome,
    SUM(IFNULL(cles.ca_annuel_pv, 0)) OVER(PARTITION BY cles.annee) AS ca_annuel_pv
FROM ca_mensuel_pvente AS cles
LEFT JOIN ca_mensuel_pvente AS pv_tours ON cles.annee = pv_tours.annee
                                        AND cles.mois = pv_tours.mois
                                        AND pv_tours.id_p_vente = 1
LEFT JOIN ca_mensuel_pvente AS pv_angers ON cles.annee = pv_angers.annee
                                        AND cles.mois = pv_angers.mois
                                        AND pv_angers.id_p_vente = 2
LEFT JOIN ca_mensuel_pvente AS pv_orleans ON cles.annee = pv_orleans.annee
                                        AND cles.mois = pv_orleans.mois
                                        AND pv_orleans.id_p_vente = 3
LEFT JOIN ca_mensuel_pvente AS pv_poitiers ON cles.annee = pv_poitiers.annee
                                        AND cles.mois = pv_poitiers.mois
                                        AND pv_poitiers.id_p_vente = 4
LEFT JOIN ca_mensuel_pvente AS pv_vendome ON cles.annee = pv_vendome.annee
                                        AND cles.mois = pv_vendome.mois
                                        AND pv_vendome.id_p_vente = 5;

