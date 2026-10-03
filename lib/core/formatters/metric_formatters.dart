abstract final class MetricFormatters {
  static const String emptyPace = '--:--';
  static const double _metersPerKilometer = 1000;
  static const int _secondsPerMinute = 60;
  static const int _minutesPerHour = 60;

  static String distanceInKilometers(double meters) {
    return (meters / _metersPerKilometer)
        .toStringAsFixed(2)
        .replaceAll('.', ',');
  }

  static String duration(Duration value) {
    final minutes = _twoDigits(value.inMinutes.remainder(_minutesPerHour));
    final seconds = _twoDigits(value.inSeconds.remainder(_secondsPerMinute));

    if (value.inHours > 0) return '${value.inHours}:$minutes:$seconds';
    return '$minutes:$seconds';
  }

  static String pace(int? secondsPerKilometer) {
    if (secondsPerKilometer == null) return emptyPace;

    final minutes = secondsPerKilometer ~/ _secondsPerMinute;
    final seconds = secondsPerKilometer % _secondsPerMinute;
    return '$minutes:${_twoDigits(seconds)}';
  }

  static String _twoDigits(int value) => value.toString().padLeft(2, '0');
}
