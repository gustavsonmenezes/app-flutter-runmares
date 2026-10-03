import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/core/database/app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});
