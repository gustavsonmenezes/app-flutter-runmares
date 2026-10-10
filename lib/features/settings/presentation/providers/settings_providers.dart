import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/core/formatters/distance_unit.dart';
import 'package:runmares/core/widgets/map_style.dart';
import 'package:runmares/features/settings/data/settings_repository_provider.dart';
import 'package:runmares/features/settings/domain/app_settings.dart';

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

final distanceUnitProvider = Provider<DistanceUnit>(
  (ref) => ref.watch(settingsProvider.select((s) => s.distanceUnit)),
);

final mapStyleProvider = Provider<MapStyle>(
  (ref) => ref.watch(settingsProvider.select((s) => s.mapStyle)),
);

final audioAnnouncementsEnabledProvider = Provider<bool>(
  (ref) =>
      ref.watch(settingsProvider.select((s) => s.audioAnnouncementsEnabled)),
);

final themeModeProvider = Provider<ThemeMode>(
  (ref) => ref.watch(settingsProvider.select((s) => s.themeMode)),
);

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.read(settingsRepositoryProvider).load();

  Future<void> selectDistanceUnit(DistanceUnit unit) {
    return _update(state.copyWith(distanceUnit: unit));
  }

  Future<void> selectMapStyle(MapStyle style) {
    return _update(state.copyWith(mapStyle: style));
  }

  Future<void> toggleAudioAnnouncements(bool enabled) {
    return _update(state.copyWith(audioAnnouncementsEnabled: enabled));
  }

  Future<void> selectThemeMode(ThemeMode mode) {
    return _update(state.copyWith(themeMode: mode));
  }

  Future<void> _update(AppSettings next) async {
    state = next;
    try {
      await ref.read(settingsRepositoryProvider).save(next);
    } on Exception {
      // Se não gravar, a escolha continua valendo até o app fechar.
    }
  }
}
