import 'package:runmares/features/ai_coach/domain/coach_analysis.dart';
import 'package:runmares/features/ai_coach/domain/coach_facts.dart';

abstract interface class CoachGenerator {
  Future<CoachAnalysis> generate(CoachFacts facts);
}
