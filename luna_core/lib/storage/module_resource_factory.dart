// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:io';
import 'dart:typed_data';

import 'package:luna_core/utils/logging.dart';
import 'package:luna_mhealth_mobile/core/constants/constants.dart';
import 'package:path/path.dart' as p;

import '../models/module.dart';
import 'module_storage.dart';

/// An archive handler that provides methods to handle Luna files.
class ModuleResourceFactory {
  /// The name of the image module.
  static late String imageModuleName;

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
      return moduleStorage.createNewModuleFile(moduleName, jsonData);
    });
  }

  /// Adds a module file with the given name and file data.
  static Future<bool> addModuleFile(
      String moduleName, Uint8List fileData) async {
    return moduleStorage.importModuleFile(moduleName, fileData);
  }

  /// Gets the image with the given name from the stored module.
  static Future<Uint8List?> getImageBytes(
      String moduleName, String imageFileName) async {
    return moduleStorage.getAsset(
        moduleName, moduleStorage.getImagePath(moduleName, imageFileName));
  }

  /// Gets the audio with the given name and language locale from the stored module.
  static Future<Uint8List?> getAudioBytes(
      String moduleName, String audioFileName, String langLocale) async {
    return moduleStorage.getAsset(moduleName,
        moduleStorage.getAudioPath(moduleName, audioFileName, langLocale));
  }

  /// Adds an image asset to a Module.luna archive package.
  static Future<bool> addModuleImage(
      String moduleName, String imageFileName, Uint8List? imageBytes) async {
    String filePath = "resources/images/$imageFileName";
    return moduleStorage.addModuleAsset(moduleName, filePath, imageBytes);
  }

  /// Adds an audio asset to a Module.luna archive package.
  /// (matched audio structure)
  static Future<bool> addModuleAudio(String moduleName, String audioFileName,
      Uint8List? audioBytes, String langLocale) async {
    String filePath = "resources/$langLocale/audio/$audioFileName";
    return moduleStorage.addModuleAsset(moduleName, filePath, audioBytes);
  }

  /// Loads all modules from storage.
  static Future<List<Module>> _getAllModulesFromStorage() async {
    return await moduleStorage.loadAllModules() as List<Module>;
  }
}
