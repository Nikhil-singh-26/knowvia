import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';

class QuizRunnerScreen extends ConsumerStatefulWidget {
  final String title;
  final String? noteId;
  final String? category;
  final List<Map<String, dynamic>> questions;

  const QuizRunnerScreen({
    super.key,
    required this.title,
    this.noteId,
    this.category,
    required this.questions,
  });

  @override
  ConsumerState<QuizRunnerScreen> createState() => _QuizRunnerScreenState();
}

class _QuizRunnerScreenState extends ConsumerState<QuizRunnerScreen> {
  int _currentIndex = 0;
  late List<int?> _selectedAnswers;
  bool _isSubmitted = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List.filled(widget.questions.length, null);
  }

  void _selectOption(int optionIndex) {
    if (_isSubmitted) return;
    setState(() {
      _selectedAnswers[_currentIndex] = optionIndex;
    });
  }

  void _next() {
    if (_currentIndex < widget.questions.length - 1) {
      setState(() => _currentIndex++);
    }
  }

  void _previous() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  Future<void> _submitQuiz() async {
    final unansweredCount = _selectedAnswers.where((ans) => ans == null).length;

    if (unansweredCount > 0) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Unanswered Questions'),
          content: Text(
            'You have $unansweredCount unanswered question(s). Are you sure you want to finish and submit now?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Keep Working'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Submit Anyway'),
            ),
          ],
        ),
      );
      if (proceed != true) return;
    }

    // Calculate score & identify weak topics
    int correctCount = 0;
    final List<String> weakTopicsList = [];

    for (int i = 0; i < widget.questions.length; i++) {
      final q = widget.questions[i];
      final correct = q['answer'] as int? ?? 0;
      if (_selectedAnswers[i] == correct) {
        correctCount++;
      } else {
        final topic = q['topic'] ?? q['question'] ?? 'Question ${i + 1}';
        weakTopicsList.add(topic.toString());
      }
    }

    setState(() {
      _score = correctCount;
      _isSubmitted = true;
    });

    // Save full quiz session to database
    try {
      final db = ref.read(databaseProvider);
      final enrichedQuestions = <Map<String, dynamic>>[];
      for (int i = 0; i < widget.questions.length; i++) {
        final copy = Map<String, dynamic>.from(widget.questions[i]);
        copy['userAnswer'] = _selectedAnswers[i];
        enrichedQuestions.add(copy);
      }

      await db.insertQuizSessionRecord(
        QuizSessionsCompanion(
          noteId: drift.Value(widget.noteId ?? 'standalone'),
          title: drift.Value(widget.title),
          score: drift.Value(correctCount),
          totalQuestions: drift.Value(widget.questions.length),
          questionsJson: drift.Value(jsonEncode(enrichedQuestions)),
          category: drift.Value(widget.category ?? 'General'),
          weakTopics: drift.Value(
            weakTopicsList.isEmpty ? null : weakTopicsList.join(' | '),
          ),
          createdAt: drift.Value(DateTime.now()),
        ),
      );
    } catch (_) {}
  }

  void _retryQuiz() {
    setState(() {
      _currentIndex = 0;
      _selectedAnswers = List.filled(widget.questions.length, null);
      _isSubmitted = false;
      _score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isSubmitted) {
      return _buildResultsView(theme);
    }

    if (widget.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: const Center(child: Text('No questions available in this quiz.')),
      );
    }

    final question = widget.questions[_currentIndex];
    final questionText = question['question']?.toString() ?? '';
    final options = List<String>.from(question['options'] ?? const []);
    final userSelection = _selectedAnswers[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        actions: [
          TextButton.icon(
            onPressed: _submitQuiz,
            icon: const Icon(Iconsax.tick_circle, size: 18),
            label: const Text(
              'Submit',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentIndex + 1} of ${widget.questions.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${_selectedAnswers.where((a) => a != null).length}/${widget.questions.length} Answered',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (_currentIndex + 1) / widget.questions.length,
                borderRadius: BorderRadius.circular(8),
                minHeight: 6,
              ),
              const SizedBox(height: 24),

              // Question Prompt Card
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.15,
                            ),
                          ),
                        ),
                        child: Text(
                          questionText,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Multiple Choice Options
                      ...List.generate(options.length, (optIdx) {
                        final isSelected = userSelection == optIdx;
                        final letter = String.fromCharCode(65 + optIdx);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          width: double.infinity,
                          child: InkWell(
                            onTap: () => _selectOption(optIdx),
                            borderRadius: BorderRadius.circular(16),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.12)
                                    : theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : theme.colorScheme.outline.withValues(
                                          alpha: 0.2,
                                        ),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: isSelected
                                        ? AppColors.primary
                                        : theme.colorScheme.outline.withValues(
                                            alpha: 0.15,
                                          ),
                                    child: Text(
                                      letter,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.white
                                            : theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      options[optIdx],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Bottom Navigation Buttons
              Row(
                children: [
                  if (_currentIndex > 0)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _previous,
                        icon: const Icon(Iconsax.arrow_left_2),
                        label: const Text('Previous'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                    ),
                  if (_currentIndex > 0) const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _currentIndex == widget.questions.length - 1
                          ? _submitQuiz
                          : _next,
                      icon: Icon(
                        _currentIndex == widget.questions.length - 1
                            ? Iconsax.tick_circle
                            : Iconsax.arrow_right_3,
                      ),
                      label: Text(
                        _currentIndex == widget.questions.length - 1
                            ? 'Finish & Submit'
                            : 'Next',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsView(ThemeData theme) {
    final percentage = ((_score / widget.questions.length) * 100).round();
    final isPassed = percentage >= 60;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Result Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isPassed
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isPassed
                        ? Colors.green.withValues(alpha: 0.3)
                        : Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      isPassed ? Iconsax.cup : Iconsax.refresh,
                      size: 48,
                      color: isPassed ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: isPassed ? Colors.green : Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isPassed
                          ? 'Passed! Excellent comprehension.'
                          : 'Review your mistakes below and retry.',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Scored $_score out of ${widget.questions.length} questions correctly.',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _retryQuiz,
                      icon: const Icon(Iconsax.refresh),
                      label: const Text('Retry Quiz'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Iconsax.tick_circle),
                      label: const Text('Done'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              const Text(
                'Review Answers & Explanations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Review of Questions
              ...List.generate(widget.questions.length, (idx) {
                final q = widget.questions[idx];
                final qText = q['question']?.toString() ?? '';
                final options = List<String>.from(q['options'] ?? const []);
                final correct = q['answer'] as int? ?? 0;
                final userAns = _selectedAnswers[idx];
                final isCorrect = userAns == correct;
                final explanation = q['explanation']?.toString() ?? '';

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isCorrect
                          ? Colors.green.withValues(alpha: 0.3)
                          : Colors.redAccent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isCorrect
                                ? Iconsax.tick_circle
                                : Iconsax.close_circle,
                            color: isCorrect ? Colors.green : Colors.redAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Question ${idx + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isCorrect
                                  ? Colors.green
                                  : Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        qText,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your answer: ${userAns != null && userAns < options.length ? options[userAns] : "(No answer)"}',
                        style: TextStyle(
                          color: isCorrect ? Colors.green : Colors.redAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      if (!isCorrect && correct < options.length) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Correct answer: ${options[correct]}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                      if (explanation.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Explanation: $explanation',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
