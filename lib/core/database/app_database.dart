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
  int get schemaVersion => 2;

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
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}
