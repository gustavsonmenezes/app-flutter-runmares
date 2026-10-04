import 'package:runmares/features/recording/domain/activity_type.dart';

class ActivitySummary {
  const ActivitySummary({
    required this.id,
    required this.type,
    required this.startedAt,
    required this.duration,
    required this.distanceMeters,
    this.isSynced = false,
  });

  final int id;
  final ActivityType type;
  final DateTime startedAt;
  final Duration duration;
  final double distanceMeters;
  final bool isSynced;
}
