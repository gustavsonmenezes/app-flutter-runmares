abstract class AudioAnnouncer {
  Future<void> announceKilometer({
    required int kilometerNumber,
    required Duration totalElapsed,
    required int? averagePaceSecondsPerKm,
  });

  Future<void> speak(String text);
  Future<void> stop();
}
