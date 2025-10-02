import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

abstract class UtilService {
  static Future<File?> pickFile({
    String? dialogTitle,
    FileType type = FileType.any,
    bool allowMultiple = false,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: dialogTitle,
      type: type,
      allowMultiple: allowMultiple,
      onFileLoading: (status) {},
    );

    if (result?.files.isNotEmpty ?? false) {
      final file = result?.files.first;
      return File(file!.path!);
    }
    return null;
  }

  static Future<String> imageToBase64(File file) async {
    final bytes = await file.readAsBytes();
    final base64 = base64Encode(bytes);
    return base64;
  }

  static Image imageFromUrl(
    String base64, {
    double? width,
    double? height,
    Color? color,
    BoxFit? fit,
  }) {
    final bytes = base64Decode(base64);
    final image = Image.memory(bytes);
    return image;
  }
}
