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
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:luna_mhealth_mobile/core/constants/constants.dart';
import 'package:luna_mhealth_mobile/models/module.dart';
import 'package:luna_mhealth_mobile/storage/istorage_provider.dart';
import 'package:luna_mhealth_mobile/utils/logging.dart';

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
  IStorageProvider _storageProvider;
  final String _userPath;

  /// Creates a new instance of the `ModuleStorage` class.
  ///
  /// Parameters:
  /// - `provider`: An optional `IStorageProvider` implementation. If not provided,
  /// it will create a default storage provider based on the configuration set in the
  /// `app_settings.json` file under the key `StorageProviderType`.
  /// - `userName`: An optional string representing the user's path for storing modules.
  ///
  /// Example:
  /// ```dart
  /// ModuleStorage({IStorageProvider? provider, String userName = ""})
  ///   : storageProvider = provider ?? StorageProviderFactory.createProvider(GlobalConfiguration().getValue('StorageProviderType')),
  ///     userPath = userName;
  /// ```
  ModuleStorage({IStorageProvider? provider, String userName = ""})
      : _storageProvider = provider ??
            StorageProviderFactory.createProvider(
                GlobalConfiguration().getValue('StorageProviderType')),
        _userPath = userName;

  /// Updates the Module.json file in a Module.luna archive package
  Future<bool> updateModuleSchema(String moduleName, String jsonData) async {
    Archive? archive = await _getModuleArchive(moduleName);
    return await LogManager().logFunction('ModuleStorage.updateModuleSchema',
        () async {
      if (archive == null) {
        return false;
      }

      if (await _updateOrAddAssetToArchive(
          archive, _getModuleJsonFileName(moduleName), utf8.encode(jsonData))) {
        return _saveArchiveToFileSystem(moduleName, archive);
      }
      return false;
    });
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
    return await LogManager().logFunction('ModuleStorage.loadModule', () async {
      moduleName.trim().replaceAll(" ", "_");

      Uint8List? jsonData =
          await _extractAssetFromModule(moduleName, "$moduleName.json");

      String jsonString = utf8.decode(jsonData as List<int>);

      return Module.fromJson(jsonDecode(jsonString));
    });
  }

  /// Loads all modules stored in the user's path.
  ///
  /// This method retrieves and loads all modules stored in the user's path. It iterates through the files within the user's path, extracts the module JSON data from each module archive, and deserializes it into `Module` objects.
  ///
  /// Returns:
  /// - A list of `Module` objects representing all the modules stored in the user's path. If no modules are found or an error occurs during the process, an empty list is returned.
  ///
  /// Example:
  /// ```dart
  /// List<Module?> modules = await ModuleStorage().loadAllModules();
  /// ```
  Future<List<Module?>> loadAllModules() async {
    return await LogManager().logFunction('ModuleStorage.loadAllModules',
        () async {
      List<Module> modules = [];
      List<Uint8List> modulesBytes = await _storageProvider.getAllFiles(
          container: _userPath, recursiveSearch: false);

      for (Uint8List moduleBytes in modulesBytes) {
        Archive? archive = await _getArchiveFromBytes(moduleBytes);

        if (archive != null) {
          for (final ArchiveFile file in archive) {
            if (file.isFile &&
                !file.name.startsWith(AppConstants.macosSystemFilePrefix) &&
                file.name.endsWith(".json") &&
                file.content.isNotEmpty) {
              String jsonModule = utf8.decode(file.content as List<int>);
              modules.add(Module.fromJson(jsonDecode(jsonModule)));
            }
          }
        }
      }
      return modules;
    });
  }

  /// Retrieves an image asset from a Module.luna archive package
  Future<Uint8List?> getImageBytes(
      String moduleName, String imageFileName) async {
    return await LogManager().logFunction('ModuleStorage.getImageBytes',
        () async {
      return _extractAssetFromModule(
          moduleName, "$moduleName/images/$imageFileName");
    });
  }

  /// Retrieves an audio asset from a Module.luna archive package
  Future<Uint8List?> getAudioBytes(
      String moduleName, String audioFileName) async {
    return await LogManager().logFunction('ModuleStorage.getAudioBytes',
        () async {
      return _extractAssetFromModule(moduleName, "audio/$audioFileName");
    });
  }

  /// Adds a new Module to the storage provider
  Future<Module> addModule(String moduleName, String jsonData) async {
    return await LogManager().logFunction('ModuleStorage.addModule', () async {
      Module module = Module.fromJson(jsonDecode(jsonData));
      String moduleFileName = _getModuleFileName(moduleName);
      String fullModulePath = _getModuleFileNameWithPath(moduleName);

      if (await _storageProvider.isFileExists(fullModulePath)) {
        throw Exception("Module already exists: $moduleFileName");
      }

      Archive archive = Archive();

      _updateOrAddAssetToArchive(
          archive, _getModuleJsonFileName(moduleName), utf8.encode(jsonData));

      await _saveArchiveToFileSystem(moduleName, archive);

      return module;
    });
  }

  /// Adds a new Module file to the storage provider
  Future<bool> addModuleFile(String moduleName, Uint8List fileData) async {
    return await LogManager().logFunction('ModuleStorage.addModuleFile',
        () async {
      String moduleFileName = _getModuleFileName(moduleName);
      String fullModulePath = _getModuleFileNameWithPath(moduleName);

      if (await _storageProvider.isFileExists(fullModulePath)) {
        throw Exception("Module already exists: $moduleFileName");
      }

      return _storageProvider.saveFile(fullModulePath, fileData,
          createContainer: true);
    });
  }

  /// Adds an image asset to a Module.luna archive package
  Future<bool> addModuleImage(
      String moduleName, String imageFileName, Uint8List? imageBytes) async {
    return await LogManager().logFunction('ModuleStorage.addModuleImage',
        () async {
      Archive? archive = await _getModuleArchive(moduleName);

      if (archive == null) {
        return false;
      }
      String filePath = "$moduleName/images/$imageFileName";

      if (await _updateOrAddAssetToArchive(archive, filePath, imageBytes!)) {
        return _saveArchiveToFileSystem(moduleName, archive);
      }
      return false;
    });
  }

  /// Adds an audio asset to a Module.luna archive package
  Future<bool> addModuleAudio(
      String moduleName, String audioFileName, Uint8List? audioBytes) async {
    return await LogManager().logFunction('ModuleStorage.addModuleAudio',
        () async {
      Archive? archive = await _getModuleArchive(moduleName);

      if (archive == null) {
        return false;
      }
      String filePath = "audio/$audioFileName";

      if (await _updateOrAddAssetToArchive(archive, filePath, audioBytes!)) {
        return _saveArchiveToFileSystem(moduleName, archive);
      }
      return false;
    });
  }

  /// Removes a Module from the storage provider
  Future<bool> removeModule(String moduleName) async {
    return await LogManager().logFunction('ModuleStorage.removeModule',
        () async {
      // delete tempFiles
      List<String> fileNames = await _storageProvider.getAllFileNames(
          container: _getModuleTempFilePath(moduleName));
      for (String fileName in fileNames) {
        _storageProvider.deleteFile(fileName);
      }

      // delete module.luna file
      return _storageProvider
          .deleteFile(_getModuleFileNameWithPath(moduleName));
    });
  }

  /// Clears all temporary files associated with a specific module.
  ///
  /// The [moduleName] parameter specifies the name of the module.
  /// This method removes all temporary image and audio files associated with the module.
  /// The image and audio files are stored in containers specified by the 'TempImageFolder'
  /// and 'TempAudioFolder' values from the global configuration.
  ///
  /// Throws an exception if there is an error while deleting the files.
  Future<void> clearAllTempFiles(String moduleName) async {
    return LogManager().logFunction('ModuleStorage.clearAllTempFiles',
        () async {
      moduleName.trim().replaceAll(" ", "_");
      String modulePath = _getModuleFileName(moduleName);

      List<String> imageFileNames = await _storageProvider.getAllFileNames(
          container:
              "$modulePath/GlobalConfiguration().getValue('TempImageFolder')");
      List<String> audioFileNames = await _storageProvider.getAllFileNames(
          container:
              "$modulePath/GlobalConfiguration().getValue('TempAudioFolder')");

      for (String fileName in (imageFileNames + audioFileNames)) {
        _storageProvider.deleteFile(fileName);
      }
    });
  }

  /// Validates a Module package
  bool validateModule(String moduleName) {
    // ToDo: Hook up to future Validation Classes
    return true;
  }

  /// Signs a Module package
  bool signModule(String moduleName) {
    // ToDo: Hook up to future Signing Classes
    return true;
  }

  Future<bool> _saveArchiveToFileSystem(
      String moduleName, Archive archive) async {
    return _storageProvider.saveFile(_getModuleFileNameWithPath(moduleName),
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

    final zippedBytes = await _storageProvider.loadFile(modulePath);
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
    ArchiveFile tempFile = ArchiveFile(filePath, fileData.length, fileData);
    archive.addFile(tempFile);
    return true;
  }

  String _getModuleTempFilePath(String moduleName) {
    moduleName.trim().replaceAll(" ", "_");
    return _userPath == '' ? "$moduleName" : '$_userPath/$moduleName';
  }

  String _getModuleFileName(String moduleName) {
    moduleName.trim().replaceAll(" ", "_");
    return "$moduleName.luna";
  }

  String _getModuleFileNameWithPath(String moduleName) {
    return _userPath == ''
        ? _getModuleFileName(moduleName)
        : '$_userPath/${_getModuleFileName(moduleName)}';
  }

  String _getModuleJsonFileName(String moduleName) {
    return '${moduleName.trim().replaceAll(" ", "_")}.json';
  }
}
