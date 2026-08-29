import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import '../../../notes/presentation/screens/note_detail_screen.dart';
import '../../../../core/ai/ai_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedCategory = 'All';
  bool _isSemanticSearch = false;
  bool _isLoading = false;
  List<Note> _semanticResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSemanticSearch(List<Note> allNotes) async {
    if (_query.isEmpty) return;
    setState(() {
      _isLoading = true;
      _isSemanticSearch = true;
    });

    try {
      final notesData = allNotes.map((n) => {
        'id': n.id,
        'title': n.title,
        'category': n.category,
        'content': n.content,
      }).toList();

      final relevantIds = await ref.read(geminiServiceProvider).semanticSearch(
        query: _query,
        notes: notesData,
      );

      final results = relevantIds
          .map((id) => allNotes.firstWhere((n) => n.id == id))
          .toList();

      setState(() {
        _semanticResults = results;
        _isLoading = false;
      });

      // Save to history
      final db = ref.read(databaseProvider);
      await db.into(db.searchHistory).insert(SearchHistoryCompanion.insert(
        query: _query,
        createdAt: DateTime.now(),
      ));
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),

      body: StreamBuilder<List<Note>>(
        stream: database.select(database.notes).watch(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final notes = snapshot.data!;

          final categories = [
            'All',
            ...notes.map((n) => n.category).toSet(),
          ];

          List<Note> displayedNotes;
          if (_isSemanticSearch) {
            displayedNotes = _semanticResults;
          } else {
            displayedNotes = notes.where((note) {
              final q = _query.toLowerCase();
              final matchesSearch = q.isEmpty ||
                  note.title.toLowerCase().contains(q) ||
                  note.content.toLowerCase().contains(q) ||
                  note.category.toLowerCase().contains(q);
              final matchesCategory = _selectedCategory == 'All' || note.category == _selectedCategory;
              return matchesSearch && matchesCategory;
            }).toList();
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() {
                        _query = value.trim();
                        _isSemanticSearch = false;
                      }),
                      onSubmitted: (value) => _performSemanticSearch(notes),
                      decoration: InputDecoration(
                        hintText: 'Search notes...',
                        prefixIcon: const Icon(Iconsax.search_normal),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _query = '';
                                    _isSemanticSearch = false;
                                  });
                                },
                                icon: const Icon(Iconsax.close_circle),
                              )
                            : null,
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ActionChip(
                            avatar: Icon(_isSemanticSearch ? Iconsax.magic_star : Iconsax.search_normal_1, size: 16),
                            label: Text(_isSemanticSearch ? 'Semantic Active' : 'Semantic Search'),
                            onPressed: () => _performSemanticSearch(notes),
                            backgroundColor: _isSemanticSearch ? AppColors.primary.withValues(alpha: 0.1) : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        FutureBuilder<List<SearchHistoryData>>(
                          future: (database.select(database.searchHistory)
                                ..orderBy([(t) => drift.OrderingTerm(expression: t.createdAt, mode: drift.OrderingMode.desc)])
                                ..limit(1))
                              .get(),
                          builder: (context, hist) {
                            if (!hist.hasData || hist.data!.isEmpty) return const SizedBox.shrink();
                            return ActionChip(
                              label: const Text('Recent'),
                              onPressed: () {
                                _searchController.text = hist.data!.first.query;
                                setState(() => _query = hist.data!.first.query);
                                _performSemanticSearch(notes);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (!_isSemanticSearch)
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final sel = cat == _selectedCategory;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: sel,
                        onSelected: (selected) => setState(() => _selectedCategory = cat),
                      );
                    },
                  ),
                ),

              if (_isLoading) const Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()),

              Expanded(
                child: displayedNotes.isEmpty
                    ? _EmptySearch(hasSearch: _query.isNotEmpty)
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: displayedNotes.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) => _NoteSearchCard(note: displayedNotes[index]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NoteSearchCard extends StatelessWidget {
  final Note note;

  const _NoteSearchCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NoteDetailScreen(note: note)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.outline.withValues(alpha: 0.18),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(Iconsax.note, color: AppColors.primary),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    note.category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    note.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Iconsax.arrow_right_3,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  final bool hasSearch;

  const _EmptySearch({required this.hasSearch});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasSearch ? Iconsax.search_status : Iconsax.note,
              size: 52,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 14),
            Text(
              hasSearch ? 'No matching notes' : 'No notes yet',
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 7),
            Text(
              hasSearch
                  ? 'Try another search or category.'
                  : 'Create a note to start searching.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
