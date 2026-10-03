import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/core/database/app_database_provider.dart';
import 'package:runmares/features/history/data/drift_activity_repository.dart';
import 'package:runmares/features/history/domain/activity_repository.dart';

final activityRepositoryProvider = Provider<ActivityRepository>(
  (ref) => DriftActivityRepository(ref.watch(appDatabaseProvider)),
);
