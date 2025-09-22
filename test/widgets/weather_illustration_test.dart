import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_rigolote/models/weather.dart';
import 'package:meteo_rigolote/widgets/weather_illustration.dart';

void main() {
  group('WeatherIllustration Widget Tests', () {
    testWidgets('displays correct icon for weather condition', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherIllustration(
              condition: WeatherCondition.clear,
              size: 64,
            ),
          ),
        ),
      );

      // Verify the icon is displayed
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(WeatherIllustration), findsOneWidget);
    });

    testWidgets('respects size parameter', (tester) async {
      const testSize = 100.0;
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherIllustration(
              condition: WeatherCondition.rain,
              size: testSize,
            ),
          ),
        ),
      );

      final iconWidget = tester.widget<Icon>(find.byType(Icon));
      expect(iconWidget.size, testSize);
    });

    testWidgets('uses custom color when provided', (tester) async {
      const testColor = Colors.red;
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeatherIllustration(
              condition: WeatherCondition.snow,
              color: testColor,
            ),
          ),
        ),
      );

      final iconWidget = tester.widget<Icon>(find.byType(Icon));
      expect(iconWidget.color, testColor);
    });
  });

  group('Weather Condition Description Tests', () {
    test('returns correct French descriptions', () {
      expect(getWeatherConditionDescription(WeatherCondition.clear), 'Ensoleillé');
      expect(getWeatherConditionDescription(WeatherCondition.rain), 'Pluie');
      expect(getWeatherConditionDescription(WeatherCondition.snow), 'Neige');
      expect(getWeatherConditionDescription(WeatherCondition.clouds), 'Nuageux');
      expect(getWeatherConditionDescription(WeatherCondition.thunderstorm), 'Orage');
      expect(getWeatherConditionDescription(WeatherCondition.fog), 'Brouillard');
    });
  });
}
