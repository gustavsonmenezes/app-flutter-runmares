import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/features/ai_coach/data/firebase_ai_coach_generator.dart';
import 'package:runmares/features/ai_coach/domain/ai_coach_service.dart';

final aiCoachServiceProvider = Provider<AiCoachService>(
  (ref) => AiCoachService(
    remote: FirebaseAiCoachGenerator(),
    // Sem isso uma falha da IA passaria despercebida, porque o app cai
    // sozinho para a análise local.
    onRemoteFailure: (error) => debugPrint('Coach com IA indisponível: $error'),
  ),
);
