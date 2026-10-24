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

## 0.4 Suivre une requête de bout en bout

- Complétez le tableau en indiquant, pour chaque étape, **le fichier et le nom de la fonction** :

| # | Étape | Fichier | Fonction / ligne |
|---|---|---|---|
| 1 | Le formulaire est soumis | `components/PlatForm.vue` | `enregistrer()` |
| 2 | La requête HTTP est construite | `api.js` | `requete()` |
| 3 | Vite transmet `/api/...` au port 8080 | `api.js` | `fetch(BASE + chemin, options)` |
| 4 | CodeIgniter choisit le contrôleur | `Config/Routes.php` | `$routes->post('plats', 'Plats::create');` |
| 5 | Le contrôleur lit le JSON | `Api/Plats.php` | `$donnees = $this->donneesJson();` |
| 6 | Les règles de validation sont vérifiées | `Models/PlatModel.php` | `protected $validationRules` |
| 7 | La ligne est insérée | `Api/Plats.php` | `$id = $this->plats->insert($donnees);` |
| 8 | Le formulaire prévient l’écran parent | `components/PlatForm.vue` | ` emit('enregistre', resultat)` |
| 9 | L’écran recharge la liste | `views/CarteView.vue` | `surEnregistrement(plat) / await charger()`|

### 0.4.8. Création d’une commande 
- Le code metier de la creation d'une commande est dans `Services/CommandService.php`, cette separation permet une bonne lisibilité du code

## 0.5 Repérer les notions de Vue

Vue est nouveau pour vous. Le code de base utilise sept notions ; trouvez **un exemple de chacune** (fichier + ligne) et expliquez-le en une phrase.

| Notion | À quoi ça sert | Votre exemple |
|---|---|---|
| `ref()` | une variable dont le changement met l’écran à jour | `PlatForm.vue`: `const message = ref('')` => la valeur de `message` change en fonction du resultat du requet et met a jour automatiquement l'information a l'ecran |
| `computed()` | une valeur calculée à partir d’autres, recalculée automatiquement | `PlatList.vue`: `const groupes = computed(() => parCategorie(props.plats))` =>  la valeur de `groupe` se recalcul automatiquement quand les données `props.plats` change grace a la fonctino `computed`|
| `v-for` | répéter un élément pour chaque élément d’une liste | `PlatList.vue`: `<li v-for="plat in liste" :key="plat.id">` => ici l'element `plat` se repete jusqu'a `liste.length` |
| `v-if` / `v-else` | afficher un élément seulement si une condition est vraie | `Panier.vue`: `<p v-if="lignes.length === 0" class="vide">Touchez un plat de la carte pour l’ajouter.</p> <ul v-else class="panier-liste">` => Le text `Touchez un plat de la carte pour l’ajouter.` s'affiche si la condition `lignes.length === 0` dans `v-if` est vrai, sinon on affiche la liste grace dans condition `v-else`|
| `v-model` | lier un champ de formulaire à une variable, dans les deux sens | `CommandeView.vue`: `<input v-model.number="numeroTable" type="number" min="1" />` => le variable `numeroTable` prend directement les données saisie sur le champs grace a `v-model` |
| `defineProps` | recevoir des données du composant parent | `Panier.vue`: `const props = defineProps({ lignes: { type: Array, required: true }, })` => le props `lignes` recoit les données transmis par le composant parent puis utiliser dans le composant fille grace au props `lignes` |
| `defineEmits` / `emit` | envoyer un événement au composant parent | `PlatForm.vue`: `const emit = defineEmits(['enregistre', 'annule'])` => Les emits `enregistre` et `annule` sont envoyer au composant parent puis traiter selon les besoins |
| `onMounted` | exécuter du code quand le composant apparaît | `CarteView.vue`: `onMounted(charger)` => Execute la fonction `charge` qui charge les données a afficher quand le composant apparait |

### 0.5.9 Quantité plat dans le commande : `plus` et `moins`
- `Panier.vue` émet `plus` et `moins` parcequ'il affiche juste les données envoyées par le composant parent, donc il ne peut pas les manipulé directement, d'où l'utilisation des `plus` et `moins`

- C'est `CommandeView.vue` qui modifie réellement la quantité grace au fonction `ajouter` et `retirer` 

### 0.5.9 Quantité plat dans le commande : `plus` et `moins`
- `watch` sert a preremplir les champs du formulaire quand on clique sur **Modifier** d’un plat

- Sans `watch`, les champs du formulaire ne serait pas preremplis car elle verfie si un plat a été selectionné par le bouton **Modifier** et preremplis les champs

## 0.6 Premières modifications

### 0.6.11 Explication de l'apparition du nouvelle categorie
- Dans `CarteView.vue`, la fonction `charger` appel une requet pour prendre la liste des categories grace a cette code dans `api.js`
    ```
    categories: {
        lister: () => requete('GET', '/categories'),
    },
    ```
- Une route a été configuré dans `backend/app/Config/Route.php` :
    ```
    $routes->get('categories', 'Categories::index');
    ```
- Puis la fonction `index` du controller `backend/app/Controllers/Categories.php` a été appeler par ce route, cette fonction prend la liste des categorie et la renvoie en JSON
    ```
    public function index()
    {
        $categories = model(CategorieModel::class)->orderBy('libelle')->findAll();

        return $this->respond($categories);
    }
    ```
- Apres `CarteView.vue` prend les reponse dans les lignes
    ```
    ;[plats.value, categories.value] = await Promise.all([
      api.plats.lister(),
      api.categories.lister(),
    ])
    ```
- Enfin `PlatForm.vue` prend ces categorie grace au props definie puis les liste dans le champs select
    ```
    <PlatForm
      :plat="platSelectionne"
      :categories="categories"
      @enregistre="surEnregistrement"
      @annule="platSelectionne = null"
    />
    ```

