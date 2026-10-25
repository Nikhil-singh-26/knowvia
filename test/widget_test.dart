import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:know_via/app/app.dart';
import 'package:know_via/core/database/database.dart';
import 'package:know_via/features/study/domain/models/spaced_repetition.dart';
import 'package:know_via/main.dart';

void main() {
  testWidgets('Know Via app loads successfully', (WidgetTester tester) async {
    final db = AppDatabase.memory();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const KnowViaApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Know Via'), findsOneWidget);

    await db.close();
    await tester.pump(Duration.zero);
  });

  test('Database persists notes, flashcards, and study notes', () async {
    final db = AppDatabase.memory();

    const noteId = 'doc-123';
    await db
        .into(db.notes)
        .insert(
          NotesCompanion.insert(
            id: noteId,
            title: 'Quantum Physics Intro',
            content:
                'Quantum physics is the study of matter and energy at the most fundamental level.',
            category: const Value('Academic'),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

    final notes = await db.getAllNotes();
    expect(notes.length, 1);
    expect(notes.first.title, 'Quantum Physics Intro');

    // Test Flashcard persistence
    const cardId = 'card-1';
    await db.insertFlashcard(
      FlashcardsCompanion.insert(
        id: cardId,
        documentId: const Value(noteId),
        front: 'What is a photon?',
        back: 'A quantum of electromagnetic radiation.',
        deckTitle: const Value('Physics'),
        nextReviewAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    final cards = await db.getFlashcardsForDocument(noteId);
    expect(cards.length, 1);
    expect(cards.first.front, 'What is a photon?');

    // Test StudyNote persistence
    const studyNoteId = 'sn-1';
    await db.insertStudyNote(
      StudyNotesCompanion.insert(
        id: studyNoteId,
        documentId: const Value(noteId),
        title: 'Formula reminder',
        content: 'E = h * f',
        tags: const Value('formula,exam'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    final studyNotes = await db.getStudyNotesForDocument(noteId);
    expect(studyNotes.length, 1);
    expect(studyNotes.first.content, 'E = h * f');

    await db.close();
  });

  test(
    'Spaced repetition algorithm calculates intervals deterministically',
    () {
      final now = DateTime(2026, 1, 1, 10, 0);

      // Initial review: Good
      final res1 = SpacedRepetitionService.calculateNextReview(
        rating: CardRating.good,
        currentRepetitions: 0,
        currentIntervalDays: 0,
        currentEaseFactor: 2.5,
        now: now,
      );
      expect(res1.nextIntervalDays, 1);
      expect(res1.nextRepetitions, 1);
      expect(res1.status, 'review');

      // Second review: Good
      final res2 = SpacedRepetitionService.calculateNextReview(
        rating: CardRating.good,
        currentRepetitions: 1,
        currentIntervalDays: 1,
        currentEaseFactor: 2.5,
        now: now,
      );
      expect(res2.nextIntervalDays, 3);
      expect(res2.nextRepetitions, 2);

      // Failed recall: Again resets repetitions
      final resAgain = SpacedRepetitionService.calculateNextReview(
        rating: CardRating.again,
        currentRepetitions: 2,
        currentIntervalDays: 3,
        currentEaseFactor: 2.5,
        now: now,
      );
      expect(resAgain.nextRepetitions, 0);
      expect(resAgain.nextIntervalDays, 1);
      expect(resAgain.status, 'learning');
    },
  );
}
