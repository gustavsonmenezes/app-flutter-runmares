import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/features/auth/data/auth_repository_provider.dart';
import 'package:runmares/features/history/data/activity_repository_provider.dart';
import 'package:runmares/features/history/domain/recorded_activity.dart';
import 'package:runmares/features/recording/data/location_service.dart';
import 'package:runmares/features/recording/data/recording_draft_repository_provider.dart';
import 'package:runmares/features/recording/domain/activity_save_status.dart';
import 'package:runmares/features/recording/domain/activity_timer.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/current_pace_calculator.dart';
import 'package:runmares/features/recording/domain/distance_tracker.dart';
import 'package:runmares/features/recording/domain/location_failure.dart';
import 'package:runmares/features/recording/domain/recording_status.dart';
import 'package:runmares/features/recording/domain/track_point.dart';
import 'package:runmares/features/recording/presentation/controllers/recording_state.dart';
import 'package:runmares/features/sync/presentation/providers/sync_providers.dart';

final locationServiceProvider = Provider<LocationService>(
  (ref) => LocationService(),
);

final recordingControllerProvider =
    NotifierProvider<RecordingController, RecordingState>(
      RecordingController.new,
    );

class RecordingController extends Notifier<RecordingState> {
  static const Duration _tickInterval = Duration(seconds: 1);
  static const Duration _stalePaceAfter = Duration(seconds: 15);

  final DistanceTracker _tracker = DistanceTracker();
  final ActivityTimer _timer = ActivityTimer();
  StreamSubscription<TrackPoint>? _subscription;
  Timer? _ticker;
  DateTime? _startedAt;
  Duration _lastPointElapsed = Duration.zero;
  String? _draftUserId;
  Future<void> _draftQueue = Future.value();
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
    _lastPointElapsed = Duration.zero;
    final startedAt = DateTime.now();
    _startedAt = startedAt;
    state = state.copyWith(
      status: RecordingStatus.recording,
      distanceMeters: 0,
      elapsed: Duration.zero,
      routeSegments: const [],
      clearCurrentPace: true,
      saveStatus: ActivitySaveStatus.none,
      clearLocationFailure: true,
    );
    _beginDraft(startedAt);
    _startTracking();
  }

  void pause() {
    if (state.status != RecordingStatus.recording) return;

    _stopTracking();
    state = state.copyWith(
      status: RecordingStatus.paused,
      elapsed: _timer.elapsed,
      clearCurrentPace: true,
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
      clearCurrentPace: true,
    );
    await _saveActivity();
  }

  void reset() {
    _stopTracking();
    _tracker.reset();
    _timer.reset();
    _startedAt = null;
    _lastPointElapsed = Duration.zero;
    state = RecordingState(activityType: state.activityType);
  }

  Future<void> _saveActivity() async {
    final startedAt = _startedAt;
    final segments = _tracker.segments;
    if (startedAt == null || segments.isEmpty) {
      _discardDraft();
      return;
    }

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
      // O rascunho só some depois que a atividade foi salva de verdade.
      _discardDraft();
      _syncInBackground(userId);
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

  void _syncInBackground(String userId) {
    if (_isDisposed) return;
    unawaited(ref.read(activitySyncServiceProvider).syncPending(userId));
  }

  void _beginDraft(DateTime startedAt) {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    _draftUserId = userId;
    if (userId == null) return;

    final drafts = ref.read(recordingDraftRepositoryProvider);
    final type = state.activityType;
    _enqueueDraftWrite(
      () => drafts.begin(userId: userId, type: type, startedAt: startedAt),
    );
  }

  void _persistPoint(TrackPoint point) {
    final userId = _draftUserId;
    if (userId == null) return;

    final drafts = ref.read(recordingDraftRepositoryProvider);
    final segmentIndex = _tracker.segmentCount - 1;
    final elapsed = _timer.elapsed;
    _enqueueDraftWrite(
      () => drafts.appendPoint(
        userId: userId,
        segmentIndex: segmentIndex,
        point: point,
        elapsed: elapsed,
      ),
    );
  }

  void _discardDraft() {
    final userId = _draftUserId;
    if (userId == null || _isDisposed) return;

    final drafts = ref.read(recordingDraftRepositoryProvider);
    _enqueueDraftWrite(() => drafts.discard(userId));
  }

  // As escritas do rascunho entram numa fila para manter a ordem dos pontos.
  // Uma falha aqui não pode interromper a gravação em andamento.
  void _enqueueDraftWrite(Future<void> Function() write) {
    _draftQueue = _draftQueue.then((_) => write()).catchError((Object _) {});
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
    final elapsed = _timer.elapsed;
    final isPaceStale =
        state.currentPaceSecondsPerKilometer != null &&
        elapsed - _lastPointElapsed > _stalePaceAfter;

    state = isPaceStale
        ? state.copyWith(elapsed: elapsed, clearCurrentPace: true)
        : state.copyWith(elapsed: elapsed);
  }

  void _onPoint(TrackPoint point) {
    final accepted = _tracker.add(point);
    var next = state.copyWith(
      distanceMeters: _tracker.totalMeters,
      routeSegments: _tracker.segments,
    );

    if (accepted) {
      _lastPointElapsed = _timer.elapsed;
      next = _withCurrentPace(next);
      _persistPoint(point);
    }
    state = next;
  }

  RecordingState _withCurrentPace(RecordingState base) {
    final segments = _tracker.segments;
    final pace = segments.isEmpty
        ? null
        : CurrentPaceCalculator.secondsPerKilometer(segments.last);

    return pace == null
        ? base.copyWith(clearCurrentPace: true)
        : base.copyWith(currentPaceSecondsPerKilometer: pace);
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
      clearCurrentPace: true,
      locationFailure: reason,
    );
  }
}
