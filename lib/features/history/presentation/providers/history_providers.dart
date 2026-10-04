import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/features/history/data/activity_repository_provider.dart';
import 'package:runmares/features/history/domain/activity_details.dart';
import 'package:runmares/features/history/domain/activity_summary.dart';

final activitySummariesProvider = StreamProvider<List<ActivitySummary>>(
  (ref) => ref.watch(activityRepositoryProvider).watchSummaries(),
);

final activityDetailsProvider = FutureProvider.family<ActivityDetails?, int>(
  (ref, id) => ref.watch(activityRepositoryProvider).findDetails(id),
);
