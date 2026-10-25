import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../core/theme/theme_controller.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/notes/presentation/screens/create_note_screen.dart';
import '../features/notes/presentation/screens/notes_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/qa/presentation/screens/document_qa_screen.dart';
import '../features/search/presentation/screens/search_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/study/presentation/screens/flashcard_deck_screen.dart';
import '../features/study/presentation/screens/quiz_history_screen.dart';
import '../features/study/presentation/screens/study_dashboard_screen.dart';
import '../features/study/presentation/screens/study_notes_screen.dart';

final ThemeController themeController = ThemeController();

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainNavigationScreen(navigationShell: navigationShell);
      },
      branches: [
        // 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // 1: Library (My Documents)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/documents',
              builder: (context, state) => const NotesScreen(),
            ),
            GoRoute(path: '/notes', redirect: (context, state) => '/documents'),
          ],
        ),
        // 2: Study & Revision Center
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/study',
              builder: (context, state) => const StudyDashboardScreen(),
            ),
            GoRoute(path: '/map', redirect: (context, state) => '/study'),
          ],
        ),
        // 3: Ask AI
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/qa',
              builder: (context, state) {
                final docId = state.uri.queryParameters['docId'];
                return DocumentQaScreen(initialDocumentId: docId);
              },
            ),
          ],
        ),
        // 4: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    // Additional Routes
    GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
    GoRoute(
      path: '/notes/create',
      builder: (context, state) => const CreateNoteScreen(),
    ),
    GoRoute(
      path: '/documents/create',
      builder: (context, state) => const CreateNoteScreen(),
    ),
    GoRoute(
      path: '/study/notes',
      builder: (context, state) => const StudyNotesScreen(),
    ),
    GoRoute(
      path: '/study/history',
      builder: (context, state) => const QuizHistoryScreen(),
    ),
    GoRoute(
      path: '/study/flashcards',
      builder: (context, state) {
        final docId = state.uri.queryParameters['docId'];
        final docTitle = state.uri.queryParameters['docTitle'] ?? 'All Cards';
        return FlashcardDeckScreen(documentId: docId, deckTitle: docTitle);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) {
        return SettingsScreen(themeController: themeController);
      },
    ),
  ],
);

class MainNavigationScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationScreen({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: navigationShell,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder_rounded),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories_rounded),
            label: 'Study',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.message_question),
            selectedIcon: Icon(
              Iconsax.message_question,
              color: Colors.deepPurple,
            ),
            label: 'Ask AI',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
