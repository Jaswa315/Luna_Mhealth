// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:io';
import 'dart:typed_data';

import 'package:luna_mhealth_mobile/core/constants/constants.dart';
import 'package:luna_mhealth_mobile/utils/logging.dart';
import 'package:path/path.dart' as p;

import '../../models/module.dart';
import '../../storage/module_storage.dart';

/// An archive handler that provides methods to handle Luna files.
class ModuleHandler {
  /// The module storage instance.
  static ModuleStorage moduleStorage =
      ModuleStorage(userName: AppConstants.moduleStorageUserName);

  /// Loads the available modules.
  static Future<List<Module>> getModules() async => _getAllModulesFromStorage();

  /// Saves the given Luna file to the app data storage.
  static Future<bool> saveModuleFileToStorage(File lunaFile) async {
    return await LogManager()
        .logFunction('ModuleHandler.saveModuleFileToStorage', () async {
      String fileName = p.basenameWithoutExtension(lunaFile.path);
      Uint8List fileData = await lunaFile.readAsBytes();
      return addModuleFile(fileName, fileData);
    });
  }

  /// Cleans up the data associated with the given module.
  static Future<bool> cleanupModuleData(String moduleName) async {
    return await LogManager().logFunction('ModuleHandler.cleanupModuleData',
        () async {
      return moduleStorage.removeModule(moduleName);
    });
  }

  /// Adds a module with the given name and JSON data.
  static Future<Module> addModule(String moduleName, String jsonData) async {
    return await LogManager().logFunction('ModuleHandler.addModule', () async {
      try {
        return await moduleStorage.addModule(moduleName, jsonData);
      } catch (e) {
        print("Error adding module: $e");
        rethrow;
      }
    });
  }

  /// Adds a module file with the given name and file data.
  static Future<bool> addModuleFile(
      String moduleName, Uint8List fileData) async {
    return await LogManager().logFunction('ModuleHandler.addModuleFile',
        () async {
      try {
        return await moduleStorage.addModuleFile(moduleName, fileData);
      } catch (e) {
        print("Error adding module file: $e");
        return false;
      }
    });
  }

  /// Gets the image with the given name from the stored module.
  static Future<Uint8List?> getImageBytes(
      String moduleName, String imageFileName) async {
    try {
      return await moduleStorage.getImageBytes(moduleName, imageFileName);
    } catch (e) {
      print("Error getting image: $e");
      return null;
    }
  }

  /// Loads all modules from storage.
  static Future<List<Module>> _getAllModulesFromStorage() async {
    try {
      return await moduleStorage.loadAllModules() as List<Module>;
    } catch (e) {
      print("Error loading modules: $e");
      return [];
    }
  }
}
