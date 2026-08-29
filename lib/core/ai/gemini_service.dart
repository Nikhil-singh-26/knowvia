import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'ai_config.dart';

class GeminiService {
  final String apiKey;

  static String get model => AiConfig.geminiModelName;

  static String get baseUrl => AiConfig.geminiBaseUrl;

  GeminiService(this.apiKey);

  Future<String> _post(
    String action,
    String prompt, {
    double temperature = 0.3,
    bool isJson = true,
  }) async {
    final url = Uri.parse('$baseUrl/$model:$action?key=$apiKey');

    final body = {
      'contents': [
        {
          'parts': [
            {'text': prompt},
          ],
        },
      ],
      'generationConfig': {
        'temperature': temperature,
        if (isJson) 'responseMimeType': 'application/json',
      },
    };

    try {
      debugPrint(
        'Gemini API Request: action=$action, model=$model, isJson=$isJson',
      );

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        debugPrint(
          'Gemini API Error: status=${response.statusCode}, body=${response.body}',
        );

        String errorMsg = 'AI service error (Status ${response.statusCode}).';
        try {
          final errorBody = jsonDecode(response.body);
          if (errorBody['error'] != null &&
              errorBody['error']['message'] != null) {
            errorMsg = errorBody['error']['message'];
          }
        } catch (_) {}

        if (response.statusCode == 404) {
          errorMsg = 'Gemini 404: ${response.body}';
              // 'AI model or version unavailable. Please check configuration.';
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          errorMsg = 'AI authorization failed. Please check your API key.';
        } else if (response.statusCode == 429) {
          errorMsg = 'AI usage limit reached. Please try again later.';
        }
        throw Exception(errorMsg);
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = data['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        throw Exception('AI returned no response.');
      }

      final candidate = candidates.first as Map<String, dynamic>;
      final content = candidate['content'] as Map<String, dynamic>?;
      final parts = content?['parts'] as List?;
      if (parts == null || parts.isEmpty) {
        throw Exception('AI returned empty content.');
      }

      String text = parts.first['text']?.toString() ?? '';
      if (text.trim().isEmpty) {
        throw Exception('AI returned empty text.');
      }

      // Extra safety for JSON: sometimes models still wrap with markdown
      if (isJson && text.contains('```')) {
        final match = RegExp(r'```json?\s*([\s\S]*?)\s*```').firstMatch(text);
        if (match != null) {
          text = match.group(1) ?? text;
        } else {
          text = text.replaceAll('```json', '').replaceAll('```', '').trim();
        }
      }

      return text.trim();
    } catch (e) {
      debugPrint('Gemini Service Exception: $e');
      if (e is http.ClientException || e is SocketException) {
        throw Exception(
          'Network error: Please check your internet connection.',
        );
      }
      if (e.toString().contains('timeout')) {
        throw Exception('AI service timed out. Please try again.');
      }
      rethrow;
    }
  }

  Future<String> generateFlashcards({
    required String title,
    required String content,
    required String category,
  }) async {
    final prompt =
        '''
Create 8 useful flashcards from this knowledge note.
Title: $title
Category: $category
Content: $content

Return ONLY valid JSON:
{
  "cards": [
    {
      "question": "...",
      "answer": "..."
    }
  ]
}
Rules:
- Create exactly 8 cards.
- Questions should test understanding.
- Answers should be concise.
- Cover different concepts from the note.
''';
    return _post('generateContent', prompt);
  }

  Future<String> generateQuiz({
    required String title,
    required String content,
    required String category,
  }) async {
    final prompt =
        '''
Create a short quiz from this knowledge note.
Title: $title
Category: $category
Content: $content

Create exactly 5 multiple-choice questions.
Return ONLY valid JSON:
{
  "questions": [
    {
      "question": "...",
      "options": ["...", "...", "...", "..."],
      "answer": 0,
      "explanation": "..."
    }
  ]
}
Rules:
- answer must be the zero-based index of the correct option.
- Questions must test understanding.
- Use exactly 4 options per question.
''';
    return _post('generateContent', prompt);
  }

