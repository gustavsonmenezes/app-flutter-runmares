import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/recording/domain/distance_announcement_tracker.dart';

void main() {
  group('DistanceAnnouncementTracker', () {
    test('returns null when distance is below 1km', () {
      final tracker = DistanceAnnouncementTracker();

      expect(tracker.checkNewKilometerMilestone(0), isNull);
      expect(tracker.checkNewKilometerMilestone(500), isNull);
      expect(tracker.checkNewKilometerMilestone(999), isNull);
      expect(tracker.lastAnnouncedKm, 0);
    });

    test('detects milestone at 1km', () {
      final tracker = DistanceAnnouncementTracker();

      expect(tracker.checkNewKilometerMilestone(1000), 1);
      expect(tracker.lastAnnouncedKm, 1);
      // Repeating checks at 1005m should not re-announce
      expect(tracker.checkNewKilometerMilestone(1005), isNull);
    });

    test('detects successive milestones at 2km and 3km', () {
      final tracker = DistanceAnnouncementTracker();

      expect(tracker.checkNewKilometerMilestone(1050), 1);
      expect(tracker.checkNewKilometerMilestone(1800), isNull);
      expect(tracker.checkNewKilometerMilestone(2010), 2);
      expect(tracker.checkNewKilometerMilestone(3000), 3);
      expect(tracker.lastAnnouncedKm, 3);
    });

    test('resets last announced milestone', () {
      final tracker = DistanceAnnouncementTracker();

      tracker.checkNewKilometerMilestone(2500);
      expect(tracker.lastAnnouncedKm, 2);

      tracker.reset();
      expect(tracker.lastAnnouncedKm, 0);
      expect(tracker.checkNewKilometerMilestone(1000), 1);
    });
  });
}
