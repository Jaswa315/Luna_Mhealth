/// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
/// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
/// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
/// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
/// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
/// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
/// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/// LocalStorageProvider Unit Tests
/// Author: Shaun Stangler

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:luna_mhealth_mobile/storage/istorage_provider.dart';
import 'package:luna_mhealth_mobile/storage/local_storage_provider.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

const String kApplicationDocumentsPath = 'test/storage/testdatafolder';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalStorageProvider Tests', () {
    late IStorageProvider storageProvider;

    setUp(() {
      // Use fake path provider to account for non-mobile unit tests
      storageProvider = LocalStorageProvider(FakePathProviderPlatform());    
    });

    test('Save and load local file', () async {
      final fileName = 'test_file.txt';
      final testData = Uint8List.fromList([1, 2, 3, 4, 5]);

      await storageProvider.saveFile(fileName, testData);

      final loadedData = await storageProvider.loadFile(fileName);

      expect(loadedData, testData);
    });

    test('Delete local file', () async {
      final fileName = 'test_file_to_delete.txt';
      final testData = Uint8List.fromList([1, 2, 3, 4, 5]);

      await storageProvider.saveFile(fileName, testData);

      final fileExistsBeforeDeletion =
          await storageProvider.isFileExists(fileName);
      expect(fileExistsBeforeDeletion, isTrue);

      await storageProvider.deleteFile(fileName);

      final fileExistsAfterDeletion =
          await storageProvider.isFileExists(fileName);
      expect(fileExistsAfterDeletion, isFalse);
    });

    tearDown(() async {
      // clear out all files in the test folder
      await clearTestFiles();
      storageProvider.close();
    });
  });
}

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return kApplicationDocumentsPath;
  }
}

Future<void> clearTestFiles() async { 
  final folder = Directory(kApplicationDocumentsPath);
  final files = folder.list();
  await for (var file in files) {
    if (file is File) {
      await file.delete();
    }
  }
}
