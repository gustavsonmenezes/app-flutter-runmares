import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/features/auth/data/auth_repository_provider.dart';
import 'package:runmares/features/history/data/activity_repository_provider.dart';
import 'package:runmares/features/history/domain/recorded_activity.dart';
import 'package:runmares/features/recording/data/location_service.dart';
import 'package:runmares/features/recording/domain/activity_save_status.dart';
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
  DateTime? _startedAt;
  bool _isDisposed = false;

  @override
  RecordingState build() {
    _isDisposed = false;
    ref.onDispose(() {
      _isDisposed = true;
      _stopTracking();
    });
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
    _startedAt = DateTime.now();
    state = state.copyWith(
      status: RecordingStatus.recording,
      distanceMeters: 0,
      elapsed: Duration.zero,
      routeSegments: const [],
      saveStatus: ActivitySaveStatus.none,
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

  Future<void> finish() async {
    final canFinish =
        state.status == RecordingStatus.recording ||
        state.status == RecordingStatus.paused;
    if (!canFinish) return;

    _stopTracking();
    state = state.copyWith(
      status: RecordingStatus.finished,
      elapsed: _timer.elapsed,
    );
    await _saveActivity();
  }

  void reset() {
    _stopTracking();
    _tracker.reset();
    _timer.reset();
    _startedAt = null;
    state = RecordingState(activityType: state.activityType);
  }

  Future<void> _saveActivity() async {
    final startedAt = _startedAt;
    final segments = _tracker.segments;
    if (startedAt == null || segments.isEmpty) return;

    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) {
      state = state.copyWith(saveStatus: ActivitySaveStatus.failed);
      return;
    }

    final activity = RecordedActivity(
      userId: userId,
      type: state.activityType,
      startedAt: startedAt,
      duration: state.elapsed,
      distanceMeters: state.distanceMeters,
      segments: segments,
    );

    state = state.copyWith(saveStatus: ActivitySaveStatus.saving);
    try {
      await ref.read(activityRepositoryProvider).save(activity);
      _updateSaveStatus(ActivitySaveStatus.saved);
    } on Exception {
      _updateSaveStatus(ActivitySaveStatus.failed);
    }
  }

  // Ignora o resultado se a tela já foi reiniciada ou descartada durante o
  // salvamento, para não sobrescrever o estado de uma nova atividade.
  void _updateSaveStatus(ActivitySaveStatus status) {
    if (_isDisposed || state.status != RecordingStatus.finished) return;
    state = state.copyWith(saveStatus: status);
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
