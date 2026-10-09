import 'package:runmares/core/formatters/distance_unit.dart';
import 'package:runmares/core/widgets/map_style.dart';

class AppSettings {
  const AppSettings({
    this.distanceUnit = DistanceUnit.kilometers,
    this.mapStyle = MapStyle.standard,
    this.audioAnnouncementsEnabled = true,
  });

  final DistanceUnit distanceUnit;
  final MapStyle mapStyle;
  final bool audioAnnouncementsEnabled;

  AppSettings copyWith({
    DistanceUnit? distanceUnit,
    MapStyle? mapStyle,
    bool? audioAnnouncementsEnabled,
  }) {
    return AppSettings(
      distanceUnit: distanceUnit ?? this.distanceUnit,
      mapStyle: mapStyle ?? this.mapStyle,
      audioAnnouncementsEnabled:
          audioAnnouncementsEnabled ?? this.audioAnnouncementsEnabled,
    );
  }
}
