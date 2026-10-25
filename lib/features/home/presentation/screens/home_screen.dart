import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import '../../../notes/presentation/screens/note_detail_screen.dart';
import '../../../../core/utils/connectivity_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _openImageViewer(BuildContext context, String? imagePath) {
    if (imagePath == null || imagePath.trim().isEmpty) return;

    showDialog<void>(
      context: context,
      barrierColor: Colors.black,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.black,
          child: GestureDetector(
            onTap: () => Navigator.of(dialogContext).pop(),
            child: Stack(
              children: [
                Positioned.fill(
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    child: Center(
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 32,
                  left: 16,
                  child: IconButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(databaseProvider);
    final isOnline = ref.watch(connectivityProvider).value ?? true;
    final theme = Theme.of(context);

    return StreamBuilder<List<Profile>>(
      stream: database.select(database.profiles).watch(),
      builder: (context, profileSnapshot) {
        final profile = profileSnapshot.data?.isNotEmpty == true
            ? profileSnapshot.data!.first
            : null;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Know Via',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            actions: [
              if (!isOnline)
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Tooltip(
                    message: 'Offline Mode (Local database active)',
                    child: Icon(
                      Iconsax.cloud_cross,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                ),
              IconButton(
                tooltip: 'Search Knowledge',
                icon: const Icon(Icons.search, size: 22),
                onPressed: () => context.push('/search'),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => _openImageViewer(context, profile?.imagePath),
                  child: CircleAvatar(
                    radius: 17,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    backgroundImage: profile?.imagePath != null
                        ? FileImage(File(profile!.imagePath!))
                        : null,
                    child: profile?.imagePath == null
                        ? const Icon(
                            Iconsax.user,
                            size: 18,
                            color: AppColors.primary,
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
          body: StreamBuilder<List<Note>>(
            stream: database.select(database.notes).watch(),
            builder: (context, snapshot) {
              final notes = snapshot.data ?? [];

              return StreamBuilder<List<Flashcard>>(
                stream: database.watchAllFlashcards(),
                builder: (context, cardSnapshot) {
                  final allCards = cardSnapshot.data ?? [];
                  final now = DateTime.now();
                  final dueCards = allCards
                      .where((c) => c.nextReviewAt.isBefore(now))
                      .toList();

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 80),
                    children: [
                      // Welcome Area
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile?.name != null &&
                                        profile!.name.trim().isNotEmpty
                                    ? 'Hello, ${profile.name.trim().split(' ').first} 👋'
                                    : 'Welcome to Know Via 👋',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Local-first document learning & revision',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Revision / Continue Learning Banner
                      if (dueCards.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF6366F1,
                                ).withValues(alpha: 0.28),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Iconsax.timer_1,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${dueCards.length} ${dueCards.length == 1 ? 'card' : 'cards'} due for review',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Keep your memory retention active today with spaced repetition.',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF6366F1),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                ),
                                onPressed: () => context.push('/study'),
                                child: const Text(
                                  'Review',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Quick Actions Grid
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _QuickActionButton(
                              icon: Iconsax.document_upload,
                              label: 'Import',
                              subtitle: 'PDF, Text',
                              color: const Color(0xFF3B82F6),
                              onTap: () => context.push('/notes/create'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _QuickActionButton(
                              icon: Iconsax.message_question,
                              label: 'Ask AI',
                              subtitle: 'Grounded Q&A',
                              color: const Color(0xFF8B5CF6),
                              onTap: () => context.push('/qa'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _QuickActionButton(
                              icon: Iconsax.card,
                              label: 'Study',
                              subtitle: 'SM-2 & Quiz',
                              color: const Color(0xFF10B981),
                              onTap: () => context.push('/study'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // Learning Stats
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              icon: Iconsax.document_text,
                              title: 'Documents',
                              value: '${notes.length}',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              icon: Iconsax.cards,
                              title: 'Flashcards',
                              value: '${allCards.length}',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 26),

                      // Recent Documents Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Documents',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (notes.isNotEmpty)
                            TextButton(
                              onPressed: () => context.push('/documents'),
                              child: const Text('View All'),
                            ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      if (notes.isEmpty)
                        _EmptyRecentNotes(
                          onCreate: () {
                            context.push('/notes/create');
                          },
                        )
                      else
                        ...notes.reversed.take(4).map((note) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _NoteCard(note: note),
                          );
                        }),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final Note note;

  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = DateFormat('MMM d').format(note.createdAt);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NoteDetailScreen(note: note)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(
                Iconsax.document_text,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          note.category.isEmpty ? 'General' : note.category,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '•  $dateStr',
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Iconsax.arrow_right_3,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyRecentNotes extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyRecentNotes({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Iconsax.document_upload,
            size: 42,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 12),
          const Text(
            'No documents yet',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text(
            'Import a PDF or document to begin reading, asking questions, and generating flashcards.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: onCreate,
            child: const Text('Upload your first document'),
          ),
        ],
      ),
    );
  }
}
