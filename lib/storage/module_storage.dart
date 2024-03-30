// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/// ModuleStorage Library
/// Purpose: Module Storage class for module file handling.  Operates on an
/// IStorageProvider.  Handles unpacking, packing, and validation of modules

import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:luna_mhealth_mobile/models/module.dart';
import 'package:luna_mhealth_mobile/storage/istorage_provider.dart';

/// Handles packaging, asset retrieval, loading, and storage
/// for Module operations
///
/// This class provides CRUD and storage operations for Module archive packages.
/// Module loading, creating new modules, retrieving/adding/updating image/audio
/// assets, and removing modules is currently supported.  Storage provider type 
/// is handled by app_settings.json StorageProviderType key.  
///
/// ToDo: Add module validation and signing logic
///
/// Example usage:
///
/// ```dart
/// ModuleStorage moduleStorage;
/// Module module = await moduleStorage.addModule("ModuleName",
/// jsonModuleString);
/// Bool audioResult = await moduleStorage.addModuleAudio("ModuleName",
/// audioFileName, audioBytes);
/// Uint8List? audioBytes = await moduleStorage.getAudioBytes("ModuleName",
/// audioFileName);
/// ```
class ModuleStorage {
  IStorageProvider storageProvider;
  final String userPath;

  // CTOR.  Needs to handle userProfiles going forward.
  // TODO: Add a defualt profile to the parameters, uses userName currently
  ModuleStorage({IStorageProvider? provider, String userName = ""})
      : storageProvider = provider ??
            StorageProviderFactory.createProvider(
                GlobalConfiguration().getValue('StorageProviderType')),
        userPath = userName;

  Future<bool> updateModuleSchema(String moduleName, String jsonData) async {
    Archive? archive = await _getModuleArchive(moduleName);
    if (archive == null) {
      return false;
    }    

    if (await _updateOrAddAssetToArchive(
        archive, _getModuleJsonFileName(moduleName), utf8.encode(jsonData))) {
      return _saveArchiveToFileSystem(moduleName, archive);
    }
    return false;
  }

  /// Loads a Module object from a Module.luna archive package
  ///
  /// This method will lookup and extract the Module.json file from
  /// a Module.luna package and deserialize into a Module object.
  ///
  /// Parameters:
  /// - [moduleName]: The name of the module. Accessable from Module.name.
  /// Does not include file type suffix.
  ///
  /// Returns:
  /// - A Module object. Will return null if no such module exists or
  /// module package is corrupted.
  ///
  /// Usage:
  /// ```dart
  /// Module? module = await moduleStorage.loadModule("ModuleName");
  /// ```
  Future<Module?> loadModule(String moduleName) async {
    moduleName.trim().replaceAll(" ", "_");

    Uint8List? jsonData =
        await _extractAssetFromModule(moduleName, "$moduleName.json");

    String jsonString = utf8.decode(jsonData as List<int>);

    return Module.fromJson(jsonDecode(jsonString));
  }

  Future<List<Module?>> loadAllModules() async {
    List<Module> modules = [];
    List<Uint8List> modulesBytes = await storageProvider.getAllFiles(
        container: userPath, recursiveSearch: false);

    for (Uint8List moduleBytes in modulesBytes) {
      Archive? archive = await _getArchiveFromBytes(moduleBytes);

      if (archive != null) {
        // Grab only asset file
        for (final ArchiveFile file in archive) {
          if (file.isFile && file.name.contains(".json")) {
            String jsonModule =
                utf8.decode(Uint8List.fromList(file.content as List<int>));
            modules.add(Module.fromJson(jsonDecode(jsonModule)));
          }
        }
      }
    }
    return modules;
  }

  Future<Uint8List?> getImageBytes(
      String moduleName, String imageFileName) async {
    return _extractAssetFromModule(moduleName, "images/$imageFileName");
  }

  Future<Uint8List?> getAudioBytes(
      String moduleName, String audioFileName) async {
    return _extractAssetFromModule(moduleName, "audio/$audioFileName");
  }

