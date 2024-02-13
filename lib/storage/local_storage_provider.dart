/// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
/// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
/// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
/// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
/// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
/// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
/// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/// LocalStorageProvider
/// Purpose: Concrete local storage provider for file access.
/// Author: Shaun Stangler

import 'dart:io';
import 'dart:typed_data';
import 'package:luna_mhealth_mobile/storage/istorage_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class LocalStorageProvider implements IStorageProvider {
  final PathProviderPlatform pathPlatform;

  LocalStorageProvider(this.pathPlatform) {
    PathProviderPlatform.instance = pathPlatform;
  }

  @override
  Future<bool> saveFile(String fileName, Uint8List data) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/$fileName";

      final file = File(filePath);
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
  void close() {
    // no op
    // violates I in SOLID, but might need later
  }
}
