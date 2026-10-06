import 'package:runmares/core/formatters/distance_unit.dart';
import 'package:runmares/core/widgets/map_style.dart';

class AppSettings {
  const AppSettings({
    this.distanceUnit = DistanceUnit.kilometers,
    this.mapStyle = MapStyle.standard,
  });

  final DistanceUnit distanceUnit;
  final MapStyle mapStyle;

  AppSettings copyWith({DistanceUnit? distanceUnit, MapStyle? mapStyle}) {
    return AppSettings(
      distanceUnit: distanceUnit ?? this.distanceUnit,
      mapStyle: mapStyle ?? this.mapStyle,
    );
  }
}
