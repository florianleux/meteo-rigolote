import 'package:flutter/material.dart';
import 'package:meteo_rigolote/constants/app_constants.dart';
import 'package:meteo_rigolote/models/weather.dart';
import 'package:meteo_rigolote/services/weather_service.dart';
import 'package:meteo_rigolote/services/storage_service.dart';
import 'package:meteo_rigolote/services/navigation_service.dart';
import 'package:meteo_rigolote/widgets/app_header.dart';
import 'package:meteo_rigolote/widgets/loading_indicator.dart';
import 'package:meteo_rigolote/widgets/error_display.dart';
import 'package:meteo_rigolote/widgets/current_weather_card.dart';
import 'package:meteo_rigolote/widgets/forecast_card.dart';
import 'package:meteo_rigolote/screens/home_screen.dart';

/// Main weather display screen with current weather and forecast
class WeatherScreen extends StatefulWidget {
  final String cityName;

  const WeatherScreen({
    super.key,
    required this.cityName,
  });

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  final StorageService _storageService = StorageService();
  
  WeatherForecast? _forecast;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isFavorite = false;
  int _selectedForecastIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
    _checkFavoriteStatus();
  }

  Future<void> _loadWeatherData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Force cache cleanup to get fresh data and trigger debug info generation
      await _weatherService.cleanupCache();
      
      final forecast = await _weatherService.getWeatherForecast(widget.cityName);
      if (mounted) {
        setState(() {
          _forecast = forecast;
          _isLoading = false;
          _selectedForecastIndex = 0; // Always start with "today"
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _checkFavoriteStatus() async {
    final isFavorite = await _storageService.isFavorite(widget.cityName);
    if (mounted) {
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      if (_isFavorite) {
        // Remove from favorites
        final success = await _storageService.removeFromFavorites(widget.cityName);
        if (success && mounted) {
          setState(() {
            _isFavorite = false;
          });
          _showSnackBar('Retiré des favoris');
        }
      } else {
        // Add to favorites
        final success = await _storageService.addToFavorites(widget.cityName);
        if (success && mounted) {
          setState(() {
            _isFavorite = true;
          });
          _showSnackBar('Ajouté aux favoris');
        } else if (!success && mounted) {
          _showSnackBar(AppConstants.maxFavoritesErrorMessage);
        }
      }
    } catch (e) {
      _showSnackBar('Erreur lors de la gestion des favoris');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _navigateToHome() {
    NavigationService.pushAndRemoveUntil(
      context,
      const HomeScreen(),
    );
  }


  void _onForecastSelected(int index) {
    setState(() {
      _selectedForecastIndex = index;
    });
  }


  Widget _buildContent() {
    if (_isLoading) {
      return const LoadingIndicator(
        message: 'Chargement de la météo...',
      );
    }

    if (_errorMessage != null) {
      return ErrorDisplay(
        message: _errorMessage!,
        onRetry: _loadWeatherData,
      );
    }

    if (_forecast == null) {
      return const ErrorDisplay(
        message: 'Aucune donnée météo disponible',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadWeatherData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            // Current weather card
            CurrentWeatherCard(
              weather: _forecast!.current,
              todayForecast: _forecast!.daily.isNotEmpty ? _forecast!.daily.first : null,
            ),
            const SizedBox(height: 16),
            
            // Forecast section title
            Row(
              children: [
                Text(
                  'Prévisions 7 jours',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _onForecastSelected(0),
                  icon: const Icon(Icons.today),
                  tooltip: "Retour à aujourd'hui",
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Horizontal forecast list
            ForecastList(
              forecasts: _forecast!.daily,
              selectedIndex: _selectedForecastIndex,
              onForecastSelected: _onForecastSelected,
            ),
            
            // Extra space at bottom for scrolling
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: widget.cityName,
        leading: IconButton(
          onPressed: _navigateToHome,
          icon: const Icon(Icons.home),
          tooltip: 'Retour à l\'accueil',
        ),
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
            tooltip: _isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'home':
                  _navigateToHome();
                  break;
                case 'refresh':
                  _loadWeatherData();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'home',
                child: ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Accueil'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'refresh',
                child: ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text('Actualiser'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildContent(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
