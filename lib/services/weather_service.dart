import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:meteo_rigolote/constants/app_constants.dart';
import 'package:meteo_rigolote/models/city.dart';
import 'package:meteo_rigolote/models/weather.dart';
import 'package:meteo_rigolote/services/storage_service.dart';

/// Custom exceptions for weather service
class WeatherException implements Exception {
  final String message;
  final String? code;

  WeatherException(this.message, {this.code});

  @override
  String toString() => message;
}

class NetworkException extends WeatherException {
  NetworkException(String message) : super(message, code: 'NETWORK_ERROR');
}

class ApiException extends WeatherException {
  ApiException(String message) : super(message, code: 'API_ERROR');
}

/// Service for weather data and city search
class WeatherService {
  static final WeatherService _instance = WeatherService._internal();
  factory WeatherService() => _instance;
  WeatherService._internal();

  final StorageService _storageService = StorageService();
  
  final http.Client _httpClient = http.Client();

  // CITY SEARCH AND GEOCODING

  /// Search for French cities by name or postal code
  Future<List<City>> searchCities(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final encodedQuery = Uri.encodeComponent(query.trim());
      final url = Uri.parse(
        '${AppConstants.openWeatherBaseUrl}${AppConstants.geocodingEndpoint}'
        '?q=$encodedQuery,${AppConstants.countryCode}'
        '&limit=5'
        '&appid=${AppConstants.openWeatherApiKey}',
      );

      final response = await _httpClient.get(url).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((cityData) => City.fromJson(cityData)).toList();
      } else if (response.statusCode == 401) {
        throw ApiException('Clé API invalide');
      } else if (response.statusCode == 429) {
        throw ApiException('Limite d\'appels API atteinte');
      } else {
        throw ApiException('Erreur de recherche de ville: ${response.statusCode}');
      }
    } on SocketException {
      throw NetworkException('Pas de connexion internet');
    } on http.ClientException {
      throw NetworkException('Erreur de connexion réseau');
    } on TimeoutException {
      throw NetworkException('Délai d\'attente dépassé');
    } catch (e) {
      if (e is WeatherException) rethrow;
      debugPrint('WeatherService: City search error - $e');
      throw WeatherException('Erreur lors de la recherche de villes');
    }
  }

  // WEATHER DATA

  /// Get current weather for a city
  Future<CurrentWeather> getCurrentWeather(String cityName) async {
    try {
      // First, try to get from cache
      final cachedForecast = await _storageService.getCachedWeatherForecast(cityName);
      if (cachedForecast != null && cachedForecast.isValid) {
        return cachedForecast.current;
      }

      // If not in cache or expired, fetch from API
      final url = Uri.parse(
        '${AppConstants.openWeatherBaseUrl}${AppConstants.weatherEndpoint}'
        '?q=$cityName,${AppConstants.countryCode}'
        '&appid=${AppConstants.openWeatherApiKey}'
        '&units=metric'
        '&lang=${AppConstants.language}',
      );

      final response = await _httpClient.get(url).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return CurrentWeather.fromJson(data);
      } else if (response.statusCode == 404) {
        throw ApiException('Ville non trouvée');
      } else if (response.statusCode == 401) {
        throw ApiException('Clé API invalide');
      } else if (response.statusCode == 429) {
        throw ApiException('Limite d\'appels API atteinte');
      } else {
        throw ApiException('Erreur météo: ${response.statusCode}');
      }
    } on SocketException {
      // Try to get from cache even if expired
      final cachedForecast = await _storageService.getCachedWeatherForecast(cityName);
      if (cachedForecast != null) {
        return cachedForecast.current;
      }
      throw NetworkException('Pas de connexion internet');
    } on http.ClientException {
      throw NetworkException('Erreur de connexion réseau');
    } on TimeoutException {
      throw NetworkException('Délai d\'attente dépassé');
    } catch (e) {
      if (e is WeatherException) rethrow;
      debugPrint('WeatherService: Current weather error - $e');
      throw WeatherException('Erreur lors de la récupération de la météo');
    }
  }

  /// Get weather forecast for a city (current + 7 days)
  Future<WeatherForecast> getWeatherForecast(String cityName) async {
    try {
      // First, try to get from cache
      final cachedForecast = await _storageService.getCachedWeatherForecast(cityName);
      if (cachedForecast != null && cachedForecast.isValid) {
        return cachedForecast;
      }

      // If not in cache or expired, fetch from API
      final currentWeather = await getCurrentWeather(cityName);
      final dailyForecasts = await _getDailyForecasts(cityName);

      final forecast = WeatherForecast(
        current: currentWeather,
        daily: dailyForecasts,
        lastUpdated: DateTime.now(),
      );

      // Cache the forecast
      await _storageService.cacheWeatherForecast(cityName, forecast);
      
      // Save as last consulted city
      await _storageService.saveLastCity(cityName);

      return forecast;
    } catch (e) {
      // If API fails, try to return cached data even if expired
      final cachedForecast = await _storageService.getCachedWeatherForecast(cityName);
      if (cachedForecast != null) {
        return cachedForecast;
      }
      rethrow;
    }
  }

  /// Get daily forecasts from 5-day forecast API
  Future<List<DailyForecast>> _getDailyForecasts(String cityName) async {
    try {
      final url = Uri.parse(
        '${AppConstants.openWeatherBaseUrl}${AppConstants.forecastEndpoint}'
        '?q=$cityName,${AppConstants.countryCode}'
        '&appid=${AppConstants.openWeatherApiKey}'
        '&units=metric'
        '&lang=${AppConstants.language}',
      );

      final response = await _httpClient.get(url).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        
        
        final List<dynamic> forecastList = data['list'];

        // Calculate min/max temperatures for today (until midnight)
        final now = DateTime.now();
        final todayKey = '${now.year}-${now.month}-${now.day}';
        final midnight = DateTime(now.year, now.month, now.day + 1); // Minuit de la journée suivante
        
        // Get temperatures from forecasts until midnight of current day
        final todayForecasts = <Map<String, dynamic>>[];
        final temperatures = <double>[];
        
        for (final item in forecastList) {
          final dt = DateTime.fromMillisecondsSinceEpoch((item['dt'] as int) * 1000);
          
          // Ne prendre que les prévisions jusqu'à minuit de la journée actuelle
          if (dt.isBefore(midnight)) {
            final main = item['main'] as Map<String, dynamic>;
            final temp = (main['temp'] as num).toDouble();
            
            todayForecasts.add(item);
            temperatures.add(temp);
          } else {
            break; // Arrêter dès qu'on dépasse minuit
          }
        }
        
        // Calculate today's real min/max from actual temperatures
        final todayMinTemp = temperatures.reduce((a, b) => a < b ? a : b);
        final todayMaxTemp = temperatures.reduce((a, b) => a > b ? a : b);
        
        
        
        // Group forecasts by day and calculate min/max for each full day (midnight to midnight)
        final Map<String, List<DailyForecast>> dailyForecastsGroups = {};
        final Map<String, DailyForecast> dailyForecasts = {};
        
        // Group all forecasts by day
        for (final item in forecastList) {
          final forecast = DailyForecast.fromJson(item);
          final dateKey = '${forecast.date.year}-${forecast.date.month}-${forecast.date.day}';
          
          if (!dailyForecastsGroups.containsKey(dateKey)) {
            dailyForecastsGroups[dateKey] = [];
          }
          dailyForecastsGroups[dateKey]!.add(forecast);
        }
        
        // Process each day
        for (final entry in dailyForecastsGroups.entries) {
          final dateKey = entry.key;
          final dayForecasts = entry.value;
          
          // Find the midday forecast (or closest to midday) for base data
          final middayForecast = dayForecasts.reduce((a, b) {
            final aMidDiff = (a.date.hour - 12).abs();
            final bMidDiff = (b.date.hour - 12).abs();
            return aMidDiff < bMidDiff ? a : b;
          });
          
          double minTemp, maxTemp;
          
          if (dateKey == todayKey) {
            // For today, use temperatures calculated until midnight
            minTemp = todayMinTemp;
            maxTemp = todayMaxTemp;
          } else {
            // For other days, calculate min/max from actual temperatures (main.temp) of that day
            final dayTemperatures = <double>[];
            
            // Get all main.temp values for this day from the original forecast data
            for (final item in forecastList) {
              final dt = DateTime.fromMillisecondsSinceEpoch((item['dt'] as int) * 1000);
              final itemDateKey = '${dt.year}-${dt.month}-${dt.day}';
              
              if (itemDateKey == dateKey) {
                final main = item['main'] as Map<String, dynamic>;
                final temp = (main['temp'] as num).toDouble();
                dayTemperatures.add(temp);
              }
            }
            
            if (dayTemperatures.isNotEmpty) {
              minTemp = dayTemperatures.reduce((a, b) => a < b ? a : b);
              maxTemp = dayTemperatures.reduce((a, b) => a > b ? a : b);
            } else {
              // Fallback to API min/max if no temperatures found
              minTemp = dayForecasts.map((f) => f.tempMin).reduce((a, b) => a < b ? a : b);
              maxTemp = dayForecasts.map((f) => f.tempMax).reduce((a, b) => a > b ? a : b);
            }
          }
          
          // Create daily forecast with calculated min/max temperatures
          dailyForecasts[dateKey] = DailyForecast(
            date: middayForecast.date,
            tempMin: minTemp,
            tempMax: maxTemp,
            description: middayForecast.description,
            iconCode: middayForecast.iconCode,
            condition: middayForecast.condition,
            humidity: middayForecast.humidity,
            windSpeed: middayForecast.windSpeed,
          );
        }

        // Sort by date and limit to max forecast days
        final sortedForecasts = dailyForecasts.values.toList()
          ..sort((a, b) => a.date.compareTo(b.date));

        return sortedForecasts.take(AppConstants.maxForecastDays).toList();
      } else {
        throw ApiException('Erreur prévisions: ${response.statusCode}');
      }
    } on SocketException {
      throw NetworkException('Pas de connexion internet');
    } on http.ClientException {
      throw NetworkException('Erreur de connexion réseau');
    } on TimeoutException {
      throw NetworkException('Délai d\'attente dépassé');
    } catch (e) {
      if (e is WeatherException) rethrow;
      debugPrint('WeatherService: Forecast error - $e');
      throw WeatherException('Erreur lors de la récupération des prévisions');
    }
  }

  // UTILITY METHODS

  /// Check if API key is configured
  bool get isApiKeyConfigured {
    return AppConstants.openWeatherApiKey.isNotEmpty && 
           AppConstants.openWeatherApiKey != '8b1c963e5e6fc545f03cbd058d74fdad'
;
  }

  /// Clean up expired cache
  Future<void> cleanupCache() async {
    await _storageService.cleanupExpiredCache();
  }


  /// Dispose of resources
  void dispose() {
    _httpClient.close();
  }
}
