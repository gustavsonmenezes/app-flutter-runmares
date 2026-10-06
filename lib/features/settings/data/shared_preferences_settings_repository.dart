import 'package:runmares/core/formatters/distance_unit.dart';
import 'package:runmares/core/widgets/map_style.dart';
import 'package:runmares/features/settings/domain/app_settings.dart';
import 'package:runmares/features/settings/domain/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSettingsRepository implements SettingsRepository {
  const SharedPreferencesSettingsRepository(this._preferences);

  static const String _distanceUnitKey = 'distance_unit';
  static const String _mapStyleKey = 'map_style';

  final SharedPreferences _preferences;

  @override
  AppSettings load() {
    return AppSettings(
      distanceUnit: _read(
        DistanceUnit.values,
        _distanceUnitKey,
        DistanceUnit.kilometers,
      ),
      mapStyle: _read(MapStyle.values, _mapStyleKey, MapStyle.standard),
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    await _preferences.setString(_distanceUnitKey, settings.distanceUnit.name);
    await _preferences.setString(_mapStyleKey, settings.mapStyle.name);
  }

  // Um valor desconhecido (por exemplo, de uma versão futura) volta ao padrão.
  T _read<T extends Enum>(List<T> values, String key, T fallback) {
    final stored = _preferences.getString(key);
    for (final value in values) {
      if (value.name == stored) return value;
    }
    return fallback;
  }
}
