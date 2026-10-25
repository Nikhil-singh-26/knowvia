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
  TextColumn get title => text().withDefault(const Constant('Document Quiz'))();
  TextColumn get questionsJson => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get weakTopics => text().nullable()();
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

class Flashcards extends Table {
  TextColumn get id => text()();
  TextColumn get documentId =>
      text().nullable().references(Notes, #id, onDelete: KeyAction.cascade)();
  TextColumn get deckTitle => text().withDefault(const Constant('General'))();
  TextColumn get front => text()();
  TextColumn get back => text()();
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();
  IntColumn get intervalDays => integer().withDefault(const Constant(0))();
  IntColumn get repetitions => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextReviewAt => dateTime()();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('new'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class StudyNotes extends Table {
  TextColumn get id => text()();
  TextColumn get documentId =>
      text().nullable().references(Notes, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get tags => text().nullable()();
  TextColumn get sourceExcerpt => text().nullable()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class DocumentQas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get documentId => text().nullable()();
  TextColumn get question => text()();
  TextColumn get answer => text()();
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
    Flashcards,
    StudyNotes,
    DocumentQas,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 8;

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
      if (from < 7) {
        await m.createTable(documentQas);
      }
      if (from < 8) {
        await m.createTable(flashcards);
        await m.createTable(studyNotes);
        await m.addColumn(quizSessions, quizSessions.title);
        await m.addColumn(quizSessions, quizSessions.questionsJson);
        await m.addColumn(quizSessions, quizSessions.category);
        await m.addColumn(quizSessions, quizSessions.weakTopics);
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

  // Document Q&A Queries
  Future<List<DocumentQa>> getQasForDocument(String? documentId) {
    if (documentId == null) {
      return (select(documentQas)
            ..where((tbl) => tbl.documentId.isNull())
            ..orderBy([
              (t) =>
                  OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc),
            ]))
          .get();
    }
    return (select(documentQas)
          ..where((tbl) => tbl.documentId.equals(documentId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc),
          ]))
        .get();
  }

  Stream<List<DocumentQa>> watchQasForDocument(String? documentId) {
    if (documentId == null) {
      return (select(documentQas)
            ..where((tbl) => tbl.documentId.isNull())
            ..orderBy([
              (t) =>
                  OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc),
            ]))
          .watch();
    }
    return (select(documentQas)
          ..where((tbl) => tbl.documentId.equals(documentId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc),
          ]))
        .watch();
  }

  Stream<List<DocumentQa>> watchAllQas() {
    return (select(documentQas)..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  Future<int> insertQa({
    String? documentId,
    required String question,
    required String answer,
  }) {
    return into(documentQas).insert(
      DocumentQasCompanion.insert(
        documentId: Value(documentId),
        question: question,
        answer: answer,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> deleteQa(int id) {
    return (delete(documentQas)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> clearQasForDocument(String? documentId) {
    if (documentId == null) {
      return (delete(
        documentQas,
      )..where((tbl) => tbl.documentId.isNull())).go();
    }
    return (delete(
      documentQas,
    )..where((tbl) => tbl.documentId.equals(documentId))).go();
  }

  // --- Flashcard Queries ---
  Future<List<Flashcard>> getAllFlashcards() => select(flashcards).get();
  Stream<List<Flashcard>> watchAllFlashcards() =>
      (select(flashcards)..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
          .watch();

  Future<List<Flashcard>> getFlashcardsForDocument(String docId) =>
      (select(flashcards)..where((tbl) => tbl.documentId.equals(docId))).get();

  Stream<List<Flashcard>> watchFlashcardsForDocument(String docId) =>
      (select(flashcards)
            ..where((tbl) => tbl.documentId.equals(docId))
            ..orderBy([
              (t) => OrderingTerm(
                expression: t.createdAt,
                mode: OrderingMode.desc,
              ),
            ]))
          .watch();

  Future<List<Flashcard>> getDueFlashcards(DateTime now) => (select(
    flashcards,
  )..where((tbl) => tbl.nextReviewAt.isSmallerOrEqualValue(now))).get();

  Stream<List<Flashcard>> watchDueFlashcards(DateTime now) =>
      (select(flashcards)
            ..where((tbl) => tbl.nextReviewAt.isSmallerOrEqualValue(now))
            ..orderBy([
              (t) => OrderingTerm(
                expression: t.nextReviewAt,
                mode: OrderingMode.asc,
              ),
            ]))
          .watch();

  Future<void> insertFlashcard(FlashcardsCompanion card) =>
      into(flashcards).insert(card);

  Future<void> insertFlashcards(List<FlashcardsCompanion> cards) =>
      batch((b) => b.insertAll(flashcards, cards));

  Future<bool> updateFlashcard(FlashcardsCompanion card) =>
      update(flashcards).replace(card);

  Future<void> deleteFlashcard(String id) =>
      (delete(flashcards)..where((tbl) => tbl.id.equals(id))).go();

  Future<void> deleteFlashcardsForDocument(String docId) =>
      (delete(flashcards)..where((tbl) => tbl.documentId.equals(docId))).go();

  // --- Study Notes / Bookmarks Queries ---
  Future<List<StudyNote>> getAllStudyNotes() =>
      (select(studyNotes)..orderBy([
            (t) =>
                OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
          ]))
          .get();

  Stream<List<StudyNote>> watchAllStudyNotes() =>
      (select(studyNotes)..orderBy([
            (t) =>
                OrderingTerm(expression: t.isPinned, mode: OrderingMode.desc),
            (t) =>
                OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
          ]))
          .watch();

  Future<List<StudyNote>> getStudyNotesForDocument(String docId) =>
      (select(studyNotes)..where((tbl) => tbl.documentId.equals(docId))).get();

  Stream<List<StudyNote>> watchStudyNotesForDocument(String docId) =>
      (select(studyNotes)
            ..where((tbl) => tbl.documentId.equals(docId))
            ..orderBy([
              (t) =>
                  OrderingTerm(expression: t.isPinned, mode: OrderingMode.desc),
              (t) => OrderingTerm(
                expression: t.updatedAt,
                mode: OrderingMode.desc,
              ),
            ]))
          .watch();

  Future<void> insertStudyNote(StudyNotesCompanion note) =>
      into(studyNotes).insert(note);

  Future<bool> updateStudyNote(StudyNotesCompanion note) =>
      update(studyNotes).replace(note);

  Future<void> deleteStudyNote(String id) =>
      (delete(studyNotes)..where((tbl) => tbl.id.equals(id))).go();

  // --- Quiz Session Queries ---
  Stream<List<QuizSession>> watchAllQuizSessions() =>
      (select(quizSessions)..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
          .watch();

  Stream<List<QuizSession>> watchQuizSessionsForDocument(String docId) =>
      (select(quizSessions)
            ..where((tbl) => tbl.noteId.equals(docId))
            ..orderBy([
              (t) => OrderingTerm(
                expression: t.createdAt,
                mode: OrderingMode.desc,
              ),
            ]))
          .watch();

  Future<int> insertQuizSessionRecord(QuizSessionsCompanion session) =>
      into(quizSessions).insert(session);

  Future<void> deleteQuizSession(int id) =>
      (delete(quizSessions)..where((tbl) => tbl.id.equals(id))).go();

  // --- Reset All Data ---
  Future<void> clearAllUserData() async {
    await delete(studyNotes).go();
    await delete(flashcards).go();
    await delete(quizSessions).go();
    await delete(flashcardReviews).go();
    await delete(documentQas).go();
    await delete(noteAttachments).go();
    await delete(notes).go();
    await delete(searchHistory).go();
  }

  Future<void> resetAllData() => clearAllUserData();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File(p.join(directory.path, 'know_via.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
