/// Data model for city information from geocoding API
class City {
  final String name;
  final String country;
  final String? state;
  final double lat;
  final double lon;
  final Map<String, String>? localNames;

  const City({
    required this.name,
    required this.country,
    this.state,
    required this.lat,
    required this.lon,
    this.localNames,
  });

  /// Create City from OpenWeatherMap geocoding API response
  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] as String,
      country: json['country'] as String,
      state: json['state'] as String?,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      localNames: json['local_names'] != null
          ? Map<String, String>.from(json['local_names'] as Map)
          : null,
    );
  }

  /// Convert City to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'state': state,
      'lat': lat,
      'lon': lon,
      'local_names': localNames,
    };
  }

  /// Get display name with postal code if available
  String get displayName {
    if (localNames != null && localNames!.containsKey('fr')) {
      return localNames!['fr']!;
    }
    return name;
  }

  /// Get full display name with state/country info
  String get fullDisplayName {
    final parts = <String>[displayName];
    if (state != null && state!.isNotEmpty) {
      parts.add(state!);
    }
    if (country.isNotEmpty) {
      parts.add(country);
    }
    return parts.join(', ');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is City &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          country == other.country &&
          state == other.state &&
          lat == other.lat &&
          lon == other.lon;

  @override
  int get hashCode =>
      name.hashCode ^
      country.hashCode ^
      state.hashCode ^
      lat.hashCode ^
      lon.hashCode;

  @override
  String toString() {
    return 'City{name: $name, country: $country, state: $state, lat: $lat, lon: $lon}';
  }
}
