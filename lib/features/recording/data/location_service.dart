import 'package:geolocator/geolocator.dart';

enum LocationFailureReason {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
}

class LocationException implements Exception {
  const LocationException(this.reason);

  final LocationFailureReason reason;
}

class LocationService {
  static const LocationSettings _settings = LocationSettings(
    accuracy: LocationAccuracy.high,
  );

  Future<Position> getCurrentPosition() async {
    await _ensureAccess();
    return Geolocator.getCurrentPosition(locationSettings: _settings);
  }

  Future<bool> openAppSettings() => Geolocator.openAppSettings();

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
