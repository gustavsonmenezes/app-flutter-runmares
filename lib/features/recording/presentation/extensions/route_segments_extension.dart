import 'package:latlong2/latlong.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

extension RouteSegmentsLatLng on List<List<TrackPoint>> {
  List<List<LatLng>> toLatLngSegments() {
    return [
      for (final segment in this)
        [for (final point in segment) LatLng(point.latitude, point.longitude)],
    ];
  }
}
