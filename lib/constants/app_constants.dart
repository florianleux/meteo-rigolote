/// Application constants and configuration
class AppConstants {
  // App Info
  static const String appName = 'Météo Rigolote';
  static const String version = '1.0.0';
  static const String buildNumber = '1';
  static const String fullVersion = '$version+$buildNumber';
  
  // Display version in UI
  static String get displayVersion => 'v$version ($buildNumber)';
  
  // API Configuration
  static const String openWeatherApiKey = 'ab22ac05456bc2157b255ec8a4ac9ef2';
  static const String openWeatherBaseUrl = 'https://api.openweathermap.org';
  static const String geocodingEndpoint = '/geo/1.0/direct';
  static const String weatherEndpoint = '/data/2.5/weather';
  static const String forecastEndpoint = '/data/2.5/forecast';
  
  // Cache Configuration
  static const Duration cacheExpiration = Duration(minutes: 30);
  
  // App Limits
  static const int maxFavorites = 5;
  static const int maxForecastDays = 7;
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 10);
  
  // Storage Keys
  static const String favoritesKey = 'favorites';
  static const String lastCityKey = 'last_city';
  static const String cachePrefix = 'weather_cache_';
  
  // Language and Locale
  static const String language = 'fr';
  static const String countryCode = 'FR';
  
  // Error Messages
  static const String networkErrorMessage = 'Erreur de connexion réseau';
  static const String timeoutErrorMessage = 'Délai d\'attente dépassé';
  static const String genericErrorMessage = 'Une erreur inattendue s\'est produite';
  static const String noDataErrorMessage = 'Aucune donnée disponible';
  static const String maxFavoritesErrorMessage = 'Maximum $maxFavorites favoris autorisés';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}
