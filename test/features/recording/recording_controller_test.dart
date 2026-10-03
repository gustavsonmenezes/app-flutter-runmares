import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/recording_status.dart';
import 'package:runmares/features/recording/presentation/controllers/recording_controller.dart';

void main() {
  late ProviderContainer container;
  late RecordingController controller;

  RecordingStatus currentStatus() {
    return container.read(recordingControllerProvider).status;
  }

  setUp(() {
    container = ProviderContainer();
    controller = container.read(recordingControllerProvider.notifier);
  });

  tearDown(() => container.dispose());

  test('starts idle', () {
    expect(currentStatus(), RecordingStatus.idle);
  });

  test('goes through start, pause, resume and finish', () {
    controller.start();
    expect(currentStatus(), RecordingStatus.recording);

    controller.pause();
    expect(currentStatus(), RecordingStatus.paused);

    controller.resume();
    expect(currentStatus(), RecordingStatus.recording);

    controller.finish();
    expect(currentStatus(), RecordingStatus.finished);
  });

  test('ignores pause and finish before the activity starts', () {
    controller.pause();
    controller.finish();

    expect(currentStatus(), RecordingStatus.idle);
  });

  test('does not change the activity type while recording', () {
    controller.start();
    controller.selectActivityType(ActivityType.cycling);

    expect(
      container.read(recordingControllerProvider).activityType,
      ActivityType.running,
    );
  });

  test('reset returns to idle and keeps the activity type', () {
    controller.selectActivityType(ActivityType.walking);
    controller.start();
    controller.finish();

    controller.reset();

    final state = container.read(recordingControllerProvider);
    expect(state.status, RecordingStatus.idle);
    expect(state.activityType, ActivityType.walking);
  });
}
