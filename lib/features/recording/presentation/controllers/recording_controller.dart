import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/recording_status.dart';
import 'package:runmares/features/recording/presentation/controllers/recording_state.dart';

final recordingControllerProvider =
    NotifierProvider<RecordingController, RecordingState>(
      RecordingController.new,
    );

class RecordingController extends Notifier<RecordingState> {
  @override
  RecordingState build() => const RecordingState();

  void selectActivityType(ActivityType type) {
    if (state.status != RecordingStatus.idle) return;
    state = state.copyWith(activityType: type);
  }

  void start() {
    _moveTo(RecordingStatus.recording, allowedFrom: {RecordingStatus.idle});
  }

  void pause() {
    _moveTo(RecordingStatus.paused, allowedFrom: {RecordingStatus.recording});
  }

  void resume() {
    _moveTo(RecordingStatus.recording, allowedFrom: {RecordingStatus.paused});
  }

  void finish() {
    _moveTo(
      RecordingStatus.finished,
      allowedFrom: {RecordingStatus.recording, RecordingStatus.paused},
    );
  }

  void reset() {
    state = RecordingState(activityType: state.activityType);
  }

  void _moveTo(
    RecordingStatus next, {
    required Set<RecordingStatus> allowedFrom,
  }) {
    if (!allowedFrom.contains(state.status)) return;
    state = state.copyWith(status: next);
  }
}
