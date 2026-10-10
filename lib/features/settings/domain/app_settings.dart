import 'package:flutter/material.dart';
import 'package:runmares/core/formatters/distance_unit.dart';
import 'package:runmares/core/widgets/map_style.dart';

class AppSettings {
  const AppSettings({
    this.distanceUnit = DistanceUnit.kilometers,
    this.mapStyle = MapStyle.standard,
    this.audioAnnouncementsEnabled = true,
    this.themeMode = ThemeMode.dark,
  });

  final DistanceUnit distanceUnit;
  final MapStyle mapStyle;
  final bool audioAnnouncementsEnabled;
  final ThemeMode themeMode;

  AppSettings copyWith({
    DistanceUnit? distanceUnit,
    MapStyle? mapStyle,
    bool? audioAnnouncementsEnabled,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      distanceUnit: distanceUnit ?? this.distanceUnit,
      mapStyle: mapStyle ?? this.mapStyle,
      audioAnnouncementsEnabled:
          audioAnnouncementsEnabled ?? this.audioAnnouncementsEnabled,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
