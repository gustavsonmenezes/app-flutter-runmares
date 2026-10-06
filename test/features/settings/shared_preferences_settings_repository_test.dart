import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/core/formatters/distance_unit.dart';
import 'package:runmares/core/widgets/map_style.dart';
import 'package:runmares/features/settings/data/shared_preferences_settings_repository.dart';
import 'package:runmares/features/settings/domain/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferencesSettingsRepository> _repository() async {
  return SharedPreferencesSettingsRepository(
    await SharedPreferences.getInstance(),
  );
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('starts with the default settings', () async {
    final settings = (await _repository()).load();

    expect(settings.distanceUnit, DistanceUnit.kilometers);
    expect(settings.mapStyle, MapStyle.standard);
  });

  test('stores the settings and loads them again', () async {
    await (await _repository()).save(
      const AppSettings(
        distanceUnit: DistanceUnit.miles,
        mapStyle: MapStyle.topographic,
      ),
    );

    final settings = (await _repository()).load();

    expect(settings.distanceUnit, DistanceUnit.miles);
    expect(settings.mapStyle, MapStyle.topographic);
  });

  test('falls back to the defaults when a stored value is unknown', () async {
    SharedPreferences.setMockInitialValues({
      'distance_unit': 'furlongs',
      'map_style': 'satellite',
    });

    final settings = (await _repository()).load();

    expect(settings.distanceUnit, DistanceUnit.kilometers);
    expect(settings.mapStyle, MapStyle.standard);
  });
}
