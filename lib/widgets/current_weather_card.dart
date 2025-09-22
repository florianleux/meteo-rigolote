import 'package:flutter/material.dart';
import 'package:meteo_rigolote/models/weather.dart';
import 'package:meteo_rigolote/widgets/weather_illustration.dart';
import 'package:meteo_rigolote/theme/app_theme.dart';

/// Widget displaying current weather information
class CurrentWeatherCard extends StatelessWidget {
  final CurrentWeather weather;
  final DailyForecast? todayForecast;

  const CurrentWeatherCard({
    super.key,
    required this.weather,
    this.todayForecast,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // City name and date
            Text(
              weather.cityName,
              style: AppTheme.cityNameStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _formatCurrentDate(),
              style: AppTheme.dateStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Weather illustration and temperature
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WeatherIllustration(
                  condition: weather.condition,
                  size: 80,
                  temperature: weather.temperature,
                  iconCode: weather.iconCode,
                ),
                Column(
                  children: [
                    Text(
                      weather.temperatureString,
                      style: AppTheme.weatherTemperatureStyle,
                    ),
                    Text(
                      'Ressentei ${weather.feelsLikeString}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Weather description
            Text(
              weather.description,
              style: AppTheme.weatherDescriptionStyle,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            // Additional weather details
            _buildWeatherDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetails(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildDetailItem(
          context,
          Icons.thermostat,
          'Min/Max',
          _getTemperatureRange(),
        ),
        _buildDetailItem(
          context,
          Icons.water_drop,
          'Humidité',
          '${weather.humidity}%',
        ),
        _buildDetailItem(
          context,
          Icons.air,
          'Vent',
          '${weather.windSpeed.toStringAsFixed(1)} km/h',
        ),
      ],
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getTemperatureRange() {
    if (todayForecast != null) {
      // Utiliser les températures min/max de la journée entière
      return '${todayForecast!.tempMin.round()}°/${todayForecast!.tempMax.round()}°';
    } else {
      // Fallback sur les données actuelles si pas de prévision disponible
      return weather.temperatureRangeString;
    }
  }

  String _formatCurrentDate() {
    final now = DateTime.now();
    final weekdays = [
      'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'
    ];
    final months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    
    final weekday = weekdays[now.weekday - 1];
    final day = now.day;
    final month = months[now.month - 1];
    final year = now.year;
    
    return '$weekday $day $month $year';
  }
}
