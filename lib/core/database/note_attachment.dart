import 'package:drift/drift.dart';

class NoteAttachments extends Table {
  TextColumn get id => text()();

  TextColumn get noteId => text()();

  TextColumn get path => text()();

  TextColumn get type => text()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
