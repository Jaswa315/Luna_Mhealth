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
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:collection/collection.dart';
import 'package:luna_mhealth_mobile/storage/istorage_provider.dart';
import 'package:luna_mhealth_mobile/storage/local_storage_provider.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:luna_mhealth_mobile/storage/module_storage.dart';
import 'package:luna_mhealth_mobile/models/module.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:luna_mhealth_mobile/utils/logging.dart';

const String kApplicationDocumentsPath = 'test/storage/moduletestdata';
const String kTestAssetsPath = 'test/storage/testassets';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalStorageProvider Tests', () {
    late IStorageProvider storageProvider;
    LogManager.createInstance();

    setUpAll(() {
      // Create testdatafolder for file operations
      final testDirectory = Directory(kApplicationDocumentsPath);
      if (!testDirectory.existsSync()) {
        testDirectory.createSync(recursive: false);
      } else {
        testDirectory.deleteSync(recursive: true);
        testDirectory.createSync(recursive: false);
      }
    });

    setUp(() {
      // Use fake path provider to account for non-mobile unit tests
      storageProvider = LocalStorageProvider.withPathPlatformProvider(
          FakePathProviderPlatform());
    });

    test('Add Module - NoUserProfile', () async {
      String testModuleName = "TestModule";
      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();
      Module expectData = Module.fromJson(jsonDecode(jsonModule));

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: "");

      Module testData =
          await moduleStorage.addModule(testModuleName, jsonModule);
      List<String> moduleFileNames = await storageProvider.getAllFileNames();

      expect(expectData.id == testData.id, true);
      expect(expectData.description == testData.description, true);
      expect(moduleFileNames.contains("$testModuleName.luna"), true);
    });

    test('Add Module - Exception: Already Exists', () async {
      String testModuleName = "TestModule";
      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();
      Module expectData = Module.fromJson(jsonDecode(jsonModule));

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: "");

      Module testData =
          await moduleStorage.addModule(testModuleName, jsonModule);

      expect(() async {
        await moduleStorage.addModule(testModuleName, jsonModule);
      }, throwsA(TypeMatcher<Exception>()));
    });

    test('Add Module - UserProfile', () async {
      String testModuleName = "TestModule";
      String userName = "TestUser";
      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();
      Module expectData = Module.fromJson(jsonDecode(jsonModule));

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: userName);

      Module testData =
          await moduleStorage.addModule(testModuleName, jsonModule);
      List<String> moduleFileNames =
          await storageProvider.getAllFileNames(container: userName);

      expect(expectData.id == testData.id, true);
      expect(expectData.description == testData.description, true);
      expect(moduleFileNames.contains("$testModuleName.luna"), true);
    });

    test('Load Module - UserProfle', () async {
      String testModuleName = "TestModule";
      String userName = "TestUser";

      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();
      Module expectData = Module.fromJson(jsonDecode(jsonModule));

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: userName);

      await moduleStorage.addModule(testModuleName, jsonModule);

      Module? testData = await moduleStorage.loadModule(testModuleName);

      expect(expectData.id == testData?.id, true);
      expect(expectData.description == testData?.description, true);
    });

    test('Load Module - NoUserProfle', () async {
      String testModuleName = "TestModule";
      String userName = "";

      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();
      Module expectData = Module.fromJson(jsonDecode(jsonModule));

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: userName);

      await moduleStorage.addModule(testModuleName, jsonModule);

      Module? testData = await moduleStorage.loadModule(testModuleName);

      expect(expectData.id == testData?.id, true);
      expect(expectData.description == testData?.description, true);
    });

    test('Load All Modules - UserProfle', () async {
      String testModuleName1 = "TestModule1";
      String testModuleName2 = "TestModule2";
      String userName = "TestUser";

      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();
      Module expectData = Module.fromJson(jsonDecode(jsonModule));

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: userName);

      await moduleStorage.addModule(testModuleName1, jsonModule);
      await moduleStorage.addModule(testModuleName2, jsonModule);

      List<Module?> modules = await moduleStorage.loadAllModules();

      expect(modules.length == 2, true);
      expect(modules[0]?.id == expectData.id, true);
    });

    test('Load All Modules - NoUserProfle', () async {
      String testModuleName1 = "TestModule1";
      String testModuleName2 = "TestModule2";
      String userName = "";

      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();
      Module expectData = Module.fromJson(jsonDecode(jsonModule));

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: userName);

      await moduleStorage.addModule(testModuleName1, jsonModule);
      await moduleStorage.addModule(testModuleName2, jsonModule);

      List<Module?> modules = await moduleStorage.loadAllModules();

      expect(modules.length == 2, true);
      expect(modules[0]?.id == expectData.id, true);
    });

    test('Update Module - NoUserProfile', () async {
      String testModuleName = "TestModule";
      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();
      String jsonModule2 =
          File("$kTestAssetsPath/module2.json").readAsStringSync();
      Module module1 = Module.fromJson(jsonDecode(jsonModule));
      Module expectData = Module.fromJson(jsonDecode(jsonModule2));

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: "");

      await moduleStorage.addModule(testModuleName, jsonModule);

      bool result =
          await moduleStorage.updateModuleSchema(testModuleName, jsonModule2);

      Module? testData = await moduleStorage.loadModule(testModuleName);

      expect(expectData.id == testData?.id, true);
      expect(expectData.description == testData?.description, true);
    });

    test('Add/Retrieve Image', () async {
      String testModuleName = "TestModule";
      String userName = "";
      String imageFileName = "checkmark.png";

      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();

      File image = File("$kTestAssetsPath/$imageFileName");

      List<int> listImageBytes = await image.readAsBytes();

      Uint8List imageBytes = Uint8List.fromList(listImageBytes);

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: userName);

      await moduleStorage.addModule(testModuleName, jsonModule);

      await moduleStorage.addModuleImage(
          testModuleName, imageFileName, imageBytes);

      Uint8List? testBytes =
          await moduleStorage.getImageBytes(testModuleName, imageFileName);

      expect(testBytes != null && ListEquality().equals(testBytes, imageBytes),
          true);
    });

    test('Add/Retrieve Audio', () async {
      String testModuleName = "TestModule";
      String userName = "";
      String audioFileName = "sampleaudio.mp3";

      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();

      File image = File("$kTestAssetsPath/$audioFileName");

      List<int> listAudioBytes = await image.readAsBytes();

      Uint8List audioBytes = Uint8List.fromList(listAudioBytes);

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: userName);

      await moduleStorage.addModule(testModuleName, jsonModule);

      await moduleStorage.addModuleAudio(
          testModuleName, audioFileName, audioBytes);

      Uint8List? testBytes =
          await moduleStorage.getAudioBytes(testModuleName, audioFileName);

      expect(testBytes != null && ListEquality().equals(testBytes, audioBytes),
          true);
    });

    test('Remove Module - UserProfle', () async {
      String testModuleName = "TestModule";
      String userName = "TestUser";
      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();
      Module expectData = Module.fromJson(jsonDecode(jsonModule));

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: userName);

      Module testData =
          await moduleStorage.addModule(testModuleName, jsonModule);

      bool result = await moduleStorage.removeModule(testModuleName);

      List<String> moduleFileNames =
          await storageProvider.getAllFileNames(container: userName);

      expect(result, true);
      expect(!moduleFileNames.contains("$testModuleName.luna"), true);
    });

    test('Remove Module - NoUserProfle', () async {
      String testModuleName = "TestModule";
      String userName = "";
      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();
      Module expectData = Module.fromJson(jsonDecode(jsonModule));

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: userName);

      Module testData =
          await moduleStorage.addModule(testModuleName, jsonModule);

      bool result = await moduleStorage.removeModule(testModuleName);

      List<String> moduleFileNames =
          await storageProvider.getAllFileNames(container: userName);

      expect(result, true);
      expect(!moduleFileNames.contains("$testModuleName.luna"), true);
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
