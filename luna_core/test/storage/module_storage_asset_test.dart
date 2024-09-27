// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:collection/collection.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/storage/istorage_provider.dart';
import 'package:luna_core/storage/local_storage_provider.dart';
import 'package:luna_core/storage/module_resource_factory.dart';
import 'package:luna_core/storage/module_storage.dart';
import 'package:luna_core/utils/logging.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:global_configuration/global_configuration.dart';

const String kApplicationDocumentsPath = 'test/storage/moduletestdata';
const String kTestAssetsPath = 'test/storage/testassets';
const String kLangLocale = 'en';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GlobalConfiguration().loadFromAsset("app_settings");

  group('ModuleStorage Asset Tests', () {
    late IStorageProvider storageProvider;

    setUpAll(() {
      // Create test data folder for file operations
      final testDirectory = Directory(kApplicationDocumentsPath);
      if (!testDirectory.existsSync()) {
        testDirectory.createSync(recursive: false);
      } else {
        testDirectory.deleteSync(recursive: true);
        testDirectory.createSync(recursive: false);
      }
      LogManager.createInstance();
    });

    setUp(() {
      // Use fake path provider to account for non-mobile unit tests
      storageProvider = LocalStorageProvider.withPathPlatformProvider(
          FakePathProviderPlatform());
    });

    test('Add Module Image', () async {
      /* TODO: fix test
      String testModuleName = "TestModule";
      String imageFileName = "checkmark.png";

      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();

      File image = File("$kTestAssetsPath/$imageFileName");

      List<int> listImageBytes = await image.readAsBytes();
      Uint8List imageBytes = Uint8List.fromList(listImageBytes);

      await ModuleResourceFactory.addModule(testModuleName, jsonModule);
      bool imageAdded = await ModuleResourceFactory.addModuleImage(
          testModuleName, imageFileName, imageBytes);

      print('Image added: $imageAdded');
      expect(imageAdded, true);
      */
    });

    test('Add Module Audio', () async {
      /* TODO: fix test
      String testModuleName = "TestModule";
      String audioFileName = "sampleaudio.mp3";

      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();

      File audio = File("$kTestAssetsPath/$audioFileName");

      List<int> listAudioBytes = await audio.readAsBytes();
      Uint8List audioBytes = Uint8List.fromList(listAudioBytes);

      await ModuleResourceFactory.addModule(testModuleName, jsonModule);
      bool audioAdded = await ModuleResourceFactory.addModuleAudio(
          testModuleName, audioFileName, audioBytes, kLangLocale);

      print('Audio added: $audioAdded');
      expect(audioAdded, true);
      */
    });

    test('Get Image Path', () {
      /* TODO: fix test
      String moduleName = "TestModule";
      String imageFileName = "checkmark.png";
      String userPath = "";

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: userPath);

      String expectedPath = "$moduleName/resources/images/$imageFileName";
      String actualPath = moduleStorage.getImagePath(moduleName, imageFileName);

      expect(actualPath, expectedPath);
      */
    });

    test('Get Audio Path', () {
      /* TODO: fix test
      String moduleName = "TestModule";
      String audioFileName = "sampleaudio.mp3";
      String langLocale = "en_US";
      String userPath = "";

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: userPath);

      String expectedPath =
          "$moduleName/resources/$langLocale/audio/$audioFileName";
      String actualPath =
          moduleStorage.getAudioPath(moduleName, audioFileName, langLocale);

      expect(actualPath, expectedPath);
      */
    });

    test('Get Asset', () async {
      /* TODO: fix test
      String testModuleName = "TestModule";
      String assetFileName = "generic.txt";
      String assetContent = "This is a test file.";

      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();

      Uint8List assetBytes = Uint8List.fromList(utf8.encode(assetContent));

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: "");

      await moduleStorage.createNewModuleFile(testModuleName, jsonModule);
      await moduleStorage.addModuleAsset(
          testModuleName, assetFileName, assetBytes);

      Uint8List? testBytes =
          await moduleStorage.getAsset(testModuleName, assetFileName);

      expect(testBytes != null && ListEquality().equals(testBytes, assetBytes),
          true);
      */
    });

    tearDown(() async {
      // Clear out all files in the test folder
      await clearTestFiles();
      storageProvider.close();
    });

    tearDownAll(() {
      // Remove test data folder
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
