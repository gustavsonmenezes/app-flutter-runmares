import 'package:runmares/features/history/domain/recorded_activity.dart';

class PendingActivity {
  const PendingActivity({required this.id, required this.activity});

  final int id;
  final RecordedActivity activity;
}
