import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/location_failure.dart';
import 'package:runmares/features/recording/domain/recording_status.dart';

class RecordingState {
  const RecordingState({
    this.status = RecordingStatus.idle,
    this.activityType = ActivityType.running,
    this.distanceMeters = 0,
    this.locationFailure,
  });

  final RecordingStatus status;
  final ActivityType activityType;
  final double distanceMeters;
  final LocationFailureReason? locationFailure;

  RecordingState copyWith({
    RecordingStatus? status,
    ActivityType? activityType,
    double? distanceMeters,
    LocationFailureReason? locationFailure,
    bool clearLocationFailure = false,
  }) {
    return RecordingState(
      status: status ?? this.status,
      activityType: activityType ?? this.activityType,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      locationFailure: clearLocationFailure
          ? null
          : locationFailure ?? this.locationFailure,
    );
  }
}
