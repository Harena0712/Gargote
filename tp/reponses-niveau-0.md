## 0.2. Lire le schéma relationnel

### 0.2.1. Schema relationnelle des 4 tables
- categorie (**id**, libelle)
- plat (**id**, nom, prix, #id_categorie)
- commande (**id**, date_comnmande, numero_table)
- commande_ligne(**id**, #id_commande, #id_plat, quantite, prix_unitaire)

### 0.2.2. Difference entre `prix_unitaire` et `prix`
- On utilise `prix_unitaire` dans la table `commande_ligne`  pour calculer les montants totals des commandes deja enregister au cas où le prix des plats changent
- On utilise le `prix` dans la table `plat` pour afficher le prix a jour de chaque plat, et utiliser aussi pour avoir le `prix_unitaire` dans la table `commande_ligne`

### 0.2.3. Suppresion des lignes de commande
- Les lignes de commande sont supprimer quand on supprime la commande, l'instruction qui en est resposable est `ON DELETE CASCADE` dans la ligne `id_commande` de la table `commande_ligne`

### 0.2.4. Trois données absurdes
```sql
INSERT INTO plat (nom, prix, id_categorie) VALUES
('Autre plat', -10000, 1);
INSERT INTO plat (nom, prix, id_categorie) VALUES
('Autre plat', -15000, 1);
```
- Acceptation de données negatif
- Accepte 2 plat de meme nom
- Accepte un plat avec un categorie eroné (`Mi sao` dans la categorie `Soupe`)


## 0.3. Interroger l’API à la main
- Code HTTP et reponse de chaque reponse
  - curl http://localhost:8080/api/plats?categorie=2
    ```
    HTTP == 200

    {
        "id": 7,
        "nom": "Mi sao",
        "prix": 6500,
        "id_categorie": 2,
        "categorie": "Soupe"
    },
    {
        "id": 6,
        "nom": "Soupe chinoise",
        "prix": 6000,
        "id_categorie": 2,
        "categorie": "Soupe"
    }
    ```
    - curl -X POST http://localhost:8080/api/plats \
     -H "Content-Type: application/json" \
     -d '{"nom":"Mofo gasy","prix":300,"id_categorie":1}'
    ```
    HTTP == 201

    {
        "id": 16,
        "nom": "Mofo gasy",
        "prix": 300,
        "id_categorie": 1
    }
    ```

    - curl -X POST http://localhost:8080/api/plats \
     -H "Content-Type: application/json" \
     -d '{"nom":"","prix":"cher"}'
    ```
    HTTP == 422

    {
        "message": "Données invalides.",
        "errors": {
            "nom": "Le nom du plat est obligatoire.",
            "prix": "Le prix doit être un nombre entier (en Ariary).",
            "id_categorie": "Choisissez une catégorie."
        }
    }
    ```

    - curl -X DELETE http://localhost:8080/api/plats/2
    ```
    HTTP == 409

    {
        "message": "Ce plat figure déjà dans des commandes, il ne peut pas être supprimé.",
        "errors": {}
    }
    ```

    - curl http://localhost:8080/api/commandes/999
    ```
    HTTP == 404
    
    {
        "message": "Commande 999 introuvable.",
        "errors": {}
    }
    ```
### 0.3.5. Requete b
- Le code obtenu pour la requete `b)` est 201, le code est 201 car c'est une creation

### 0.3.6. Requete d
- Pour la requete `d)`, c'est PHP qui bloque la suppression grace a la ligne :
`return $this->erreur('Ce plat figure déjà dans des commandes, il ne peut pas être supprimé.', 409);`

### 0.3.7. Creation d'une commande avec curl
```
curl -i -X POST http://localhost:8080/api/commandes \
  -H "Content-Type: application/json" \
  -d '{
    "numero_table": 6,
    "lignes": [
      { "id_plat": 4,  "quantite": 2, "prix_unitaire": 7000 },
      { "id_plat": 10,  "quantite": 1, "prix_unitaire": 1000 }
    ]
  }'
```