1. Schema relationnelle des 4 tables
- categorie (**id**, libelle)
- plat (**id**, nom, prix, #id_categorie)
- commande (**id**, date_comnmande, numero_table)
- commande_ligne(**id**, #id_commande, #id_plat, quantite, prix_unitaire)

2. Difference entre `prix_unitaire` et `prix`
- On utilise `prix_unitaire` dans la table `commande_ligne`  pour calculer les montants totals des commandes deja enregister au cas où le prix des plats changent
- On utilise le `prix` dans la table `plat` pour afficher le prix a jour de chaque plat, et utiliser aussi pour avoir le `prix_unitaire` dans la table `commande_ligne`

3. Les lignes de commande sont supprimer quand on supprime la commande, l'instruction qui en est resposable est `ON DELETE CASCADE` dans la ligne `id_commande` de la table `commande_ligne`

4. Trois données absurdes
```sql
INSERT INTO plat (nom, prix, id_categorie) VALUES
('Autre plat', -10000, 1);
INSERT INTO plat (nom, prix, id_categorie) VALUES
('Autre plat', -15000, 1);
```
- Acceptation de données negatif
- Accepte 2 plat de meme nom
- Accepte un plat avec un categorie eroné (`Mi sao` dans la categorie `Soupe`)