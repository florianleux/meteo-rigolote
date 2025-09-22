import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meteo_rigolote/constants/app_constants.dart';
import 'package:meteo_rigolote/models/weather.dart';

/// Service for local data storage and caching
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  /// Initialize the storage service
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Ensure storage is initialized
  void _ensureInitialized() {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
  }

  // FAVORITES MANAGEMENT

  /// Get list of favorite cities (max 5)
  Future<List<String>> getFavorites() async {
    _ensureInitialized();
    final favoritesJson = _prefs!.getString(AppConstants.favoritesKey);
    if (favoritesJson == null) return [];
    
    try {
      final List<dynamic> favoritesList = json.decode(favoritesJson);
      return favoritesList.cast<String>();
    } catch (e) {
      return [];
    }
  }

  /// Add city to favorites (respects max limit)
  Future<bool> addToFavorites(String cityName) async {
    final favorites = await getFavorites();
    
    // Check if already in favorites
    if (favorites.contains(cityName)) {
      return false;
    }
    
    // Check max limit
    if (favorites.length >= AppConstants.maxFavorites) {
      return false;
    }
    
    favorites.add(cityName);
    await _saveFavorites(favorites);
    return true;
  }

  /// Remove city from favorites
  Future<bool> removeFromFavorites(String cityName) async {
    final favorites = await getFavorites();
    final removed = favorites.remove(cityName);
    
    if (removed) {
      await _saveFavorites(favorites);
    }
    
    return removed;
  }

  /// Reorder favorites (for drag and drop)
  Future<void> reorderFavorites(List<String> newOrder) async {
    // Ensure we don't exceed max favorites
    if (newOrder.length > AppConstants.maxFavorites) {
      newOrder = newOrder.take(AppConstants.maxFavorites).toList();
    }
    
    await _saveFavorites(newOrder);
  }

  /// Check if city is in favorites
  Future<bool> isFavorite(String cityName) async {
    final favorites = await getFavorites();
    return favorites.contains(cityName);
  }

  /// Get main favorite (first in list)
  Future<String?> getMainFavorite() async {
    final favorites = await getFavorites();
    return favorites.isNotEmpty ? favorites.first : null;
  }

  /// Save favorites list
  Future<void> _saveFavorites(List<String> favorites) async {
    _ensureInitialized();
    final favoritesJson = json.encode(favorites);
    await _prefs!.setString(AppConstants.favoritesKey, favoritesJson);
  }

  // LAST CONSULTATION

  /// Save last consulted city
  Future<void> saveLastCity(String cityName) async {
    _ensureInitialized();
    await _prefs!.setString(AppConstants.lastCityKey, cityName);
  }

  /// Get last consulted city
  Future<String?> getLastCity() async {
    _ensureInitialized();
    return _prefs!.getString(AppConstants.lastCityKey);
  }

  // WEATHER CACHE

  /// Cache weather forecast data
  Future<void> cacheWeatherForecast(
    String cityName, 
    WeatherForecast forecast,
  ) async {
    _ensureInitialized();
    final cacheKey = '${AppConstants.cachePrefix}${cityName.toLowerCase()}';
    final cacheData = {
      'forecast': forecast.toJson(),
      'cached_at': DateTime.now().millisecondsSinceEpoch,
    };
    
    await _prefs!.setString(cacheKey, json.encode(cacheData));
  }

  /// Get cached weather forecast
  Future<WeatherForecast?> getCachedWeatherForecast(String cityName) async {
    _ensureInitialized();
    final cacheKey = '${AppConstants.cachePrefix}${cityName.toLowerCase()}';
    final cacheJson = _prefs!.getString(cacheKey);
    
    if (cacheJson == null) return null;
    
    try {
      final cacheData = json.decode(cacheJson) as Map<String, dynamic>;
      final cachedAt = DateTime.fromMillisecondsSinceEpoch(
        cacheData['cached_at'] as int,
      );
      
      // Check if cache is still valid (30 minutes)
      if (DateTime.now().difference(cachedAt) > AppConstants.cacheExpiration) {
        // Cache expired, remove it
        await _removeCachedWeather(cityName);
        return null;
      }
      
      return WeatherForecast.fromCachedJson(
        cacheData['forecast'] as Map<String, dynamic>,
      );
    } catch (e) {
      // Invalid cache data, remove it
      await _removeCachedWeather(cityName);
      return null;
    }
  }

  /// Remove cached weather data for a city
  Future<void> _removeCachedWeather(String cityName) async {
    _ensureInitialized();
    final cacheKey = '${AppConstants.cachePrefix}${cityName.toLowerCase()}';
    await _prefs!.remove(cacheKey);
  }

  /// Clean up expired cache entries
  Future<void> cleanupExpiredCache() async {
    _ensureInitialized();
    final keys = _prefs!.getKeys();
    final cacheKeys = keys.where((key) => key.startsWith(AppConstants.cachePrefix));
    
    for (final key in cacheKeys) {
      final cacheJson = _prefs!.getString(key);
      if (cacheJson != null) {
        try {
          final cacheData = json.decode(cacheJson) as Map<String, dynamic>;
          final cachedAt = DateTime.fromMillisecondsSinceEpoch(
            cacheData['cached_at'] as int,
          );
          
          // Remove expired cache
          if (DateTime.now().difference(cachedAt) > AppConstants.cacheExpiration) {
            await _prefs!.remove(key);
          }
        } catch (e) {
          // Invalid cache data, remove it
          await _prefs!.remove(key);
        }
      }
    }
  }

  /// Clear all cached weather data
  Future<void> clearAllCache() async {
    _ensureInitialized();
    final keys = _prefs!.getKeys();
    final cacheKeys = keys.where((key) => key.startsWith(AppConstants.cachePrefix));
    
    for (final key in cacheKeys) {
      await _prefs!.remove(key);
    }
  }

  /// Clear all stored data (for testing/debugging)
  Future<void> clearAllData() async {
    _ensureInitialized();
    await _prefs!.clear();
  }

  /// Get storage statistics
  Future<Map<String, dynamic>> getStorageStats() async {
    _ensureInitialized();
    final keys = _prefs!.getKeys();
    final favorites = await getFavorites();
    final cacheKeys = keys.where((key) => key.startsWith(AppConstants.cachePrefix));
    
    return {
      'total_keys': keys.length,
      'favorites_count': favorites.length,
      'cache_entries': cacheKeys.length,
      'last_city': await getLastCity(),
    };
  }
}
