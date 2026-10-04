import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/auth/data/auth_repository_provider.dart';
import 'package:runmares/features/auth/domain/auth_user.dart';
import 'package:runmares/features/history/data/activity_repository_provider.dart';
import 'package:runmares/features/recording/data/recording_draft_repository_provider.dart';
import 'package:runmares/features/recording/domain/activity_save_status.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/location_failure.dart';
import 'package:runmares/features/recording/domain/recording_status.dart';
import 'package:runmares/features/recording/domain/track_point.dart';
import 'package:runmares/features/recording/presentation/controllers/recording_controller.dart';
import 'package:runmares/features/recording/presentation/controllers/recording_state.dart';
import 'package:runmares/features/sync/data/remote_activity_store_provider.dart';

import '../auth/fakes/fake_auth_repository.dart';
import '../sync/fakes/fake_remote_activity_store.dart';
import 'fakes/fake_activity_repository.dart';
import 'fakes/fake_location_service.dart';
import 'fakes/fake_recording_draft_repository.dart';

TrackPoint _point(double latitude, int seconds) {
  return TrackPoint(
    latitude: latitude,
    longitude: 0,
    accuracyMeters: 5,
    timestamp: DateTime(2026).add(Duration(seconds: seconds)),
  );
}

void main() {
  late StreamController<TrackPoint> locationUpdates;
  late FakeActivityRepository repository;
  late FakeRecordingDraftRepository draftRepository;
  late FakeAuthRepository authRepository;
  late ProviderContainer container;
  late RecordingController controller;

  RecordingState currentState() => container.read(recordingControllerProvider);

  ProviderContainer containerWith(FakeLocationService service) {
    return ProviderContainer(
      overrides: [
        locationServiceProvider.overrideWithValue(service),
        activityRepositoryProvider.overrideWithValue(repository),
        recordingDraftRepositoryProvider.overrideWithValue(draftRepository),
        authRepositoryProvider.overrideWithValue(authRepository),
        remoteActivityStoreProvider.overrideWithValue(
          FakeRemoteActivityStore(),
        ),
      ],
    );
  }

  setUp(() {
    locationUpdates = StreamController<TrackPoint>.broadcast();
    repository = FakeActivityRepository();
    draftRepository = FakeRecordingDraftRepository();
    authRepository = FakeAuthRepository(
      initialUser: const AuthUser(uid: 'user-1', email: 'ana@exemplo.com'),
    );
    container = containerWith(FakeLocationService(locationUpdates.stream));
    controller = container.read(recordingControllerProvider.notifier);
  });

  tearDown(() {
    container.dispose();
    locationUpdates.close();
    authRepository.dispose();
  });

  test('starts idle', () {
    expect(currentState().status, RecordingStatus.idle);
  });

  test('goes through start, pause, resume and finish', () {
    controller.start();
    expect(currentState().status, RecordingStatus.recording);

    controller.pause();
    expect(currentState().status, RecordingStatus.paused);

    controller.resume();
    expect(currentState().status, RecordingStatus.recording);

    controller.finish();
    expect(currentState().status, RecordingStatus.finished);
  });

  test('ignores pause and finish before the activity starts', () {
    controller.pause();
    controller.finish();

    expect(currentState().status, RecordingStatus.idle);
  });

  test('does not change the activity type while recording', () {
    controller.start();
    controller.selectActivityType(ActivityType.cycling);

    expect(currentState().activityType, ActivityType.running);
  });

  test('reset returns to idle and keeps the activity type', () async {
    controller.selectActivityType(ActivityType.walking);
    controller.start();
    locationUpdates.add(_point(0, 0));
    locationUpdates.add(_point(0.001, 30));
    await pumpEventQueue();

    controller.finish();
    controller.reset();
    await pumpEventQueue();

    expect(currentState().status, RecordingStatus.idle);
    expect(currentState().activityType, ActivityType.walking);
    expect(currentState().distanceMeters, 0);
    expect(currentState().saveStatus, ActivitySaveStatus.none);
  });

  test('accumulates the distance from location updates', () async {
    controller.start();
    locationUpdates.add(_point(0, 0));
    locationUpdates.add(_point(0.001, 30));
    await pumpEventQueue();

    expect(currentState().distanceMeters, closeTo(111.2, 0.5));
  });

  test('does not count the distance travelled while paused', () async {
    controller.start();
    locationUpdates.add(_point(0, 0));
    locationUpdates.add(_point(0.001, 30));
    await pumpEventQueue();

    controller.pause();
    locationUpdates.add(_point(0.2, 60));
    await pumpEventQueue();

    controller.resume();
    locationUpdates.add(_point(0.5, 600));
    locationUpdates.add(_point(0.501, 630));
    await pumpEventQueue();

    expect(currentState().distanceMeters, closeTo(222.4, 1));
  });

  test('keeps the route in separate segments around a pause', () async {
    controller.start();
    locationUpdates.add(_point(0, 0));
    locationUpdates.add(_point(0.001, 30));
    await pumpEventQueue();

    controller.pause();
    controller.resume();
    locationUpdates.add(_point(0.5, 600));
    locationUpdates.add(_point(0.501, 630));
    await pumpEventQueue();

    expect(currentState().routeSegments, hasLength(2));
  });

  test('saves the finished activity for the logged user', () async {
    controller.selectActivityType(ActivityType.walking);
    controller.start();
    locationUpdates.add(_point(0, 0));
    locationUpdates.add(_point(0.001, 30));
    await pumpEventQueue();

    await controller.finish();

    expect(repository.saved, hasLength(1));
    expect(repository.saved.single.userId, 'user-1');
    expect(repository.saved.single.type, ActivityType.walking);
    expect(repository.saved.single.distanceMeters, closeTo(111.2, 0.5));
    expect(repository.saved.single.segments.single, hasLength(2));
    expect(currentState().saveStatus, ActivitySaveStatus.saved);
  });

  test('does not save an activity without location points', () async {
    controller.start();

    await controller.finish();

    expect(repository.saved, isEmpty);
    expect(currentState().saveStatus, ActivitySaveStatus.none);
  });

  test('reports a failure when saving fails', () async {
    repository.shouldFail = true;
    controller.start();
    locationUpdates.add(_point(0, 0));
    await pumpEventQueue();

    await controller.finish();

    expect(currentState().status, RecordingStatus.finished);
    expect(currentState().saveStatus, ActivitySaveStatus.failed);
  });

  test('does not save when nobody is logged in', () async {
    await authRepository.signOut();
    controller.start();
    locationUpdates.add(_point(0, 0));
    await pumpEventQueue();

    await controller.finish();

    expect(repository.saved, isEmpty);
    expect(currentState().saveStatus, ActivitySaveStatus.failed);
  });

  test('keeps a draft of the activity while it is recorded', () async {
    controller.selectActivityType(ActivityType.cycling);
    controller.start();
    locationUpdates.add(_point(0, 0));
    locationUpdates.add(_point(0.001, 30));
    await pumpEventQueue();

    final draft = draftRepository.draftOf('user-1');

    expect(draft, isNotNull);
    expect(draft!.type, ActivityType.cycling);
    expect(draft.segments.single, hasLength(2));
  });

  test('does not store discarded points in the draft', () async {
    controller.start();
    locationUpdates.add(_point(0, 0));
    locationUpdates.add(
      TrackPoint(
        latitude: 0.001,
        longitude: 0,
        accuracyMeters: 80,
        timestamp: DateTime(2026).add(const Duration(seconds: 30)),
      ),
    );
    await pumpEventQueue();

    expect(draftRepository.draftOf('user-1')!.segments.single, hasLength(1));
  });

  test('starts a new draft segment after a pause', () async {
    controller.start();
    locationUpdates.add(_point(0, 0));
    await pumpEventQueue();

    controller.pause();
    controller.resume();
    locationUpdates.add(_point(0.5, 600));
    await pumpEventQueue();

    expect(draftRepository.draftOf('user-1')!.segments, hasLength(2));
  });

  test('discards the draft once the activity is saved', () async {
    controller.start();
    locationUpdates.add(_point(0, 0));
    locationUpdates.add(_point(0.001, 30));
    await pumpEventQueue();

    await controller.finish();
    await pumpEventQueue();

    expect(repository.saved, hasLength(1));
    expect(draftRepository.draftOf('user-1'), isNull);
  });

  test('keeps the draft when saving fails', () async {
    repository.shouldFail = true;
    controller.start();
    locationUpdates.add(_point(0, 0));
    locationUpdates.add(_point(0.001, 30));
    await pumpEventQueue();

    await controller.finish();
    await pumpEventQueue();

    expect(draftRepository.draftOf('user-1'), isNotNull);
  });

  test('discards the draft of an activity without points', () async {
    controller.start();

    await controller.finish();
    await pumpEventQueue();

    expect(draftRepository.draftOf('user-1'), isNull);
  });

  test('goes back to idle when location is not available', () async {
    container.dispose();
    container = containerWith(
      FakeLocationService.failing(LocationFailureReason.permissionDenied),
    );
    controller = container.read(recordingControllerProvider.notifier);

    controller.start();
    await pumpEventQueue();

    expect(currentState().status, RecordingStatus.idle);
    expect(
      currentState().locationFailure,
      LocationFailureReason.permissionDenied,
    );
  });
}
