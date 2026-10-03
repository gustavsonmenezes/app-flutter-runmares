import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:runmares/features/recording/domain/location_failure.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

class LocationService {
  static const int _distanceFilterMeters = 5;
  static const String _notificationTitle = 'RunMares';
  static const String _notificationText = 'Gravando sua atividade';

  Stream<TrackPoint> watchPosition() async* {
    await _ensureAccess();
    yield* Geolocator.getPositionStream(
      locationSettings: _buildSettings(),
    ).map(_toTrackPoint);
  }

  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  // No Android, a notificação fixa mantém o GPS ativo com a tela apagada.
  // No iOS, o mesmo efeito vem do modo de localização em segundo plano.
  LocationSettings _buildSettings() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: _distanceFilterMeters,
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationTitle: _notificationTitle,
            notificationText: _notificationText,
            enableWakeLock: true,
            setOngoing: true,
          ),
        );
      case TargetPlatform.iOS:
        return AppleSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: _distanceFilterMeters,
          pauseLocationUpdatesAutomatically: false,
          showBackgroundLocationIndicator: true,
          allowBackgroundLocationUpdates: true,
        );
      default:
        return const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: _distanceFilterMeters,
        );
    }
  }

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
