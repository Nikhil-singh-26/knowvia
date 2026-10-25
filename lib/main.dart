import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/app.dart';
import 'core/database/database.dart';
import 'core/ai/ai_config.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();

  ref.onDispose(() {
    database.close();
  });

  return database;
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AiConfig.loadPreferences();

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // .env is optional; user can also supply their Gemini API key in Settings.
  }

  runApp(const ProviderScope(child: KnowViaApp()));
}
