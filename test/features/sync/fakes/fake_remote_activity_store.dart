import 'dart:async';

import 'package:runmares/features/history/domain/recorded_activity.dart';
import 'package:runmares/features/sync/domain/remote_activity_store.dart';

class FakeRemoteActivityStore implements RemoteActivityStore {
  bool shouldFail = false;
  Completer<void>? gate;
  final List<RecordedActivity> uploaded = [];

  @override
  Future<void> upload(RecordedActivity activity) async {
    await gate?.future;
    if (shouldFail) throw Exception('offline');
    uploaded.add(activity);
  }
}
