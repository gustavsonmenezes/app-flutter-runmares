import 'package:runmares/core/formatters/distance_unit.dart';

abstract final class MetricFormatters {
  static const String emptyPace = '--:--';
  static const double _metersPerKilometer = 1000;
  static const int _secondsPerMinute = 60;
  static const int _minutesPerHour = 60;

  static String distance(
    double meters, [
    DistanceUnit unit = DistanceUnit.kilometers,
  ]) {
    return (meters / unit.metersPerUnit)
        .toStringAsFixed(2)
        .replaceAll('.', ',');
  }

  static String duration(Duration value) {
    final minutes = _twoDigits(value.inMinutes.remainder(_minutesPerHour));
    final seconds = _twoDigits(value.inSeconds.remainder(_secondsPerMinute));

    if (value.inHours > 0) return '${value.inHours}:$minutes:$seconds';
    return '$minutes:$seconds';
  }

  /// Formata o ritmo na unidade escolhida a partir dos segundos por quilômetro.
  static String pace(
    int? secondsPerKilometer, [
    DistanceUnit unit = DistanceUnit.kilometers,
  ]) {
    if (secondsPerKilometer == null) return emptyPace;

    final seconds =
        (secondsPerKilometer * unit.metersPerUnit / _metersPerKilometer)
            .round();
    final minutes = seconds ~/ _secondsPerMinute;
    return '$minutes:${_twoDigits(seconds % _secondsPerMinute)}';
  }

  static String dateTime(DateTime value) {
    final day = _twoDigits(value.day);
    final month = _twoDigits(value.month);
    final hour = _twoDigits(value.hour);
    final minute = _twoDigits(value.minute);
    return '$day/$month/${value.year} $hour:$minute';
  }

  static String _twoDigits(int value) => value.toString().padLeft(2, '0');
}
