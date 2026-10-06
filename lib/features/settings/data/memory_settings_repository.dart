import 'package:runmares/features/settings/domain/app_settings.dart';
import 'package:runmares/features/settings/domain/settings_repository.dart';

class MemorySettingsRepository implements SettingsRepository {
  MemorySettingsRepository([AppSettings initial = const AppSettings()])
    : _settings = initial;

  AppSettings _settings;

  @override
  AppSettings load() => _settings;

  @override
  Future<void> save(AppSettings settings) async {
    _settings = settings;
  }
}
