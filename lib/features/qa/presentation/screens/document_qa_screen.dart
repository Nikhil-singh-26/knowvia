import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../../app/theme/app_colors.dart';
import '../../../../core/ai/ai_provider.dart';
import '../../../../core/database/database.dart';
import '../../../../core/utils/connectivity_service.dart';
import '../../../../main.dart';

class DocumentQaScreen extends ConsumerStatefulWidget {
  final String? initialDocumentId;

  const DocumentQaScreen({super.key, this.initialDocumentId});

  @override
  ConsumerState<DocumentQaScreen> createState() => _DocumentQaScreenState();
}

class _DocumentQaScreenState extends ConsumerState<DocumentQaScreen> {
  final TextEditingController _questionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final stt.SpeechToText _speech = stt.SpeechToText();

  String? _selectedDocumentId;
  bool _isListening = false;
  bool _isLoading = false;
  final List<String> _suggestedQuestions = const [
    'Summarize this document in 3 bullet points',
    'What are the key takeaways?',
    'Explain the most important concepts',
    'List any action items or findings',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDocumentId = widget.initialDocumentId;
  }

  @override
  void dispose() {
    _questionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool _isOnline() {
    return ref.read(connectivityProvider).value ?? true;
  }

  void _showOfflineMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AI features require an active internet connection.'),
      ),
    );
  }

  Future<void> _listen() async {
    if (!_isListening) {
      final available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              if (val.recognizedWords.isNotEmpty) {
                _questionController.text = val.recognizedWords;
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

  Future<void> _submitQuestion(String questionText, List<Note> allDocs) async {
    final query = questionText.trim();
    if (query.isEmpty) return;

    if (!_isOnline()) {
      _showOfflineMessage();
      return;
    }

    if (allDocs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a document first.')),
      );
      return;
    }

    _questionController.clear();
    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    try {
      final gemini = ref.read(geminiServiceProvider);
      final db = ref.read(databaseProvider);

      String answer = '';

      if (_selectedDocumentId != null) {
        final currentDoc = allDocs.firstWhere(
          (d) => d.id == _selectedDocumentId,
          orElse: () => allDocs.first,
        );

        final pastQas = await db.getQasForDocument(currentDoc.id);
        final history = pastQas
            .map((q) => {'question': q.question, 'answer': q.answer})
            .toList();

        answer = await gemini.askDocumentQuestion(
          documentTitle: currentDoc.title,
          documentContent: currentDoc.content,
          question: query,
          history: history,
        );

        await db.insertQa(
          documentId: currentDoc.id,
          question: query,
          answer: answer,
        );
      } else {
        // Global search across all documents
        final docsData = allDocs
            .map(
              (d) => {
                'id': d.id,
                'title': d.title,
                'category': d.category,
                'content': d.content,
              },
            )
            .toList();

        final pastQas = await db.getQasForDocument(null);

        final history = pastQas
            .map((q) => {'question': q.question, 'answer': q.answer})
            .toList();

        answer = await gemini.askGlobalQuestion(
          documents: docsData,
          question: query,
          history: history,
        );

        await db.insertQa(documentId: null, question: query, answer: answer);
      }

      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Q&A Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Clear Q&A History?'),
        content: const Text(
          'This will delete all saved questions and answers for this session.',
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
      await db.clearQasForDocument(_selectedDocumentId);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Q&A history cleared')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Iconsax.message_question, color: AppColors.primary, size: 24),
            SizedBox(width: 10),
            Text(
              'AI Document Q&A',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Clear History',
            icon: const Icon(Iconsax.trash, size: 20),
            onPressed: _clearHistory,
          ),
        ],
      ),
      body: StreamBuilder<List<Note>>(
        stream: db.select(db.notes).watch(),
        builder: (context, noteSnapshot) {
          final allDocs = noteSnapshot.data ?? [];

          if (noteSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Document Selector Bar
              _buildDocumentSelector(allDocs),

              // Q&A Conversation Stream
              Expanded(
                child: StreamBuilder<List<DocumentQa>>(
                  stream: db.watchQasForDocument(_selectedDocumentId),
                  builder: (context, qaSnapshot) {
                    final qas = qaSnapshot.data ?? [];

                    if (allDocs.isEmpty) {
                      return _buildEmptyDocsState();
                    }

                    if (qas.isEmpty && !_isLoading) {
                      return _buildEmptyQaState(allDocs);
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: qas.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == qas.length) {
                          return _buildLoadingBubble();
                        }
                        final qa = qas[index];
                        return _buildQaItem(qa, allDocs);
                      },
                    );
                  },
                ),
              ),

              // Bottom Input Bar
              _buildInputBar(allDocs),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDocumentSelector(List<Note> allDocs) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.12),
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(Iconsax.document_text, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          const Text(
            'Target:',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                value:
                    _selectedDocumentId != null &&
                        allDocs.any((d) => d.id == _selectedDocumentId)
                    ? _selectedDocumentId
                    : null,
                isExpanded: true,
                hint: const Text(
                  'All Documents (Global Search)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text(
                      'All Documents (Global Search)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  ...allDocs.map((doc) {
                    return DropdownMenuItem<String?>(
                      value: doc.id,
                      child: Text(
                        doc.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                    );
                  }),
                ],
                onChanged: (val) {
                  setState(() {
                    _selectedDocumentId = val;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDocsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.document_upload,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No Documents Found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Upload a PDF, document, camera scan, or paste text to start asking questions.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/notes/create');
              },
              icon: const Icon(Iconsax.add),
              label: const Text('Upload Document'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyQaState(List<Note> allDocs) {
    String docName = 'your documents';
    if (_selectedDocumentId != null) {
      final doc = allDocs.firstWhere(
        (d) => d.id == _selectedDocumentId,
        orElse: () => allDocs.first,
      );
      docName = '"${doc.title}"';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.magic_star,
                color: AppColors.primary,
                size: 36,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Ask anything about $docName',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Get instant AI answers with references and key takeaways.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Suggested Questions',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: _suggestedQuestions.map((q) {
              return ActionChip(
                avatar: const Icon(
                  Iconsax.message_question,
                  size: 16,
                  color: AppColors.primary,
                ),
                label: Text(q, style: const TextStyle(fontSize: 13)),
                backgroundColor: Theme.of(context).colorScheme.surface,
                side: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.2),
                ),
                onPressed: () => _submitQuestion(q, allDocs),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQaItem(DocumentQa qa, List<Note> allDocs) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // User Question Bubble
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.82,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      qa.question,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // AI Answer Card
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.92,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E26) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Iconsax.magic_star,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
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
                        icon: const Icon(Iconsax.copy, size: 16),
                        tooltip: 'Copy Answer',
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: qa.answer));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Answer copied to clipboard'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  MarkdownBody(
                    data: qa.answer,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                      p: TextStyle(
                        fontSize: 14.5,
                        height: 1.55,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('MMM d, h:mm a').format(qa.createdAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.outline.withValues(alpha: 0.15),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text(
              'Know Via is analyzing your document...',
              style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(List<Note> allDocs) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        MediaQuery.of(context).padding.bottom + 10,
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
            tooltip: _isListening ? 'Stop Voice' : 'Voice Dictation',
            onPressed: _listen,
          ),
          Expanded(
            child: TextField(
              controller: _questionController,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (txt) => _submitQuestion(txt, allDocs),
              decoration: InputDecoration(
                hintText: 'Ask a question about documents...',
                hintStyle: const TextStyle(fontSize: 14),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.4,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            icon: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Iconsax.send_1, size: 18),
            onPressed: _isLoading
                ? null
                : () => _submitQuestion(_questionController.text, allDocs),
          ),
        ],
      ),
    );
  }
}
