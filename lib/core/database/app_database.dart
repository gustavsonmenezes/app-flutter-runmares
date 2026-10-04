import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:runmares/core/database/tables/activity_records.dart';
import 'package:runmares/core/database/tables/track_point_records.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [ActivityRecords, TrackPointRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: _databaseName));

  static const String _databaseName = 'runmares';

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}