  Future<String> generateStudyPlan({
    required String title,
    required String content,
    required String category,
  }) async {
    final prompt =
        '''
You are a personal learning assistant.
Based on this knowledge note, create a practical study path.
Title: $title
Category: $category
Content: $content

Give the learner:
1. What they already understand
2. What they should learn next
3. Three recommended concepts in order
4. One practical exercise
5. One question they should be able to answer after studying

Keep it concise and beginner-friendly.
Use this format:
WHAT YOU KNOW
...
STUDY NEXT
1. ...
...
PRACTICE
...
CHECK YOURSELF
...
''';
    return _post('generateContent', prompt, temperature: 0.4, isJson: false);
  }

  Future<String> analyzeNote({
    required String title,
    required String content,
    required String category,
  }) async {
    final prompt =
        '''
Analyze this knowledge note.
Title: $title
Category: $category
Content: $content

Return ONLY valid JSON in exactly this structure:
{
  "summary": "short useful summary",
  "topics": ["topic1", "topic2"],
  "keywords": ["keyword1", "keyword2"],
  "difficulty": "Beginner",
  "relatedConcepts": ["concept1", "concept2"]
}
Rules:
- difficulty must be exactly one of: Beginner, Intermediate, Advanced
''';
    return _post('generateContent', prompt, temperature: 0.2);
  }

  Future<String> extractConcepts({
    required String title,
    required String content,
  }) async {
    final prompt =
        '''
Extract key concepts from this note.
Title: $title
Content: $content

Return ONLY valid JSON in this structure:
{
  "concepts": [
    {
      "name": "Concept Name",
      "category": "Topic Category",
      "description": "Short explanation",
      "related": ["Other Concept 1", "Other Concept 2"]
    }
  ]
}
Rules:
- Extract 3 to 7 most important concepts.
- Descriptions should be 1-2 sentences.
- 'related' should list other concepts from this list or general related concepts.
''';
    return _post('generateContent', prompt, temperature: 0.2);
  }

  Future<String> explainConcept({
    required String conceptName,
    required String category,
  }) async {
    final prompt =
        '''
Explain this concept in the context of $category.
Concept: $conceptName
Return ONLY a clear, concise, and structured explanation (max 3 paragraphs).
''';
    return _post('generateContent', prompt, temperature: 0.5, isJson: false);
  }

  Future<String> performOcr(List<int> imageBytes, String mimeType) async {
    final url = Uri.parse('$baseUrl/$model:generateContent?key=$apiKey');
    final prompt =
        'Extract all the text from this image. Maintain logical structure. Return ONLY the extracted text.';

    final body = {
      'contents': [
        {
          'parts': [
            {'text': prompt},
            {
              'inline_data': {
                'mime_type': mimeType,
                'data': base64Encode(imageBytes),
              },
            },
          ],
        },
      ],
    };

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 45));

      if (response.statusCode != 200) {
        throw Exception('AI service error: ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final text = data['candidates']?[0]['content']?['parts']?[0]['text']
          ?.toString();
      return text?.trim() ?? '';
    } catch (e) {
      if (e is http.ClientException || e is SocketException) {
        throw Exception(
          'Network error: Please check your internet connection.',
        );
      }
      rethrow;
    }
  }

  Future<String> suggestMetadata(String content) async {
    final prompt =
        '''
Based on this content, suggest a title and category.
Content: $content
Return ONLY valid JSON:
{
  "title": "...",
  "category": "...",
  "tags": ["tag1", "tag2"]
}
''';
    return _post('generateContent', prompt);
  }

  Future<List<String>> semanticSearch({
    required String query,
    required List<Map<String, String>> notes,
  }) async {
    final notesJson = jsonEncode(notes);
    final prompt =
        '''
Identify Note IDs relevant to: "$query"
Notes: $notesJson
Return ONLY a JSON array of the relevant Note IDs, ordered by relevance.
Example: ["id1", "id2"]
''';
    final result = await _post('generateContent', prompt);
    try {
      return List<String>.from(jsonDecode(result));
    } catch (_) {
      return [];
    }
  }
}
