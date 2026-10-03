import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/recording_status.dart';

class RecordingState {
  const RecordingState({
    this.status = RecordingStatus.idle,
    this.activityType = ActivityType.running,
  });

  final RecordingStatus status;
  final ActivityType activityType;

  RecordingState copyWith({
    RecordingStatus? status,
    ActivityType? activityType,
  }) {
    return RecordingState(
      status: status ?? this.status,
      activityType: activityType ?? this.activityType,
    );
  }
}
