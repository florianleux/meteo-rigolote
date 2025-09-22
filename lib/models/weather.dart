/// Weather condition types for custom illustrations
enum WeatherCondition {
  clear,
  clouds,
  rain,
  drizzle,
  thunderstorm,
  snow,
  mist,
  fog,
  haze,
  dust,
  sand,
  ash,
  squall,
  tornado,
}

/// Current weather data model
class CurrentWeather {
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int windDirection;
  final int visibility;
  final String description;
  final String iconCode;
  final WeatherCondition condition;
  final DateTime timestamp;
  final String cityName;
  final String countryCode;

  const CurrentWeather({
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDirection,
    required this.visibility,
    required this.description,
    required this.iconCode,
    required this.condition,
    required this.timestamp,
    required this.cityName,
    required this.countryCode,
  });

  /// Create CurrentWeather from OpenWeatherMap API response
  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0] as Map<String, dynamic>;
    final main = json['main'] as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>? ?? {};
    final sys = json['sys'] as Map<String, dynamic>? ?? {};

    return CurrentWeather(
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      tempMin: (main['temp_min'] as num).toDouble(),
      tempMax: (main['temp_max'] as num).toDouble(),
      humidity: main['humidity'] as int,
      pressure: main['pressure'] as int,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0.0,
      windDirection: (wind['deg'] as num?)?.toInt() ?? 0,
      visibility: (json['visibility'] as num?)?.toInt() ?? 0,
      description: weather['description'] as String,
      iconCode: weather['icon'] as String,
      condition: _mapWeatherCondition(weather['main'] as String),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        (json['dt'] as int) * 1000,
      ),
      cityName: json['name'] as String,
      countryCode: sys['country'] as String? ?? '',
    );
  }

  /// Convert to JSON for caching
  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'feels_like': feelsLike,
      'temp_min': tempMin,
      'temp_max': tempMax,
      'humidity': humidity,
      'pressure': pressure,
      'wind_speed': windSpeed,
      'wind_direction': windDirection,
      'visibility': visibility,
      'description': description,
      'icon_code': iconCode,
      'condition': condition.name,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'city_name': cityName,
      'country_code': countryCode,
    };
  }

  /// Create from cached JSON
  factory CurrentWeather.fromCachedJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feels_like'] as num).toDouble(),
      tempMin: (json['temp_min'] as num).toDouble(),
      tempMax: (json['temp_max'] as num).toDouble(),
      humidity: json['humidity'] as int,
      pressure: json['pressure'] as int,
      windSpeed: (json['wind_speed'] as num).toDouble(),
      windDirection: json['wind_direction'] as int,
      visibility: json['visibility'] as int,
      description: json['description'] as String,
      iconCode: json['icon_code'] as String,
      condition: WeatherCondition.values.firstWhere(
        (e) => e.name == json['condition'],
        orElse: () => WeatherCondition.clear,
      ),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        json['timestamp'] as int,
      ),
      cityName: json['city_name'] as String,
      countryCode: json['country_code'] as String,
    );
  }

  /// Get formatted temperature string
  String get temperatureString => '${temperature.round()}°C';

  /// Get formatted feels like temperature
  String get feelsLikeString => '${feelsLike.round()}°C';

  /// Get temperature range string
  String get temperatureRangeString => 
      '${tempMin.round()}°C / ${tempMax.round()}°C';

  /// Check if weather data is still valid (within cache expiration)
  bool get isValid {
    return DateTime.now().difference(timestamp).inMinutes < 30;
  }
}

/// Daily forecast data model
class DailyForecast {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String description;
  final String iconCode;
  final WeatherCondition condition;
  final int humidity;
  final double windSpeed;

  const DailyForecast({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.description,
    required this.iconCode,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
  });

