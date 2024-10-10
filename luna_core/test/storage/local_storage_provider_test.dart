// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/// LocalStorageProvider Unit Tests

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:luna_core/storage/istorage_provider.dart';
import 'package:luna_core/storage/local_storage_provider.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

const String kApplicationDocumentsPath = 'test/storage/testdatafolder';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalStorageProvider Tests', () {
    late IStorageProvider storageProvider;

    setUpAll(() {
      // Create testdatafolder for file operations
      final testDirectory = Directory(kApplicationDocumentsPath);
      if (!testDirectory.existsSync()) {
        testDirectory.createSync(recursive: false);
      }
    });

    setUp(() {
      // Use fake path provider to account for non-mobile unit tests
      storageProvider = LocalStorageProvider.withPathPlatformProvider(FakePathProviderPlatform());
    });

    test('Save - Result', () async {
      final fileName = 'test_file.txt';
      final testData = Uint8List.fromList([1, 2, 3, 4, 5]);

      bool result = await storageProvider.saveFile(fileName, testData);

      expect(result, true);
    });

    test('Save - With Path', () async {
      final fileName = 'stuff/test_file.txt';
      final testData = Uint8List.fromList([1, 2, 3, 4, 5]);

      bool result = await storageProvider.saveFile(fileName, testData,
          createContainer: true);

      expect(result, true);
    });

    test('Save - Bad Path', () async {
      final fileName = 'stuff/test_file.txt';
      final testData = Uint8List.fromList([1, 2, 3, 4, 5]);

      bool result = await storageProvider.saveFile(fileName, testData);

      expect(result, false);
    });

    test('Save and load local file', () async {
      final fileName = 'test_file.txt';
      final testData = Uint8List.fromList([1, 2, 3, 4, 5]);

      await storageProvider.saveFile(fileName, testData);

      final loadedData = await storageProvider.loadFile(fileName);

      expect(loadedData, testData);
    });

    test('Load - Bad File', () async {
      final fileName = 'test_file.txt';

      final loadedData = await storageProvider.loadFile(fileName);

      expect(loadedData, null);
    });

    test('Save and Load - Empty', () async {
      final fileName = 'test_file.txt';
      final testData = Uint8List.fromList([]);

      await storageProvider.saveFile(fileName, testData);

      final loadedData = await storageProvider.loadFile(fileName);

      expect(loadedData, []);
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

    test('Find Multiple File Names - No Results', () async {
      final fileNameList = await storageProvider.getAllFileNames();

      expect(fileNameList, []);
    });

    test('Find Multiple File Names', () async {
      final fileName1 = 'test_file1.txt';
      final testData1 = Uint8List.fromList([1, 2, 3, 4, 5]);

      final fileName2 = 'test_file2.txt';
      final testData2 = Uint8List.fromList([6, 7, 8, 9, 10]);

      await storageProvider.saveFile(fileName1, testData1);
      await storageProvider.saveFile(fileName2, testData2);

      final fileNameList = await storageProvider.getAllFileNames();

      expect(fileNameList, {"test_file1.txt", "test_file2.txt"});
    });

    test('Find Multiple File Names - Subfolder', () async {
      final fileName1 = 'sub/test_file1.txt';
      final testData1 = Uint8List.fromList([1, 2, 3, 4, 5]);

      final fileName2 = 'sub/test_file2.txt';
      final testData2 = Uint8List.fromList([6, 7, 8, 9, 10]);

      await storageProvider.saveFile(fileName1, testData1,
          createContainer: true);
      await storageProvider.saveFile(fileName2, testData2,
          createContainer: true);

      final fileNameList =
          await storageProvider.getAllFileNames(container: "sub");

      expect(fileNameList, {"test_file1.txt", "test_file2.txt"});
    });

    test('Find Multiple File Names - Subfolder - No Access Root', () async {
      final fileName1 = 'test_file1.txt';
      final testData1 = Uint8List.fromList([1, 2, 3, 4, 5]);

      final fileName2 = 'test_file2.txt';
      final testData2 = Uint8List.fromList([6, 7, 8, 9, 10]);

      await storageProvider.saveFile(fileName1, testData1);
      await storageProvider.saveFile(fileName2, testData2);

      final fileNameList =
          await storageProvider.getAllFileNames(container: "sub");

      expect(fileNameList, isNot({"test_file3.txt", "test_file4.txt"}));
    });

    test('Find Multiple Files', () async {
      final fileName1 = 'test_file1.txt';
      final testData1 = Uint8List.fromList([1, 2, 3, 4, 5]);

      final fileName2 = 'test_file2.txt';
      final testData2 = Uint8List.fromList([6, 7, 8, 9, 10]);

      await storageProvider.saveFile(fileName1, testData1);
      await storageProvider.saveFile(fileName2, testData2);

      final loadedFilesList = await storageProvider.getAllFiles();

      expect(loadedFilesList[0], equals(testData1));
      expect(loadedFilesList[1], equals(testData2));
    });

    test('Find Multiple Files - Subfolder', () async {
      final fileName1 = 'sub/test_file1.txt';
      final testData1 = Uint8List.fromList([1, 2, 3, 4, 5]);

      final fileName2 = 'sub/test_file2.txt';
      final testData2 = Uint8List.fromList([6, 7, 8, 9, 10]);

      await storageProvider.saveFile(fileName1, testData1,
          createContainer: true);
      await storageProvider.saveFile(fileName2, testData2,
          createContainer: true);

      final loadedFilesList =
          await storageProvider.getAllFiles(container: "sub");

      expect(loadedFilesList[0], equals(testData1));
      expect(loadedFilesList[1], equals(testData2));
    });

    test('Find Multiple Files - child subfolder item access', () async {
      final fileName1 = 'sub/test_file1.txt';
      final testData1 = Uint8List.fromList([1, 2, 3, 4, 5]);

      final fileName2 = 'sub/test_file2.txt';
      final testData2 = Uint8List.fromList([6, 7, 8, 9, 10]);

      await storageProvider.saveFile(fileName1, testData1,
          createContainer: true);
      await storageProvider.saveFile(fileName2, testData2,
          createContainer: true);

      final loadedFilesList = await storageProvider.getAllFiles();

      expect(loadedFilesList.length, equals(2));
      expect(loadedFilesList[0], equals(testData1));
      expect(loadedFilesList[1], equals(testData2));
    });

    test('Find Multiple Files - parent subfolder no access', () async {
      final fileName1 = 'sub/test_file1.txt';
      final testData1 = Uint8List.fromList([1, 2, 3, 4, 5]);

      final fileName2 = 'test_file2.txt';
      final testData2 = Uint8List.fromList([6, 7, 8, 9, 10]);

      await storageProvider.saveFile(fileName1, testData1,
          createContainer: true);
      await storageProvider.saveFile(fileName2, testData2);

      final loadedFilesList =
          await storageProvider.getAllFiles(container: "sub");

      // cant find test_file2.txt
      expect(loadedFilesList.length, equals(1));
      expect(loadedFilesList[0], equals(testData1));
    });

    tearDown(() async {
      // clear out all files in the test folder
      await clearTestFiles();
      storageProvider.close();
    });

    tearDownAll(() {
      // remove testdatafolder
      final testDirectory = Directory(kApplicationDocumentsPath);
      if (testDirectory.existsSync()) {
        testDirectory.deleteSync(recursive: false);
      }
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
  if (await folder.exists()) {
    final entities = await folder.list(recursive: true).toList();
    for (var entity in entities) {
      if (entity is File) {
        try {
          await entity.delete();
        } catch (e) {}
      } else if (entity is Directory) {
        await entity.delete(recursive: true);
      }
    }
  }
}
