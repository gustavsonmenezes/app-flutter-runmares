import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/ai_coach/domain/ai_coach_service.dart';
import 'package:runmares/features/history/domain/activity_details.dart';
import 'package:runmares/features/history/domain/activity_summary.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';

import 'fakes/fake_coach_generator.dart';

ActivityDetails _details() {
  return ActivityDetails(
    summary: ActivitySummary(
      id: 1,
      type: ActivityType.running,
      startedAt: DateTime(2026, 10, 5, 8),
      duration: const Duration(minutes: 30),
      distanceMeters: 5000,
    ),
    segments: const [],
  );
}

void main() {
  test('uses the answer of the AI when it is available', () async {
    final remote = FakeCoachGenerator();
    final service = AiCoachService(remote: remote);

    final analysis = await service.analyzeActivity(_details());

    expect(analysis.source, CoachSource.ai);
    expect(analysis.headline, 'Resposta da IA');
    expect(remote.calls, 1);
  });

  test('falls back to the local analysis when the AI fails', () async {
    Object? reported;
    final service = AiCoachService(
      remote: FakeCoachGenerator(error: Exception('sem internet')),
      onRemoteFailure: (error) => reported = error,
    );

    final analysis = await service.analyzeActivity(_details());

    expect(analysis.source, CoachSource.local);
    expect(analysis.headline, 'Bom treino de corrida');
    expect(reported, isNotNull);
  });

  test('falls back to the local analysis when the AI takes too long', () async {
    final service = AiCoachService(
      remote: FakeCoachGenerator(neverCompletes: true),
      timeout: const Duration(milliseconds: 20),
    );

    final analysis = await service.analyzeActivity(_details());

    expect(analysis.source, CoachSource.local);
  });

  test('works without an AI generator', () async {
    final analysis = await AiCoachService().analyzeActivity(_details());

    expect(analysis.source, CoachSource.local);
  });
}
