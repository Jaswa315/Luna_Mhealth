import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompression {
  static Future<XFile?> compressImage(File file) async {
    final filePath = file.absolute.path;
    // Create target path
    final targetPath =
        "${filePath.substring(0, filePath.lastIndexOf('.'))}_compressed.jpg";

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      filePath,
      targetPath,
      quality: 80, // Adjust quality
      minWidth: 500, // Adjust size if needed
      minHeight: 500,
    );

    return compressedFile;
  }
}
