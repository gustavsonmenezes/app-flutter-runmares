import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/recording/domain/geo_distance.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

TrackPoint _point(double latitude, double longitude) {
  return TrackPoint(
    latitude: latitude,
    longitude: longitude,
    accuracyMeters: 5,
    timestamp: DateTime(2026),
  );
}

void main() {
  test('is zero between identical points', () {
    expect(GeoDistance.betweenMeters(_point(0, 0), _point(0, 0)), 0);
  });

  test('measures about 111 m for 0.001 degrees of latitude', () {
    final distance = GeoDistance.betweenMeters(_point(0, 0), _point(0.001, 0));

    expect(distance, closeTo(111.2, 0.5));
  });
}
