import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/features/settings/data/memory_settings_repository.dart';
import 'package:runmares/features/settings/domain/settings_repository.dart';

/// O padrão guarda as configurações só na memória. O `main` o substitui pela
/// versão que grava no aparelho, e os testes usam o padrão.
final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => MemorySettingsRepository(),
);
