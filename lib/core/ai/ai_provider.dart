import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ai_config.dart';
import 'gemini_service.dart';

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService(AiConfig.geminiApiKey);
});
