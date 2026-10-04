import 'package:runmares/features/recording/domain/activity_save_status.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/location_failure.dart';
import 'package:runmares/features/recording/domain/pace_calculator.dart';
import 'package:runmares/features/recording/domain/recording_status.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

class RecordingState {
  const RecordingState({
    this.status = RecordingStatus.idle,
    this.activityType = ActivityType.running,
    this.distanceMeters = 0,
    this.elapsed = Duration.zero,
    this.routeSegments = const [],
    this.saveStatus = ActivitySaveStatus.none,
    this.locationFailure,
  });

  final RecordingStatus status;
  final ActivityType activityType;
  final double distanceMeters;
  final Duration elapsed;
  final List<List<TrackPoint>> routeSegments;
  final ActivitySaveStatus saveStatus;
  final LocationFailureReason? locationFailure;

  int? get averagePaceSecondsPerKilometer {
    return PaceCalculator.secondsPerKilometer(
      distanceMeters: distanceMeters,
      elapsed: elapsed,
    );
  }

  RecordingState copyWith({
    RecordingStatus? status,
    ActivityType? activityType,
    double? distanceMeters,
    Duration? elapsed,
    List<List<TrackPoint>>? routeSegments,
    ActivitySaveStatus? saveStatus,
    LocationFailureReason? locationFailure,
    bool clearLocationFailure = false,
  }) {
    return RecordingState(
      status: status ?? this.status,
      activityType: activityType ?? this.activityType,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      elapsed: elapsed ?? this.elapsed,
      routeSegments: routeSegments ?? this.routeSegments,
      saveStatus: saveStatus ?? this.saveStatus,
      locationFailure: clearLocationFailure
          ? null
          : locationFailure ?? this.locationFailure,
    );
  }
}
