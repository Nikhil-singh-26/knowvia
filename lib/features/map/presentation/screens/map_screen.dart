import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/ai/concept_service.dart';
import '../../../../core/utils/connectivity_service.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import '../../../notes/presentation/screens/note_detail_screen.dart';
import 'concept_detail_screen.dart';

enum MapFilter { all, notes, concepts }

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  MapFilter _filter = MapFilter.all;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final database = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Knowledge Map',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          PopupMenuButton<MapFilter>(
            icon: const Icon(Iconsax.filter),
            onSelected: (value) => setState(() => _filter = value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: MapFilter.all,
                child: Text('All Nodes'),
              ),
              const PopupMenuItem(
                value: MapFilter.notes,
                child: Text('Notes Only'),
              ),
              const PopupMenuItem(
                value: MapFilter.concepts,
                child: Text('Concepts Only'),
              ),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController,
              onChanged: (value) =>
                  setState(() => _searchQuery = value.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search map...',
                prefixIcon: const Icon(Iconsax.search_normal),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Note>>(
              stream: database.select(database.notes).watch(),
              builder: (context, noteSnapshot) {
                return StreamBuilder<List<Concept>>(
                  stream: database.watchAllConcepts(),
                  builder: (context, conceptSnapshot) {
                    if (noteSnapshot.hasError || conceptSnapshot.hasError) {
                      return const Center(child: Text('Error loading map'));
                    }
                    if (!noteSnapshot.hasData || !conceptSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final notes = noteSnapshot.data!;
                    final concepts = conceptSnapshot.data!;

                    if (notes.isEmpty) {
                      return const _EmptyMap(isEmptyBecauseNoNotes: true);
                    }

                    if (concepts.isEmpty) {
                      return const _EmptyMap(isEmptyBecauseNoNotes: false);
                    }

                    return _MapView(
                      notes: notes,
                      concepts: concepts,
                      filter: _filter,
                      searchQuery: _searchQuery,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MapView extends ConsumerWidget {
  final List<Note> notes;
  final List<Concept> concepts;
  final MapFilter filter;
  final String searchQuery;

  const _MapView({
    required this.notes,
    required this.concepts,
    required this.filter,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredNotes = notes.where((n) {
      if (filter == MapFilter.concepts) return false;
      if (searchQuery.isEmpty) return true;
      return n.title.toLowerCase().contains(searchQuery) ||
          n.category.toLowerCase().contains(searchQuery);
    }).toList();

    final filteredConcepts = concepts.where((c) {
      if (filter == MapFilter.notes) return false;
      if (searchQuery.isEmpty) return true;
      return c.name.toLowerCase().contains(searchQuery) ||
          c.category.toLowerCase().contains(searchQuery);
    }).toList();

    return FutureBuilder<Map<String, List<String>>>(
      future: _loadRelationships(ref),
      builder: (context, relSnapshot) {
        if (!relSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final relations = relSnapshot.data!;

        return _InteractiveMap(
          notes: filteredNotes,
          concepts: filteredConcepts,
          relations: relations,
        );
      },
    );
  }

  Future<Map<String, List<String>>> _loadRelationships(WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final map = <String, List<String>>{};

    // Note to Concept relations
    final noteConceptLinks = await db.select(db.noteConcepts).get();
    for (final link in noteConceptLinks) {
      map.putIfAbsent(link.noteId, () => []).add(link.conceptId);
    }

    // Concept to Concept relations
    final conceptLinks = await db.select(db.conceptRelations).get();
    for (final link in conceptLinks) {
      map.putIfAbsent(link.fromConceptId, () => []).add(link.toConceptId);
    }

    return map;
  }
}

class MapNodeLabel extends StatelessWidget {
  final String label;
  final bool isConcept;

  const MapNodeLabel({super.key, required this.label, required this.isConcept});

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      textAlign: TextAlign.center,
      maxLines: isConcept ? 3 : 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: isConcept ? 10 : 11,
        fontWeight: FontWeight.bold,
        color: isConcept
            ? Colors.white
            : Theme.of(context).colorScheme.onSurface,
      ),
    );

    if (isConcept) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 72),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: text,
          ),
        ),
      );
    }

    return text;
  }
}

class _InteractiveMap extends StatefulWidget {
  final List<Note> notes;
  final List<Concept> concepts;
  final Map<String, List<String>> relations;

  const _InteractiveMap({
    required this.notes,
    required this.concepts,
    required this.relations,
  });

  @override
  State<_InteractiveMap> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<_InteractiveMap> {
  final Map<String, Offset> _positions = {};
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _generatePositions();
  }

  void _generatePositions() {
    final allNodes = [
      ...widget.notes.map((n) => n.id),
      ...widget.concepts.map((c) => c.id),
    ];
    const areaSize = 1500.0;
    for (final id in allNodes) {
      _positions[id] = Offset(
        _random.nextDouble() * areaSize,
        _random.nextDouble() * areaSize,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.notes.isEmpty && widget.concepts.isEmpty) {
      return const Center(child: Text('No results match your search.'));
    }

    return InteractiveViewer(
      minScale: 0.1,
      maxScale: 2.0,
      boundaryMargin: const EdgeInsets.all(1000),
      constrained: false,
      child: SizedBox(
        width: 3000,
        height: 3000,
        child: Stack(
          children: [
            CustomPaint(
              size: const Size(3000, 3000),
              painter: _LinkPainter(
                positions: _positions,
                relations: widget.relations,
              ),
            ),
            ...widget.notes.map(
              (note) => _buildNode(note.id, note.title, 'note', note),
            ),
            ...widget.concepts.map(
              (concept) =>
                  _buildNode(concept.id, concept.name, 'concept', concept),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNode(String id, String label, String type, dynamic data) {
    final pos = _positions[id] ?? Offset.zero;
    final isNote = type == 'note';

    return Positioned(
      left: pos.dx,
      top: pos.dy,
      child: GestureDetector(
        onTap: () {
          if (isNote) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NoteDetailScreen(note: data)),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ConceptDetailScreen(concept: data),
              ),
            );
          }
        },
        child: Container(
          width: isNote ? 120.0 : 86.0,
          height: isNote ? null : 86.0,
          padding: EdgeInsets.all(isNote ? 10 : 8),
          decoration: BoxDecoration(
            color: isNote
                ? Theme.of(context).colorScheme.surface
                : AppColors.primary,
            shape: isNote ? BoxShape.rectangle : BoxShape.circle,
            borderRadius: isNote ? BorderRadius.circular(15) : null,
            border: Border.all(color: AppColors.primary, width: 2),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
          ),
          child: Center(
            child: MapNodeLabel(label: label, isConcept: !isNote),
          ),
        ),
      ),
    );
  }
}

class _LinkPainter extends CustomPainter {
  final Map<String, Offset> positions;
  final Map<String, List<String>> relations;

  _LinkPainter({required this.positions, required this.relations});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    relations.forEach((sourceId, targets) {
      final sourcePos = positions[sourceId];
      if (sourcePos == null) return;

      for (final targetId in targets) {
        final targetPos = positions[targetId];
        if (targetPos == null) continue;

        canvas.drawLine(
          sourcePos + const Offset(60, 25),
          targetPos + const Offset(60, 25),
          paint,
        );
      }
    });
  }

  @override
  bool shouldRepaint(covariant _LinkPainter oldDelegate) => true;
}

class _EmptyMap extends ConsumerStatefulWidget {
  final bool isEmptyBecauseNoNotes;
  const _EmptyMap({required this.isEmptyBecauseNoNotes});

  @override
  ConsumerState<_EmptyMap> createState() => _EmptyMapState();
}

class _EmptyMapState extends ConsumerState<_EmptyMap> {
  bool _isAnalyzing = false;
  String _progressMessage = '';

  bool _isOnline() {
    return ref.read(connectivityProvider).value ?? true;
  }

  Future<void> _analyzeNotes() async {
    if (!_isOnline()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('AI features require an internet connection.'),
        ),
      );
      return;
    }
    setState(() {
      _isAnalyzing = true;
      _progressMessage = 'Starting analysis...';
    });

    try {
      final results = await ref
          .read(conceptServiceProvider)
          .analyzeAllNotes(
            onProgress: (msg) => setState(() => _progressMessage = msg),
          );

      if (mounted) {
        final notes = results['notesAnalyzed'] ?? 0;
        final concepts = results['conceptsCreated'] ?? 0;
        if (notes <= 0 || concepts <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Unable to build the map. No map data was generated.',
              ),
            ),
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Analyzed $notes notes and created $concepts concepts.',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Analysis failed: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isAnalyzing) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                _progressMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ] else ...[
              Icon(
                widget.isEmptyBecauseNoNotes
                    ? Iconsax.note_add
                    : Icons.account_tree_outlined,
                size: 60,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                widget.isEmptyBecauseNoNotes
                    ? 'No notes yet'
                    : 'Build Your Knowledge Map',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.isEmptyBecauseNoNotes
                    ? 'Create a few notes to build your knowledge map.'
                    : 'Analyze your notes to discover connected concepts and ideas.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              if (widget.isEmptyBecauseNoNotes)
                FilledButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/notes/create'),
                  icon: const Icon(Iconsax.add),
                  label: const Text('Create Note'),
                )
              else
                FilledButton.icon(
                  onPressed: _analyzeNotes,
                  icon: const Icon(Iconsax.magic_star),
                  label: const Text('Analyze My Notes'),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
