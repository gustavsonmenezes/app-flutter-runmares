import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/core/formatters/distance_unit.dart';
import 'package:runmares/core/widgets/map_style.dart';
import 'package:runmares/features/settings/data/memory_settings_repository.dart';
import 'package:runmares/features/settings/data/settings_repository_provider.dart';
import 'package:runmares/features/settings/domain/app_settings.dart';
import 'package:runmares/features/settings/presentation/providers/settings_providers.dart';

ProviderContainer _container(MemorySettingsRepository repository) {
  final container = ProviderContainer(
    overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('starts from the stored settings', () {
    final container = _container(
      MemorySettingsRepository(
        const AppSettings(distanceUnit: DistanceUnit.miles),
      ),
    );

    expect(container.read(distanceUnitProvider), DistanceUnit.miles);
    expect(container.read(mapStyleProvider), MapStyle.standard);
  });

  test('changes and stores the distance unit', () async {
    final repository = MemorySettingsRepository();
    final container = _container(repository);

    await container
        .read(settingsProvider.notifier)
        .selectDistanceUnit(DistanceUnit.miles);

    expect(container.read(distanceUnitProvider), DistanceUnit.miles);
    expect(repository.load().distanceUnit, DistanceUnit.miles);
  });

  test('changes and stores the map style', () async {
    final repository = MemorySettingsRepository();
    final container = _container(repository);

    await container
        .read(settingsProvider.notifier)
        .selectMapStyle(MapStyle.topographic);

    expect(container.read(mapStyleProvider), MapStyle.topographic);
    expect(repository.load().mapStyle, MapStyle.topographic);
  });

  test('changing one setting keeps the other', () async {
    final container = _container(MemorySettingsRepository());
    final controller = container.read(settingsProvider.notifier);

    await controller.selectDistanceUnit(DistanceUnit.miles);
    await controller.selectMapStyle(MapStyle.topographic);

    expect(container.read(distanceUnitProvider), DistanceUnit.miles);
    expect(container.read(mapStyleProvider), MapStyle.topographic);
  });
}
