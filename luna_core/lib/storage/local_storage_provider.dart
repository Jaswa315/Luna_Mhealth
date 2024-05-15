// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/// LocalStorageProvider
/// Purpose: Concrete local storage provider for file access.

import 'dart:io';
import 'dart:typed_data';
import 'package:luna_core/storage/istorage_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

/// LocalStorageProvider
/// Use for file operations on local mobile appdata stores
/// Usage: IStorageProvider myProvider = LocalStorageProvider();
/// ! Do not use as a concrete object within Luna!!!
class LocalStorageProvider implements IStorageProvider {
  final PathProviderPlatform _pathPlatform;

  /// LocalStorageProvider CTOR
  LocalStorageProvider() : _pathPlatform = PathProviderPlatform.instance;

  /// LocalStorageProvider CTOR w/PathProviderPlatform
  /// Overrides default PathProviderPlatform behaviors
  /// Useful for testing on non-mobile platforms
  LocalStorageProvider.withPathPlatformProvider(this._pathPlatform) {
    PathProviderPlatform.instance = _pathPlatform;
  }

  @override
  Future<bool> saveFile(String fileName, Uint8List data,
      {bool createContainer = false}) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/$fileName";

      final file = File(filePath);
      if (createContainer) {
        await file.parent.create(recursive: true);
      }
      await file.writeAsBytes(data);
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Future<Uint8List?> loadFile(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/$fileName";

      final file = File(filePath);
      return await file.readAsBytes();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> deleteFile(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/$fileName";

      final file = File(filePath);
      await file.delete();
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> isFileExists(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/$fileName";

    final file = File(filePath);
    return file.exists();
  }

  @override
  Future<List<String>> getAllFileNames(
      {String container = '', bool recursiveSearch = true}) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final folderPath = "${directory.path}/$container";
      final folder = Directory(folderPath);

      final files = folder.list(recursive: recursiveSearch);
      final fileNames = <String>[];

      await for (var file in files) {
        if (file is File) {
          fileNames.add(file.uri.pathSegments.last);
        }
      }
      return fileNames;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Uint8List>> getAllFiles(
      {String container = '', bool recursiveSearch = true}) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final folderPath = "${directory.path}/$container";
      final folder = Directory(folderPath);
      final files = folder.list(recursive: recursiveSearch);
      final fileDataList = <Uint8List>[];

      await for (var file in files) {
        if (file is File) {
          final fileData = await file.readAsBytes();
          fileDataList.add(fileData);
        }
      }

      return fileDataList;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> init({String options = ''}) async {
    // no op
    // violates I in SOLID, but might need later
    return true;
  }

  @override
  void close() {
    // no op
    // violates I in SOLID, but might need later
  }
}
