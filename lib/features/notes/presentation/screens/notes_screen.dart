import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import 'note_detail_screen.dart';

enum DocumentSortOption { newest, oldest, titleAsc, category }

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  DocumentSortOption _sortOption = DocumentSortOption.newest;
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCreateNote(BuildContext context) {
    context.push('/notes/create');
  }

  Future<void> _renameDocument(Note note) async {
    final titleController = TextEditingController(text: note.title);
    final formKey = GlobalKey<FormState>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Document'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: titleController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Document Title',
              border: OutlineInputBorder(),
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Title cannot be empty';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(ctx, true);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (confirmed == true && titleController.text.trim().isNotEmpty) {
      final db = ref.read(databaseProvider);
      final newTitle = titleController.text.trim();
      await (db.update(db.notes)..where((tbl) => tbl.id.equals(note.id))).write(
        NotesCompanion(
          title: drift.Value(newTitle),
          updatedAt: drift.Value(DateTime.now()),
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Renamed to "$newTitle"')));
    }
  }

  Future<void> _confirmDeleteDocument(Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Document?'),
        content: Text(
          'Are you sure you want to delete "${note.title}"? Associated flashcards and study notes will also be removed.',
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
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final db = ref.read(databaseProvider);
      await (db.delete(db.notes)..where((tbl) => tbl.id.equals(note.id))).go();
      // Also clean up flashcards for this document
      await (db.delete(
        db.flashcards,
      )..where((tbl) => tbl.documentId.equals(note.id))).go();
      // Also clean up study notes for this document
      await (db.delete(
        db.studyNotes,
      )..where((tbl) => tbl.documentId.equals(note.id))).go();

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Deleted "${note.title}"')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = ref.watch(databaseProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Document Library',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          PopupMenuButton<DocumentSortOption>(
            icon: const Icon(Iconsax.sort),
            tooltip: 'Sort Documents',
            initialValue: _sortOption,
            onSelected: (opt) {
              setState(() {
                _sortOption = opt;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: DocumentSortOption.newest,
                child: Text('Newest First'),
              ),
              const PopupMenuItem(
                value: DocumentSortOption.oldest,
                child: Text('Oldest First'),
              ),
              const PopupMenuItem(
                value: DocumentSortOption.titleAsc,
                child: Text('Title (A-Z)'),
              ),
              const PopupMenuItem(
                value: DocumentSortOption.category,
                child: Text('Category'),
              ),
            ],
          ),
          IconButton(
            tooltip: 'Import Document',
            onPressed: () => _openCreateNote(context),
            icon: const Icon(Iconsax.document_upload),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateNote(context),
        icon: const Icon(Iconsax.document_upload),
        label: const Text('Import'),
      ),
      body: StreamBuilder<List<Note>>(
        stream: database.select(database.notes).watch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Unable to load documents.\n\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allNotes = snapshot.data ?? [];

          if (allNotes.isEmpty) {
            return _EmptyNotes(onCreate: () => _openCreateNote(context));
          }

          // Extract unique categories
          final categories = {
            'All',
            ...allNotes
                .map((n) => n.category.trim())
                .where((c) => c.isNotEmpty),
          };

          // Filter by search query and category
          var filteredNotes = allNotes.where((note) {
            final matchesQuery =
                _searchQuery.isEmpty ||
                note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                note.content.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                note.category.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                );
            final matchesCategory =
                _selectedCategory == 'All' ||
                note.category.trim().toLowerCase() ==
                    _selectedCategory.toLowerCase();
            return matchesQuery && matchesCategory;
          }).toList();

          // Sort documents
          switch (_sortOption) {
            case DocumentSortOption.newest:
              filteredNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
              break;
            case DocumentSortOption.oldest:
              filteredNotes.sort((a, b) => a.createdAt.compareTo(b.createdAt));
              break;
            case DocumentSortOption.titleAsc:
              filteredNotes.sort(
                (a, b) =>
                    a.title.toLowerCase().compareTo(b.title.toLowerCase()),
              );
              break;
            case DocumentSortOption.category:
              filteredNotes.sort(
                (a, b) => a.category.toLowerCase().compareTo(
                  b.category.toLowerCase(),
                ),
              );
              break;
          }

          return Column(
            children: [
              // Search & Filter Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search documents by title or text...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.4),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Category filter chips
              if (categories.length > 2)
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, idx) {
                      final cat = categories.elementAt(idx);
                      final isSelected = cat == _selectedCategory;
                      return ChoiceChip(
                        label: Text(cat, style: const TextStyle(fontSize: 12)),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          }
                        },
                      );
                    },
                  ),
                ),

              const SizedBox(height: 6),

              // Document list
              Expanded(
                child: filteredNotes.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Iconsax.search_status,
                                size: 48,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No documents match "$_searchQuery"',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                    _selectedCategory = 'All';
                                  });
                                },
                                child: const Text('Reset filters'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                        itemCount: filteredNotes.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final note = filteredNotes[index];
                          final wordCount = note.content.trim().isEmpty
                              ? 0
                              : note.content
                                    .trim()
                                    .split(RegExp(r'\s+'))
                                    .length;
                          final dateStr = DateFormat(
                            'MMM d, yyyy',
                          ).format(note.createdAt);

                          return InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NoteDetailScreen(note: note),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: theme.colorScheme.outline.withValues(
                                    alpha: 0.18,
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.10,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Iconsax.document_text,
                                      color: AppColors.primary,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          note.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Wrap(
                                          spacing: 6,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: theme
                                                    .colorScheme
                                                    .surfaceContainerHighest
                                                    .withValues(alpha: 0.5),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                note.category.isEmpty
                                                    ? 'General'
                                                    : note.category,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: theme
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '•  $wordCount words',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                            Text(
                                              '•  $dateStr',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (note.content.trim().isNotEmpty) ...[
                                          const SizedBox(height: 6),
                                          Text(
                                            note.content,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: theme
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert, size: 20),
                                    tooltip: 'Document options',
                                    onSelected: (action) {
                                      switch (action) {
                                        case 'open':
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  NoteDetailScreen(note: note),
                                            ),
                                          );
                                          break;
                                        case 'study':
                                          context.push(
                                            '/study/flashcards?docId=${note.id}&docTitle=${Uri.encodeComponent(note.title)}',
                                          );
                                          break;
                                        case 'ask':
                                          context.push('/qa?docId=${note.id}');
                                          break;
                                        case 'rename':
                                          _renameDocument(note);
                                          break;
                                        case 'delete':
                                          _confirmDeleteDocument(note);
                                          break;
                                      }
                                    },
                                    itemBuilder: (ctx) => [
                                      const PopupMenuItem(
                                        value: 'open',
                                        child: Row(
                                          children: [
                                            Icon(Iconsax.book_1, size: 18),
                                            SizedBox(width: 10),
                                            Text('Open Document'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'study',
                                        child: Row(
                                          children: [
                                            Icon(Iconsax.card, size: 18),
                                            SizedBox(width: 10),
                                            Text('Study Flashcards'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'ask',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Iconsax.message_question,
                                              size: 18,
                                            ),
                                            SizedBox(width: 10),
                                            Text('Ask AI'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'rename',
                                        child: Row(
                                          children: [
                                            Icon(Iconsax.edit, size: 18),
                                            SizedBox(width: 10),
                                            Text('Rename'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuDivider(),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Iconsax.trash,
                                              size: 18,
                                              color: theme.colorScheme.error,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: theme.colorScheme.error,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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

class _EmptyNotes extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyNotes({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Iconsax.document_upload,
              size: 58,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            const Text(
              'No documents yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Upload your first PDF or document to generate flashcards, quizzes, and ask grounded questions.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Iconsax.add),
              label: const Text('Import Document'),
            ),
          ],
        ),
      ),
    );
  }
}