  /// Create from OpenWeatherMap forecast API response
  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0] as Map<String, dynamic>;
    final main = json['main'] as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>? ?? {};

    return DailyForecast(
      date: DateTime.fromMillisecondsSinceEpoch(
        (json['dt'] as int) * 1000,
      ),
      tempMin: (main['temp_min'] as num).toDouble(),
      tempMax: (main['temp_max'] as num).toDouble(),
      description: weather['description'] as String,
      iconCode: weather['icon'] as String,
      condition: _mapWeatherCondition(weather['main'] as String),
      humidity: main['humidity'] as int,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert to JSON for caching
  Map<String, dynamic> toJson() {
    return {
      'date': date.millisecondsSinceEpoch,
      'temp_min': tempMin,
      'temp_max': tempMax,
      'description': description,
      'icon_code': iconCode,
      'condition': condition.name,
      'humidity': humidity,
      'wind_speed': windSpeed,
    };
  }

  /// Create from cached JSON
  factory DailyForecast.fromCachedJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      tempMin: (json['temp_min'] as num).toDouble(),
      tempMax: (json['temp_max'] as num).toDouble(),
      description: json['description'] as String,
      iconCode: json['icon_code'] as String,
      condition: WeatherCondition.values.firstWhere(
        (e) => e.name == json['condition'],
        orElse: () => WeatherCondition.clear,
      ),
      humidity: json['humidity'] as int,
      windSpeed: (json['wind_speed'] as num).toDouble(),
    );
  }

  /// Get formatted temperature range
  String get temperatureRangeString => 
      '${tempMin.round()}°C / ${tempMax.round()}°C';

  /// Get formatted date string in French
  String get dateString {
    final weekdays = [
      'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'
    ];
    final months = [
      'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun',
      'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'
    ];
    
    final weekday = weekdays[date.weekday - 1];
    final day = date.day;
    final month = months[date.month - 1];
    
    return '$weekday $day $month';
  }

  /// Check if this forecast is for today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  /// Check if this forecast is for tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && 
           date.month == tomorrow.month && 
           date.day == tomorrow.day;
  }
}

/// Weather forecast collection
class WeatherForecast {
  final CurrentWeather current;
  final List<DailyForecast> daily;
  final DateTime lastUpdated;

  const WeatherForecast({
    required this.current,
    required this.daily,
    required this.lastUpdated,
  });

  /// Convert to JSON for caching
  Map<String, dynamic> toJson() {
    return {
      'current': current.toJson(),
      'daily': daily.map((d) => d.toJson()).toList(),
      'last_updated': lastUpdated.millisecondsSinceEpoch,
    };
  }

  /// Create from cached JSON
  factory WeatherForecast.fromCachedJson(Map<String, dynamic> json) {
    return WeatherForecast(
      current: CurrentWeather.fromCachedJson(
        json['current'] as Map<String, dynamic>,
      ),
      daily: (json['daily'] as List)
          .map((d) => DailyForecast.fromCachedJson(d as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(
        json['last_updated'] as int,
      ),
    );
  }

  /// Check if forecast data is still valid
  bool get isValid {
    return DateTime.now().difference(lastUpdated).inMinutes < 30;
  }
}

/// Map OpenWeatherMap weather conditions to our enum
WeatherCondition _mapWeatherCondition(String condition) {
  switch (condition.toLowerCase()) {
    case 'clear':
      return WeatherCondition.clear;
    case 'clouds':
      return WeatherCondition.clouds;
    case 'rain':
      return WeatherCondition.rain;
    case 'drizzle':
      return WeatherCondition.drizzle;
    case 'thunderstorm':
      return WeatherCondition.thunderstorm;
    case 'snow':
      return WeatherCondition.snow;
    case 'mist':
      return WeatherCondition.mist;
    case 'fog':
      return WeatherCondition.fog;
    case 'haze':
      return WeatherCondition.haze;
    case 'dust':
      return WeatherCondition.dust;
    case 'sand':
      return WeatherCondition.sand;
    case 'ash':
      return WeatherCondition.ash;
    case 'squall':
      return WeatherCondition.squall;
    case 'tornado':
      return WeatherCondition.tornado;
    default:
      return WeatherCondition.clear;
  }
}
