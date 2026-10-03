enum LocationFailureReason {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  unavailable,
}

class LocationException implements Exception {
  const LocationException(this.reason);

  final LocationFailureReason reason;
}
