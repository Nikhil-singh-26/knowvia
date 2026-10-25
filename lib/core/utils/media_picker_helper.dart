import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class MediaPickerHelper {
  static final ImagePicker _imagePicker = ImagePicker();

  static Future<File?> gallery() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (image == null) {
      return null;
    }

    return File(image.path);
  }

  static Future<File?> camera() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );

    if (image == null) {
      return null;
    }

    return File(image.path);
  }

  static Future<File?> file() async {
    final result = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'txt',
        'md',
        'csv',
        'rtf',
        'jpg',
        'jpeg',
        'png',
        'webp',
      ],
    );

    if (result == null || result.path == null) {
      return null;
    }

    return File(result.path!);
  }

  static Future<List<File>> multipleFiles() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'txt',
        'md',
        'csv',
        'rtf',
        'jpg',
        'jpeg',
        'png',
        'webp',
      ],
    );

    return result
        .where((f) => f.path != null)
        .map((f) => File(f.path!))
        .toList();
  }
}
