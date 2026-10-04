import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runmares/features/history/domain/recorded_activity.dart';
import 'package:runmares/features/sync/data/activity_document_mapper.dart';
import 'package:runmares/features/sync/domain/remote_activity_store.dart';

class FirestoreActivityStore implements RemoteActivityStore {
  FirestoreActivityStore([FirebaseFirestore? firestore])
    : _firestore = firestore ?? FirebaseFirestore.instance;

  static const Duration _commitTimeout = Duration(seconds: 20);

  final FirebaseFirestore _firestore;

  @override
  Future<void> upload(RecordedActivity activity) async {
    final activityRef = _firestore
        .collection('users')
        .doc(activity.userId)
        .collection('activities')
        .doc(ActivityDocumentMapper.documentId(activity));

    final batch = _firestore.batch();
    batch.set(activityRef, ActivityDocumentMapper.activityData(activity));

    final chunks = ActivityDocumentMapper.routeChunks(activity);
    for (var index = 0; index < chunks.length; index++) {
      batch.set(
        activityRef
            .collection('routeChunks')
            .doc(index.toString().padLeft(4, '0')),
        {'index': index, 'points': chunks[index]},
      );
    }

    // Offline, o Firestore guarda a escrita na fila e não conclui a chamada.
    // O timeout devolve o controle ao app, e a atividade segue pendente.
    await batch.commit().timeout(_commitTimeout);
  }
}
