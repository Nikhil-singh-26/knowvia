import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

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
                  padding: EdgeInsets.only(right: 16),
                  child: Tooltip(
                    message: 'Offline Mode',
                    child: Icon(Iconsax.cloud_cross, color: Colors.orange),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => _openImageViewer(context, profile?.imagePath),
                  child: CircleAvatar(
                    radius: 18,
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

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Your Knowledge',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Capture, organize and connect what you learn.',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Iconsax.note,
                          title: 'Notes',
                          value: '${notes.length}',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Iconsax.category,
                          title: 'Categories',
                          value:
                              '${notes.map((e) => e.category).toSet().length}',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton.icon(
                      onPressed: () {
                        context.push('/notes/create');
                      },
                      icon: const Icon(Iconsax.add),
                      label: const Text(
                        'Create New Note',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Recent Notes',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),

                  const SizedBox(height: 12),

                  if (notes.isEmpty)
                    _EmptyRecentNotes(
                      onCreate: () {
                        context.push('/notes/create');
                      },
                    )
                  else
                    ...notes.reversed.take(5).map((note) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _NoteCard(note: note),
                      );
                    }),
                ],
              );
            },
          ),
        );
      },
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
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          Text(title, style: const TextStyle(color: AppColors.textSecondary)),
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
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(Iconsax.note, color: AppColors.primary),
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
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    note.category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
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

class _EmptyRecentNotes extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyRecentNotes({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Iconsax.note_add,
            size: 42,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 12),
          const Text(
            'No notes yet',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onCreate,
            child: const Text('Create your first note'),
          ),
        ],
      ),
    );
  }
}
