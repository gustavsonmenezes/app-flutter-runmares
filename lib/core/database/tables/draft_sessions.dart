import 'package:drift/drift.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';

class DraftSessions extends Table {
  TextColumn get userId => text()();
  TextColumn get type => textEnum<ActivityType>()();
  DateTimeColumn get startedAt => dateTime()();
  IntColumn get elapsedSeconds => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {userId};
}
