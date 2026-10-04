import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:runmares/core/database/tables/activity_records.dart';
import 'package:runmares/core/database/tables/draft_points.dart';
import 'package:runmares/core/database/tables/draft_sessions.dart';
import 'package:runmares/core/database/tables/track_point_records.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [ActivityRecords, TrackPointRecords, DraftSessions, DraftPoints],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: _databaseName));

  static const String _databaseName = 'runmares';

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (migrator, from, to) async {
        if (from < 2) {
          // Na versão 1 as atividades não tinham dono. Como o app ainda não foi
          // publicado, esses registros de teste são descartados.
          await migrator.drop(trackPointRecords);
          await migrator.drop(activityRecords);
          await migrator.createAll();
        } else if (from < 3) {
          await migrator.createTable(draftSessions);
          await migrator.createTable(draftPoints);
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}
