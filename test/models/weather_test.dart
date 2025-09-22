import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_rigolote/models/weather.dart';

void main() {
  group('WeatherCondition Tests', () {
    test('weather condition mapping works correctly', () {
      // Test various weather condition mappings
      expect(WeatherCondition.clear.name, 'clear');
      expect(WeatherCondition.rain.name, 'rain');
      expect(WeatherCondition.snow.name, 'snow');
    });
  });

  group('CurrentWeather Tests', () {
    test('creates CurrentWeather from API JSON correctly', () {
      final json = {
        'weather': [
          {
            'main': 'Clear',
            'description': 'clear sky',
            'icon': '01d',
          }
        ],
        'main': {
          'temp': 22.5,
          'feels_like': 24.0,
          'temp_min': 20.0,
          'temp_max': 25.0,
          'humidity': 65,
          'pressure': 1013,
        },
        'wind': {
          'speed': 3.5,
          'deg': 180,
        },
        'visibility': 10000,
        'dt': 1640995200,
        'name': 'Paris',
        'sys': {
          'country': 'FR',
        },
      };

      final weather = CurrentWeather.fromJson(json);

      expect(weather.temperature, 22.5);
      expect(weather.feelsLike, 24.0);
      expect(weather.tempMin, 20.0);
      expect(weather.tempMax, 25.0);
      expect(weather.humidity, 65);
      expect(weather.pressure, 1013);
      expect(weather.windSpeed, 3.5);
      expect(weather.windDirection, 180);
      expect(weather.description, 'clear sky');
      expect(weather.condition, WeatherCondition.clear);
      expect(weather.cityName, 'Paris');
      expect(weather.countryCode, 'FR');
    });

    test('temperature string formatting works', () {
      final weather = CurrentWeather(
        temperature: 22.7,
        feelsLike: 24.0,
        tempMin: 20.0,
        tempMax: 25.0,
        humidity: 65,
        pressure: 1013,
        windSpeed: 3.5,
        windDirection: 180,
        visibility: 10000,
        description: 'clear sky',
        iconCode: '01d',
        condition: WeatherCondition.clear,
        timestamp: DateTime.now(),
        cityName: 'Paris',
        countryCode: 'FR',
      );

      expect(weather.temperatureString, '23°C');
      expect(weather.feelsLikeString, '24°C');
      expect(weather.temperatureRangeString, '20°C / 25°C');
    });

    test('weather validity check works', () {
      final oldWeather = CurrentWeather(
        temperature: 22.0,
        feelsLike: 24.0,
        tempMin: 20.0,
        tempMax: 25.0,
        humidity: 65,
        pressure: 1013,
        windSpeed: 3.5,
        windDirection: 180,
        visibility: 10000,
        description: 'clear sky',
        iconCode: '01d',
        condition: WeatherCondition.clear,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        cityName: 'Paris',
        countryCode: 'FR',
      );

      final newWeather = CurrentWeather(
        temperature: 22.0,
        feelsLike: 24.0,
        tempMin: 20.0,
        tempMax: 25.0,
        humidity: 65,
        pressure: 1013,
        windSpeed: 3.5,
        windDirection: 180,
        visibility: 10000,
        description: 'clear sky',
        iconCode: '01d',
        condition: WeatherCondition.clear,
        timestamp: DateTime.now(),
        cityName: 'Paris',
        countryCode: 'FR',
      );

      expect(oldWeather.isValid, false); // Older than 30 minutes
      expect(newWeather.isValid, true); // Fresh data
    });
  });

  group('DailyForecast Tests', () {
    test('creates DailyForecast from API JSON correctly', () {
      final json = {
        'dt': 1640995200,
        'weather': [
          {
            'main': 'Rain',
            'description': 'light rain',
            'icon': '10d',
          }
        ],
        'main': {
          'temp_min': 15.0,
          'temp_max': 20.0,
          'humidity': 80,
        },
        'wind': {
          'speed': 5.2,
        },
      };

      final forecast = DailyForecast.fromJson(json);

      expect(forecast.tempMin, 15.0);
      expect(forecast.tempMax, 20.0);
      expect(forecast.humidity, 80);
      expect(forecast.windSpeed, 5.2);
      expect(forecast.description, 'light rain');
      expect(forecast.condition, WeatherCondition.rain);
    });

    test('date formatting works correctly', () {
      final today = DateTime.now();
      final tomorrow = today.add(const Duration(days: 1));
      final nextWeek = today.add(const Duration(days: 3));

      final todayForecast = DailyForecast(
        date: today,
        tempMin: 15.0,
        tempMax: 20.0,
        description: 'sunny',
        iconCode: '01d',
        condition: WeatherCondition.clear,
        humidity: 60,
        windSpeed: 2.0,
      );

      final tomorrowForecast = DailyForecast(
        date: tomorrow,
        tempMin: 15.0,
        tempMax: 20.0,
        description: 'sunny',
        iconCode: '01d',
        condition: WeatherCondition.clear,
        humidity: 60,
        windSpeed: 2.0,
      );

      final futureForecast = DailyForecast(
        date: nextWeek,
        tempMin: 15.0,
        tempMax: 20.0,
        description: 'sunny',
        iconCode: '01d',
        condition: WeatherCondition.clear,
        humidity: 60,
        windSpeed: 2.0,
      );

      expect(todayForecast.isToday, true);
      expect(tomorrowForecast.isTomorrow, true);
      expect(futureForecast.isToday, false);
      expect(futureForecast.isTomorrow, false);
    });
  });
}
