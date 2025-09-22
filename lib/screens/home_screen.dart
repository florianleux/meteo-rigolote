import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meteo_rigolote/constants/app_constants.dart';
import 'package:meteo_rigolote/models/city.dart';
import 'package:meteo_rigolote/services/weather_service.dart';
import 'package:meteo_rigolote/services/storage_service.dart';
import 'package:meteo_rigolote/services/navigation_service.dart';
import 'package:meteo_rigolote/screens/weather_screen.dart';
import 'package:meteo_rigolote/widgets/loading_indicator.dart';
import 'package:meteo_rigolote/widgets/error_display.dart';

/// Home screen with city search functionality for new users
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  final StorageService _storageService = StorageService();
  
  List<City> _searchResults = [];
  List<String> _favorites = [];
  bool _isSearching = false;
  bool _isLoadingFavorites = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadFavorites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoadingFavorites = true;
    });
    
    try {
      final favorites = await _storageService.getFavorites();
      if (mounted) {
        setState(() {
          _favorites = favorites;
          _isLoadingFavorites = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingFavorites = false;
        });
      }
    }
  }

  void _navigateToWeather(String cityName) {
    NavigationService.push(
      context,
      WeatherScreen(cityName: cityName),
    );
  }

  Future<void> _removeFavorite(String cityName) async {
    try {
      final success = await _storageService.removeFromFavorites(cityName);
      if (success && mounted) {
        setState(() {
          _favorites.remove(cityName);
        });
        _showSnackBar('$cityName retiré des favoris');
      }
    } catch (e) {
      _showSnackBar('Erreur lors de la suppression');
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

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
        _errorMessage = null;
      });
      return;
    }

    if (query.length < 2) return; // Wait for at least 2 characters

    _performSearch(query);
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isSearching = true;
      _errorMessage = null;
    });

    try {
      final results = await _weatherService.searchCities(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _searchResults.clear();
          _isSearching = false;
        });
      }
    }
  }

  void _onCitySelected(City city) async {
    // Naviguer vers l'écran météo
    await NavigationService.push(
      context,
      WeatherScreen(cityName: city.name),
    );
    
    // Recharger les favoris au retour
    _loadFavorites();
  }

  Widget _buildWelcomeSection() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Icon(
          Icons.wb_sunny,
          size: 80,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 24),
        Text(
          'Météo Rigolote',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Bienvenue ! Recherchez une ville française pour commencer.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSearchSection() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Rechercher une ville',
            hintText: 'Ex: Paris, Lyon, 75001...',
            prefixIcon: Icon(Icons.search),
          ),
          textInputAction: TextInputAction.search,
        ),
        const SizedBox(height: 16),
        
        // Section des favoris
        if (_searchController.text.isEmpty) ...[
          _buildFavoritesSection(),
          const SizedBox(height: 16),
        ],
        
        // Résultats de recherche
        if (_isSearching)
          const LoadingIndicator(
            message: 'Recherche en cours...',
          )
        else if (_errorMessage != null)
          ErrorDisplay(
            message: _errorMessage!,
            onRetry: () => _performSearch(_searchController.text.trim()),
          )
        else if (_searchResults.isNotEmpty)
          _buildSearchResults()
        else if (_searchController.text.trim().isNotEmpty)
          const Center(
            child: Text(
              'Aucune ville trouvée',
              style: TextStyle(color: Colors.grey),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Villes trouvées',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _searchResults.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final city = _searchResults[index];
              return ListTile(
                leading: const Icon(Icons.location_city),
                title: Text(city.displayName),
                subtitle: Text(city.fullDisplayName),
                onTap: () => _onCitySelected(city),
                trailing: const Icon(Icons.arrow_forward_ios),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCopyrightDisplay() {
    final currentYear = DateTime.now().year;
    return Center(
      child: Text(
        'CRAPOLO STUDIOS - $currentYear',
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 13,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildVersionDisplay() {
    return Center(
      child: Text(
        AppConstants.displayVersion,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 12,
          color: Colors.black54,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            children: [
              _buildWelcomeSection(),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildSearchSection(),
                ),
              ),
              const Spacer(),
              _buildCopyrightDisplay(),
              const SizedBox(height: 4),
              _buildVersionDisplay(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesSection() {
    if (_isLoadingFavorites) {
      return const LoadingIndicator(message: 'Chargement des favoris...');
    }
    
    if (_favorites.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              Icons.favorite_border,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              'Aucun favori',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Recherchez une ville pour l\'ajouter à vos favoris',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.favorite,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Mes favoris (${_favorites.length}/${AppConstants.maxFavorites})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._favorites.map((cityName) => _buildFavoriteTile(cityName)),
      ],
    );
  }

  Widget _buildFavoriteTile(String cityName) {
    final isMainFavorite = _favorites.first == cityName;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isMainFavorite 
              ? Theme.of(context).primaryColor 
              : Colors.grey.shade300,
          child: Icon(
            isMainFavorite ? Icons.star : Icons.location_city,
            color: isMainFavorite ? Colors.white : Colors.grey.shade600,
            size: 20,
          ),
        ),
        title: Text(
          cityName,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: isMainFavorite ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: isMainFavorite 
            ? Text(
                'Favori principal',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : null,
        trailing: IconButton(
          onPressed: () => _removeFavorite(cityName),
          icon: const Icon(Icons.remove_circle_outline),
          tooltip: 'Retirer des favoris',
        ),
        onTap: () => _navigateToWeather(cityName),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: Colors.grey.shade50,
      ),
    );
  }
}
