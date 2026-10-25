import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../core/theme/theme_controller.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/qa/presentation/screens/document_qa_screen.dart';
import '../features/search/presentation/screens/search_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/notes/presentation/screens/create_note_screen.dart';
import '../features/notes/presentation/screens/notes_screen.dart';

final ThemeController themeController = ThemeController();

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainNavigationScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/qa',
              builder: (context, state) {
                final docId = state.uri.queryParameters['docId'];
                return DocumentQaScreen(initialDocumentId: docId);
              },
            ),
            GoRoute(
              path: '/map',
              redirect: (context, state) => '/qa',
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),
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
    GoRoute(
      path: '/notes',
      builder: (context, state) => const NotesScreen(),
    ),
    GoRoute(
      path: '/documents',
      builder: (context, state) => const NotesScreen(),
    ),
    GoRoute(
      path: '/notes/create',
      builder: (context, state) => const CreateNoteScreen(),
    ),
    GoRoute(
      path: '/documents/create',
      builder: (context, state) => const CreateNoteScreen(),
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
        duration: const Duration(milliseconds: 300),
        child: navigationShell,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.message_question),
            selectedIcon: Icon(Iconsax.message_question, color: Colors.deepPurple),
            label: 'AI Q&A',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
