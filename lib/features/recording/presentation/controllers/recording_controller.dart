import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/features/recording/data/location_service.dart';
import 'package:runmares/features/recording/domain/activity_timer.dart';
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
  static const Duration _tickInterval = Duration(seconds: 1);

  final DistanceTracker _tracker = DistanceTracker();
  final ActivityTimer _timer = ActivityTimer();
  StreamSubscription<TrackPoint>? _subscription;
  Timer? _ticker;

  @override
  RecordingState build() {
    ref.onDispose(_stopTracking);
    _tracker.reset();
    _timer.reset();
    return const RecordingState();
  }

  void selectActivityType(ActivityType type) {
    if (state.status != RecordingStatus.idle) return;
    state = state.copyWith(activityType: type);
  }

  void start() {
    if (state.status != RecordingStatus.idle) return;

    _tracker.reset();
    _timer.reset();
    state = state.copyWith(
      status: RecordingStatus.recording,
      distanceMeters: 0,
      elapsed: Duration.zero,
      routeSegments: const [],
      clearLocationFailure: true,
    );
    _startTracking();
  }

  void pause() {
    if (state.status != RecordingStatus.recording) return;

    _stopTracking();
    state = state.copyWith(
      status: RecordingStatus.paused,
      elapsed: _timer.elapsed,
    );
  }

  void resume() {
    if (state.status != RecordingStatus.paused) return;

    state = state.copyWith(
      status: RecordingStatus.recording,
      clearLocationFailure: true,
    );
    _startTracking();
  }

  void finish() {
    final canFinish =
        state.status == RecordingStatus.recording ||
        state.status == RecordingStatus.paused;
    if (!canFinish) return;

    _stopTracking();
    state = state.copyWith(
      status: RecordingStatus.finished,
      elapsed: _timer.elapsed,
    );
  }

  void reset() {
    _stopTracking();
    _tracker.reset();
    _timer.reset();
    state = RecordingState(activityType: state.activityType);
  }

  void _startTracking() {
    _timer.start();
    _tracker.startNewSegment();
    _subscription = ref
        .read(locationServiceProvider)
        .watchPosition()
        .listen(_onPoint, onError: _onLocationError);
    _ticker = Timer.periodic(_tickInterval, (_) => _publishElapsed());
  }

  void _stopTracking() {
    _subscription?.cancel();
    _subscription = null;
    _ticker?.cancel();
    _ticker = null;
    _timer.pause();
  }

  void _publishElapsed() {
    state = state.copyWith(elapsed: _timer.elapsed);
  }

  void _onPoint(TrackPoint point) {
    _tracker.add(point);
    state = state.copyWith(
      distanceMeters: _tracker.totalMeters,
      routeSegments: _tracker.segments,
    );
  }

  void _onLocationError(Object error) {
    _stopTracking();

    final reason = error is LocationException
        ? error.reason
        : LocationFailureReason.unavailable;
    final hasRecordedDistance = _tracker.hasAcceptedPoint;
    if (!hasRecordedDistance) _timer.reset();

    state = state.copyWith(
      status: hasRecordedDistance
          ? RecordingStatus.paused
          : RecordingStatus.idle,
      elapsed: _timer.elapsed,
      locationFailure: reason,
    );
  }
}
