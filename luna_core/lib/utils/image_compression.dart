// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// A utility class for compressing images.
class ImageCompression {
  /// Compresses the given image file using the flutter_image_compress package.
  ///
  /// Returns the compressed image file as an [XFile] object.
  ///
  /// The [file] parameter is the image file to be compressed.
  ///
  /// The compression process adjusts the quality and size of the image.
  static Future<XFile?> compressImageFile(File file) async {
    final filePath = file.absolute.path;
    // Create target path
    final targetPath =
        "${filePath.substring(0, filePath.lastIndexOf('.'))}_compressed.jpg";

    final compressedXFile = await FlutterImageCompress.compressAndGetFile(
      filePath,
      targetPath,
      quality: 80,
      minWidth: 500,
      minHeight: 500,
    );

    // Create File object from XFile
    //final compressedFile = File(compressedXFile!.path);

    //final originalSize = file.lengthSync() / 1024; // Convert to KB
    //final compressedSize = compressedFile.lengthSync() / 1024; // Convert to KB
    //final difference = originalSize - compressedSize;
    //final compressionRatio = originalSize / compressedSize;

    //print('Original Size: ${originalSize.toStringAsFixed(2)} KB');
    //print('Compressed Size: ${compressedSize.toStringAsFixed(2)} KB');
    //print('Difference: ${difference.toStringAsFixed(2)} KB');
    //print('Compression Ratio: ${compressionRatio.toStringAsFixed(2)}');

    return compressedXFile;
  }

  /// Compresses a group of image files using the flutter_image_compress package.
  ///
  /// Returns a list of compressed image files as [XFile] objects.
  ///
  /// The [files] parameter is a list of image files to be compressed.
  ///
  /// The compression process adjusts the quality and size of the images.
  static Future<List<XFile?>> compressImageFiles(List<File> files) async {
    final compressedFiles = <XFile?>[];
    //double totalOriginalSize = 0;
    //double totalCompressedSize = 0;
    //print('Compressing ${files.length} files...');

    for (final file in files) {
      //final originalSize = await file.lengthSync() / 1024; // Convert to KB
      //totalOriginalSize += originalSize;
      final compressedFile = await compressImageFile(file);
      compressedFiles.add(compressedFile);
      //final compressedSize =
      //    await compressedFile!.length() / 1024; // Convert to KB
      //totalCompressedSize += compressedSize;
    }

    //print('Compression complete.');
    //print(
    //  'Total original files size: ${totalOriginalSize.toStringAsFixed(2)} KB',
    //);
    //print(
    //  'Total compressed files size: ${totalCompressedSize.toStringAsFixed(2)} KB',
    //);
    //print(
    //  'Difference: ${(totalOriginalSize - totalCompressedSize).toStringAsFixed(2)} KB',
    //);
    //print(
    //  'Compression ratio: ${(totalOriginalSize / totalCompressedSize).toStringAsFixed(2)}',
    //);

    return compressedFiles;
  }
}
