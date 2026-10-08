import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/auth/data/auth_repository_provider.dart';
import 'package:runmares/features/auth/domain/auth_user.dart';
import 'package:runmares/features/history/data/activity_repository_provider.dart';
import 'package:runmares/features/recording/data/recording_draft_repository_provider.dart';
import 'package:runmares/features/recording/domain/track_point.dart';
import 'package:runmares/features/recording/presentation/controllers/recording_controller.dart';
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
  late ProviderContainer container;
  late RecordingController controller;

  int? currentPace() {
    return container
        .read(recordingControllerProvider)
        .currentPaceSecondsPerKilometer;
  }

  Future<void> feed(List<TrackPoint> points) async {
    points.forEach(locationUpdates.add);
    await pumpEventQueue();
  }

  setUp(() {
    locationUpdates = StreamController<TrackPoint>.broadcast();
    final auth = FakeAuthRepository(
      initialUser: const AuthUser(uid: 'user-1', email: 'ana@exemplo.com'),
    );
    container = ProviderContainer(
      overrides: [
        locationServiceProvider.overrideWithValue(
          FakeLocationService(locationUpdates.stream),
        ),
        activityRepositoryProvider.overrideWithValue(FakeActivityRepository()),
        recordingDraftRepositoryProvider.overrideWithValue(
          FakeRecordingDraftRepository(),
        ),
        authRepositoryProvider.overrideWithValue(auth),
        remoteActivityStoreProvider.overrideWithValue(
          FakeRemoteActivityStore(),
        ),
      ],
    );
    controller = container.read(recordingControllerProvider.notifier);

    addTearDown(() {
      container.dispose();
      locationUpdates.close();
      auth.dispose();
    });
  });

  test('has no current pace before there is enough movement', () async {
    controller.start();
    await feed([_point(0, 0)]);

    expect(currentPace(), isNull);
  });

  test('publishes the pace of the latest points', () async {
    controller.start();
    await feed([_point(0, 0), _point(0.001, 30)]);

    expect(currentPace(), closeTo(270, 1));
  });

  test('clears the current pace when the activity is paused', () async {
    controller.start();
    await feed([_point(0, 0), _point(0.001, 30)]);

    controller.pause();

    expect(currentPace(), isNull);
  });

  test('clears the current pace when the activity is finished', () async {
    controller.start();
    await feed([_point(0, 0), _point(0.001, 30)]);

    await controller.finish();

    expect(currentPace(), isNull);
  });

  test('starts again without the pace of the previous activity', () async {
    controller.start();
    await feed([_point(0, 0), _point(0.001, 30)]);
    await controller.finish();
    controller.reset();

    controller.start();

    expect(currentPace(), isNull);
  });
}
