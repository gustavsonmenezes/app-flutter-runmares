import 'package:runmares/features/history/domain/recorded_activity.dart';

abstract interface class ActivityRepository {
  Future<int> save(RecordedActivity activity);
}
