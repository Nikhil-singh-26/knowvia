import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class Notes extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  TextColumn get content => text()();

  TextColumn get category => text().withDefault(const Constant('General'))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  TextColumn get aiSummary => text().nullable()();

  TextColumn get aiTopics => text().nullable()();

  TextColumn get aiKeywords => text().nullable()();

  TextColumn get aiDifficulty => text().nullable()();

  TextColumn get aiRelatedConcepts => text().nullable()();

  TextColumn get sourceType => text().withDefault(const Constant('text'))();

  TextColumn get attachmentPaths => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get bio => text().nullable()();
  TextColumn get interests => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
}

class NoteAttachments extends Table {
  TextColumn get id => text()();

  TextColumn get noteId => text()();

  TextColumn get path => text()();

  TextColumn get type => text()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Concepts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  TextColumn get description => text().nullable()();
  TextColumn get aiExplanation => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class NoteConcepts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get noteId =>
      text().references(Notes, #id, onDelete: KeyAction.cascade)();
  TextColumn get conceptId =>
      text().references(Concepts, #id, onDelete: KeyAction.cascade)();
}

class ConceptRelations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fromConceptId =>
      text().references(Concepts, #id, onDelete: KeyAction.cascade)();
  TextColumn get toConceptId =>
      text().references(Concepts, #id, onDelete: KeyAction.cascade)();
  TextColumn get relationType =>
      text().withDefault(const Constant('related'))();
}

class SearchHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get query => text()();
  DateTimeColumn get createdAt => dateTime()();
}

class QuizSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get noteId =>
      text().references(Notes, #id, onDelete: KeyAction.cascade)();
  IntColumn get score => integer()();
  IntColumn get totalQuestions => integer()();
  DateTimeColumn get createdAt => dateTime()();
}

class FlashcardReviews extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get noteId =>
      text().references(Notes, #id, onDelete: KeyAction.cascade)();
  IntColumn get cardIndex => integer()();
  BoolColumn get isCorrect => boolean()();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(
  tables: [
    Notes,
    Profiles,
    NoteAttachments,
    Concepts,
    NoteConcepts,
    ConceptRelations,
    SearchHistory,
    QuizSessions,
    FlashcardReviews,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },

    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 3) {
        await m.addColumn(notes, notes.sourceType);
        await m.addColumn(notes, notes.attachmentPaths);
        await m.addColumn(notes, notes.aiSummary);
        await m.addColumn(notes, notes.aiTopics);
        await m.addColumn(notes, notes.aiKeywords);
        await m.addColumn(notes, notes.aiDifficulty);
        await m.addColumn(notes, notes.aiRelatedConcepts);
        await m.createTable(profiles);
        await m.createTable(noteAttachments);
      }
      if (from < 4) {
        await m.createTable(concepts);
        await m.createTable(noteConcepts);
        await m.createTable(conceptRelations);
      }
      if (from < 5) {
        await m.createTable(searchHistory);
      }
      if (from < 6) {
        await m.createTable(quizSessions);
        await m.createTable(flashcardReviews);
      }
    },
  );

  Future<List<Note>> getAllNotes() {
    return select(notes).get();
  }

  Future<List<QuizSession>> getAllQuizSessions() {
    return select(quizSessions).get();
  }

  Future<List<FlashcardReview>> getAllFlashcardReviews() {
    return select(flashcardReviews).get();
  }

