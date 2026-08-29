import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
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

  bool _isOnline() {
    return ref.read(connectivityProvider).value ?? true;
  }

  void _showOfflineMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('AI features require an internet connection.')),
    );
  }

  final categories = const [
    'General',
    'Programming',
    'DSA',
    'Flutter',
    'Web Development',
    'Database',
    'Ideas',
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
      Permission.photos,
    ].request();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> _performOcr(File file) async {
    if (!_isOnline()) {
      _showOfflineMessage();
      return;
    }
    setState(() => _isLoading = true);
    try {
      final bytes = await file.readAsBytes();
      final extension = file.path.split('.').last.toLowerCase();
      final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';
      final extractedText = await ref.read(geminiServiceProvider).performOcr(bytes, mimeType);
      
      if (extractedText.isNotEmpty) {
        contentController.text = '${contentController.text}\n$extractedText'.trim();
        _showMetadataSuggestion(contentController.text);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OCR Failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showMetadataSuggestion(String content) async {
    if (!_isOnline()) {
      _showOfflineMessage();
      return;
    }
    if (content.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final result = await ref.read(geminiServiceProvider).suggestMetadata(content);
      final data = jsonDecode(result) as Map<String, dynamic>;
      
      if (titleController.text.isEmpty && data['title'] != null) {
        titleController.text = data['title'];
      }
      if (data['category'] != null && categories.contains(data['category'])) {
        setState(() => selectedCategory = data['category']);
      }
    } catch (_) {} 
    finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addFromGallery() async {
    final path = await MediaPickerHelper.gallery();
    if (path == null) return;
    setState(() {
      _attachments.add(path);
      _sourceType = 'image';
    });
    await _performOcr(path);
  }

  Future<void> _addFromCamera() async {
    final path = await MediaPickerHelper.camera();
    if (path == null) return;
    setState(() {
      _attachments.add(path);
      _sourceType = 'camera';
    });
    await _performOcr(path);
  }

  Future<void> _addFile() async {
    final path = await MediaPickerHelper.file();
    if (path == null) return;
    setState(() {
      _attachments.add(path);
      _sourceType = 'file';
    });
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            if (val.recognizedWords.isNotEmpty) {
              contentController.text = '${contentController.text} ${val.recognizedWords}'.trim();
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

  Future<void> _saveNote() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }

    try {
      final database = ref.read(databaseProvider);
      final now = DateTime.now();
      final noteId = DateTime.now().microsecondsSinceEpoch.toString();

      await database.into(database.notes).insert(
        NotesCompanion(
          id: drift.Value(noteId),
          title: drift.Value(title),
          content: drift.Value(content),
          category: drift.Value(selectedCategory),
          createdAt: drift.Value(now),
          updatedAt: drift.Value(now),
          sourceType: drift.Value(_sourceType),
          attachmentPaths: drift.Value(AttachmentHelper.encode(_attachments)),
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note created successfully')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Note', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(onPressed: _saveNote, icon: const Icon(Iconsax.tick_circle)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                prefixIcon: const Icon(Iconsax.note),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Category', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((category) {
                return ChoiceChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (_) => setState(() => selectedCategory = category),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: contentController,
              minLines: 8,
              maxLines: 15,
              decoration: InputDecoration(
                labelText: 'Content',
                alignLabelWithHint: true,
                suffixIcon: IconButton(
                  icon: Icon(_isListening ? Iconsax.stop : Iconsax.microphone_2, color: _isListening ? Colors.red : AppColors.primary),
                  onPressed: _listen,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            if (_isLoading) ...[
              const SizedBox(height: 10),
              const LinearProgressIndicator(),
            ],
            const SizedBox(height: 24),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                OutlinedButton.icon(onPressed: _addFromGallery, icon: const Icon(Iconsax.gallery), label: const Text('Gallery')),
                OutlinedButton.icon(onPressed: _addFromCamera, icon: const Icon(Iconsax.camera), label: const Text('Camera')),
                OutlinedButton.icon(onPressed: _addFile, icon: const Icon(Iconsax.document), label: const Text('File')),
                OutlinedButton.icon(onPressed: () => _showMetadataSuggestion(contentController.text), icon: const Icon(Iconsax.magic_star), label: const Text('Suggest Info')),
              ],
            ),
            if (_attachments.isNotEmpty) ...[
              const SizedBox(height: 14),
              ..._attachments.map((file) => ListTile(
                leading: const Icon(Iconsax.document, color: AppColors.primary),
                title: Text(file.path.split(Platform.pathSeparator).last),
                trailing: IconButton(icon: const Icon(Iconsax.close_circle), onPressed: () => setState(() => _attachments.remove(file))),
              )),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(onPressed: _saveNote, icon: const Icon(Iconsax.tick_circle), label: const Text('Save Note', style: TextStyle(fontWeight: FontWeight.w700))),
            ),
          ],
        ),
      ),
    );
  }
}
