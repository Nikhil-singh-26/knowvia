import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/ai/ai_config.dart';
import '../../../../core/database/database.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../main.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final ThemeController themeController;

  const SettingsScreen({super.key, required this.themeController});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _obscureApiKey = true;
  String _selectedModel = AiConfig.modelId;

  @override
  void initState() {
    super.initState();
    _apiKeyController.text = AiConfig.customApiKey ?? '';
    _selectedModel = AiConfig.modelId;
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _saveAiSettings() async {
    final key = _apiKeyController.text.trim();
    await AiConfig.setCustomApiKey(key.isEmpty ? null : key);
    await AiConfig.setCustomModel(_selectedModel);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('AI settings updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _confirmClearStudyData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Study Data?'),
        content: const Text(
          'This will permanently delete all flashcards, review schedules, study notes, and quiz history. Your imported documents will remain intact.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset Study Data'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final db = ref.read(databaseProvider);
      await db.delete(db.flashcards).go();
      await db.delete(db.studyNotes).go();
      await db.delete(db.quizSessions).go();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Study data has been reset')),
        );
      }
    }
  }

  Future<void> _confirmEraseAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Erase All Data?'),
        content: const Text(
          'This will delete EVERYTHING: all imported documents, extracted content, study notes, flashcards, and quiz attempts.\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Erase Everything'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final db = ref.read(databaseProvider);
      await db.resetAllData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All data erased successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.themeController;
    final database = ref.watch(databaseProvider);
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Appearance Section
              const Text(
                'Appearance',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.18),
                  ),
                ),
                child: RadioGroup<ThemeMode>(
                  groupValue: controller.themeMode,
                  onChanged: (val) {
                    if (val != null) controller.setThemeMode(val);
                  },
                  child: Column(
                    children: const [
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.light,
                        title: Text('Light'),
                        subtitle: Text('Use clean light appearance'),
                      ),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.dark,
                        title: Text('Dark'),
                        subtitle: Text('Use eye-friendly dark appearance'),
                      ),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.system,
                        title: Text('System'),
                        subtitle: Text('Follow system device theme'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Gemini AI Configuration
              const Text(
                'Gemini AI Configuration',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Iconsax.magic_star,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Google Gemini API',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Optionally provide your personal Google AI Studio API key. If not set, the built-in application key will be used for learning assistance.',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _apiKeyController,
                      obscureText: _obscureApiKey,
                      decoration: InputDecoration(
                        labelText: 'Custom Gemini API Key',
                        hintText: 'AIzaSy...',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureApiKey
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureApiKey = !_obscureApiKey;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedModel,
                      decoration: const InputDecoration(
                        labelText: 'Gemini Model',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'gemini-2.5-flash',
                          child: Text('Gemini 2.5 Flash (Recommended)'),
                        ),
                        DropdownMenuItem(
                          value: 'gemini-1.5-flash',
                          child: Text('Gemini 1.5 Flash (Legacy)'),
                        ),
                        DropdownMenuItem(
                          value: 'gemini-1.5-pro',
                          child: Text('Gemini 1.5 Pro (In-depth analysis)'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedModel = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _saveAiSettings,
                        icon: const Icon(Iconsax.tick_circle, size: 18),
                        label: const Text('Save AI Settings'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Data & Storage Management
              const Text(
                'Data & Storage Management',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<List<Note>>(
                      stream: database.select(database.notes).watch(),
                      builder: (context, noteSnap) {
                        final noteCount = noteSnap.data?.length ?? 0;
                        return StreamBuilder<List<Flashcard>>(
                          stream: database.watchAllFlashcards(),
                          builder: (context, cardSnap) {
                            final cardCount = cardSnap.data?.length ?? 0;
                            return StreamBuilder<List<StudyNote>>(
                              stream: database.watchAllStudyNotes(),
                              builder: (context, studyNoteSnap) {
                                final studyNoteCount =
                                    studyNoteSnap.data?.length ?? 0;
                                return Column(
                                  children: [
                                    _StorageRow(
                                      label: 'Imported Documents',
                                      count: '$noteCount',
                                    ),
                                    const Divider(),
                                    _StorageRow(
                                      label: 'Flashcards',
                                      count: '$cardCount',
                                    ),
                                    const Divider(),
                                    _StorageRow(
                                      label: 'Study Notes & Bookmarks',
                                      count: '$studyNoteCount',
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                        side: BorderSide(
                          color: theme.colorScheme.error.withValues(alpha: 0.5),
                        ),
                      ),
                      onPressed: _confirmClearStudyData,
                      icon: const Icon(Iconsax.refresh, size: 18),
                      label: const Text('Reset Flashcards & Quizzes'),
                    ),
                    const SizedBox(height: 8),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                      ),
                      onPressed: _confirmEraseAllData,
                      icon: const Icon(Iconsax.trash, size: 18),
                      label: const Text('Erase All Data'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Privacy & Data Handling
              const Text(
                'Privacy & Data Handling',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Iconsax.shield_tick,
                          color: Color(0xFF10B981),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Local-First Privacy Architecture',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '• All documents, extracted text, flashcards, study notes, and quiz histories are stored exclusively on your device in local SQLite.\n\n'
                      '• Content is only transmitted over HTTPS to Google Gemini when you explicitly ask an AI question, generate flashcards, or create a quiz.\n\n'
                      '• No analytics, telemetry, or user behavior tracking is collected.',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // About Section
              const Text(
                'About',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.18),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Know Via',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Local-first document learning & revision platform',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Version 2.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Developed By: Nikhil Singh',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}

class _StorageRow extends StatelessWidget {
  final String label;
  final String count;

  const _StorageRow({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(
            count,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
