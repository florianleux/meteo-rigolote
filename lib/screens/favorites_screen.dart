import 'package:flutter/material.dart';
import 'package:meteo_rigolote/constants/app_constants.dart';
import 'package:meteo_rigolote/services/storage_service.dart';
import 'package:meteo_rigolote/services/navigation_service.dart';
import 'package:meteo_rigolote/widgets/app_header.dart';
import 'package:meteo_rigolote/widgets/loading_indicator.dart';
import 'package:meteo_rigolote/screens/weather_screen.dart';
import 'package:meteo_rigolote/screens/home_screen.dart';

/// Screen for managing favorite cities with drag-and-drop reordering
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final StorageService _storageService = StorageService();
  
  List<String> _favorites = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final favorites = await _storageService.getFavorites();
      if (mounted) {
        setState(() {
          _favorites = favorites;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Erreur lors du chargement des favoris');
      }
    }
  }

  Future<void> _removeFavorite(String cityName) async {
    // Show confirmation dialog
    final confirmed = await _showRemoveConfirmationDialog(cityName);
    if (!confirmed) return;

    try {
      final success = await _storageService.removeFromFavorites(cityName);
      if (success && mounted) {
        await _loadFavorites();
        _showSnackBar('$cityName retiré des favoris');
      }
    } catch (e) {
      _showSnackBar('Erreur lors de la suppression');
    }
  }

  Future<bool> _showRemoveConfirmationDialog(String cityName) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir retirer $cityName de vos favoris ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _favorites.removeAt(oldIndex);
      _favorites.insert(newIndex, item);
    });
    
    // Save the new order
    _storageService.reorderFavorites(_favorites);
    
    if (oldIndex == 0 || newIndex == 0) {
      _showSnackBar('Favori principal mis à jour');
    }
  }

  void _navigateToWeather(String cityName) {
    NavigationService.push(
      context,
      WeatherScreen(cityName: cityName),
    );
  }

  void _navigateToHome() {
    NavigationService.pushAndRemoveUntil(
      context,
      const HomeScreen(),
    );
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Aucun favori',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Ajoutez des villes à vos favoris depuis l\'écran météo pour les retrouver ici.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _navigateToHome,
              icon: const Icon(Icons.search),
              label: const Text('Rechercher une ville'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList() {
    return Column(
      children: [
        // Instructions
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gestion des favoris',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Le premier favori s\'ouvre automatiquement au démarrage. Glissez pour réorganiser.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Favorites list
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _favorites.length,
            onReorder: _onReorder,
            itemBuilder: (context, index) {
              final cityName = _favorites[index];
              final isMainFavorite = index == 0;
              
              return Card(
                key: ValueKey(cityName),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isMainFavorite ? Icons.star : Icons.location_city,
                        color: isMainFavorite 
                            ? Colors.amber 
                            : Theme.of(context).primaryColor,
                      ),
                      if (isMainFavorite)
                        Text(
                          'Principal',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.amber[700],
                          ),
                        ),
                    ],
                  ),
                  title: Text(
                    cityName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: isMainFavorite ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: isMainFavorite 
                      ? const Text('S\'ouvre automatiquement au démarrage')
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _removeFavorite(cityName),
                        icon: const Icon(Icons.delete),
                        color: Theme.of(context).colorScheme.error,
                        tooltip: 'Supprimer',
                      ),
                      const Icon(Icons.drag_handle),
                    ],
                  ),
                  onTap: () => _navigateToWeather(cityName),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Favoris (${_favorites.length}/${AppConstants.maxFavorites})',
        leading: IconButton(
          onPressed: _navigateToHome,
          icon: const Icon(Icons.home),
          tooltip: 'Retour à l\'accueil',
        ),
        actions: [
          IconButton(
            onPressed: _navigateToHome,
            icon: const Icon(Icons.add),
            tooltip: 'Ajouter une ville',
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'Chargement des favoris...')
          : _favorites.isEmpty
              ? _buildEmptyState()
              : _buildFavoritesList(),
    );
  }
}
