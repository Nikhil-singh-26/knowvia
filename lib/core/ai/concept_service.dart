import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../database/database.dart';
import '../../main.dart';
import 'ai_provider.dart';
import 'gemini_service.dart';

final conceptServiceProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  final ai = ref.watch(geminiServiceProvider);
  return ConceptService(db, ai);
});

class ConceptService {
  final AppDatabase db;
  final GeminiService ai;
  final _uuid = const Uuid();

  ConceptService(this.db, this.ai);

  Future<int> processNoteForMap(Note note) async {
    try {
      final result = await ai.extractConcepts(
        title: note.title,
        content: note.content,
      );

      final data = jsonDecode(result) as Map<String, dynamic>;
      final extractedConcepts = data['concepts'] as List?;

      if (extractedConcepts == null || extractedConcepts.isEmpty) {
        debugPrint('AI returned no concepts for note: ${note.title}');
        return 0;
      }

      int conceptsCreated = 0;
      int relationshipsCreated = 0;
      for (final c in extractedConcepts) {
        final name = c['name']?.toString() ?? '';
        final category = c['category']?.toString() ?? 'General';
        final description = c['description']?.toString() ?? '';
        final relatedNames = List<String>.from(c['related'] ?? []);

        if (name.isEmpty) continue;

        var concept = await db.getConceptByName(name);
        String conceptId;

        if (concept == null) {
          conceptId = _uuid.v4();
          await db.insertConcept(
            ConceptsCompanion.insert(
              id: conceptId,
              name: name,
              category: category,
              description: Value(description),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
          conceptsCreated++;
        } else {
          conceptId = concept.id;
          if ((concept.description == null || concept.description!.isEmpty) &&
              description.isNotEmpty) {
            await (db.update(
              db.concepts,
            )..where((tbl) => tbl.id.equals(conceptId))).write(
              ConceptsCompanion(
                description: Value(description),
                updatedAt: Value(DateTime.now()),
              ),
            );
          }
        }

        await db.linkNoteToConcept(note.id, conceptId);

        for (final rName in relatedNames) {
          if (rName.toLowerCase() == name.toLowerCase()) continue;

          var rConcept = await db.getConceptByName(rName);
          String rConceptId;

          if (rConcept == null) {
            rConceptId = _uuid.v4();
            await db.insertConcept(
              ConceptsCompanion.insert(
                id: rConceptId,
                name: rName,
                category: category,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            );
            conceptsCreated++;
          } else {
            rConceptId = rConcept.id;
          }

          final createdRelationship = await db.linkConcepts(
            conceptId,
            rConceptId,
          );
          if (createdRelationship) {
            relationshipsCreated++;
          }
        }
      }

      debugPrint(
        'Notes found: 1 | Concepts created: $conceptsCreated | Relationships created: $relationshipsCreated',
      );
      return conceptsCreated;
    } catch (e) {
      debugPrint('Error processing note "${note.title}": $e');
      rethrow;
    }
  }

  Future<Map<String, int>> analyzeAllNotes({
    Function(String)? onProgress,
  }) async {
    final notes = await db.getAllNotes();
    if (notes.isEmpty) {
      throw Exception('No notes available. Create some notes first.');
    }

    int totalNewConcepts = 0;
    int totalRelationships = 0;
    int notesProcessed = 0;
    Object? lastError;

    for (int i = 0; i < notes.length; i++) {
      final note = notes[i];
      onProgress?.call(
        'Analyzing note ${i + 1} of ${notes.length}: ${note.title}',
      );

      try {
        final createdConcepts = await processNoteForMap(note);
        totalNewConcepts += createdConcepts;
        final conceptIds = await db.getConceptsForNote(note.id);
        if (conceptIds.isNotEmpty) {
          for (final concept in conceptIds) {
            final related = await db.getRelatedConcepts(concept.id);
            totalRelationships += related.length;
          }
        }
        notesProcessed++;
      } catch (e) {
        lastError = e;
        debugPrint('Failed to process note "${note.title}": $e');
        if (e.toString().contains('authorization failed') ||
            e.toString().contains('API key')) {
          rethrow;
        }
      }
    }

    if (notesProcessed == 0) {
      if (lastError != null) {
        throw Exception(lastError.toString());
      }
      throw Exception(
        'Failed to analyze any notes. Please check your internet connection.',
      );
    }

    debugPrint(
      'Notes found: ${notes.length} | Concepts created: $totalNewConcepts | Relationships created: $totalRelationships',
    );

    return {
      'notesAnalyzed': notesProcessed,
      'conceptsCreated': totalNewConcepts,
      'relationshipsCreated': totalRelationships,
    };
  }
}
