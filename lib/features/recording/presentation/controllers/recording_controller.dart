import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/features/recording/data/location_service.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/distance_tracker.dart';
import 'package:runmares/features/recording/domain/location_failure.dart';
import 'package:runmares/features/recording/domain/recording_status.dart';
import 'package:runmares/features/recording/domain/track_point.dart';
import 'package:runmares/features/recording/presentation/controllers/recording_state.dart';

final locationServiceProvider = Provider<LocationService>(
  (ref) => LocationService(),
);

final recordingControllerProvider =
    NotifierProvider<RecordingController, RecordingState>(
      RecordingController.new,
    );

class RecordingController extends Notifier<RecordingState> {
  final DistanceTracker _tracker = DistanceTracker();
  StreamSubscription<TrackPoint>? _subscription;

  @override
  RecordingState build() {
    ref.onDispose(_stopListening);
    _tracker.reset();
    return const RecordingState();
  }

  void selectActivityType(ActivityType type) {
    if (state.status != RecordingStatus.idle) return;
    state = state.copyWith(activityType: type);
  }

  void start() {
    if (state.status != RecordingStatus.idle) return;

    _tracker.reset();
    state = state.copyWith(
      status: RecordingStatus.recording,
      distanceMeters: 0,
      clearLocationFailure: true,
    );
    _startListening();
  }

  void pause() {
    if (state.status != RecordingStatus.recording) return;

    _stopListening();
    state = state.copyWith(status: RecordingStatus.paused);
  }

  void resume() {
    if (state.status != RecordingStatus.paused) return;

    state = state.copyWith(
      status: RecordingStatus.recording,
      clearLocationFailure: true,
    );
    _startListening();
  }

  void finish() {
    final canFinish =
        state.status == RecordingStatus.recording ||
        state.status == RecordingStatus.paused;
    if (!canFinish) return;

    _stopListening();
    state = state.copyWith(status: RecordingStatus.finished);
  }

  void reset() {
    _stopListening();
    _tracker.reset();
    state = RecordingState(activityType: state.activityType);
  }

  void _startListening() {
    _tracker.startNewSegment();
    _subscription = ref
        .read(locationServiceProvider)
        .watchPosition()
        .listen(_onPoint, onError: _onLocationError);
  }

  void _stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  void _onPoint(TrackPoint point) {
    _tracker.add(point);
    state = state.copyWith(distanceMeters: _tracker.totalMeters);
  }

  void _onLocationError(Object error) {
    _stopListening();

    final reason = error is LocationException
        ? error.reason
        : LocationFailureReason.unavailable;
    final status = _tracker.hasAcceptedPoint
        ? RecordingStatus.paused
        : RecordingStatus.idle;

    state = state.copyWith(status: status, locationFailure: reason);
  }
}
