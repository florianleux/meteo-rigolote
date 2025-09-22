# Spécifications Fonctionnelles - Météo Rigolote v1

## Vue d'ensemble du projet
Application météo Flutter avec illustrations personnalisées réalisées par des enfants. APK Android local pour usage familial avec données météo des villes françaises.

## Fonctionnalités principales

### Gestion des favoris
- Maximum 5 favoris autorisés
- Premier favori de la liste = favori principal (ouverture automatique au démarrage)
- Réorganisation par glisser-déposer activée
- Suppression individuelle avec confirmation obligatoire

### Recherche de villes
- Périmètre : villes françaises uniquement
- Autocomplétion avec noms de villes et codes postaux
- Intégration API OpenWeatherMap pour géocodage
- Suggestions en temps réel

### Affichage météo
- Données actuelles : température actuelle, type de temps avec illustration, description courte
- Données quotidiennes : température minimale, maximale, affichage de la date
- Plage de prévisions : 7 jours maximum
- Navigation : flèches temporelles gauche/droite
- Vue par défaut : toujours "aujourd'hui"
- Langue : français uniquement

### Comportement de l'application
- Premier lancement : écran d'accueil avec recherche obligatoire
- Lancement standard : direct sur le favori principal
- Changement de ville : retour automatique à la vue "aujourd'hui"
- Persistance des données : dernière ville consultée
- Durée du cache : 30 minutes par ville

## Flux utilisateurs

### Flux nouvel utilisateur
1. Lancement de l'app → Écran d'accueil
2. Écran d'accueil → Recherche de ville
3. Recherche de ville → Détail météo
4. Détail météo → Ajouter aux favoris ?
5. Ajout aux favoris → Vue météo

### Flux utilisateur existant
1. Lancement de l'app → Météo du favori principal
2. Météo favori principal → Actions utilisateur :
   - Bou