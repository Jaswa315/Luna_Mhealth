import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// A utility class for compressing images.
class ImageCompression {
  /// Compresses the given image file.
  ///
  /// Returns the compressed image file as an [XFile] object.
  ///
  /// The [file] parameter is the image file to be compressed.
  ///
  /// The compression process adjusts the quality and size of the image.
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
