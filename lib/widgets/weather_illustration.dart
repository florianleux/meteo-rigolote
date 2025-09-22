import 'package:flutter/material.dart';
import 'package:meteo_rigolote/models/weather.dart';

/// Widget for displaying weather condition illustrations
/// Uses custom weather icons with fallback to Material icons
class WeatherIllustration extends StatelessWidget {
  final WeatherCondition condition;
  final double size;
  final Color? color;
  final double? temperature;
  final String? iconCode;

  const WeatherIllustration({
    super.key,
    required this.condition,
    this.size = 64,
    this.color,
    this.temperature,
    this.iconCode,
  });

  @override
  Widget build(BuildContext context) {
    final iconPath = _getIconPathForCondition(condition, temperature, iconCode);
    
    if (iconPath != null) {
      return Image.asset(
        iconPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to Material icon if image fails to load
          final iconData = _getIconForCondition(condition);
          final iconColor = color ?? _getColorForCondition(condition);
          return Icon(
            iconData,
            size: size,
            color: iconColor,
          );
        },
      );
    } else {
      // Use Material icon as fallback
      final iconData = _getIconForCondition(condition);
      final iconColor = color ?? _getColorForCondition(condition);
      return Icon(
        iconData,
        size: size,
        color: iconColor,
      );
    }
  }

  String? _getIconPathForCondition(WeatherCondition condition, double? temperature, String? iconCode) {
    switch (condition) {
      case WeatherCondition.clear:
        // Canicule: température > 35°C
        if (temperature != null && temperature > 35) {
          return 'assets/images/weather/red-sun.png';
        }
        return 'assets/images/weather/sun.png';
        
      case WeatherCondition.clouds:
        // Utiliser sun-clouds pour les nuages partiels (codes OpenWeather 02d/02n)
        if (iconCode != null && (iconCode == '02d' || iconCode == '02n')) {
          return 'assets/images/weather/sun-clouds.png';
        }
        return 'assets/images/weather/clouds.png';
        
      case WeatherCondition.rain:
        return 'assets/images/weather/heavy-rain.png';
        
      case WeatherCondition.drizzle:
        // Utiliser sun-rain pour la bruine légère avec soleil
        if (iconCode != null && iconCode == '09d') {
          return 'assets/images/weather/sun-rain.png';
        }
        return 'assets/images/weather/light-rain.png';
        
      case WeatherCondition.thunderstorm:
        return 'assets/images/weather/thunder-rain.png';
        
      case WeatherCondition.snow:
        return 'assets/images/weather/snow.png';
        
      case WeatherCondition.mist:
      case WeatherCondition.fog:
      case WeatherCondition.haze:
        return 'assets/images/weather/heavy-clouds.png';
        
      case WeatherCondition.dust:
      case WeatherCondition.sand:
      case WeatherCondition.ash:
        return 'assets/images/weather/heavy-clouds.png';
        
      case WeatherCondition.squall:
        return 'assets/images/weather/thunder.png';
        
      case WeatherCondition.tornado:
        return 'assets/images/weather/thunder.png';
    }
  }

  IconData _getIconForCondition(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.clear:
        return Icons.wb_sunny;
      case WeatherCondition.clouds:
        return Icons.cloud;
      case WeatherCondition.rain:
        return Icons.umbrella;
      case WeatherCondition.drizzle:
        return Icons.grain;
      case WeatherCondition.thunderstorm:
        return Icons.flash_on;
      case WeatherCondition.snow:
        return Icons.ac_unit;
      case WeatherCondition.mist:
      case WeatherCondition.fog:
      case WeatherCondition.haze:
        return Icons.blur_on;
      case WeatherCondition.dust:
      case WeatherCondition.sand:
        return Icons.blur_circular;
      case WeatherCondition.ash:
        return Icons.cloud_queue;
      case WeatherCondition.squall:
        return Icons.air;
      case WeatherCondition.tornado:
        return Icons.cyclone;
    }
  }

  Color _getColorForCondition(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.clear:
        return const Color(0xFFFFD54F); // Sunny yellow
      case WeatherCondition.clouds:
        return const Color(0xFF90A4AE); // Cloudy gray
      case WeatherCondition.rain:
      case WeatherCondition.drizzle:
        return const Color(0xFF42A5F5); // Rainy blue
      case WeatherCondition.thunderstorm:
        return const Color(0xFF5C6BC0); // Storm purple
      case WeatherCondition.snow:
        return const Color(0xFFE1F5FE); // Snowy light blue
      case WeatherCondition.mist:
      case WeatherCondition.fog:
      case WeatherCondition.haze:
        return const Color(0xFFB0BEC5); // Misty gray
      case WeatherCondition.dust:
      case WeatherCondition.sand:
        return const Color(0xFFBCAAA4); // Dusty brown
      case WeatherCondition.ash:
        return const Color(0xFF78909C); // Ash gray
      case WeatherCondition.squall:
        return const Color(0xFF607D8B); // Wind gray
      case WeatherCondition.tornado:
        return const Color(0xFF455A64); // Tornado dark gray
    }
  }
}

/// Get French description for weather condition
String getWeatherConditionDescription(WeatherCondition condition) {
  switch (condition) {
    case WeatherCondition.clear:
      return 'Ensoleillé';
    case WeatherCondition.clouds:
      return 'Nuageux';
    case WeatherCondition.rain:
      return 'Pluie';
    case WeatherCondition.drizzle:
      return 'Bruine';
    case WeatherCondition.thunderstorm:
      return 'Orage';
    case WeatherCondition.snow:
      return 'Neige';
    case WeatherCondition.mist:
      return 'Brume';
    case WeatherCondition.fog:
      return 'Brouillard';
    case WeatherCondition.haze:
      return 'Brume sèche';
    case WeatherCondition.dust:
      return 'Poussière';
    case WeatherCondition.sand:
      return 'Sable';
    case WeatherCondition.ash:
      return 'Cendres';
    case WeatherCondition.squall:
      return 'Bourrasque';
    case WeatherCondition.tornado:
      return 'Tornade';
  }
}
