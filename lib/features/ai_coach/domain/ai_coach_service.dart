import 'package:runmares/features/ai_coach/domain/coach_analysis.dart';
import 'package:runmares/features/ai_coach/domain/coach_facts.dart';
import 'package:runmares/features/ai_coach/domain/coach_generator.dart';
import 'package:runmares/features/ai_coach/domain/local_coach_engine.dart';
import 'package:runmares/features/history/domain/activity_details.dart';

export 'package:runmares/features/ai_coach/domain/coach_analysis.dart';

/// Tenta a análise com IA e, se não houver internet, se o serviço falhar ou
/// se demorar demais, usa a análise local.
class AiCoachService {
  AiCoachService({
    CoachGenerator? remote,
    Duration timeout = const Duration(seconds: 8),
    void Function(Object error)? onRemoteFailure,
  }) : _remote = remote,
       _timeout = timeout,
       _onRemoteFailure = onRemoteFailure;

  final CoachGenerator? _remote;
  final Duration _timeout;
  final void Function(Object error)? _onRemoteFailure;

  Future<CoachAnalysis> analyzeActivity(ActivityDetails details) async {
    final facts = CoachFacts.fromSummary(details.summary);
    final remote = _remote;

    if (remote != null) {
      try {
        return await remote.generate(facts).timeout(_timeout);
      } on Exception catch (error) {
        _onRemoteFailure?.call(error);
      }
    }

    return LocalCoachEngine.analyze(facts);
  }
}
