// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

/// A service class that provides file management functionality.
class FileManagementService {
  /// A method to pick and store a file from the device.
  Future<File> pickAndStoreFile() async {
    try {
      File? pickedFile = await _pickFile();
      if (pickedFile == null || !pickedFile.existsSync()) {
        throw Exception('No file selected or the file does not exist.');
      }
      return pickedFile;
    } catch (e) {
      debugPrint('Error selecting and storing file: $e');
      rethrow;
    }
  }

  /// A method to pick a file from the device.
  ///
  /// Returns a [File] object representing the selected file, or `null` if no file was selected.
  Future<File?> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (result != null) {
      final path = result.files.single.path;
      return File(path!);
    }
    return null;
  }
}
