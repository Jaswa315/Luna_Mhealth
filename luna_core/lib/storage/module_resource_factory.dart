// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:io';
import 'dart:typed_data';

import 'package:luna_core/utils/json_data_extractor.dart';
import 'package:luna_core/utils/logging.dart';
import 'package:path/path.dart' as p;

import '../models/module.dart';
import 'module_storage.dart';

/// An archive handler that provides methods to handle Luna files.
class ModuleResourceFactory {
  /// The name of the module.
  static String moduleName = '';

  /// The module storage instance.
  static ModuleStorage moduleStorage = ModuleStorage();

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
      Module module =
          await moduleStorage.createEmptyModuleFile(moduleName, jsonData);
      await _populateModuleDataWithInitialAssets(moduleName, jsonData);

      return module;
    });
  }

  /// Adds a module file with the given name and file data.
  static Future<bool> addModuleFile(
      String moduleName, Uint8List fileData) async {
    await cleanupModuleData(moduleName); // FIXME: Code - Remove this line

    return moduleStorage.importModuleFile(moduleName, fileData);
  }

  static Future<bool> _populateModuleDataWithInitialAssets(
      String moduleName, String jsonData) async {
    await moduleStorage.addFolderToModule(moduleName, _getImagePath());

    // ToDo: CSV generation should be in Authoring, not in the standard createmodule flow.
    //Uint8List? csvFileBytes = await _createInitialNewLanguageCSV(jsonData);

    //String csvFilePath = _getInitialCSVFilePath(jsonData);

    //await _updateOrAddAssetToArchive(moduleArchive, csvFilePath, csvFileBytes!);

    await moduleStorage.addFolderToModule(
        moduleName, _getInitialAudioDirectoryPath(jsonData));

    return true;
  }

  /// Gets the image with the given name from the stored module.
  static Future<Uint8List?> getImageBytes(String imageFileName) async {
    return moduleStorage.getAsset(
        moduleName, '${_getImagePath()}/$imageFileName');
  }

  /// Gets the audio with the given name and language locale from the stored module.
  static Future<Uint8List?> getAudioBytes(
      String moduleName, String audioFileName, String langLocale) async {
    return moduleStorage.getAsset(
        moduleName, '${_getAudioPath(langLocale)}/$audioFileName');
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

  /// Method to get the full path for an image file within a module
  String getImagePath(String moduleName, String imageFileName) {
    moduleName = moduleName.trim().replaceAll(" ", "_");
    return 'resources/images/$imageFileName';
  }

  /// Method to get the full path for an audio file within a module,
  /// considering language locale
  String getAudioPath(
      String moduleName, String audioFileName, String langLocale) {
    moduleName = moduleName.trim().replaceAll(" ", "_");
    return 'resources/$langLocale/audio/$audioFileName';
  }

  static String _getResourcePath() {
    return "resources";
  }

  static String _getImagePath() {
    return "${_getResourcePath()}/images";
  }

  static String _getLanguagePath(String language) {
    return "${_getResourcePath()}/$language";
  }

  static String _getAudioPath(String language) {
    return "${_getLanguagePath(language)}/audio";
  }

  /// get csv data from json string
  static Future<Uint8List?> createInitialNewLanguageCSV(String jsonData) async {
    JSONDataExtractor extractor = JSONDataExtractor();
    Uint8List? csvData =
        await extractor.extractTextDataFromJSONAsCSVBytes(jsonData);
    return csvData;
  }

  static String _getLanguageFromJSONData(String jsonData) {
    JSONDataExtractor extractor = JSONDataExtractor();
    String languageAsString = extractor.extractLanguageFromJSON(jsonData);
    return languageAsString;
  }

  /// get file path for csv file
  static String getInitialCSVFilePath(String jsonData) {
    String dataLanguage = _getLanguageFromJSONData(jsonData);
    return '${_getLanguagePath(dataLanguage)}/$dataLanguage.csv';
  }

  static String _getInitialAudioDirectoryPath(String jsonData) {
    String dataLanguage = _getLanguageFromJSONData(jsonData);
    return '${_getAudioPath(dataLanguage)}';
  }
}
