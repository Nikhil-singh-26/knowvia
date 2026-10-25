import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AiConfig {
  static const String defaultModelName = 'gemini-2.5-flash';
  static const String geminiApiVersion = 'v1beta';

  static String _customApiKey = '';
  static String _customModelName = '';

  static Future<void> loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _customApiKey = prefs.getString('custom_gemini_api_key') ?? '';
      _customModelName = prefs.getString('custom_gemini_model') ?? '';
    } catch (_) {}
  }

  static String? get customApiKey =>
      _customApiKey.isEmpty ? null : _customApiKey;

  static String get modelId => geminiModelName;

  static String get geminiModelName {
    if (_customModelName.isNotEmpty) {
      return _customModelName;
    }
    return defaultModelName;
  }

  static Future<void> setCustomApiKey(String? key) async {
    _customApiKey = (key ?? '').trim();
    final prefs = await SharedPreferences.getInstance();
    if (_customApiKey.isEmpty) {
      await prefs.remove('custom_gemini_api_key');
    } else {
      await prefs.setString('custom_gemini_api_key', _customApiKey);
    }
  }

  static Future<void> setCustomModel(String? model) async {
    _customModelName = (model ?? '').trim();
    final prefs = await SharedPreferences.getInstance();
    if (_customModelName.isEmpty) {
      await prefs.remove('custom_gemini_model');
    } else {
      await prefs.setString('custom_gemini_model', _customModelName);
    }
  }

  static String get geminiApiKey {
    if (_customApiKey.isNotEmpty) {
      return _customApiKey;
    }
    final key = dotenv.env['GEMINI_API_KEY'];
    if (key == null || key.trim().isEmpty) {
      return '';
    }
    return key.trim();
  }

  static bool get hasApiKey => geminiApiKey.isNotEmpty;

  static String get geminiBaseUrl =>
      'https://generativelanguage.googleapis.com/$geminiApiVersion/models';
}
