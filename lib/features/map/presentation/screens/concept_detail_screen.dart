import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import '../../../notes/presentation/screens/note_detail_screen.dart';
import '../../../../core/ai/ai_provider.dart';

class ConceptDetailScreen extends ConsumerStatefulWidget {
  final Concept concept;

  const ConceptDetailScreen({super.key, required this.concept});

  @override
  ConsumerState<ConceptDetailScreen> createState() => _ConceptDetailScreenState();
}

class _ConceptDetailScreenState extends ConsumerState<ConceptDetailScreen> {
  String? aiExplanation;
  bool isLoadingAi = false;

  @override
  void initState() {
    super.initState();
    aiExplanation = widget.concept.aiExplanation;
  }

  Future<void> _fetchAiExplanation() async {
    setState(() => isLoadingAi = true);
    try {
      final service = ref.read(geminiServiceProvider);
      final explanation = await service.explainConcept(
        conceptName: widget.concept.name,
        category: widget.concept.category,
      );

      final database = ref.read(databaseProvider);
      await (database.update(database.concepts)
            ..where((tbl) => tbl.id.equals(widget.concept.id)))
          .write(ConceptsCompanion(
        aiExplanation: Value(explanation),
        updatedAt: Value(DateTime.now()),
      ));

      setState(() {
        aiExplanation = explanation;
        isLoadingAi = false;
      });
    } catch (e) {
      setState(() => isLoadingAi = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get AI explanation: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Concept Detail'),
        actions: [
          IconButton(
            onPressed: aiExplanation == null ? _fetchAiExplanation : null,
            icon: const Icon(Iconsax.magic_star),
            tooltip: 'AI Explanation',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.concept.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Chip(
              label: Text(widget.concept.category),
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              labelStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            if (aiExplanation != null) ...[
              const Text(
                'AI Explanation',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                ),
                child: Text(
                  aiExplanation!,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
              ),
              const SizedBox(height: 24),
            ] else if (isLoadingAi) ...[
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 24),
            ] else if (widget.concept.description != null && widget.concept.description!.isNotEmpty) ...[
              const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text(
                widget.concept.description!,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 24),
            ],

            const Text(
              'Related Notes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Note>>(
              future: database.getNotesForConcept(widget.concept.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                final notes = snapshot.data!;
                if (notes.isEmpty) return const Text('No related notes found.');

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notes.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return ListTile(
                      leading: const Icon(Iconsax.document, color: AppColors.primary),
                      title: Text(note.title),
                      subtitle: Text(note.category),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => NoteDetailScreen(note: note)),
                        );
                      },
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 24),
            const Text(
              'Related Concepts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Concept>>(
              future: database.getRelatedConcepts(widget.concept.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                final related = snapshot.data!;
                if (related.isEmpty) return const Text('No related concepts found.');

                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: related.map((c) => ActionChip(
                    label: Text(c.name),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ConceptDetailScreen(concept: c)),
                      );
                    },
                  )).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
