# Instructions de Build - Météo Rigolote

## Prérequis

1. **Flutter SDK** installé (version 3.0.0 ou supérieure)
2. **Android SDK** configuré pour le build APK
3. **Clé API OpenWeatherMap** (gratuite)

## Configuration

### 1. Clé API OpenWeatherMap

1. Créez un compte sur [OpenWeatherMap](https://openweathermap.org/api)
2. Obtenez votre clé API gratuite
3. Modifiez le fichier `lib/constants/app_constants.dart`:

```dart
static const String openWeatherApiKey = 'VOTRE_CLE_API_ICI';
```

### 2. Installation des dépendances

```bash
flutter pub get
```

## Build et Test

### Tests

```bash
flutter test
```

### Build Debug APK

```bash
flutter build apk --debug
```

### Build Release APK

```bash
flutter build apk --release
```

L'APK sera généré dans `build/app/outputs/flutter-apk/`

## Fonctionnalités Implémentées

✅ **Recherche de villes françaises** avec API OpenWeatherMap  
✅ **Météo actuelle** avec température et conditions  
✅ **Prévisions 7 jours** avec navigation temporelle  
✅ **Gestion des favoris** (max 5, réorganisation par drag-and-drop)  
✅ **Cache intelligent** de 30 minutes par ville  
✅ **Interface française** complète  
✅ **Support hors-ligne** avec données en cache  
✅ **Navigation intuitive** avec retour automatique à "aujourd'hui"  
✅ **Gestion d'erreurs** complète avec messages utilisateur  
✅ **Thème Material Design** moderne  
✅ **Tests unitaires** et widget tests

## Architecture

L'application suit les standards Flutter avec:

- **Architecture en couches** (services, models, widgets, screens)
- **Gestion d'état locale** avec setState
- **Services centralisés** pour API, stockage et navigation
- **Widgets réutilisables** et extraits selon les bonnes pratiques
- **Gestion d'erreurs** robuste avec exceptions typées
- **Cache intelligent** avec expiration automatique

## Personnalisation

### Illustrations Météo

Pour remplacer les icônes Material par des dessins d'enfants:

1. Placez les images dans `assets/images/weather/`
2. Modifiez `lib/widgets/weather_illustration.dart`
3. Mappez les conditions météo aux nouvelles illustrations

### Thème

Personnalisez les couleurs dans `lib/theme/app_theme.dart`

## Limitations (v1)

- Pas de géolocalisation automatique
- Pas de notifications push
- Pas de partage de données météo
- Interface française uniquement
- Villes françaises uniquement

## Support

L'application est prête pour la production avec toutes les fonctionnalités demandées dans les spécifications fonctionnelles et techniques.

---

**CRAPOLO STUDIOS - 2025**
