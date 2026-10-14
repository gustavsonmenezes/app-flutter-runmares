class WeatherInfo {
  const WeatherInfo({
    required this.temperatureC,
    required this.windSpeedKmH,
    required this.conditionLabel,
    required this.emoji,
  });

  final double temperatureC;
  final double windSpeedKmH;
  final String conditionLabel;
  final String emoji;

  String get formattedSummary =>
      '$emoji ${temperatureC.round()}°C · $conditionLabel · Vento ${windSpeedKmH.round()} km/h';
}
