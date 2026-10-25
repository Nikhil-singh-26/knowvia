import 'package:flutter/material.dart';
import 'router.dart';

class KnowViaApp extends StatefulWidget {
  const KnowViaApp({super.key});

  @override
  State<KnowViaApp> createState() => _KnowViaAppState();
}

class _KnowViaAppState extends State<KnowViaApp> {
  @override
  void initState() {
    super.initState();

    themeController.addListener(_themeChanged);
    themeController.load();
  }

  void _themeChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    themeController.removeListener(_themeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F7FA),
          elevation: 0,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF101014),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF101014),
          elevation: 0,
        ),
      ),

      themeMode: themeController.themeMode,

      routerConfig: appRouter,
    );
  }
}
