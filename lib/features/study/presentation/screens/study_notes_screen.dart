import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import '../../../notes/presentation/screens/note_detail_screen.dart';

class StudyNotesScreen extends ConsumerStatefulWidget {
  final String? filterDocumentId;

  const StudyNotesScreen({super.key, this.filterDocumentId});

  @override
  ConsumerState<StudyNotesScreen> createState() => _StudyNotesScreenState();
}

class _StudyNotesScreenState extends ConsumerState<StudyNotesScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  String? _selectedTag;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showAddEditNoteDialog({StudyNote? existing}) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final contentCtrl = TextEditingController(text: existing?.content ?? '');
    final tagsCtrl = TextEditingController(text: existing?.tags ?? '');
    final isEditing = existing != null;

    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(isEditing ? 'Edit Study Note' : 'Create Study Note'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Note Title',
                  hintText: 'e.g. Key formula or summary concept',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: contentCtrl,
                decoration: const InputDecoration(
                  labelText: 'Note Content',
                  hintText: 'Enter explanations, definitions, or insights...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 14),
              TextField(
                controller: tagsCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tags (comma-separated)',
                  hintText: 'e.g. Exam, Physics, Formula',
                  border: OutlineInputBorder(),
                ),
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
              final title = titleCtrl.text.trim();
              final content = contentCtrl.text.trim();
              final tags = tagsCtrl.text.trim();
              if (title.isEmpty || content.isEmpty) return;

              final db = ref.read(databaseProvider);
              final now = DateTime.now();

              if (isEditing) {
                final updated = existing.copyWith(
                  title: title,
                  content: content,
                  tags: drift.Value(tags.isEmpty ? null : tags),
                  updatedAt: now,
                );
                await db.updateStudyNote(updated.toCompanion(false));
              } else {
                final newId = const Uuid().v4();
                await db.insertStudyNote(
                  StudyNotesCompanion(
                    id: drift.Value(newId),
                    documentId: drift.Value(widget.filterDocumentId),
                    title: drift.Value(title),
                    content: drift.Value(content),
                    tags: drift.Value(tags.isEmpty ? null : tags),
                    isPinned: const drift.Value(false),
                    createdAt: drift.Value(now),
                    updatedAt: drift.Value(now),
                  ),
                );
              }

              if (mounted && dialogCtx.mounted) {
                Navigator.pop(dialogCtx);
              }
            },
            child: Text(isEditing ? 'Update' : 'Save Note'),
          ),
        ],
      ),
    );
  }

  void _shareNote(StudyNote note) {
    final text =
        '''
# ${note.title}
${note.content}

${note.tags != null ? 'Tags: ${note.tags}' : ''}
Saved with Know Via
''';
    SharePlus.instance.share(ShareParams(text: text, subject: note.title));
  }

  void _confirmDeleteNote(StudyNote note) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Delete Note?'),
        content: const Text('Are you sure you want to delete this study note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final db = ref.read(databaseProvider);
              await db.deleteStudyNote(note.id);
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

    final stream = widget.filterDocumentId != null
        ? db.watchStudyNotesForDocument(widget.filterDocumentId!)
        : db.watchAllStudyNotes();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Notes & Bookmarks'),
        actions: [
          IconButton(
            tooltip: 'Add Note',
            onPressed: () => _showAddEditNoteDialog(),
            icon: const Icon(Iconsax.add_circle),
          ),
        ],
      ),
      body: StreamBuilder<List<StudyNote>>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allNotes = snapshot.data!;

          // Collect all tags
          final Set<String> allTags = {};
          for (final n in allNotes) {
            if (n.tags != null && n.tags!.isNotEmpty) {
              for (final t in n.tags!.split(',')) {
                if (t.trim().isNotEmpty) allTags.add(t.trim());
              }
            }
          }

          final filteredNotes = allNotes.where((note) {
            final matchesQuery =
                _query.isEmpty ||
                note.title.toLowerCase().contains(_query.toLowerCase()) ||
                note.content.toLowerCase().contains(_query.toLowerCase()) ||
                (note.tags != null &&
                    note.tags!.toLowerCase().contains(_query.toLowerCase()));

            final matchesTag =
                _selectedTag == null ||
                (note.tags != null &&
                    note.tags!
                        .split(',')
                        .map((s) => s.trim().toLowerCase())
                        .contains(_selectedTag!.toLowerCase()));

            return matchesQuery && matchesTag;
          }).toList();

          return Column(
            children: [
              // Search Input
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (val) => setState(() => _query = val.trim()),
                  decoration: InputDecoration(
                    hintText: 'Search notes, tags, or content...',
                    prefixIcon: const Icon(Iconsax.search_normal_1, size: 20),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Tags Filter Chips
              if (allTags.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      FilterChip(
                        selected: _selectedTag == null,
                        label: const Text('All Tags'),
                        onSelected: (_) => setState(() => _selectedTag = null),
                      ),
                      const SizedBox(width: 8),
                      ...allTags.map((tag) {
                        final isSel =
                            _selectedTag?.toLowerCase() == tag.toLowerCase();
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: isSel,
                            label: Text(tag),
                            onSelected: (_) => setState(() {
                              _selectedTag = isSel ? null : tag;
                            }),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

              const SizedBox(height: 8),

              // Notes List
              Expanded(
                child: filteredNotes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Iconsax.note_2,
                              size: 48,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              allNotes.isEmpty
                                  ? 'No study notes saved yet.'
                                  : 'No notes match your search.',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              onPressed: () => _showAddEditNoteDialog(),
                              icon: const Icon(Iconsax.add),
                              label: const Text('Create Study Note'),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredNotes.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final note = filteredNotes[index];
                          final tagsList =
                              note.tags
                                  ?.split(',')
                                  .map((t) => t.trim())
                                  .where((t) => t.isNotEmpty)
                                  .toList() ??
                              [];

                          return Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: note.isPinned
                                    ? AppColors.primary
                                    : theme.colorScheme.outline.withValues(
                                        alpha: 0.15,
                                      ),
                                width: note.isPinned ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (note.isPinned) ...[
                                      const Icon(
                                        Iconsax.attach_circle,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 6),
                                    ],
                                    Expanded(
                                      child: Text(
                                        note.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        note.isPinned
                                            ? Iconsax.star1
                                            : Iconsax.star,
                                        color: note.isPinned
                                            ? Colors.amber
                                            : AppColors.textSecondary,
                                        size: 18,
                                      ),
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        final updated = note.copyWith(
                                          isPinned: !note.isPinned,
                                          updatedAt: DateTime.now(),
                                        );
                                        await db.updateStudyNote(
                                          updated.toCompanion(false),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Iconsax.share, size: 18),
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      onPressed: () => _shareNote(note),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(
                                        Iconsax.edit_2,
                                        size: 18,
                                      ),
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      onPressed: () => _showAddEditNoteDialog(
                                        existing: note,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(
                                        Iconsax.trash,
                                        size: 18,
                                        color: Colors.redAccent,
                                      ),
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      onPressed: () => _confirmDeleteNote(note),
                                    ),
                                  ],
                                ),
                                if (note.sourceExcerpt != null &&
                                    note.sourceExcerpt!.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: theme
                                          .colorScheme
                                          .surfaceContainerHighest
                                          .withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Excerpt: "${note.sourceExcerpt}"',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 12,
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.75),
                                      ),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 10),
                                Text(
                                  note.content,
                                  style: TextStyle(
                                    height: 1.45,
                                    fontSize: 14,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                if (tagsList.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: tagsList.map((tag) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.08,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          '#$tag',
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat(
                                        'MMM d, yyyy',
                                      ).format(note.updatedAt),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    if (note.documentId != null)
                                      InkWell(
                                        onTap: () async {
                                          final doc = await db.getNoteById(
                                            note.documentId!,
                                          );
                                          if (doc != null && context.mounted) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    NoteDetailScreen(note: doc),
                                              ),
                                            );
                                          }
                                        },
                                        child: const Row(
                                          children: [
                                            Text(
                                              'Go to Document',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(
                                              Iconsax.arrow_right_3,
                                              size: 13,
                                              color: AppColors.primary,
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
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
}
