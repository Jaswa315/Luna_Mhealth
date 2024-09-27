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
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/storage/istorage_provider.dart';
import 'package:luna_core/storage/local_storage_provider.dart';
import 'package:luna_core/storage/module_storage.dart';
import 'package:luna_core/utils/logging.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:global_configuration/global_configuration.dart';

const String kApplicationDocumentsPath = 'test/storage/moduletestdata';
const String kTestAssetsPath = 'test/storage/testassets';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GlobalConfiguration().loadFromAsset("app_settings");

  group('LocalStorageProvider Tests', () {
    late IStorageProvider storageProvider;

    setUpAll(() {
      // Create testdatafolder for file operations
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

    test('Add Module - NoUserProfile', () async {
      /* TODO: fix test
      String testModuleName = "TestModule";
      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();
      Module expectData = Module.fromJson(jsonDecode(jsonModule));

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: "");

      Module testData =
          await moduleStorage.createNewModuleFile(testModuleName, jsonModule);
      List<String> moduleFileNames = await storageProvider.getAllFileNames();

      //expect(expectData.id == testData.id, true);
      expect(expectData.title == testData.title, true);
      expect(moduleFileNames.contains("$testModuleName.luna"), true);
      */
    });

    test('Add Module - Exception: Already Exists', () async {
      /* TODO: fix test
      String testModuleName = "TestModule";
      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();
      Module expectData = Module.fromJson(jsonDecode(jsonModule));

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: "");

      Module testData =
          await moduleStorage.createNewModuleFile(testModuleName, jsonModule);

      expect(() async {
        await moduleStorage.createNewModuleFile(testModuleName, jsonModule);
      }, throwsA(TypeMatcher<Exception>()));
      */
    });

    test('Add Module - UserProfile', () async {
      /* TODO: fix test
      String testModuleName = "TestModule";
      String userName = "TestUser";
      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();
      Module expectData = Module.fromJson(jsonDecode(jsonModule));

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: userName);

      Module testData =
          await moduleStorage.createNewModuleFile(testModuleName, jsonModule);
      List<String> moduleFileNames =
          await storageProvider.getAllFileNames(container: userName);

      // expect(expectData.id == testData.id, true);
      expect(expectData.title == testData.title, true);
      expect(moduleFileNames.contains("$testModuleName.luna"), true);
      */
    });

    test('Load Module - UserProfle', () async {
      /* TODO: fix test
      String testModuleName = "TestModule";
      String userName = "TestUser";

      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();
      Module expectData = Module.fromJson(jsonDecode(jsonModule));

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: userName);

      await moduleStorage.createNewModuleFile(testModuleName, jsonModule);

      Module? testData = await moduleStorage.loadModule(testModuleName);

      // expect(expectData.id == testData?.id, true);
      expect(expectData.title == testData?.title, true);
      */
    });

    test('Load Module - NoUserProfle', () async {
      /* TODO: fix test
      String testModuleName = "TestModule";
      String userName = "";

      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();
      Module expectData = Module.fromJson(jsonDecode(jsonModule));

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: userName);

      await moduleStorage.createNewModuleFile(testModuleName, jsonModule);

      Module? testData = await moduleStorage.loadModule(testModuleName);

      // expect(expectData.id == testData?.id, true);
      expect(expectData.title == testData?.title, true);
      */
    });

    test('Load All Modules - UserProfle', () async {
      /* TODO: fix test
      String testModuleName1 = "TestModule1";
      String testModuleName2 = "TestModule2";
      String userName = "TestUser";

      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();
      Module expectData = Module.fromJson(jsonDecode(jsonModule));

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: userName);

      await moduleStorage.createNewModuleFile(testModuleName1, jsonModule);
      await moduleStorage.createNewModuleFile(testModuleName2, jsonModule);

      List<Module?> modules = await moduleStorage.loadAllModules();

      expect(modules.length == 2, true);
      // expect(modules[0]?.id == expectData.id, true);
      */
    });

    test('Load All Modules - NoUserProfle', () async {
      /* TODO: fix test
      String testModuleName1 = "TestModule1";
      String testModuleName2 = "TestModule2";
      String userName = "";

      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();
      Module expectData = Module.fromJson(jsonDecode(jsonModule));

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: userName);

      await moduleStorage.createNewModuleFile(testModuleName1, jsonModule);
      await moduleStorage.createNewModuleFile(testModuleName2, jsonModule);

      List<Module?> modules = await moduleStorage.loadAllModules();

      expect(modules.length == 2, true);
      // expect(modules[0]?.id == expectData.id, true);
      */
    });

    test('Remove Module - UserProfle', () async {
      /* TODO: fix test
      String testModuleName = "TestModule";
      String userName = "TestUser";
      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();
      Module expectData = Module.fromJson(jsonDecode(jsonModule));

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: userName);

      Module testData =
          await moduleStorage.createNewModuleFile(testModuleName, jsonModule);

      bool result = await moduleStorage.removeModule(testModuleName);

      List<String> moduleFileNames =
          await storageProvider.getAllFileNames(container: userName);

      expect(result, true);
      expect(!moduleFileNames.contains("$testModuleName.luna"), true);
      */
    });

    test('Remove Module - NoUserProfle', () async {
      /* TODO: fix test
      String testModuleName = "TestModule";
      String userName = "";
      String jsonModule =
          File("$kTestAssetsPath/module.json").readAsStringSync();
      Module expectData = Module.fromJson(jsonDecode(jsonModule));

      ModuleStorage moduleStorage =
          ModuleStorage(provider: storageProvider, userName: userName);

      Module testData =
          await moduleStorage.createNewModuleFile(testModuleName, jsonModule);

      bool result = await moduleStorage.removeModule(testModuleName);

      List<String> moduleFileNames =
          await storageProvider.getAllFileNames(container: userName);

      expect(result, true);
      expect(!moduleFileNames.contains("$testModuleName.luna"), true);
      */
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
