-- =========================
-- 1.1 Script de migration
-- =========================

ALTER TABLE plat ADD COLUMN IF NOT EXISTS description VARCHAR(255);

ALTER TABLE plat ADD COLUMN IF NOT EXISTS disponible BOOLEAN NOT NULL DEFAULT TRUE;

ALTER TABLE plat DROP CONSTRAINT IF EXISTS chk_prix_positif;
ALTER TABLE plat ADD CONSTRAINT chk_prix_positif CHECK (prix > 0);

ALTER TABLE plat DROP CONSTRAINT IF EXISTS unique_plat_nom;
ALTER TABLE plat ADD CONSTRAINT unique_plat_nom UNIQUE (nom);


-- 1.1.1 Creation du table plat_du_jour
-- =====================================
DROP TABLE IF EXISTS plat_du_jour CASCADE;

CREATE TABLE plat_du_jour (
    date_jour DATE PRIMARY KEY,
    id_plat INT NOT NULL REFERENCES plat(id)
);


-- 1.2.3 Les messages d'erreur lors de l'insertion d'un plat à 0 Ar et un plat dont le nom existe déjà
-- =====================================================================================================
INSERT INTO plat (nom, prix, id_categorie, description, disponible) VALUES ('Nouveau plat', 0, (SELECT id FROM categorie WHERE libelle = 'Plat'), 'nouveau plat avec des nouvelles ingredients', TRUE);
INSERT INTO plat (nom, prix, id_categorie, description, disponible) VALUES ('Henakisoa sy tsaramaso', 10000, (SELECT id FROM categorie WHERE libelle = 'Plat'), 'nouveau plat avec des nouvelles ingredients', TRUE);