import 'package:runmares/features/history/domain/activity_repository.dart';
import 'package:runmares/features/sync/domain/remote_activity_store.dart';

class ActivitySyncService {
  ActivitySyncService({
    required ActivityRepository repository,
    required RemoteActivityStore remote,
    DateTime Function()? now,
  }) : _repository = repository,
       _remote = remote,
       _now = now ?? DateTime.now;

  final ActivityRepository _repository;
  final RemoteActivityStore _remote;
  final DateTime Function() _now;

  bool _isSyncing = false;

  /// Envia as atividades pendentes do usuário e devolve quantas foram enviadas.
  Future<int> syncPending(String userId) async {
    if (_isSyncing) return 0;
    _isSyncing = true;

    var synced = 0;
    try {
      final pending = await _repository.findPending(userId);
      for (final item in pending) {
        await _remote.upload(item.activity);
        await _repository.markSynced(item.id, _now());
        synced++;
      }
    } on Exception {
      // Sem rede ou falha do servidor: o que não foi enviado continua
      // pendente e entra na próxima tentativa.
    } finally {
      _isSyncing = false;
    }
    return synced;
  }
}
