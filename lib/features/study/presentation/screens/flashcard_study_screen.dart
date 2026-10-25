import 'dart:math';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import '../../domain/models/spaced_repetition.dart';

class FlashcardStudyScreen extends ConsumerStatefulWidget {
  final String deckTitle;
  final List<Flashcard> cards;

  const FlashcardStudyScreen({
    super.key,
    required this.deckTitle,
    required this.cards,
  });

  @override
  ConsumerState<FlashcardStudyScreen> createState() =>
      _FlashcardStudyScreenState();
}

class _FlashcardStudyScreenState extends ConsumerState<FlashcardStudyScreen>
    with SingleTickerProviderStateMixin {
  late List<Flashcard> _cards;
  int _currentIndex = 0;
  bool _isFlipped = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  final Map<CardRating, int> _sessionStats = {
    CardRating.again: 0,
    CardRating.hard: 0,
    CardRating.good: 0,
    CardRating.easy: 0,
  };

  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _cards = List.from(widget.cards);
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  Future<void> _rateCard(CardRating rating) async {
    final currentCard = _cards[_currentIndex];
    final calc = SpacedRepetitionService.calculateNextReview(
      rating: rating,
      currentRepetitions: currentCard.repetitions,
      currentIntervalDays: currentCard.intervalDays,
      currentEaseFactor: currentCard.easeFactor,
    );

    _sessionStats[rating] = (_sessionStats[rating] ?? 0) + 1;

    // Persist to Drift database
    final db = ref.read(databaseProvider);
    final updated = currentCard.copyWith(
      easeFactor: calc.nextEaseFactor,
      intervalDays: calc.nextIntervalDays,
      repetitions: calc.nextRepetitions,
      nextReviewAt: calc.nextReviewAt,
      lastReviewedAt: drift.Value(DateTime.now()),
      status: calc.status,
      updatedAt: DateTime.now(),
    );
    await db.updateFlashcard(updated.toCompanion(false));

    // Also record review log
    if (currentCard.documentId != null) {
      await db
          .into(db.flashcardReviews)
          .insert(
            FlashcardReviewsCompanion.insert(
              noteId: currentCard.documentId!,
              cardIndex: _currentIndex,
              isCorrect: rating == CardRating.good || rating == CardRating.easy,
              createdAt: DateTime.now(),
            ),
          );
    }

    if (_currentIndex + 1 < _cards.length) {
      _flipController.reset();
      setState(() {
        _isFlipped = false;
        _currentIndex++;
      });
    } else {
      setState(() {
        _isCompleted = true;
      });
    }
  }

  void _showEditCardDialog() {
    final currentCard = _cards[_currentIndex];
    final frontCtrl = TextEditingController(text: currentCard.front);
    final backCtrl = TextEditingController(text: currentCard.back);

    showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Edit Card Content'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: frontCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Front (Question / Prompt)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: backCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Back (Answer / Definition)',
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
                final newFront = frontCtrl.text.trim();
                final newBack = backCtrl.text.trim();
                if (newFront.isEmpty || newBack.isEmpty) return;

                final db = ref.read(databaseProvider);
                final updated = currentCard.copyWith(
                  front: newFront,
                  back: newBack,
                  updatedAt: DateTime.now(),
                );
                await db.updateFlashcard(updated.toCompanion(false));
                setState(() {
                  _cards[_currentIndex] = updated;
                });
                if (mounted && dialogCtx.mounted) {
                  Navigator.pop(dialogCtx);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isCompleted) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Session Complete 🎉'),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Iconsax.cup,
                    size: 64,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Great job reviewing!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'You reviewed ${_cards.length} cards from "${widget.deckTitle}".',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatColumn(
                        label: 'Again',
                        count: _sessionStats[CardRating.again] ?? 0,
                        color: Colors.redAccent,
                      ),
                      _StatColumn(
                        label: 'Hard',
                        count: _sessionStats[CardRating.hard] ?? 0,
                        color: Colors.orangeAccent,
                      ),
                      _StatColumn(
                        label: 'Good',
                        count: _sessionStats[CardRating.good] ?? 0,
                        color: Colors.blueAccent,
                      ),
                      _StatColumn(
                        label: 'Easy',
                        count: _sessionStats[CardRating.easy] ?? 0,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Iconsax.tick_circle),
                    label: const Text(
                      'Back to Study Center',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _flipController.reset();
                      setState(() {
                        _isCompleted = false;
                        _currentIndex = 0;
                        _isFlipped = false;
                        _sessionStats.updateAll((key, val) => 0);
                      });
                    },
                    icon: const Icon(Iconsax.refresh),
                    label: const Text('Review Again'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.deckTitle)),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Iconsax.cards, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('No cards available in this deck.'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final currentCard = _cards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.deckTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        actions: [
          IconButton(
            tooltip: 'Edit Card',
            onPressed: _showEditCardDialog,
            icon: const Icon(Iconsax.edit_2, size: 20),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // Progress Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Card ${_currentIndex + 1} of ${_cards.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      currentCard.status.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (_currentIndex + 1) / _cards.length,
                borderRadius: BorderRadius.circular(8),
                minHeight: 6,
              ),
              const SizedBox(height: 18),

              // Interactive Flip Card
              Expanded(
                child: GestureDetector(
                  onTap: _flipCard,
                  child: AnimatedBuilder(
                    animation: _flipAnimation,
                    builder: (context, child) {
                      final angle = _flipAnimation.value * pi;
                      final isFront = angle < (pi / 2);

                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(angle),
                        child: isFront
                            ? _buildCardSide(
                                context,
                                tag: 'QUESTION',
                                text: currentCard.front,
                                hint: 'Tap to flip and reveal answer',
                                icon: Iconsax.message_question,
                                isDark: isDark,
                              )
                            : Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..rotateY(pi),
                                child: _buildCardSide(
                                  context,
                                  tag: 'ANSWER',
                                  text: currentCard.back,
                                  hint: 'Rate your recall below',
                                  icon: Iconsax.tick_circle,
                                  isDark: isDark,
                                  isBack: true,
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Rating Buttons (Revealed when card is flipped)
              if (_isFlipped) ...[
                const Text(
                  'How well did you remember this?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _RatingButton(
                        rating: CardRating.again,
                        color: Colors.redAccent,
                        onPressed: () => _rateCard(CardRating.again),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _RatingButton(
                        rating: CardRating.hard,
                        color: Colors.orangeAccent,
                        onPressed: () => _rateCard(CardRating.hard),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _RatingButton(
                        rating: CardRating.good,
                        color: Colors.blueAccent,
                        onPressed: () => _rateCard(CardRating.good),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _RatingButton(
                        rating: CardRating.easy,
                        color: Colors.green,
                        onPressed: () => _rateCard(CardRating.easy),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _flipCard,
                    icon: const Icon(Iconsax.repeat),
                    label: const Text(
                      'Flip to See Answer',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardSide(
    BuildContext context, {
    required String tag,
    required String text,
    required String hint,
    required IconData icon,
    required bool isDark,
    bool isBack = false,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isBack
            ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9))
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isBack
              ? AppColors.primary.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.15),
          width: isBack ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isBack
                      ? Colors.green.withValues(alpha: 0.1)
                      : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isBack ? Colors.green : AppColors.primary,
                  ),
                ),
              ),
              Icon(icon, size: 22, color: AppColors.primary),
            ],
          ),
          const Spacer(),
          SingleChildScrollView(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: text.length > 120 ? 17 : 21,
                fontWeight: FontWeight.bold,
                height: 1.45,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          const Spacer(),
          Text(
            hint,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingButton extends StatelessWidget {
  final CardRating rating;
  final Color color;
  final VoidCallback onPressed;

  const _RatingButton({
    required this.rating,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              rating.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              rating.previewInterval,
              style: TextStyle(
                fontSize: 10,
                color: color.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatColumn({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
