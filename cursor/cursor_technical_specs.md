# Spécifications Techniques Minimales - Météo Rigolote v1

## Technologies imposées
- **Framework** : Flutter / Dart
- **Plateforme cible** : Android (APK local)
- **Design System** : Material Design (au choix de la version)

## API et données externes

### OpenWeatherMap API
- **Version** : Gratuite (1000 appels/jour maximum)
- **Endpoints requis** :
  - Géocodage pour recherche de villes françaises
  - Données météo actuelles
  - Prévisions pour 7 jours
- **Paramètres obligatoires** :
  - Unités métriques (Celsius)
  - Langue française pour descriptions
  - Limitation géographique : France uniquement

### Stratégie de cache
- **Durée** : 30 minutes par ville
- **Portée** : Cache par ville ET par date consultée  
- **Nettoyage** : Automatique lors de nouvelles requêtes
- **Gestion des données futures** : Les données "demain" deviennent obsolètes au changement de date système

## Stockage local requis
- **Favoris** : Liste de 5 villes maximum, ordonnée (premier = principal)
- **Dernière consultation** : Ville et date pour réouverture automatique
- **Cache météo** : Données temporaires avec horodatage d'expiration

## Contraintes de performance
- **Timeout API** : Maximum 10 secondes par requête
- **Gestion hors-ligne** : Affichage cache si disponible, sinon message d'erreur
- **Optimisation** : Éviter les appels API redondants grâce au cache

## Illustrations personnalisées
- **Source** : Dessins d'enfants (fournis séparément)
- **Format** : À déterminer selon capacités techniques
- **Intégration** : Correspondance avec types de temps API (soleil, nuages, pluie, etc.)

## Sécurité
- **Clé API** : Protection recommandée (méthode au choix du développeur)
- **Réseau** : HTTPS obligatoire pour toutes les requêtes

## Limites acceptées pour cette version
- Pas de géolocalisation automatique
- Pas de mode hors-ligne complet  
- Pas de notifications push
- Pas de partage de données météo
- Interface française uniquement