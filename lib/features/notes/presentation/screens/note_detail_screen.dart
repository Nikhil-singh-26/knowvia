import 'dart:io';
import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../../core/ai/ai_provider.dart';
import '../../../../core/ai/concept_service.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import '../../../../core/utils/attachment_helper.dart';
import '../../../../core/utils/connectivity_service.dart';

class NoteDetailScreen extends ConsumerStatefulWidget {
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  ConsumerState<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends ConsumerState<NoteDetailScreen> {
  late Note _currentNote;
  final TextEditingController _qaQuestionController = TextEditingController();
  final ScrollController _qaScrollController = ScrollController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _isQaLoading = false;

  @override
  void initState() {
    super.initState();
    _currentNote = widget.note;
  }

  @override
  void dispose() {
    _qaQuestionController.dispose();
    _qaScrollController.dispose();
    super.dispose();
  }

  bool _isOnline() {
    return ref.read(connectivityProvider).value ?? true;
  }

  void _showOfflineMessage() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AI features require an internet connection.'),
      ),
    );
  }

  Future<void> _deleteNote() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete note?'),
          content: const Text('This note will be permanently deleted.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    final database = ref.read(databaseProvider);

    await (database.delete(
      database.notes,
    )..where((tbl) => tbl.id.equals(_currentNote.id))).go();

    if (!mounted) return;
    if (!context.mounted) return;

    Navigator.of(context).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Note deleted')));
  }

  void _shareNote(Note note) {
    final text =
        '''
${note.title}

Category: ${note.category}

${note.content}
''';

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Note'),
          content: SelectableText(text),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _openAttachment(BuildContext context, File file) {
    final extension = file.path.split('.').last.toLowerCase();
    final isImage = ['jpg', 'jpeg', 'png', 'webp', 'gif'].contains(extension);

    if (isImage) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4,
                child: Image.file(file, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Attachment'),
          content: Text(file.path.split(Platform.pathSeparator).last),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editNote(Note note) async {
    final titleController = TextEditingController(text: note.title);
    final categoryController = TextEditingController(text: note.category);
    final contentController = TextEditingController(text: note.content);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contentController,
                  minLines: 4,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final category = categoryController.text.trim();
                final content = contentController.text.trim();

                if (title.isEmpty || category.isEmpty) {
                  if (dialogContext.mounted) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(
                        content: Text('Title and category are required'),
                      ),
                    );
                  }
                  return;
                }

                final database = ref.read(databaseProvider);
                await (database.update(
                  database.notes,
                )..where((tbl) => tbl.id.equals(note.id))).write(
                  NotesCompanion(
                    title: drift.Value(title),
                    category: drift.Value(category),
                    content: drift.Value(content),
                    updatedAt: drift.Value(DateTime.now()),
                  ),
                );

                if (!dialogContext.mounted) return;
                Navigator.of(dialogContext).pop();

                if (!mounted) return;
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Note updated')));
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    titleController.dispose();
    categoryController.dispose();
    contentController.dispose();
  }

  void _dismissLoadingDialog(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  Future<void> _analyzeWithAi(
    BuildContext context,
    WidgetRef ref,
    Note note,
  ) async {
    if (!_isOnline()) {
      _showOfflineMessage();
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Expanded(child: Text('AI is analyzing your note...')),
            ],
          ),
        );
      },
    );

    try {
      final service = ref.read(geminiServiceProvider);
      final result = await service.analyzeNote(
        title: note.title,
        content: note.content,
        category: note.category,
      );

      final data = jsonDecode(result) as Map<String, dynamic>;
      final database = ref.read(databaseProvider);

      await (database.update(
        database.notes,
      )..where((tbl) => tbl.id.equals(note.id))).write(
        NotesCompanion(
          aiSummary: drift.Value(data['summary']?.toString() ?? ''),
          aiTopics: drift.Value(jsonEncode(data['topics'] ?? [])),
          aiKeywords: drift.Value(jsonEncode(data['keywords'] ?? [])),
          aiDifficulty: drift.Value(data['difficulty']?.toString() ?? ''),
          aiRelatedConcepts: drift.Value(
            jsonEncode(data['relatedConcepts'] ?? []),
          ),
          updatedAt: drift.Value(DateTime.now()),
        ),
      );

      final updatedNote = await database.getNoteById(note.id);
      if (updatedNote != null) {
        await ref.read(conceptServiceProvider).processNoteForMap(updatedNote);
      }

      if (!mounted || !context.mounted) return;

      _dismissLoadingDialog(context);
      _showAiResult(context, result);
    } catch (e) {
      if (!mounted || !context.mounted) return;
      _dismissLoadingDialog(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('AI analysis failed: $e')));
    }
  }

  void _showAiResult(BuildContext context, String result) {
    try {
      final data = jsonDecode(result) as Map<String, dynamic>;
      final summary = data['summary']?.toString() ?? '';
      final topics = List<String>.from(data['topics'] ?? const []);
      final keywords = List<String>.from(data['keywords'] ?? const []);
      final difficulty = data['difficulty']?.toString() ?? '';
      final relatedConcepts = List<String>.from(
        data['relatedConcepts'] ?? const [],
      );

      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.75,
            maxChildSize: 0.95,
            minChildSize: 0.5,
            builder: (context, controller) {
              return ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                children: [
                  const Text(
                    'AI Analysis',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Summary',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    summary,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Difficulty',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Chip(label: Text(difficulty)),
                  const SizedBox(height: 22),
                  _AiSection(title: 'Topics', items: topics),
                  const SizedBox(height: 18),
                  _AiSection(title: 'Keywords', items: keywords),
                  const SizedBox(height: 18),
                  _AiSection(title: 'Related Concepts', items: relatedConcepts),
                ],
              );
            },
          );
        },
      );
    } catch (_) {
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('AI Analysis'),
            content: SingleChildScrollView(child: SelectableText(result)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _studyNext(
    BuildContext context,
    WidgetRef ref,
    Note note,
  ) async {
    if (!_isOnline()) {
      _showOfflineMessage();
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Expanded(child: Text('Creating your study plan...')),
            ],
          ),
        );
      },
    );

    try {
      final service = ref.read(geminiServiceProvider);
      final result = await service.generateStudyPlan(
        title: note.title,
        content: note.content,
        category: note.category,
      );

      if (!mounted || !context.mounted) return;
      _dismissLoadingDialog(context);
      _showStudyPlan(context, result);
    } catch (e) {
      if (!mounted || !context.mounted) return;
      _dismissLoadingDialog(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Study plan failed: $e')));
    }
  }

  void _showStudyPlan(BuildContext context, String result) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (context, controller) {
            return ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
              children: [
                const Text(
                  'Study Next',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Recommended learning path based on this note.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: SelectableText(
                    result,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _generateFlashcards(
    BuildContext context,
    WidgetRef ref,
    Note note,
  ) async {
    if (!_isOnline()) {
      _showOfflineMessage();
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Expanded(child: Text('Creating flashcards...')),
            ],
          ),
        );
      },
    );

    try {
      final service = ref.read(geminiServiceProvider);
      final result = await service.generateFlashcards(
        title: note.title,
        content: note.content,
        category: note.category,
      );

      if (!mounted || !context.mounted) return;
      _dismissLoadingDialog(context);
      _showFlashcards(context, note, result);
    } catch (e) {
      if (!mounted || !context.mounted) return;
      _dismissLoadingDialog(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Flashcard generation failed: $e')),
      );
    }
  }

  void _showFlashcards(BuildContext context, Note note, String result) {
    try {
      final data = jsonDecode(result) as Map<String, dynamic>;
      final cards = List<Map<String, dynamic>>.from(
        (data['cards'] as List).map((card) => Map<String, dynamic>.from(card)),
      );
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _FlashcardsScreen(title: note.title, cards: cards),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not read generated flashcards')),
      );
    }
  }

  Future<void> _generateQuiz(
    BuildContext context,
    WidgetRef ref,
    Note note,
  ) async {
    if (!_isOnline()) {
      _showOfflineMessage();
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Expanded(child: Text('AI is creating your quiz...')),
            ],
          ),
        );
      },
    );

    try {
      final service = ref.read(geminiServiceProvider);
      final result = await service.generateQuiz(
        title: note.title,
        content: note.content,
        category: note.category,
      );

      if (!mounted || !context.mounted) return;
      _dismissLoadingDialog(context);
      _showQuiz(context, note, result);
    } catch (e) {
      if (!mounted || !context.mounted) return;
      _dismissLoadingDialog(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Quiz generation failed: $e')));
    }
  }

  void _showQuiz(BuildContext context, Note note, String result) {
    try {
      final data = jsonDecode(result) as Map<String, dynamic>;
      final questions = List<Map<String, dynamic>>.from(
        (data['questions'] as List).map(
          (question) => Map<String, dynamic>.from(question),
        ),
      );
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _QuizScreen(title: note.title, questions: questions),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not read the generated quiz')),
      );
    }
  }

  Future<void> _listenQa() async {
    if (!_isListening) {
      final available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              if (val.recognizedWords.isNotEmpty) {
                _qaQuestionController.text = val.recognizedWords;
              }
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _submitDocQa(Note note, String queryText) async {
    final query = queryText.trim();
    if (query.isEmpty) return;

    if (!_isOnline()) {
      _showOfflineMessage();
      return;
    }

    _qaQuestionController.clear();
    setState(() => _isQaLoading = true);
    FocusScope.of(context).unfocus();

    try {
      final gemini = ref.read(geminiServiceProvider);
      final db = ref.read(databaseProvider);

      final pastQas = await db.getQasForDocument(note.id);
      final history = pastQas.map((q) => {
        'question': q.question,
        'answer': q.answer,
      }).toList();

      final answer = await gemini.askDocumentQuestion(
        documentTitle: note.title,
        documentContent: note.content,
        question: query,
        history: history,
      );

      await db.insertQa(
        documentId: note.id,
        question: query,
        answer: answer,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_qaScrollController.hasClients) {
          _qaScrollController.animateTo(
            _qaScrollController.position.maxScrollExtent + 200,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Q&A Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isQaLoading = false);
    }
  }

  Future<void> _clearDocQa(Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Clear Q&A History?'),
        content: const Text(
          'This will delete all saved questions and answers for this document.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final db = ref.read(databaseProvider);
      await db.clearQasForDocument(note.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document Q&A history cleared')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = ref.watch(databaseProvider);

    return StreamBuilder<Note?>(
      stream: (database.select(
        database.notes,
      )..where((t) => t.id.equals(widget.note.id))).watchSingleOrNull(),
      builder: (context, snapshot) {
        final note = snapshot.data ?? _currentNote;
        final attachments = AttachmentHelper.decode(note.attachmentPaths);

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Document Details',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              bottom: const TabBar(
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                tabs: [
                  Tab(icon: Icon(Iconsax.document_text), text: 'Content'),
                  Tab(icon: Icon(Iconsax.message_question), text: 'AI Q&A'),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: 'AI Analysis',
                  onPressed: () {
                    if (note.aiSummary != null &&
                        note.aiSummary!.trim().isNotEmpty) {
                      final cachedResult = jsonEncode({
                        'summary': note.aiSummary,
                        'topics': note.aiTopics == null
                            ? []
                            : jsonDecode(note.aiTopics!),
                        'keywords': note.aiKeywords == null
                            ? []
                            : jsonDecode(note.aiKeywords!),
                        'difficulty': note.aiDifficulty ?? '',
                        'relatedConcepts': note.aiRelatedConcepts == null
                            ? []
                            : jsonDecode(note.aiRelatedConcepts!),
                      });
                      _showAiResult(context, cachedResult);
                    } else {
                      _analyzeWithAi(context, ref, note);
                    }
                  },
                  icon: const Icon(Iconsax.magic_star),
                ),
                IconButton(
                  tooltip: 'Edit',
                  onPressed: () => _editNote(note),
                  icon: const Icon(Iconsax.edit),
                ),
                IconButton(
                  tooltip: 'Share',
                  onPressed: () => _shareNote(note),
                  icon: const Icon(Iconsax.share),
                ),
                IconButton(
                  tooltip: 'Delete',
                  onPressed: _deleteNote,
                  icon: const Icon(Iconsax.trash),
                ),
              ],
            ),
            body: TabBarView(
              children: [
                _buildOverviewTab(context, note, attachments),
                _buildQaTab(context, note),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOverviewTab(
    BuildContext context,
    Note note,
    List<String> attachments,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.title,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  note.category,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Iconsax.document_favorite, size: 14),
                    const SizedBox(width: 5),
                    Text(
                      note.sourceType.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // AI Summary Banner if present
          if (note.aiSummary != null && note.aiSummary!.trim().isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Iconsax.magic_star, size: 18, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'AI Executive Summary',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.aiSummary!,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Extracted Text Card
          const Text(
            'Document Content',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.18),
              ),
            ),
            child: SelectableText(
              note.content.trim().isEmpty ? 'No content' : note.content,
              style: const TextStyle(fontSize: 15, height: 1.6),
            ),
          ),

          if (attachments.isNotEmpty) ...[
            const SizedBox(height: 22),
            const Text(
              'Attachments',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ...attachments.map((path) {
              final file = File(path);
              final extension = path.split('.').last.toLowerCase();
              final isImage = [
                'jpg',
                'jpeg',
                'png',
                'webp',
                'gif',
              ].contains(extension);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.18),
                  ),
                ),
                child: isImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: GestureDetector(
                          onTap: () => _openAttachment(context, file),
                          child: Image.file(
                            file,
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text('Image could not be loaded'),
                                ),
                          ),
                        ),
                      )
                    : ListTile(
                        leading: const Icon(
                          Iconsax.document,
                          color: AppColors.primary,
                        ),
                        title: Text(
                          file.path.split(Platform.pathSeparator).last,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          tooltip: 'Open',
                          icon: const Icon(Iconsax.export),
                          onPressed: () => _openAttachment(context, file),
                        ),
                      ),
              );
            }),
          ],

          const SizedBox(height: 24),

          // Study & Analysis Tools
          const Text(
            'Document Tools',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.tonalIcon(
              onPressed: () => _generateQuiz(context, ref, note),
              icon: const Icon(Iconsax.task_square),
              label: const Text(
                'Generate Knowledge Quiz',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () => _generateFlashcards(context, ref, note),
              icon: const Icon(Iconsax.cards),
              label: const Text(
                'Study with Flashcards',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () => _studyNext(context, ref, note),
              icon: const Icon(Iconsax.teacher),
              label: const Text(
                'What should I study next?',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildQaTab(BuildContext context, Note note) {
    final db = ref.watch(databaseProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final suggested = [
      'Summarize this document in 3 key points',
      'What are the core conclusions or takeaways?',
      'Explain complex concepts mentioned here',
      'List all action items or facts',
    ];

    return Column(
      children: [
        // Top Toolbar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: theme.colorScheme.surface,
          child: Row(
            children: [
              const Icon(Iconsax.message_question, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Ask AI questions about this document',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                icon: const Icon(Iconsax.trash, size: 18),
                tooltip: 'Clear Q&A History',
                onPressed: () => _clearDocQa(note),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // Chat stream
        Expanded(
          child: StreamBuilder<List<DocumentQa>>(
            stream: db.watchQasForDocument(note.id),
            builder: (context, snapshot) {
              final qas = snapshot.data ?? [];

              if (qas.isEmpty && !_isQaLoading) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Iconsax.messages_3,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Ask anything about "${note.title}"',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Type or speak your question below.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: suggested.map((q) {
                          return ActionChip(
                            avatar: const Icon(Iconsax.magic_star, size: 14, color: AppColors.primary),
                            label: Text(q, style: const TextStyle(fontSize: 12)),
                            onPressed: () => _submitDocQa(note, q),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: _qaScrollController,
                padding: const EdgeInsets.all(16),
                itemCount: qas.length + (_isQaLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == qas.length) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(alpha: 0.15),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Analyzing document...',
                              style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final qa = qas[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // User Question
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.8,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              qa.question,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // AI Answer
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E1E26) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.outline.withValues(alpha: 0.15),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Iconsax.magic_star,
                                      size: 14,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      'Know Via AI',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Iconsax.copy, size: 15),
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        Clipboard.setData(
                                          ClipboardData(text: qa.answer),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Copied to clipboard'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                MarkdownBody(
                                  data: qa.answer,
                                  selectable: true,
                                  styleSheet: MarkdownStyleSheet.fromTheme(
                                    theme,
                                  ).copyWith(
                                    p: TextStyle(
                                      fontSize: 14,
                                      height: 1.5,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  DateFormat('h:mm a').format(qa.createdAt),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Bottom Input Area
        Container(
          padding: EdgeInsets.fromLTRB(
            16,
            8,
            16,
            MediaQuery.of(context).padding.bottom + 8,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.12),
              ),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  _isListening ? Iconsax.stop : Iconsax.microphone_2,
                  color: _isListening ? Colors.red : AppColors.primary,
                ),
                onPressed: _listenQa,
              ),
              Expanded(
                child: TextField(
                  controller: _qaQuestionController,
                  minLines: 1,
                  maxLines: 4,
                  onSubmitted: (txt) => _submitDocQa(note, txt),
                  decoration: InputDecoration(
                    hintText: 'Ask about this document...',
                    hintStyle: const TextStyle(fontSize: 13),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                icon: _isQaLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Iconsax.send_1, size: 16),
                onPressed: _isQaLoading
                    ? null
                    : () => _submitDocQa(note, _qaQuestionController.text),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AiSection extends StatelessWidget {
  final String title;
  final List<String> items;
  const _AiSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) => Chip(label: Text(item))).toList(),
        ),
      ],
    );
  }
}

class _QuizScreen extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> questions;
  const _QuizScreen({required this.title, required this.questions});
  @override
  State<_QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<_QuizScreen> {
  int currentQuestion = 0;
  int score = 0;
  int? selectedAnswer;
  bool answered = false;

  void _selectAnswer(int index) {
    if (answered) return;
    final correctAnswer = widget.questions[currentQuestion]['answer'] as int;
    setState(() {
      selectedAnswer = index;
      answered = true;
      if (index == correctAnswer) score++;
    });
  }

  void _nextQuestion() {
    if (currentQuestion == widget.questions.length - 1) {
      _showResult();
      return;
    }
    setState(() {
      currentQuestion++;
      selectedAnswer = null;
      answered = false;
    });
  }

  void _showResult() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quiz Complete 🎉'),
          content: Text('You scored $score out of ${widget.questions.length}.'),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentQuestion];
    final questionText = question['question']?.toString() ?? '';
    final options = List<String>.from(question['options'] ?? const []);
    final correctAnswer = question['answer'] as int;
    final explanation = question['explanation']?.toString() ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Knowledge Quiz',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (currentQuestion + 1) / widget.questions.length,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 24),
            Text(
              'Question ${currentQuestion + 1} of ${widget.questions.length}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              questionText,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(options.length, (index) {
              final isSelected = selectedAnswer == index;
              final isCorrect = index == correctAnswer;
              Color? background;
              if (answered && isCorrect) {
                background = Colors.green.withValues(alpha: 0.15);
              } else if (answered && isSelected) {
                background = Colors.red.withValues(alpha: 0.15);
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(16),
                    backgroundColor: background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => _selectAnswer(index),
                  child: Text(
                    '${String.fromCharCode(65 + index)}. ${options[index]}',
                  ),
                ),
              );
            }),
            if (answered) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(explanation, style: const TextStyle(height: 1.5)),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _nextQuestion,
                  child: Text(
                    currentQuestion == widget.questions.length - 1
                        ? 'See Result'
                        : 'Next Question',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FlashcardsScreen extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> cards;
  const _FlashcardsScreen({required this.title, required this.cards});
  @override
  State<_FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<_FlashcardsScreen> {
  int currentCard = 0;
  bool showAnswer = false;

  void _nextCard() {
    if (currentCard == widget.cards.length - 1) {
      setState(() {
        currentCard = 0;
        showAnswer = false;
      });
      return;
    }
    setState(() {
      currentCard++;
      showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.cards[currentCard];
    final question = card['question']?.toString() ?? '';
    final answer = card['answer']?.toString() ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flashcards',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Card ${currentCard + 1} of ${widget.cards.length}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: (currentCard + 1) / widget.cards.length,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() {
                  showAnswer = !showAnswer;
                }),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Column(
                        key: ValueKey(showAnswer),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            showAnswer
                                ? Iconsax.tick_circle
                                : Iconsax.message_question,
                            size: 42,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            showAnswer ? answer : question,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            showAnswer
                                ? 'Tap to see question'
                                : 'Tap to reveal answer',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: _nextCard,
                icon: const Icon(Iconsax.arrow_right),
                label: Text(
                  currentCard == widget.cards.length - 1
                      ? 'Restart'
                      : 'Next Card',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
