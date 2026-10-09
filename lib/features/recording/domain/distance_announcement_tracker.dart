class DistanceAnnouncementTracker {
  DistanceAnnouncementTracker({this.intervalMeters = 1000.0});

  final double intervalMeters;
  int _lastAnnouncedKm = 0;

  int get lastAnnouncedKm => _lastAnnouncedKm;

  /// Retorna o número do quilômetro se um novo marco de quilometragem foi atingido, ou `null` caso contrário.
  int? checkNewKilometerMilestone(double currentDistanceMeters) {
    if (currentDistanceMeters <= 0) return null;
    final targetKm = (currentDistanceMeters / intervalMeters).floor();
    if (targetKm > _lastAnnouncedKm) {
      _lastAnnouncedKm = targetKm;
      return targetKm;
    }
    return null;
  }

  void reset() {
    _lastAnnouncedKm = 0;
  }
}
