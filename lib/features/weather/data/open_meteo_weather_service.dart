import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:runmares/features/weather/domain/weather_info.dart';

class OpenMeteoWeatherService {
  OpenMeteoWeatherService([http.Client? client])
      : _client = client ?? http.Client();

  final http.Client _client;

  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<WeatherInfo?> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl?latitude=$latitude&longitude=$longitude&current_weather=true',
      );
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final currentWeather = data['current_weather'] as Map<String, dynamic>?;
      if (currentWeather == null) return null;

      final temp = (currentWeather['temperature'] as num?)?.toDouble() ?? 20.0;
      final wind = (currentWeather['windspeed'] as num?)?.toDouble() ?? 10.0;
      final code = (currentWeather['weathercode'] as num?)?.toInt() ?? 0;

      final condition = _interpretWmoCode(code);

      return WeatherInfo(
        temperatureC: temp,
        windSpeedKmH: wind,
        conditionLabel: condition.label,
        emoji: condition.emoji,
      );
    } catch (_) {
      return null;
    }
  }

  static ({String label, String emoji}) _interpretWmoCode(int code) {
    return switch (code) {
      0 => (label: 'Céu Limpo', emoji: '☀️'),
      1 => (label: 'Predominantemente Limpo', emoji: '🌤️'),
      2 => (label: 'Parcialmente Nublado', emoji: '⛅'),
      3 => (label: 'Encoberto', emoji: '☁️'),
      45 || 48 => (label: 'Nevoeiro', emoji: '🌫️'),
      51 || 53 || 55 => (label: 'Garoa', emoji: '🌦️'),
      61 || 63 || 65 => (label: 'Chuva', emoji: '🌧️'),
      71 || 73 || 75 => (label: 'Neve', emoji: '🌨️'),
      80 || 81 || 82 => (label: 'Pancadas de Chuva', emoji: '🌧️'),
      95 || 96 || 99 => (label: 'Tempestade', emoji: '🌩️'),
      _ => (label: 'Ensolarado', emoji: '🌤️'),
    };
  }
}
