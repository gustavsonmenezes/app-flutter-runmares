import 'dart:async';

import 'package:runmares/features/ai_coach/domain/coach_analysis.dart';
import 'package:runmares/features/ai_coach/domain/coach_facts.dart';
import 'package:runmares/features/ai_coach/domain/coach_generator.dart';

class FakeCoachGenerator implements CoachGenerator {
  FakeCoachGenerator({this.error, this.neverCompletes = false});

  final Exception? error;
  final bool neverCompletes;
  int calls = 0;

  @override
  Future<CoachAnalysis> generate(CoachFacts facts) async {
    calls++;
    if (neverCompletes) return Completer<CoachAnalysis>().future;

    final failure = error;
    if (failure != null) throw failure;

    return const CoachAnalysis(
      headline: 'Resposta da IA',
      feedback: 'Comentário da IA.',
      recoveryTip: 'Dica da IA.',
      source: CoachSource.ai,
    );
  }
}
