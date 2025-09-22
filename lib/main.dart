import 'package:flutter/material.dart';
import 'package:meteo_rigolote/services/storage_service.dart';
import 'package:meteo_rigolote/screens/home_screen.dart';
import 'package:meteo_rigolote/screens/weather_screen.dart';
import 'package:meteo_rigolote/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage service
  await StorageService().init();
  
  runApp(const MeteoRigoloteApp());
}

class MeteoRigoloteApp extends StatelessWidget {
  const MeteoRigoloteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Météo Rigolote',
      theme: AppTheme.lightTheme,
      home: const AppLauncher(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Determines which screen to show at app launch
class AppLauncher extends StatefulWidget {
  const AppLauncher({super.key});

  @override
  State<AppLauncher> createState() => _AppLauncherState();
}

class _AppLauncherState extends State<AppLauncher> {
  @override
  void initState() {
    super.initState();
    _determineInitialScreen();
  }

  Future<void> _determineInitialScreen() async {
    final storageService = StorageService();
    final favorites = await storageService.getFavorites();
    
    if (favorites.isNotEmpty) {
      // User has favorites - navigate to main favorite
      final mainFavorite = favorites.first;
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WeatherScreen(cityName: mainFavorite),
          ),
        );
      }
    } else {
      // New user - show home screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
