import 'package:runmares/core/formatters/metric_formatters.dart';
import 'package:runmares/features/history/domain/activity_summary.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/pace_calculator.dart';

/// Os únicos dados de uma atividade que o coach usa. Não há localização,
/// trajeto nem dados do usuário.
class CoachFacts {
  const CoachFacts({
    required this.type,
    required this.distanceMeters,
    required this.duration,
  });

  factory CoachFacts.fromSummary(ActivitySummary summary) {
    return CoachFacts(
      type: summary.type,
      distanceMeters: summary.distanceMeters,
      duration: summary.duration,
    );
  }

  static const double _metersPerKilometer = 1000;
  static const double _secondsPerHour = 3600;

  final ActivityType type;
  final double distanceMeters;
  final Duration duration;

  double get distanceKm => distanceMeters / _metersPerKilometer;

  String get sportLabel {
    return switch (type) {
      ActivityType.running => 'corrida',
      ActivityType.walking => 'caminhada',
      ActivityType.cycling => 'bicicleta',
    };
  }

  String get distanceLabel => '${MetricFormatters.distance(distanceMeters)} km';

  String get durationLabel => MetricFormatters.duration(duration);

  /// Velocidade média na bicicleta e ritmo médio nas demais atividades. É nulo
  /// quando o trecho é curto demais para uma média confiável.
  String? get effortLabel {
    if (distanceMeters < PaceCalculator.minDistanceMeters) return null;

    if (type == ActivityType.cycling) {
      final hours = duration.inSeconds / _secondsPerHour;
      if (hours <= 0) return null;
      final speed = (distanceKm / hours)
          .toStringAsFixed(1)
          .replaceAll('.', ',');
      return 'velocidade média de $speed km/h';
    }

    final pace = PaceCalculator.secondsPerKilometer(
      distanceMeters: distanceMeters,
      elapsed: duration,
    );
    if (pace == null) return null;
    return 'ritmo médio de ${MetricFormatters.pace(pace)} min/km';
  }
}
