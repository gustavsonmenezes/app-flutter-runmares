import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/features/auth/presentation/providers/current_user_provider.dart';
import 'package:runmares/features/history/data/activity_repository_provider.dart';
import 'package:runmares/features/history/domain/activity_details.dart';
import 'package:runmares/features/history/domain/activity_summary.dart';

final activitySummariesProvider = StreamProvider<List<ActivitySummary>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(const []);

  return ref.watch(activityRepositoryProvider).watchSummaries(user.uid);
});

final activityDetailsProvider = FutureProvider.family<ActivityDetails?, int>((
  ref,
  id,
) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  return ref
      .watch(activityRepositoryProvider)
      .findDetails(id, userId: user.uid);
});
