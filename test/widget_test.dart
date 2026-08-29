import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:know_via/app/app.dart';
import 'package:know_via/core/database/database.dart';
import 'package:know_via/features/map/presentation/screens/map_screen.dart';
import 'package:know_via/main.dart';

void main() {
  testWidgets('Know Via app loads', (WidgetTester tester) async {
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

  testWidgets('Map renders actual note and concept data', (
    WidgetTester tester,
  ) async {
    final db = AppDatabase.memory();

    final noteId = 'note-1';
    final conceptId = 'concept-1';

    await db
        .into(db.notes)
        .insert(
          NotesCompanion.insert(
            id: noteId,
            title: 'Real Map Note',
            content: 'This note explains the concept of graphs.',
            category: const Value('Technology'),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

    await db
        .into(db.concepts)
        .insert(
          ConceptsCompanion.insert(
            id: conceptId,
            name: 'Map',
            category: 'Technology',
            description: const Value(
              'A visual representation of linked ideas.',
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

    await db.linkNoteToConcept(noteId, conceptId);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: MapScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Real Map Note'), findsOneWidget);
    expect(find.text('Map'), findsOneWidget);

    await db.close();
    await tester.pump(Duration.zero);
  });
}
