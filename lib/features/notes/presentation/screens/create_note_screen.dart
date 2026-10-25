import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:drift/drift.dart' as drift;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import '../../../../core/utils/attachment_helper.dart';
import '../../../../core/utils/media_picker_helper.dart';
import '../../../../core/utils/connectivity_service.dart';
import '../../../../core/ai/ai_provider.dart';

class CreateNoteScreen extends ConsumerStatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  ConsumerState<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends ConsumerState<CreateNoteScreen> {
  final List<File> _attachments = [];
  String _sourceType = 'text';
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String selectedCategory = 'General';
  bool _isListening = false;
  late stt.SpeechToText _speech;
  bool _isLoading = false;
  String _loadingMessage = '';

  bool _isOnline() {
    return ref.read(connectivityProvider).value ?? true;
  }

  void _showOfflineMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AI extraction features require an internet connection.'),
      ),
    );
  }

  final categories = const [
    'General',
    'Research',
    'Programming',
    'Academic',
    'Business',
    'Legal',
    'Personal',
    'Ideas',
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    try {
      await [
        Permission.camera,
        Permission.microphone,
        Permission.storage,
        Permission.photos,
      ].request();
    } catch (_) {}
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> _extractFromFile(File file, {String? defaultSource}) async {
    final filename = file.path.split(Platform.pathSeparator).last;
    final ext = filename.split('.').last.toLowerCase();

    // Auto set title if empty
    if (titleController.text.trim().isEmpty) {
      final nameWithoutExt = filename.contains('.')
          ? filename.substring(0, filename.lastIndexOf('.'))
          : filename;
      titleController.text = nameWithoutExt
          .replaceAll('_', ' ')
          .replaceAll('-', ' ');
    }

    if (['txt', 'md', 'csv', 'json', 'log'].contains(ext)) {
      try {
        final text = await file.readAsString();
        if (text.isNotEmpty) {
          contentController.text = contentController.text.isEmpty
              ? text
              : '${contentController.text}\n\n$text';
          await _showMetadataSuggestion(contentController.text);
        }
      } catch (_) {}
      return;
    }

    if (!_isOnline()) {
      _showOfflineMessage();
      return;
    }

    setState(() {
      _isLoading = true;
      _loadingMessage = 'AI is extracting document text...';
    });

    try {
      final bytes = await file.readAsBytes();
      String extracted = '';

      if (['jpg', 'jpeg', 'png', 'webp'].contains(ext)) {
        final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';
        extracted = await ref
            .read(geminiServiceProvider)
            .performOcr(bytes, mimeType);
      } else if (ext == 'pdf') {
        extracted = await ref
            .read(geminiServiceProvider)
            .extractDocumentContent(
              bytes: bytes,
              mimeType: 'application/pdf',
              fileName: filename,
            );
      } else if (ext == 'doc' || ext == 'docx') {
        try {
          final binaryStr = String.fromCharCodes(bytes);
          final matches = RegExp(
            r'<w:t[^>]*>(.*?)</w:t>',
          ).allMatches(binaryStr);
          if (matches.isNotEmpty) {
            final buffer = StringBuffer();
            for (final m in matches) {
              final val = m.group(1);
              if (val != null) buffer.write('$val ');
            }
            extracted = buffer.toString().trim();
          }
        } catch (_) {}

        if (extracted.isEmpty) {
          extracted = await ref
              .read(geminiServiceProvider)
              .extractDocumentContent(
                bytes: bytes,
                mimeType: 'application/octet-stream',
                fileName: filename,
              );
        }
      } else {
        extracted = await ref
            .read(geminiServiceProvider)
            .extractDocumentContent(
              bytes: bytes,
              mimeType: 'application/octet-stream',
              fileName: filename,
            );
      }

      if (extracted.isNotEmpty) {
        contentController.text = contentController.text.isEmpty
            ? extracted
            : '${contentController.text}\n\n$extracted';
        await _showMetadataSuggestion(contentController.text);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Document extraction note: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadingMessage = '';
        });
      }
    }
  }

  Future<void> _showMetadataSuggestion(String content) async {
    if (!_isOnline() || content.trim().isEmpty) return;
    try {
      final result = await ref
          .read(geminiServiceProvider)
          .suggestMetadata(content);
      final data = jsonDecode(result) as Map<String, dynamic>;

      if (titleController.text.isEmpty && data['title'] != null) {
        titleController.text = data['title'];
      }
      if (data['category'] != null && categories.contains(data['category'])) {
        setState(() => selectedCategory = data['category']);
      }
    } catch (_) {}
  }

  Future<void> _addFromGallery() async {
    final path = await MediaPickerHelper.gallery();
    if (path == null) return;
    setState(() {
      _attachments.add(path);
      _sourceType = 'image';
    });
    await _extractFromFile(path, defaultSource: 'image');
  }

  Future<void> _addFromCamera() async {
    final path = await MediaPickerHelper.camera();
    if (path == null) return;
    setState(() {
      _attachments.add(path);
      _sourceType = 'camera';
    });
    await _extractFromFile(path, defaultSource: 'camera');
  }

  Future<void> _addFile() async {
    final path = await MediaPickerHelper.file();
    if (path == null) return;
    final ext = path.path.split('.').last.toLowerCase();
    setState(() {
      _attachments.add(path);
      _sourceType = ext == 'pdf'
          ? 'pdf'
          : (['doc', 'docx'].contains(ext) ? 'doc' : 'file');
    });
    await _extractFromFile(path);
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.trim().isNotEmpty) {
      final pasted = data.text!.trim();
      contentController.text = contentController.text.isEmpty
          ? pasted
          : '${contentController.text}\n\n$pasted';
      _sourceType = 'text';
      await _showMetadataSuggestion(contentController.text);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Pasted from clipboard')));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Clipboard is empty')));
      }
    }
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
          _sourceType = 'voice';
        });
        _speech.listen(
          onResult: (val) => setState(() {
            if (val.recognizedWords.isNotEmpty) {
              contentController.text =
                  '${contentController.text} ${val.recognizedWords}'.trim();
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      await _showMetadataSuggestion(contentController.text);
    }
  }

  Future<void> _saveDocument() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a document title')),
      );
      return;
    }

    if (content.isEmpty && _attachments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add document content or attach a file'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _loadingMessage = 'Saving document & generating summary...';
    });

    try {
      final database = ref.read(databaseProvider);
      final now = DateTime.now();
      final docId = DateTime.now().microsecondsSinceEpoch.toString();

      String? summary;
      if (_isOnline() && content.isNotEmpty) {
        try {
          final analysis = await ref
              .read(geminiServiceProvider)
              .analyzeNote(
                title: title,
                content: content,
                category: selectedCategory,
              );
          final parsed = jsonDecode(analysis) as Map<String, dynamic>;
          summary = parsed['summary']?.toString();
        } catch (_) {}
      }

      await database
          .into(database.notes)
          .insert(
            NotesCompanion(
              id: drift.Value(docId),
              title: drift.Value(title),
              content: drift.Value(
                content.isEmpty ? 'File attachment: $title' : content,
              ),
              category: drift.Value(selectedCategory),
              createdAt: drift.Value(now),
              updatedAt: drift.Value(now),
              sourceType: drift.Value(_sourceType),
              attachmentPaths: drift.Value(
                AttachmentHelper.encode(_attachments),
              ),
              aiSummary: summary != null
                  ? drift.Value(summary)
                  : const drift.Value.absent(),
            ),
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Document added successfully!'),
          action: SnackBarAction(
            label: 'Ask Q&A',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving document: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload Document',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _saveDocument,
            tooltip: 'Save Document',
            icon: const Icon(Iconsax.tick_circle),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Import Options Strip
            const Text(
              'Import / Extract From',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildInputOptionChip(
                    icon: Iconsax.document_upload,
                    label: 'Files (PDF, DOC, TXT)',
                    color: Colors.blue,
                    onTap: _addFile,
                  ),
                  const SizedBox(width: 8),
                  _buildInputOptionChip(
                    icon: Iconsax.camera,
                    label: 'Camera Scan',
                    color: Colors.purple,
                    onTap: _addFromCamera,
                  ),
                  const SizedBox(width: 8),
                  _buildInputOptionChip(
                    icon: Iconsax.gallery,
                    label: 'Gallery (JPG, PNG)',
                    color: Colors.green,
                    onTap: _addFromGallery,
                  ),
                  const SizedBox(width: 8),
                  _buildInputOptionChip(
                    icon: Iconsax.clipboard_text,
                    label: 'Paste Text',
                    color: Colors.orange,
                    onTap: _pasteFromClipboard,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Document Title
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Document Title',
                hintText: 'e.g. Operating Systems Chapter 4, Annual Report...',
                prefixIcon: const Icon(Iconsax.document_text),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Category Chips
            const Text(
              'Category',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((category) {
                return ChoiceChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (_) =>
                      setState(() => selectedCategory = category),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Extracted Content Editor
            TextField(
              controller: contentController,
              minLines: 8,
              maxLines: 16,
              decoration: InputDecoration(
                labelText: 'Document Content (Extracted Text)',
                hintText:
                    'Upload a PDF/image or dictate to extract text automatically, or type/paste your content here.',
                alignLabelWithHint: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isListening ? Iconsax.stop : Iconsax.microphone_2,
                    color: _isListening ? Colors.red : AppColors.primary,
                  ),
                  tooltip: _isListening ? 'Stop' : 'Voice Dictation',
                  onPressed: _listen,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            if (_isLoading) ...[
              const SizedBox(height: 14),
              LinearProgressIndicator(
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              ),
              const SizedBox(height: 6),
              Text(
                _loadingMessage.isNotEmpty
                    ? _loadingMessage
                    : 'AI is processing...',
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Attachment badges
            if (_attachments.isNotEmpty) ...[
              const Text(
                'Attached Files',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ..._attachments.map((file) {
                final fname = file.path.split(Platform.pathSeparator).last;
                final ext = fname.split('.').last.toLowerCase();
                IconData fileIcon = Iconsax.document;
                if (ext == 'pdf') {
                  fileIcon = Iconsax.document_favorite;
                }
                if (['jpg', 'png', 'jpeg'].contains(ext)) {
                  fileIcon = Iconsax.gallery;
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(fileIcon, color: AppColors.primary),
                    title: Text(
                      fname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text('${ext.toUpperCase()} file'),
                    trailing: IconButton(
                      icon: const Icon(
                        Iconsax.close_circle,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        setState(() => _attachments.remove(file));
                      },
                    ),
                  ),
                );
              }),
              const SizedBox(height: 10),
            ],

            const SizedBox(height: 20),

            // Save Document Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _saveDocument,
                icon: const Icon(Iconsax.tick_circle),
                label: const Text(
                  'Save & Prepare Document for Q&A',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputOptionChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: _isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
