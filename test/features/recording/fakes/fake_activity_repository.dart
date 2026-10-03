import 'package:runmares/features/history/domain/activity_repository.dart';
import 'package:runmares/features/history/domain/recorded_activity.dart';

class FakeActivityRepository implements ActivityRepository {
  FakeActivityRepository({this.shouldFail = false});

  bool shouldFail;
  final List<RecordedActivity> saved = [];

  @override
  Future<int> save(RecordedActivity activity) async {
    if (shouldFail) throw Exception('save failed');
    saved.add(activity);
    return saved.length;
  }
}
