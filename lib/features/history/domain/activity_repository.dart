import 'package:runmares/features/history/domain/activity_details.dart';
import 'package:runmares/features/history/domain/activity_summary.dart';
import 'package:runmares/features/history/domain/recorded_activity.dart';

abstract interface class ActivityRepository {
  Future<int> save(RecordedActivity activity);

  Stream<List<ActivitySummary>> watchSummaries(String userId);

  Future<ActivityDetails?> findDetails(int id, {required String userId});
}
