import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiConfig {
  static const String geminiModelName = 'gemini-3.6-flash';
  static const String geminiApiVersion = 'v1beta';

  static String get geminiApiKey {
    final key = dotenv.env['GEMINI_API_KEY'];

    if (key == null || key.trim().isEmpty) {
      return '';
    }

    return key.trim();
  }

  static String get geminiBaseUrl =>
      'https://generativelanguage.googleapis.com/$geminiApiVersion/models';
}
