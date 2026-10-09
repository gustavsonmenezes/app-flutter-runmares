import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/ai_coach/data/coach_response_parser.dart';
import 'package:runmares/features/ai_coach/domain/coach_analysis.dart';

void main() {
  test('reads a valid answer and marks it as coming from the AI', () {
    final analysis = CoachResponseParser.parse(
      '{"headline": " Bom ritmo ", "feedback": "Treino firme.", '
      '"recoveryTip": "Beba água."}',
    );

    expect(analysis.headline, 'Bom ritmo');
    expect(analysis.feedback, 'Treino firme.');
    expect(analysis.recoveryTip, 'Beba água.');
    expect(analysis.source, CoachSource.ai);
  });

  test('rejects an answer with a missing field', () {
    expect(
      () => CoachResponseParser.parse('{"headline": "Oi", "feedback": "Olá"}'),
      throwsFormatException,
    );
  });

  test('rejects an empty field', () {
    expect(
      () => CoachResponseParser.parse(
        '{"headline": "", "feedback": "a", "recoveryTip": "b"}',
      ),
      throwsFormatException,
    );
  });

  test('rejects text that is not JSON', () {
    expect(
      () => CoachResponseParser.parse('Bom treino!'),
      throwsFormatException,
    );
  });

  test('rejects JSON that is not an object', () {
    expect(
      () => CoachResponseParser.parse('["a", "b"]'),
      throwsFormatException,
    );
  });

  test('rejects a missing answer', () {
    expect(() => CoachResponseParser.parse(null), throwsFormatException);
    expect(() => CoachResponseParser.parse('  '), throwsFormatException);
  });
}
