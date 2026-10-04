import 'package:runmares/features/history/domain/recorded_activity.dart';

abstract interface class RemoteActivityStore {
  Future<void> upload(RecordedActivity activity);
}
