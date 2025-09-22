import 'package:flutter/material.dart';
import 'package:meteo_rigolote/models/weather.dart';
import 'package:meteo_rigolote/widgets/weather_illustration.dart';

/// Widget for displaying a single day forecast
class ForecastCard extends StatelessWidget {
  final DailyForecast forecast;
  final bool isSelected;
  final VoidCallback? onTap;

  const ForecastCard({
    super.key,
    required this.forecast,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 8 : 2,
      color: isSelected 
          ? Theme.of(context).primaryColor.withOpacity(0.1)
          : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Date
              Flexible(
                child: Text(
                  _getDateLabel(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected 
                        ? Theme.of(context).primaryColor
                        : null,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
              
              // Weather illustration
              WeatherIllustration(
                condition: forecast.condition,
                size: 40,
                temperature: forecast.tempMax,
              ),
              const SizedBox(height: 6),
              
              // Temperature range
              Flexible(
                child: Text(
                  forecast.temperatureRangeString,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),
              
              // Weather description
              Flexible(
                child: Text(
                  forecast.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDateLabel() {
    if (forecast.isToday) {
      return "Aujourd'hui";
    } else if (forecast.isTomorrow) {
      return 'Demain';
    } else {
      return forecast.dateString;
    }
  }
}

/// Horizontal scrollable list of forecast cards
class ForecastList extends StatelessWidget {
  final List<DailyForecast> forecasts;
  final int selectedIndex;
  final Function(int) onForecastSelected;

  const ForecastList({
    super.key,
    required this.forecasts,
    required this.selectedIndex,
    required this.onForecastSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: forecasts.length,
        itemBuilder: (context, index) {
          final forecast = forecasts[index];
          return Container(
            width: 110,
            margin: const EdgeInsets.only(right: 8),
            child: ForecastCard(
              forecast: forecast,
              isSelected: index == selectedIndex,
              onTap: () => onForecastSelected(index),
            ),
          );
        },
      ),
    );
  }
}

/// Detailed view of selected forecast
class ForecastDetailCard extends StatelessWidget {
  final DailyForecast forecast;

  const ForecastDetailCard({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                WeatherIllustration(
                  condition: forecast.condition,
                  size: 60,
                  temperature: forecast.tempMax,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getDateLabel(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        forecast.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        forecast.temperatureRangeString,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  String _getDateLabel() {
    if (forecast.isToday) {
      return "Aujourd'hui";
    } else if (forecast.isTomorrow) {
      return 'Demain';
    } else {
      return forecast.dateString;
    }
  }
}
