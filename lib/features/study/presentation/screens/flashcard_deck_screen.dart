import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import 'flashcard_study_screen.dart';

class FlashcardDeckScreen extends ConsumerStatefulWidget {
  final String? documentId;
  final String deckTitle;

  const FlashcardDeckScreen({
    super.key,
    this.documentId,
    required this.deckTitle,
  });

  @override
  ConsumerState<FlashcardDeckScreen> createState() =>
      _FlashcardDeckScreenState();
}

class _FlashcardDeckScreenState extends ConsumerState<FlashcardDeckScreen> {
  String _selectedFilter = 'all'; // 'all', 'due', 'learning', 'mastered'

  void _showAddEditCardDialog({Flashcard? existingCard}) {
    final frontCtrl = TextEditingController(text: existingCard?.front ?? '');
    final backCtrl = TextEditingController(text: existingCard?.back ?? '');
    final isEditing = existingCard != null;

    showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Flashcard' : 'Add New Flashcard'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: frontCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Front (Question / Concept)',
                    hintText: 'e.g. What is polymorphism?',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: backCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Back (Answer / Definition)',
                    hintText:
                        'e.g. Ability of an object to take on many forms.',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final front = frontCtrl.text.trim();
                final back = backCtrl.text.trim();
                if (front.isEmpty || back.isEmpty) return;

                final db = ref.read(databaseProvider);
                final now = DateTime.now();

                if (isEditing) {
                  final updated = existingCard.copyWith(
                    front: front,
                    back: back,
                    updatedAt: now,
                  );
                  await db.updateFlashcard(updated.toCompanion(false));
                } else {
                  final newId = const Uuid().v4();
                  await db.insertFlashcard(
                    FlashcardsCompanion(
                      id: drift.Value(newId),
                      documentId: drift.Value(widget.documentId),
                      deckTitle: drift.Value(widget.deckTitle),
                      front: drift.Value(front),
                      back: drift.Value(back),
                      easeFactor: const drift.Value(2.5),
                      intervalDays: const drift.Value(0),
                      repetitions: const drift.Value(0),
                      nextReviewAt: drift.Value(now),
                      status: const drift.Value('new'),
                      createdAt: drift.Value(now),
                      updatedAt: drift.Value(now),
                    ),
                  );
                }

                if (mounted && dialogCtx.mounted) {
                  Navigator.pop(dialogCtx);
                }
              },
              child: Text(isEditing ? 'Update' : 'Create'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteCard(Flashcard card) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Delete Flashcard?'),
        content: const Text('This flashcard will be permanently removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final db = ref.read(databaseProvider);
              await db.deleteFlashcard(card.id);
              if (mounted && dialogCtx.mounted) {
                Navigator.pop(dialogCtx);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final theme = Theme.of(context);

    final stream = widget.documentId != null
        ? db.watchFlashcardsForDocument(widget.documentId!)
        : db.watchAllFlashcards();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deckTitle),
        actions: [
          IconButton(
            tooltip: 'Add Card',
            onPressed: () => _showAddEditCardDialog(),
            icon: const Icon(Iconsax.add_circle),
          ),
        ],
      ),
      body: StreamBuilder<List<Flashcard>>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allCards = snapshot.data!;
          final now = DateTime.now();

          final filteredCards = allCards.where((card) {
            if (_selectedFilter == 'due') {
              return card.nextReviewAt.isBefore(now) ||
                  card.nextReviewAt.isAtSameMomentAs(now);
            } else if (_selectedFilter == 'learning') {
              return card.status == 'learning' || card.status == 'new';
            } else if (_selectedFilter == 'mastered') {
              return card.status == 'mastered';
            }
            return true;
          }).toList();

          final dueCount = allCards
              .where(
                (c) =>
                    c.nextReviewAt.isBefore(now) ||
                    c.nextReviewAt.isAtSameMomentAs(now),
              )
              .length;

          return Column(
            children: [
              // Deck Summary Card
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${allCards.length} Total Cards',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$dueCount due for review today',
                              style: TextStyle(
                                color: dueCount > 0
                                    ? Colors.orangeAccent
                                    : Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: allCards.isEmpty
                            ? null
                            : () {
                                final cardsToStudy = dueCount > 0
                                    ? filteredCards
                                    : allCards;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FlashcardStudyScreen(
                                      deckTitle: widget.deckTitle,
                                      cards: cardsToStudy,
                                    ),
                                  ),
                                );
                              },
                        icon: const Icon(Iconsax.play, size: 18),
                        label: Text(
                          dueCount > 0 ? 'Study Due ($dueCount)' : 'Study All',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _filterChip('all', 'All (${allCards.length})'),
                    const SizedBox(width: 8),
                    _filterChip('due', 'Due ($dueCount)'),
                    const SizedBox(width: 8),
                    _filterChip(
                      'learning',
                      'Learning (${allCards.where((c) => c.status == 'learning' || c.status == 'new').length})',
                    ),
                    const SizedBox(width: 8),
                    _filterChip(
                      'mastered',
                      'Mastered (${allCards.where((c) => c.status == 'mastered').length})',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Card List
              Expanded(
                child: filteredCards.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Iconsax.cards,
                              size: 48,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              allCards.isEmpty
                                  ? 'No flashcards in this deck yet.'
                                  : 'No cards match the selected filter.',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              onPressed: () => _showAddEditCardDialog(),
                              icon: const Icon(Iconsax.add),
                              label: const Text('Add Card Manually'),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: filteredCards.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final card = filteredCards[index];
                          final isDue = card.nextReviewAt.isBefore(now);

                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.outline.withValues(
                                  alpha: 0.12,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDue
                                            ? Colors.orange.withValues(
                                                alpha: 0.15,
                                              )
                                            : Colors.green.withValues(
                                                alpha: 0.15,
                                              ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        isDue
                                            ? 'DUE'
                                            : 'INTERVAL: ${card.intervalDays}d',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isDue
                                              ? Colors.orange
                                              : Colors.green,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(
                                        Iconsax.edit_2,
                                        size: 17,
                                      ),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () => _showAddEditCardDialog(
                                        existingCard: card,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    IconButton(
                                      icon: const Icon(
                                        Iconsax.trash,
                                        size: 17,
                                        color: Colors.redAccent,
                                      ),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () => _confirmDeleteCard(card),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  card.front,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  card.back,
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.75),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _filterChip(String key, String label) {
    final isSelected = _selectedFilter == key;
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      onSelected: (_) => setState(() => _selectedFilter = key),
    );
  }
}