  Future<Note?> getNoteById(String id) {
    return (select(notes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertNote(NotesCompanion note) {
    return into(notes).insert(note);
  }

  Future<void> updateNote(NotesCompanion note) {
    return update(notes).replace(note);
  }

  Future<void> deleteNote(String id) {
    return (delete(notes)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<List<Note>> getNotesByCategory(String category) {
    return (select(notes)..where((tbl) => tbl.category.equals(category))).get();
  }

  Future<void> addAttachment({
    required String noteId,
    required String path,
    required String type,
  }) async {
    await into(noteAttachments).insert(
      NoteAttachmentsCompanion.insert(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        noteId: noteId,
        path: path,
        type: type,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<List<NoteAttachment>> getAttachments(String noteId) {
    return (select(
      noteAttachments,
    )..where((tbl) => tbl.noteId.equals(noteId))).get();
  }

  Future<void> deleteAttachments(String noteId) async {
    await (delete(
      noteAttachments,
    )..where((tbl) => tbl.noteId.equals(noteId))).go();
  }

  Future<Profile?> getProfile() {
    return select(profiles).getSingleOrNull();
  }

  Future<void> saveProfile({
    required String name,
    String? bio,
    String? interests,
    String? imagePath,
  }) async {
    final existing = await getProfile();

    final companion = ProfilesCompanion(
      name: Value(name),
      bio: bio == null ? const Value.absent() : Value(bio),
      interests: interests == null ? const Value.absent() : Value(interests),
      imagePath: imagePath == null ? const Value.absent() : Value(imagePath),
      updatedAt: Value(DateTime.now()),
    );

    if (existing == null) {
      await into(profiles).insert(companion);
    } else {
      await (update(
        profiles,
      )..where((tbl) => tbl.id.equals(existing.id))).write(companion);
    }
  }

  // Knowledge Map Queries
  Future<List<Concept>> getAllConcepts() => select(concepts).get();
  Stream<List<Concept>> watchAllConcepts() => select(concepts).watch();

  Future<Concept?> getConceptByName(String name) {
    return (select(
      concepts,
    )..where((tbl) => tbl.name.equals(name))).getSingleOrNull();
  }

  Future<void> insertConcept(ConceptsCompanion companion) =>
      into(concepts).insert(companion);

  Future<void> linkNoteToConcept(String noteId, String conceptId) async {
    final existing =
        await (select(noteConcepts)..where(
              (tbl) =>
                  tbl.noteId.equals(noteId) & tbl.conceptId.equals(conceptId),
            ))
            .getSingleOrNull();
    if (existing == null) {
      await into(noteConcepts).insert(
        NoteConceptsCompanion.insert(noteId: noteId, conceptId: conceptId),
      );
    }
  }

  Future<bool> linkConcepts(
    String fromId,
    String toId, {
    String type = 'related',
  }) async {
    final existing =
        await (select(conceptRelations)..where(
              (tbl) =>
                  tbl.fromConceptId.equals(fromId) &
                  tbl.toConceptId.equals(toId),
            ))
            .getSingleOrNull();
    if (existing != null) {
      return false;
    }

    await into(conceptRelations).insert(
      ConceptRelationsCompanion.insert(
        fromConceptId: fromId,
        toConceptId: toId,
        relationType: Value(type),
      ),
    );
    return true;
  }

  Future<List<Note>> getNotesForConcept(String conceptId) async {
    final query = select(notes).join([
      innerJoin(noteConcepts, noteConcepts.noteId.equalsExp(notes.id)),
    ])..where(noteConcepts.conceptId.equals(conceptId));
    final rows = await query.get();
    return rows.map((row) => row.readTable(notes)).toList();
  }

  Future<List<Concept>> getConceptsForNote(String noteId) async {
    final query = select(concepts).join([
      innerJoin(noteConcepts, noteConcepts.conceptId.equalsExp(concepts.id)),
    ])..where(noteConcepts.noteId.equals(noteId));
    final rows = await query.get();
    return rows.map((row) => row.readTable(concepts)).toList();
  }

  Future<List<Concept>> getRelatedConcepts(String conceptId) async {
    final query = select(concepts).join([
      innerJoin(
        conceptRelations,
        conceptRelations.toConceptId.equalsExp(concepts.id),
      ),
    ])..where(conceptRelations.fromConceptId.equals(conceptId));
    final rows = await query.get();
    return rows.map((row) => row.readTable(concepts)).toList();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File(p.join(directory.path, 'know_via.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
