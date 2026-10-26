## 1.1 Script de migration

### 1.1.1 Creation du table plat_du_jour
-  C'est la n=colonne date_jour qui est choisi comme clé primaire pour ne pouvoir qu'ajouter un seul plat par jour et sans aucune ligne de PHP

### 1.1.2 proposition d’ajouter une colonne est_plat_du_jour BOOLEAN dans plat
- On peut mettre plusieur ligne de la colonne est_plat_du_jour TRUE et donc on ne pourait pas garantir un seul plat du jour par jour
- On ne pourrait pas savoir les plat du jour avant

#### Verification
- La seconde exécution a échoué, et c'est normal car elles existent deja

## 1.2 Données de test

### 1.2.3 Les messages d'erreur lors de l'insertion d'un plat à 0 Ar et un plat dont le nom existe déjà
- Insertion d'un plat a 0 Ar
  - ERROR:  new row for relation "plat" violates check constraint "chk_prix_positif"

- Insertion d'un plat dont le nom existe deja
  - ERROR:  duplicate key value violates unique constraint "unique_plat_nom"