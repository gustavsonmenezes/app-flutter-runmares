import 'dart:convert';

import 'package:runmares/features/ai_coach/domain/coach_analysis.dart';

abstract final class CoachResponseParser {
  /// Lança [FormatException] quando a resposta não tem o formato esperado.
  static CoachAnalysis parse(String? text) {
    if (text == null || text.trim().isEmpty) {
      throw const FormatException('A resposta veio vazia.');
    }

    final decoded = jsonDecode(text.trim());
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('A resposta não é um objeto JSON.');
    }

    return CoachAnalysis(
      headline: _read(decoded, 'headline'),
      feedback: _read(decoded, 'feedback'),
      recoveryTip: _read(decoded, 'recoveryTip'),
      source: CoachSource.ai,
    );
  }

  static String _read(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is String && value.trim().isNotEmpty) return value.trim();
    throw FormatException('Campo ausente ou vazio: $key');
  }
}