  Future<Module> addModule(String moduleName, String jsonData) async {
    Module module = Module.fromJson(jsonDecode(jsonData));    
    String moduleFileName = _getModuleFileName(moduleName);
    String fullModulePath = _getModuleFileNameWithPath(moduleName);

    if (await storageProvider.isFileExists(fullModulePath)) {
      throw Exception("Module already exists: $moduleFileName");
    }

    Archive archive = Archive();

    _updateOrAddAssetToArchive(archive, _getModuleJsonFileName(moduleName), utf8.encode(jsonData));

    await _saveArchiveToFileSystem(moduleName, archive);

    return module;
  }

  
  Future<bool> addModuleImage(
      String moduleName, String imageFileName, Uint8List? imageBytes) async {
    Archive? archive = await _getModuleArchive(moduleName);

    if (archive == null) {
      return false;
    }
    String filePath = "images/$imageFileName";

    if (await _updateOrAddAssetToArchive(archive, filePath, imageBytes!)) {
      return _saveArchiveToFileSystem(moduleName, archive);
    }
    return false;
  }

  Future<bool> addModuleAudio(
      String moduleName, String audioFileName, Uint8List? audioBytes) async {
    Archive? archive = await _getModuleArchive(moduleName);

    if (archive == null) {
      return false;
    }
    String filePath = "audio/$audioFileName";

    if (await _updateOrAddAssetToArchive(archive, filePath, audioBytes!)) {
      return _saveArchiveToFileSystem(moduleName, archive);
    }
    return false;
  }

  Future<bool> removeModule(String moduleName) async {
    // delete tempFiles
    List<String> fileNames = await storageProvider.getAllFileNames(
        container: _getModuleTempFilePath(moduleName));
    for (String fileName in fileNames) {
      storageProvider.deleteFile(fileName);
    }

    // delete module.luna file
    return storageProvider.deleteFile(_getModuleFileNameWithPath(moduleName));
  }

  void clearAllTempFiles(String moduleName) async {
    moduleName.trim().replaceAll(" ", "_");
    String modulePath = _getModuleFileName(moduleName);

    List<String> imageFileNames = await storageProvider.getAllFileNames(
        container:
            "$modulePath/GlobalConfiguration().getValue('TempImageFolder')");
    List<String> audioFileNames = await storageProvider.getAllFileNames(
        container:
            "$modulePath/GlobalConfiguration().getValue('TempAudioFolder')");

    for (String fileName in (imageFileNames + audioFileNames)) {
      storageProvider.deleteFile(fileName);
    }
  }

  bool validateModule(String moduleName) {
    // ToDo: Hook up to future Validation Classes
    return true;
  }

  bool signModule(String moduleName) {
    // ToDo: Hook up to future Signing Classes
    return true;
  }

  Future<bool> _saveArchiveToFileSystem(
      String moduleName, Archive archive) async {
    return storageProvider.saveFile(_getModuleFileNameWithPath(moduleName),
        ZipEncoder().encode(archive) as Uint8List,
        createContainer: true);
  }

  Future<Uint8List?> _extractAssetFromModule(
      String moduleName, String assetFileName) async {
    Archive? archive = await _getModuleArchive(moduleName);

    if (archive != null) {
      // Grab only asset file
      for (final ArchiveFile file in archive) {
        if (file.isFile && file.name == assetFileName) {
          return file.content as Uint8List;
        }
      }
    }
    return null;
  }

  Future<Archive?> _getModuleArchive(String moduleName) async {
    String modulePath = _getModuleFileNameWithPath(moduleName);

    final zippedBytes = await storageProvider.loadFile(modulePath);
    if (zippedBytes == null) {
      return null;
    }

    return _getArchiveFromBytes(zippedBytes);
  }

  Future<Archive?> _getArchiveFromBytes(Uint8List zippedBytes) async {
    return ZipDecoder().decodeBytes(zippedBytes);
  }

  Future<bool> _updateOrAddAssetToArchive(
      Archive archive, String filePath, Uint8List fileData) async {
    bool fileExists = archive.any((file) => file.name == filePath);

    ArchiveFile tempFile = ArchiveFile(filePath, fileData.length, fileData);

    archive.addFile(tempFile);
    return true;
  }

  String _getModuleTempFilePath(String moduleName) {
    moduleName.trim().replaceAll(" ", "_");
    return userPath == '' ? "$moduleName" : '$userPath/$moduleName';
  }

  String _getModuleFileName(String moduleName) {
    moduleName.trim().replaceAll(" ", "_");
    return "$moduleName.luna";
  }

  String _getModuleFileNameWithPath(String moduleName) {
    return userPath == ''
        ? _getModuleFileName(moduleName)
        : '$userPath/${_getModuleFileName(moduleName)}';
  }

  String _getModuleJsonFileName(String moduleName) {
    return '${moduleName.trim().replaceAll(" ", "_")}.json';
    
  }
}
