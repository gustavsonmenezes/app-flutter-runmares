import 'package:geolocator/geolocator.dart';
import 'package:runmares/features/recording/domain/location_failure.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

class LocationService {
  static const int _distanceFilterMeters = 5;
  static const LocationSettings _settings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: _distanceFilterMeters,
  );

  Stream<TrackPoint> watchPosition() async* {
    await _ensureAccess();
    yield* Geolocator.getPositionStream(
      locationSettings: _settings,
    ).map(_toTrackPoint);
  }

  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  TrackPoint _toTrackPoint(Position position) {
    return TrackPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracyMeters: position.accuracy,
      timestamp: position.timestamp,
    );
  }

  Future<void> _ensureAccess() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      throw const LocationException(LocationFailureReason.serviceDisabled);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    switch (permission) {
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return;
      case LocationPermission.deniedForever:
        throw const LocationException(
          LocationFailureReason.permissionDeniedForever,
        );
      case LocationPermission.denied:
      case LocationPermission.unableToDetermine:
        throw const LocationException(LocationFailureReason.permissionDenied);
    }
  }
}
