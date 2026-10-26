-- ====================
-- 1.2 Données de test
-- ====================

INSERT INTO plat (nom, prix, id_categorie, description) VALUES
('mofo gasy',  500, (SELECT id FROM categorie WHERE libelle = 'Goûter'), 'Pain malgache à base de farine de riz, cuit dans un moule, souvent mangé au petit-déjeuner.'),
('mokary',     1000, (SELECT id FROM categorie WHERE libelle = 'Goûter'), 'Galette de riz sucrée à la noix de coco, dorée et légèrement croustillante.'),
('koba',       1500, (SELECT id FROM categorie WHERE libelle = 'Goûter'), 'Gâteau de cacahuètes pilées, de farine de riz et de sucre, enveloppé dans une feuille de bananier.'),
('godrogodro', 500, (SELECT id FROM categorie WHERE libelle = 'Goûter'), 'Petit beignet frit croustillant, vendu en snack.'),
('menakely',   1000, (SELECT id FROM categorie WHERE libelle = 'Goûter'), 'Beignet de farine de blé en forme d''anneau, frit et moelleux.');

UPDATE plat SET description = 'Poulet mijoté dans du lait de coco, plat parfumé et onctueux du quotidien malgache.' WHERE nom = 'Akoho sy voanio';
UPDATE plat SET description = 'Porc mijoté avec des haricots, un plat copieux servi avec du riz.' WHERE nom = 'Henakisoa sy tsaramaso';
UPDATE plat SET description = 'Feuilles de manioc pilées cuites longuement avec du porc, à l''ail et parfois au lait de coco.' WHERE nom = 'Ravitoto sy henakisoa';
UPDATE plat SET description = 'Plat national : bouillon de viande de zébu avec des brèdes, du gingembre, de la tomate et de l''oignon.' WHERE nom = 'Romazava';
UPDATE plat SET description = 'Riz cuit en bouillon avec des brèdes (feuilles vertes), souvent accompagné de viande ou de poisson.' WHERE nom = 'Vary amin''anana';

UPDATE plat SET disponible = FALSE WHERE nom = 'Henakisoa sy tsaramaso';
UPDATE plat SET disponible = FALSE WHERE nom = 'Ravitoto sy henakisoa';

INSERT INTO plat_du_jour (date_jour, id_plat) VALUES 
(CURRENT_DATE, (SELECT id FROM plat WHERE nom = 'Henakisoa sy tsaramaso')),
(CURRENT_DATE -1, (SELECT id FROM plat WHERE nom = 'Ravitoto sy henakisoa')),
(CURRENT_DATE -2, (SELECT id FROM plat WHERE nom = 'Akoho sy voanio')),
(CURRENT_DATE -3, (SELECT id FROM plat WHERE nom = 'Romazava')),
(CURRENT_DATE -4, (SELECT id FROM plat WHERE nom = 'Ravitoto sy henakisoa')),
(CURRENT_DATE -5, (SELECT id FROM plat WHERE nom = $$Vary amin'anana$$)),
(CURRENT_DATE -6, (SELECT id FROM plat WHERE nom = 'Henakisoa sy tsaramaso'));