import 'package:firebase_ai/firebase_ai.dart';
import 'package:runmares/features/ai_coach/data/coach_prompt.dart';
import 'package:runmares/features/ai_coach/data/coach_response_parser.dart';
import 'package:runmares/features/ai_coach/domain/coach_analysis.dart';
import 'package:runmares/features/ai_coach/domain/coach_facts.dart';
import 'package:runmares/features/ai_coach/domain/coach_generator.dart';

class FirebaseAiCoachGenerator implements CoachGenerator {
  static const String modelName = 'gemini-2.5-flash';

  // Criado só na primeira chamada, depois que o Firebase já foi inicializado.
  late final GenerativeModel _model = FirebaseAI.googleAI().generativeModel(
    model: modelName,
    generationConfig: GenerationConfig(
      responseMimeType: 'application/json',
      responseSchema: Schema.object(
        properties: {
          'headline': Schema.string(),
          'feedback': Schema.string(),
          'recoveryTip': Schema.string(),
        },
      ),
    ),
  );

  @override
  Future<CoachAnalysis> generate(CoachFacts facts) async {
    final response = await _model.generateContent([
      Content.text(CoachPrompt.build(facts)),
    ]);
    return CoachResponseParser.parse(response.text);
  }
}
