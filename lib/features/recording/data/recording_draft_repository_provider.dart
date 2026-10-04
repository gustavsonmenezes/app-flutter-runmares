import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/core/database/app_database_provider.dart';
import 'package:runmares/features/recording/data/drift_recording_draft_repository.dart';
import 'package:runmares/features/recording/domain/recording_draft_repository.dart';

final recordingDraftRepositoryProvider = Provider<RecordingDraftRepository>(
  (ref) => DriftRecordingDraftRepository(ref.watch(appDatabaseProvider)),
);
