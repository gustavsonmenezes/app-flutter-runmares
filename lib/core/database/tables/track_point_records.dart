import 'package:drift/drift.dart';
import 'package:runmares/core/database/tables/activity_records.dart';

class TrackPointRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get activityId =>
      integer().references(ActivityRecords, #id, onDelete: KeyAction.cascade)();
  IntColumn get segmentIndex => integer()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get accuracyMeters => real()();
  DateTimeColumn get recordedAt => dateTime()();
}
