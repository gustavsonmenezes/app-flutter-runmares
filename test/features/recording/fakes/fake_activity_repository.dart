import 'package:runmares/features/history/domain/activity_details.dart';
import 'package:runmares/features/history/domain/activity_repository.dart';
import 'package:runmares/features/history/domain/activity_summary.dart';
import 'package:runmares/features/history/domain/pending_activity.dart';
import 'package:runmares/features/history/domain/recorded_activity.dart';

class FakeActivityRepository implements ActivityRepository {
  FakeActivityRepository({this.shouldFail = false});

  bool shouldFail;
  final List<RecordedActivity> saved = [];
  final List<ActivitySummary> summaries = [];
  final Map<int, ActivityDetails> details = {};
  final List<PendingActivity> pending = [];
  final List<int> syncedIds = [];

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

  @override
  Future<List<PendingActivity>> findPending(String userId) async {
    return List.of(pending);
  }

  @override
  Future<void> markSynced(int id, DateTime syncedAt) async {
    syncedIds.add(id);
    pending.removeWhere((item) => item.id == id);
  }
}
