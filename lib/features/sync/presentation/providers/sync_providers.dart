import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/features/auth/presentation/providers/current_user_provider.dart';
import 'package:runmares/features/history/data/activity_repository_provider.dart';
import 'package:runmares/features/sync/data/remote_activity_store_provider.dart';
import 'package:runmares/features/sync/domain/activity_sync_service.dart';

final activitySyncServiceProvider = Provider<ActivitySyncService>(
  (ref) => ActivitySyncService(
    repository: ref.watch(activityRepositoryProvider),
    remote: ref.watch(remoteActivityStoreProvider),
  ),
);

/// Envia as pendências sempre que o app abre com um usuário logado.
final autoSyncProvider = Provider<void>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return;

  unawaited(ref.read(activitySyncServiceProvider).syncPending(user.uid));
});
