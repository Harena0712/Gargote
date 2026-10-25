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
-- C'est la n=colonne date_jour qui est choisi comme clé primaire pour ne pouvoir qu'ajouter un seul plat par jour et sans aucune ligne de PHP


-- 1.1.2 proposition d’ajouter une colonne est_plat_du_jour BOOLEAN dans plat
-- ===========================================================================

-- On peut mettre plusieur ligne de la colonne est_plat_du_jour TRUE et donc on ne pourait pas garantir un seul plat du jour par jour
-- On ne pourrait pas savoir les plat du jour avant


-- ==============
-- Verification
-- ==============

-- La seconde exécution a échoué, et c'est normal car elles existent deja