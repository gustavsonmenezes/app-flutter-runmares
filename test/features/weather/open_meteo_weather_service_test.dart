import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:runmares/features/weather/data/open_meteo_weather_service.dart';

void main() {
  group('OpenMeteoWeatherService', () {
    test('parses weather response correctly', () async {
      final mockClient = MockClient((request) async {
        final responseData = {
          'current_weather': {
            'temperature': 24.5,
            'windspeed': 12.3,
            'weathercode': 0,
          },
        };
        return http.Response(jsonEncode(responseData), 200);
      });

      final service = OpenMeteoWeatherService(mockClient);
      final weather = await service.getWeather(
        latitude: -23.55,
        longitude: -46.63,
      );

      expect(weather, isNotNull);
      expect(weather!.temperatureC, 24.5);
      expect(weather.windSpeedKmH, 12.3);
      expect(weather.conditionLabel, 'Céu Limpo');
      expect(weather.emoji, '☀️');
    });

    test('returns null when API returns non-200 status code', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      final service = OpenMeteoWeatherService(mockClient);
      final weather = await service.getWeather(
        latitude: -23.55,
        longitude: -46.63,
      );

      expect(weather, isNull);
    });
  });
}
