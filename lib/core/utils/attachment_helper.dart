import 'dart:convert';
import 'dart:io';

class AttachmentHelper {
  static String encode(List<File> files) {
    return files.map((file) => file.path).join('|');
  }

  static List<String> decode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return [];
    }

    if (value.startsWith('[')) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {}
    }

    return value.split('|').where((s) => s.isNotEmpty).toList();
  }
}

