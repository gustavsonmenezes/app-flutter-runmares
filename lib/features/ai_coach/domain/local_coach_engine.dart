import 'package:runmares/features/ai_coach/domain/coach_analysis.dart';
import 'package:runmares/features/ai_coach/domain/coach_facts.dart';

/// Análise por regras simples. Funciona sem internet e sem custo.
abstract final class LocalCoachEngine {
  static const double _shortDistanceKm = 1;
  static const double _longDistanceKm = 10;

  static CoachAnalysis analyze(CoachFacts facts) {
    final effort = facts.effortLabel;
    final summary =
        '${facts.distanceLabel} em ${facts.durationLabel}'
        '${effort == null ? '' : ', $effort'}';

    if (facts.distanceKm < _shortDistanceKm) {
      return CoachAnalysis(
        headline: 'Treino curto registrado',
        feedback: '$summary. Sessões curtas também contam para a rotina.',
        recoveryTip:
            'Para evoluir com calma, aumente o tempo aos poucos de uma '
            'semana para a outra.',
      );
    }

    if (facts.distanceKm >= _longDistanceKm) {
      return CoachAnalysis(
        headline: 'Treino longo concluído',
        feedback:
            '$summary. Distâncias assim pedem uma recuperação mais '
            'cuidadosa.',
        recoveryTip:
            'Hidrate-se e prefira um treino leve ou um dia de descanso '
            'antes do próximo esforço forte.',
      );
    }

    return CoachAnalysis(
      headline: 'Bom treino de ${facts.sportLabel}',
      feedback:
          '$summary. Manter a regularidade vale mais do que um treino '
          'isolado.',
      recoveryTip: 'Hidrate-se e alongue de forma suave depois do treino.',
    );
  }
}
