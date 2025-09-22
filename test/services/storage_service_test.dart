import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meteo_rigolote/services/storage_service.dart';
import 'package:meteo_rigolote/constants/app_constants.dart';

void main() {
  group('StorageService Tests', () {
    late StorageService storageService;

    setUp(() async {
      // Mock SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
      storageService = StorageService();
      await storageService.init();
    });

    tearDown(() async {
      // Clear all data after each test
      await storageService.clearAllData();
    });

    group('Favorites Management', () {
      test('starts with empty favorites list', () async {
        final favorites = await storageService.getFavorites();
        expect(favorites, isEmpty);
      });

      test('can add city to favorites', () async {
        final success = await storageService.addToFavorites('Paris');
        expect(success, true);

        final favorites = await storageService.getFavorites();
        expect(favorites, contains('Paris'));
        expect(favorites.length, 1);
      });

      test('prevents duplicate favorites', () async {
        await storageService.addToFavorites('Paris');
        final success = await storageService.addToFavorites('Paris');
        
        expect(success, false);
        final favorites = await storageService.getFavorites();
        expect(favorites.length, 1);
      });

      test('respects maximum favorites limit', () async {
        // Add maximum number of favorites
        for (int i = 0; i < AppConstants.maxFavorites; i++) {
          await storageService.addToFavorites('City$i');
        }

        // Try to add one more
        final success = await storageService.addToFavorites('ExtraCity');
        expect(success, false);

        final favorites = await storageService.getFavorites();
        expect(favorites.length, AppConstants.maxFavorites);
      });

      test('can remove city from favorites', () async {
        await storageService.addToFavorites('Paris');
        await storageService.addToFavorites('Lyon');

        final success = await storageService.removeFromFavorites('Paris');
        expect(success, true);

        final favorites = await storageService.getFavorites();
        expect(favorites, isNot(contains('Paris')));
        expect(favorites, contains('Lyon'));
      });

      test('can reorder favorites', () async {
        await storageService.addToFavorites('Paris');
        await storageService.addToFavorites('Lyon');
        await storageService.addToFavorites('Marseille');

        final newOrder = ['Lyon', 'Marseille', 'Paris'];
        await storageService.reorderFavorites(newOrder);

        final favorites = await storageService.getFavorites();
        expect(favorites, equals(newOrder));
      });

      test('can check if city is favorite', () async {
        await storageService.addToFavorites('Paris');

        final isParisFavorite = await storageService.isFavorite('Paris');
        final isLyonFavorite = await storageService.isFavorite('Lyon');

        expect(isParisFavorite, true);
        expect(isLyonFavorite, false);
      });

      test('returns correct main favorite', () async {
        await storageService.addToFavorites('Paris');
        await storageService.addToFavorites('Lyon');

        final mainFavorite = await storageService.getMainFavorite();
        expect(mainFavorite, 'Paris');
      });

      test('returns null main favorite when no favorites', () async {
        final mainFavorite = await storageService.getMainFavorite();
        expect(mainFavorite, null);
      });
    });

    group('Last City Management', () {
      test('can save and retrieve last city', () async {
        await storageService.saveLastCity('Paris');
        final lastCity = await storageService.getLastCity();
        expect(lastCity, 'Paris');
      });

      test('returns null when no last city saved', () async {
        final lastCity = await storageService.getLastCity();
        expect(lastCity, null);
      });
    });

    group('Storage Statistics', () {
      test('returns correct storage statistics', () async {
        await storageService.addToFavorites('Paris');
        await storageService.addToFavorites('Lyon');
        await storageService.saveLastCity('Paris');

        final stats = await storageService.getStorageStats();
        
        expect(stats['favorites_count'], 2);
        expect(stats['last_city'], 'Paris');
        expect(stats['cache_entries'], 0); // No cache entries yet
      });
    });
  });
}
