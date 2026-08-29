import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class MediaPickerHelper {
  static final ImagePicker _imagePicker = ImagePicker();

  static Future<File?> gallery() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) {
      return null;
    }

    return File(image.path);
  }

  static Future<File?> camera() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );

    if (image == null) {
      return null;
    }

    return File(image.path);
  }

  static Future<File?> file() async {
    final result = await FilePicker.pickFiles(
      type: FileType.any,
    );

    if (result.isEmpty) {
      return null;
    }

    final path = result.first.path;

    if (path == null) {
      return null;
    }

    return File(path);
  }
}
