import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _editProfile(
    BuildContext context,
    WidgetRef ref,
    Profile? profile,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditProfileScreen(profile: profile)),
    );
    ref.invalidate(databaseProvider);
  }

  Future<void> _saveProfilePhoto(
    WidgetRef ref,
    Profile? profile,
    String? imagePath,
    ScaffoldMessengerState? messenger,
  ) async {
    final database = ref.read(databaseProvider);
    await database.saveProfile(
      name: profile?.name ?? '',
      bio: profile?.bio,
      interests: profile?.interests,
      imagePath: imagePath,
    );

    messenger?.showSnackBar(
      const SnackBar(content: Text('Profile photo updated')),
    );
  }

  Future<void> _showPhotoActions(
    BuildContext context,
    WidgetRef ref,
    Profile? profile,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Profile Photo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Iconsax.camera, color: Colors.white, size: 20),
                ),
                title: const Text('Take Photo'),
                onTap: () async {
                  final messenger = ScaffoldMessenger.maybeOf(context);
                  Navigator.pop(bottomSheetContext);
                  final picker = ImagePicker();
                  final image = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 85,
                  );
                  if (image == null) return;

                  await _saveProfilePhoto(ref, profile, image.path, messenger);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.greenAccent,
                  child: Icon(Iconsax.gallery, color: Colors.white, size: 20),
                ),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  final messenger = ScaffoldMessenger.maybeOf(context);
                  Navigator.pop(bottomSheetContext);
                  final picker = ImagePicker();
                  final image = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 85,
                  );
                  if (image == null) return;

                  await _saveProfilePhoto(ref, profile, image.path, messenger);
                },
              ),
              if (profile?.imagePath != null && profile!.imagePath!.isNotEmpty)
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    child: Icon(Iconsax.trash, color: Colors.white, size: 20),
                  ),
                  title: const Text('Remove Photo'),
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);
                    final messenger = ScaffoldMessenger.maybeOf(context);
                    await _saveProfilePhoto(ref, profile, null, messenger);
                  },
                ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Iconsax.setting_2),
          ),
        ],
      ),
      body: StreamBuilder<List<Profile>>(
        stream: database.select(database.profiles).watch(),
        builder: (context, profileSnapshot) {
          final profile = profileSnapshot.data?.isNotEmpty == true
              ? profileSnapshot.data!.first
              : null;

          return StreamBuilder<List<Note>>(
            stream: database.select(database.notes).watch(),
            builder: (context, noteSnapshot) {
              final notes = noteSnapshot.data ?? [];

              return StreamBuilder<List<Flashcard>>(
                stream: database.watchAllFlashcards(),
                builder: (context, cardSnapshot) {
                  final cards = cardSnapshot.data ?? [];

                  return StreamBuilder<List<StudyNote>>(
                    stream: database.watchAllStudyNotes(),
                    builder: (context, studyNoteSnapshot) {
                      final studyNotes = studyNoteSnapshot.data ?? [];

                      return StreamBuilder<List<QuizSession>>(
                        stream: database.watchAllQuizSessions(),
                        builder: (context, quizSnapshot) {
                          final quizzes = quizSnapshot.data ?? [];

                          return SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildHeader(context, ref, profile),
                                const SizedBox(height: 28),
                                const Text(
                                  'Learning Progress',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildLearningProgressGrid(
                                  notesCount: notes.length,
                                  cardsCount: cards.length,
                                  studyNotesCount: studyNotes.length,
                                  quizzesCount: quizzes.length,
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'Quick Navigation',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildNavigationTile(
                                  context: context,
                                  title: 'Study & Revision Center',
                                  subtitle:
                                      'Spaced repetition flashcards & quizzes',
                                  icon: Iconsax.card,
                                  onTap: () => context.push('/study'),
                                ),
                                const SizedBox(height: 10),
                                _buildNavigationTile(
                                  context: context,
                                  title: 'Study Notes & Bookmarks',
                                  subtitle:
                                      'Saved passages, AI answers, and notes',
                                  icon: Iconsax.note_favorite,
                                  onTap: () => context.push('/study/notes'),
                                ),
                                const SizedBox(height: 10),
                                _buildNavigationTile(
                                  context: context,
                                  title: 'Quiz History',
                                  subtitle: 'Past test scores & answer reviews',
                                  icon: Iconsax.award,
                                  onTap: () => context.push('/study/history'),
                                ),
                                const SizedBox(height: 10),
                                _buildNavigationTile(
                                  context: context,
                                  title: 'Settings & Privacy',
                                  subtitle:
                                      'Theme, Gemini API key, storage management',
                                  icon: Iconsax.setting_2,
                                  onTap: () => context.push('/settings'),
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, Profile? profile) {
    final displayName = profile == null || profile.name.trim().isEmpty
        ? 'Enter your name'
        : profile.name;

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () => _openImageViewer(context, profile?.imagePath),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      width: 4,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 54,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    backgroundImage: profile?.imagePath != null
                        ? FileImage(File(profile!.imagePath!))
                        : null,
                    child: profile?.imagePath == null
                        ? const Icon(
                            Iconsax.user,
                            size: 46,
                            color: AppColors.primary,
                          )
                        : null,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () => _showPhotoActions(context, ref, profile),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.camera,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  displayName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _editProfile(context, ref, profile),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Iconsax.edit_2,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          if (profile?.bio != null && profile!.bio!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              profile.bio!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 14),
          if (profile?.interests != null && profile!.interests!.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: profile.interests!
                  .split(',')
                  .map(
                    (i) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        i.trim(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildLearningProgressGrid({
    required int notesCount,
    required int cardsCount,
    required int studyNotesCount,
    required int quizzesCount,
  }) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _ProgressCard(
          label: 'Documents',
          value: notesCount.toString(),
          icon: Iconsax.document_text,
        ),
        _ProgressCard(
          label: 'Flashcards',
          value: cardsCount.toString(),
          icon: Iconsax.card,
        ),
        _ProgressCard(
          label: 'Study Notes',
          value: studyNotesCount.toString(),
          icon: Iconsax.note_favorite,
        ),
        _ProgressCard(
          label: 'Quizzes Taken',
          value: quizzesCount.toString(),
          icon: Iconsax.award,
        ),
      ],
    );
  }

  Widget _buildNavigationTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.14),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
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

class _ProgressCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProgressCard({
    required this.label,
    required this.value,
    required this.icon,
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
          color: theme.colorScheme.outline.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
