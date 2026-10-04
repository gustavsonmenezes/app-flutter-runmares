import 'package:drift/drift.dart';
import 'package:runmares/core/database/tables/draft_sessions.dart';

class DraftPoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId =>
      text().references(DraftSessions, #userId, onDelete: KeyAction.cascade)();
  IntColumn get segmentIndex => integer()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get accuracyMeters => real()();
  DateTimeColumn get recordedAt => dateTime()();
}
