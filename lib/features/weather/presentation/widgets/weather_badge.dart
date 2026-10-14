import 'package:flutter/material.dart';
import 'package:runmares/features/history/domain/activity_details.dart';
import 'package:runmares/features/weather/data/open_meteo_weather_service.dart';
import 'package:runmares/features/weather/domain/weather_info.dart';

class WeatherBadge extends StatefulWidget {
  const WeatherBadge({required this.details, this.onWeatherLoaded, super.key});

  final ActivityDetails details;
  final ValueChanged<WeatherInfo>? onWeatherLoaded;

  @override
  State<WeatherBadge> createState() => _WeatherBadgeState();
}

class _WeatherBadgeState extends State<WeatherBadge> {
  final OpenMeteoWeatherService _weatherService = OpenMeteoWeatherService();
  Future<WeatherInfo?>? _weatherFuture;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() {
    final points = widget.details.segments.expand((s) => s).toList();
    if (points.isNotEmpty) {
      final firstPoint = points.first;
      _weatherFuture = _weatherService
          .getWeather(
            latitude: firstPoint.latitude,
            longitude: firstPoint.longitude,
          )
          .then((weather) {
            if (weather != null && widget.onWeatherLoaded != null) {
              widget.onWeatherLoaded!(weather);
            }
            return weather;
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_weatherFuture == null) return const SizedBox.shrink();

    return FutureBuilder<WeatherInfo?>(
      future: _weatherFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }

        final weather = snapshot.data!;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                weather.emoji,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                '${weather.temperatureC.round()}°C · ${weather.conditionLabel} · Vento ${weather.windSpeedKmH.round()} km/h',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
