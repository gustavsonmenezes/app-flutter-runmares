import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/features/auth/presentation/providers/current_user_provider.dart';
import 'package:runmares/features/history/data/activity_repository_provider.dart';
import 'package:runmares/features/sync/data/remote_activity_store_provider.dart';
import 'package:runmares/features/sync/domain/activity_sync_service.dart';

const Duration syncRetryInterval = Duration(minutes: 1);

final activitySyncServiceProvider = Provider<ActivitySyncService>(
  (ref) => ActivitySyncService(
    repository: ref.watch(activityRepositoryProvider),
    remote: ref.watch(remoteActivityStoreProvider),
  ),
);

/// Envia as pendências ao abrir o app, a cada [syncRetryInterval] e sempre que
/// o app volta para o primeiro plano, enquanto houver um usuário logado.
final autoSyncProvider = Provider<void>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return;

  final service = ref.read(activitySyncServiceProvider);
  void sync() => unawaited(service.syncPending(user.uid));

  sync();
  final timer = Timer.periodic(syncRetryInterval, (_) => sync());
  final observer = _ResumeObserver(sync);
  WidgetsBinding.instance.addObserver(observer);

  ref.onDispose(() {
    timer.cancel();
    WidgetsBinding.instance.removeObserver(observer);
  });
});

class _ResumeObserver with WidgetsBindingObserver {
  _ResumeObserver(this._onResume);

  final VoidCallback _onResume;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _onResume();
  }
}
