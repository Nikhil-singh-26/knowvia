import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import 'flashcard_deck_screen.dart';
import 'flashcard_study_screen.dart';
import 'quiz_history_screen.dart';
import 'study_notes_screen.dart';
import '../../../notes/presentation/screens/note_detail_screen.dart';

class StudyDashboardScreen extends ConsumerWidget {
  const StudyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final theme = Theme.of(context);
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Study & Revision Center',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Study Notes & Bookmarks',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudyNotesScreen()),
              );
            },
            icon: const Icon(Iconsax.note_favorite),
          ),
          IconButton(
            tooltip: 'Quiz History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuizHistoryScreen()),
              );
            },
            icon: const Icon(Iconsax.clock),
          ),
        ],
      ),
      body: StreamBuilder<List<Flashcard>>(
        stream: db.watchAllFlashcards(),
        builder: (context, cardSnap) {
          return StreamBuilder<List<QuizSession>>(
            stream: db.watchAllQuizSessions(),
            builder: (context, quizSnap) {
              return StreamBuilder<List<Note>>(
                stream: db.select(db.notes).watch(),
                builder: (context, notesSnap) {
                  final allCards = cardSnap.data ?? [];
                  final allQuizzes = quizSnap.data ?? [];
                  final allNotes = notesSnap.data ?? [];

                  final dueCards = allCards
                      .where(
                        (c) =>
                            c.nextReviewAt.isBefore(now) ||
                            c.nextReviewAt.isAtSameMomentAs(now),
                      )
                      .toList();

                  final masteredCount = allCards
                      .where((c) => c.status == 'mastered')
                      .length;

                  // Aggregate weak topics from quizzes
                  final Set<String> weakTopics = {};
                  for (final q in allQuizzes) {
                    if (q.weakTopics != null && q.weakTopics!.isNotEmpty) {
                      for (final t in q.weakTopics!.split('|')) {
                        if (t.trim().isNotEmpty) weakTopics.add(t.trim());
                      }
                    }
                  }

                  // Group flashcards by document/deck
                  final Map<String, List<Flashcard>> decks = {};
                  for (final card in allCards) {
                    final title = card.deckTitle;
                    decks.putIfAbsent(title, () => []).add(card);
                  }

                  return ListView(
                    padding: const EdgeInsets.all(18),
                    children: [
                      // Daily Revision Queue Banner
                      if (dueCards.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF4F46E5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF6C63FF,
                                ).withValues(alpha: 0.3),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Iconsax.calendar_tick,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Daily Revision Queue',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '${dueCards.length} flashcards are due for review today based on your spaced-repetition schedule.',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 46,
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF4F46E5),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FlashcardStudyScreen(
                                          deckTitle: 'Daily Revision Queue',
                                          cards: dueCards,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Iconsax.play, size: 18),
                                  label: const Text(
                                    'Start Daily Revision',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: theme.colorScheme.outline.withValues(
                                alpha: 0.15,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Iconsax.tick_circle,
                                  color: Colors.green,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'All caught up for today!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      allCards.isEmpty
                                          ? 'Generate flashcards from your documents to begin.'
                                          : 'No cards are due right now. Keep up the great work!',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.65),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Metrics Dashboard Grid
                      const Text(
                        'Study Performance',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _StudyStatCard(
                              icon: Iconsax.cards,
                              label: 'Total Cards',
                              value: '${allCards.length}',
                              subtitle: '${dueCards.length} due today',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StudyStatCard(
                              icon: Iconsax.cup,
                              label: 'Mastered',
                              value: '$masteredCount',
                              subtitle:
                                  '${allCards.length - masteredCount} in progress',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _StudyStatCard(
                              icon: Iconsax.task_square,
                              label: 'Quiz Attempts',
                              value: '${allQuizzes.length}',
                              subtitle: allQuizzes.isEmpty
                                  ? 'No attempts yet'
                                  : 'Avg ${((allQuizzes.map((e) => e.score / (e.totalQuestions == 0 ? 1 : e.totalQuestions)).reduce((a, b) => a + b) / allQuizzes.length) * 100).round()}%',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StudyStatCard(
                              icon: Iconsax.document_text,
                              label: 'Documents',
                              value: '${allNotes.length}',
                              subtitle: 'In local library',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Quick Actions
                      const Text(
                        'Revision Tools',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _ActionTile(
                              icon: Iconsax.note_favorite,
                              title: 'Study Notes',
                              subtitle: 'Saved excerpts & tips',
                              color: Colors.blueAccent,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const StudyNotesScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ActionTile(
                              icon: Iconsax.clock,
                              title: 'Quiz History',
                              subtitle: 'Mistakes & scores',
                              color: Colors.purpleAccent,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const QuizHistoryScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Weak Topics Section (if user made mistakes)
                      if (weakTopics.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(
                              Iconsax.warning_2,
                              color: Colors.orangeAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Topics to Reinforce',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Identified from recent quiz incorrect answers:',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: weakTopics.take(6).map((topic) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.orange.withValues(alpha: 0.25),
                                ),
                              ),
                              child: Text(
                                topic,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 28),
                      ],

                      // Flashcard Decks List
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Flashcard Decks',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const FlashcardDeckScreen(
                                    deckTitle: 'General Flashcards',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Iconsax.add, size: 16),
                            label: const Text('New Card'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      if (decks.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: theme.colorScheme.outline.withValues(
                                alpha: 0.15,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(
                                  Iconsax.cards,
                                  size: 44,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'No flashcard decks yet',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Open any document and tap "Flashcards" to auto-generate a deck with AI.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...decks.entries.map((entry) {
                          final deckCards = entry.value;
                          final deckDue = deckCards
                              .where(
                                (c) =>
                                    c.nextReviewAt.isBefore(now) ||
                                    c.nextReviewAt.isAtSameMomentAs(now),
                              )
                              .length;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: theme.colorScheme.outline.withValues(
                                  alpha: 0.15,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Iconsax.cards,
                                    color: AppColors.primary,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.key,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${deckCards.length} cards • $deckDue due',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: deckDue > 0
                                              ? Colors.orangeAccent
                                              : AppColors.textSecondary,
                                          fontWeight: deckDue > 0
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FlashcardDeckScreen(
                                          documentId:
                                              deckCards.first.documentId,
                                          deckTitle: entry.key,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Manage'),
                                ),
                                const SizedBox(width: 8),
                                FilledButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FlashcardStudyScreen(
                                          deckTitle: entry.key,
                                          cards: deckDue > 0
                                              ? deckCards
                                                    .where(
                                                      (c) =>
                                                          c.nextReviewAt
                                                              .isBefore(now) ||
                                                          c.nextReviewAt
                                                              .isAtSameMomentAs(
                                                                now,
                                                              ),
                                                    )
                                                    .toList()
                                              : deckCards,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(deckDue > 0 ? 'Study' : 'Review'),
                                ),
                              ],
                            ),
                          );
                        }),

                      const SizedBox(height: 28),

                      // Continue Learning: Recent Documents
                      const Text(
                        'Continue Learning Documents',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (allNotes.isEmpty)
                        const Text(
                          'No documents in library yet. Import a document to begin study sessions.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        )
                      else
                        ...allNotes.take(3).map((doc) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              tileColor: theme.colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: theme.colorScheme.outline.withValues(
                                    alpha: 0.12,
                                  ),
                                ),
                              ),
                              leading: const Icon(
                                Iconsax.document_text,
                                color: AppColors.primary,
                              ),
                              title: Text(
                                doc.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Text(
                                doc.category,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              trailing: const Icon(
                                Iconsax.arrow_right_3,
                                size: 16,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => NoteDetailScreen(note: doc),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _StudyStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;

  const _StudyStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
