import 'package:drift/drift.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';

class ActivityRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => textEnum<ActivityType>()();
  DateTimeColumn get startedAt => dateTime()();
  IntColumn get durationSeconds => integer()();
  RealColumn get distanceMeters => real()();
}
