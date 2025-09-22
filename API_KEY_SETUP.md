# Configuration de la Clé API OpenWeatherMap

## Étapes pour obtenir votre clé API gratuite

### 1. Créer un compte OpenWeatherMap

1. Allez sur [https://openweathermap.org/api](https://openweathermap.org/api)
2. Cliquez sur **"Sign up"** en haut à droite
3. Remplissez le formulaire d'inscription :
   - **Username** : Choisissez un nom d'utilisateur
   - **Email** : Votre adresse email
   - **Password** : Un mot de passe sécurisé
   - **Confirm Password** : Confirmez votre mot de passe
4. Acceptez les conditions d'utilisation
5. Cliquez sur **"Create Account"**

### 2. Vérifier votre email

1. Consultez votre boîte email
2. Ouvrez l'email de vérification d'OpenWeatherMap
3. Cliquez sur le lien de vérification

### 3. Se connecter et accéder aux clés API

1. Retournez sur [https://openweathermap.org](https://openweathermap.org)
2. Cliquez sur **"Sign in"** et connectez-vous
3. Une fois connecté, cliquez sur votre nom d'utilisateur en haut à droite
4. Sélectionnez **"My API keys"** dans le menu déroulant

### 4. Récupérer votre clé API

1. Sur la page "API keys", vous verrez une clé par défaut déjà créée
2. **Copiez la clé API** (elle ressemble à : `a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6`)
3. **Important** : La clé peut prendre jusqu'à 2 heures pour être activée

### 5. Configurer la clé dans l'application

1. Ouvrez le fichier `lib/constants/app_constants.dart`
2. Trouvez cette ligne :
   ```dart
   static const String openWeatherApiKey = 'YOUR_API_KEY_HERE';
   ```
3. Remplacez `YOUR_API_KEY_HERE` par votre vraie clé API :
   ```dart
   static const String openWeatherApiKey = 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6';
   ```
4. Sauvegardez le fichier

## Plan Gratuit - Limites

Le plan gratuit d'OpenWeatherMap inclut :

- ✅ **1,000 appels API par jour**
- ✅ **Données météo actuelles**
- ✅ **Prévisions 5 jours / 3 heures**
- ✅ **Géocodage** (recherche de villes)
- ✅ **Données historiques** (limitées)

Ces limites sont largement suffisantes pour l'usage familial de Météo Rigolote.

## Test de la configuration

Une fois la clé configurée :

1. Lancez l'application :

   ```bash
   flutter run
   ```

2. Testez la recherche d'une ville française (ex: "Paris")

3. Si la clé fonctionne, vous verrez les données météo s'afficher

## Dépannage

### ❌ Erreur "Clé API invalide"

- Vérifiez que vous avez bien copié la clé complète
- Attendez jusqu'à 2 heures après la création du compte
- Vérifiez qu'il n'y a pas d'espaces avant/après la clé

### ❌ Erreur "Limite d'appels API atteinte"

- Vous avez dépassé les 1000 appels quotidiens
- Attendez le lendemain ou passez à un plan payant

### ❌ Pas de résultats de recherche

- Vérifiez votre connexion internet
- Assurez-vous de chercher des villes françaises
- La clé peut ne pas encore être activée

## Sécurité

⚠️ **Important** :

- Ne partagez jamais votre clé API publiquement
- Ne la commitez pas dans un repository public
- Pour une app de production, utilisez des variables d'environnement

## Support OpenWeatherMap

Si vous avez des problèmes avec votre compte :

- Documentation : [https://openweathermap.org/api](https://openweathermap.org/api)
- Support : [https://openweathermap.org/support](https://openweathermap.org/support)
- FAQ : [https://openweathermap.org/faq](https://openweathermap.org/faq)

---

Une fois votre clé API configurée, votre application Météo Rigolote sera pleinement fonctionnelle ! 🌤️
