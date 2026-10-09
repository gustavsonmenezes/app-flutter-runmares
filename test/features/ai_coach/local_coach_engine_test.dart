import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/ai_coach/domain/coach_facts.dart';
import 'package:runmares/features/ai_coach/domain/local_coach_engine.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';

CoachFacts _facts(
  double meters,
  Duration duration, {
  ActivityType type = ActivityType.running,
}) {
  return CoachFacts(type: type, distanceMeters: meters, duration: duration);
}

void main() {
  test('recognizes a short activity', () {
    final analysis = LocalCoachEngine.analyze(
      _facts(500, const Duration(minutes: 5)),
    );

    expect(analysis.headline, 'Treino curto registrado');
  });

  test('describes a regular activity with its distance, time and pace', () {
    final analysis = LocalCoachEngine.analyze(
      _facts(5000, const Duration(minutes: 30)),
    );

    expect(analysis.headline, 'Bom treino de corrida');
    expect(analysis.feedback, contains('5,00 km'));
    expect(analysis.feedback, contains('30:00'));
    expect(analysis.feedback, contains('6:00 min/km'));
  });

  test('recognizes a long activity', () {
    final analysis = LocalCoachEngine.analyze(
      _facts(12000, const Duration(hours: 1, minutes: 10)),
    );

    expect(analysis.headline, 'Treino longo concluído');
  });

  test('uses the average speed for a bike ride', () {
    final analysis = LocalCoachEngine.analyze(
      _facts(20000, const Duration(hours: 1), type: ActivityType.cycling),
    );

    expect(analysis.feedback, contains('20,0 km/h'));
    expect(analysis.feedback, isNot(contains('min/km')));
  });

  test('does not invent a pace for a very short stretch', () {
    final analysis = LocalCoachEngine.analyze(
      _facts(30, const Duration(minutes: 5)),
    );

    expect(analysis.feedback, isNot(contains('ritmo')));
  });
}
