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

              return StreamBuilder<List<Concept>>(
                stream: database.watchAllConcepts(),
                builder: (context, conceptSnapshot) {
                  final concepts = conceptSnapshot.data ?? [];

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
                        _buildLearningProgressGrid(notes, concepts),
                        const SizedBox(height: 40),
                      ],
                    ),
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
                    radius: 60,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    backgroundImage: profile?.imagePath != null
                        ? FileImage(File(profile!.imagePath!))
                        : null,
                    child: profile?.imagePath == null
                        ? const Icon(
                            Iconsax.user,
                            size: 50,
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
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  displayName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
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
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          if (profile?.bio != null && profile!.bio!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              profile.bio!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 20),
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

  Widget _buildLearningProgressGrid(List<Note> notes, List<Concept> concepts) {
    final topicCount = notes.map((n) => n.category).toSet().length;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.6,
      children: [
        _ProgressCard(
          label: 'Total Notes',
          value: notes.length.toString(),
          icon: Iconsax.document_text,
        ),
        _ProgressCard(
          label: 'Concepts',
          value: concepts.length.toString(),
          icon: Iconsax.status_up,
        ),
        _ProgressCard(
          label: 'Topics',
          value: topicCount.toString(),
          icon: Iconsax.category,
        ),
      ],
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
