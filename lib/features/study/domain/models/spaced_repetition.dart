enum CardRating {
  again(1, 'Again', '< 1 day'),
  hard(2, 'Hard', '1 day'),
  good(3, 'Good', '3-6 days'),
  easy(4, 'Easy', '7+ days');

  final int value;
  final String label;
  final String previewInterval;

  const CardRating(this.value, this.label, this.previewInterval);
}

class SpacedRepetitionResult {
  final int nextIntervalDays;
  final int nextRepetitions;
  final double nextEaseFactor;
  final DateTime nextReviewAt;
  final String status;

  const SpacedRepetitionResult({
    required this.nextIntervalDays,
    required this.nextRepetitions,
    required this.nextEaseFactor,
    required this.nextReviewAt,
    required this.status,
  });
}

class SpacedRepetitionService {
  /// Deterministic implementation of the SuperMemo-2 (SM-2) algorithm.
  /// Computes the next interval, repetition count, ease factor, and review date.
  static SpacedRepetitionResult calculateNextReview({
    required CardRating rating,
    required int currentRepetitions,
    required int currentIntervalDays,
    required double currentEaseFactor,
    DateTime? now,
  }) {
    final DateTime reviewBase = now ?? DateTime.now();

    // 1. Calculate updated Ease Factor (EF)
    // Formula: EF' = EF + (0.1 - (4 - q) * (0.08 + (4 - q) * 0.02))
    final int q = rating.value;
    double newEaseFactor =
        currentEaseFactor + (0.1 - (4 - q) * (0.08 + (4 - q) * 0.02));
    if (newEaseFactor < 1.3) {
      newEaseFactor = 1.3;
    }

    int nextInterval;
    int nextRepetitions;
    String status;

    if (q < 3) {
      // Failed recall (Again or Hard) -> reset repetitions and review soon
      nextRepetitions = 0;
      nextInterval = 1;
      status = 'learning';
    } else {
      // Successful recall (Good or Easy)
      if (currentRepetitions == 0) {
        nextInterval = q == 4 ? 2 : 1;
      } else if (currentRepetitions == 1) {
        nextInterval = q == 4 ? 6 : 3;
      } else {
        final double calculated =
            (currentIntervalDays <= 0 ? 1 : currentIntervalDays) *
            newEaseFactor;
        nextInterval = calculated.round();
      }

      nextRepetitions = currentRepetitions + 1;
      status = nextInterval >= 21 ? 'mastered' : 'review';
    }

    final DateTime nextReviewAt = reviewBase.add(Duration(days: nextInterval));

    return SpacedRepetitionResult(
      nextIntervalDays: nextInterval,
      nextRepetitions: nextRepetitions,
      nextEaseFactor: double.parse(newEaseFactor.toStringAsFixed(2)),
      nextReviewAt: nextReviewAt,
      status: status,
    );
  }
}
