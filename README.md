# Météo Rigolote

Application météo Flutter avec illustrations personnalisées réalisées par des enfants. APK Android local pour usage familial avec données météo des villes françaises.

## Fonctionnalités

- **Recherche de villes françaises** avec autocomplétion
- **Météo actuelle** avec température, description et illustration personnalisée
- **Prévisions 7 jours** avec navigation par flèches temporelles
- **Gestion des favoris** (max 5) avec réorganisation par glisser-déposer
- **Cache intelligent** de 30 minutes par ville
- **Interface française** uniquement
- **Support hors-ligne** avec cache

## Configuration

### 1. Clé API OpenWeatherMap

1. Créez un compte gratuit sur [OpenWeatherMap](https://openweathermap.org/api)
2. Obtenez votre clé API gratuite (1000 appels/jour)
3. Remplacez `YOUR_API_KEY_HERE` dans `lib/constants/app_constants.dart`:

```dart
static const String openWeatherApiKey = 'VOTRE_CLE_API_ICI';
```

### 2. Installation des dépendances

```bash
flutter pub get
```

### 3. Lancement de l'application

```bash
flutter run
```

## Structure du projet

```
lib/
├── main.dart                    # Point d'entrée de l'app
├── constants/
│   └── app_constants.dart       # Configuration et constantes
├── models/
│   ├── city.dart               # Modèle de données ville
│   └── weather.dart            # Modèles météo
├── services/
│   ├── weather_service.dart    # Service API météo
│   ├── storage_service.dart    # Service stockage local
│   └── navigation_service.dart # Service navigation
├── screens/
│   ├── home_screen.dart        # Écran d'accueil avec recherche
│   ├── weather_screen.dart     # Écran météo principal
│   └── favorites_screen.dart   # Gestion des favoris
├── widgets/                    # Composants réutilisables
└── theme/
    └── app_theme.dart         # Thème Material Design
```

## Flux utilisateurs

### Nouvel utilisateur

1. Lancement → Écran d'accueil
2. Recherche de ville française
3. Sélection → Affichage météo
4. Ajout optionnel aux favoris

### Utilisateur existant

1. Lancement → Météo du favori principal
2. Navigation entre favoris ou recherche de nouvelles villes

## Spécifications techniques

- **Framework**: Flutter / Dart
- **API**: OpenWeatherMap (gratuite, 1000 appels/jour)
- **Cache**: 30 minutes par ville avec nettoyage automatique
- **Stockage**: SharedPreferences pour favoris et cache
- **Langue**: Interface française uniquement
- **Cible**: Android APK local

## Fonctionnalités avancées

- **Cache intelligent**: Évite les appels API redondants
- **Gestion hors-ligne**: Affiche le cache si disponible
- **Favoris persistants**: Sauvegarde locale avec réorganisation
- **Navigation intuitive**: Retour automatique à "aujourd'hui"
- **Illustrations météo**: Support pour dessins d'enfants personnalisés

## Développement

L'application suit les standards Flutter définis dans les fichiers `.mdc` du projet :

- Architecture en couches avec services
- Gestion d'état locale avec setState
- Widgets réutilisables et extraits
- Gestion d'erreurs complète
- Performance optimisée

## Limitations acceptées (v1)

- Pas de géolocalisation automatique
- Pas de mode hors-ligne complet
- Pas de notifications push
- Pas de partage de données météo
- Interface française uniquement

## Support

Pour les illustrations personnalisées d'enfants, placez les fichiers dans `assets/images/weather/` et modifiez le widget `WeatherIllustration` pour les utiliser à la place des icônes Material.

---

**CRAPOLO STUDIOS - 2025**
