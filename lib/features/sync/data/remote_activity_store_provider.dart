import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/features/sync/data/firestore_activity_store.dart';
import 'package:runmares/features/sync/domain/remote_activity_store.dart';

final remoteActivityStoreProvider = Provider<RemoteActivityStore>(
  (ref) => FirestoreActivityStore(),
);
