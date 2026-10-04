import 'package:runmares/features/history/domain/activity_details.dart';
import 'package:runmares/features/history/domain/activity_repository.dart';
import 'package:runmares/features/history/domain/activity_summary.dart';
import 'package:runmares/features/history/domain/recorded_activity.dart';

class FakeActivityRepository implements ActivityRepository {
  FakeActivityRepository({this.shouldFail = false});

  bool shouldFail;
  final List<RecordedActivity> saved = [];
  final List<ActivitySummary> summaries = [];
  final Map<int, ActivityDetails> details = {};

  @override
  Future<int> save(RecordedActivity activity) async {
    if (shouldFail) throw Exception('save failed');
    saved.add(activity);
    return saved.length;
  }

  @override
  Stream<List<ActivitySummary>> watchSummaries(String userId) {
    return Stream.value(List.unmodifiable(summaries));
  }

  @override
  Future<ActivityDetails?> findDetails(
    int id, {
    required String userId,
  }) async => details[id];
}
