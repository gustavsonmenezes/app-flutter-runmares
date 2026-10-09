import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/ai_coach/data/coach_prompt.dart';
import 'package:runmares/features/ai_coach/domain/coach_facts.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';

void main() {
  test('describes the activity with its main numbers', () {
    final prompt = CoachPrompt.build(
      const CoachFacts(
        type: ActivityType.running,
        distanceMeters: 5000,
        duration: Duration(minutes: 30),
      ),
    );

    expect(prompt, contains('corrida'));
    expect(prompt, contains('5,00 km'));
    expect(prompt, contains('30:00'));
    expect(prompt, contains('6:00 min/km'));
  });

  test('uses speed for a bike ride', () {
    final prompt = CoachPrompt.build(
      const CoachFacts(
        type: ActivityType.cycling,
        distanceMeters: 20000,
        duration: Duration(hours: 1),
      ),
    );

    expect(prompt, contains('km/h'));
  });

  test('asks for a safe, non-medical comment', () {
    final prompt = CoachPrompt.build(
      const CoachFacts(
        type: ActivityType.walking,
        distanceMeters: 3000,
        duration: Duration(minutes: 40),
      ),
    );

    expect(prompt, contains('Não faça diagnósticos'));
  });
}
