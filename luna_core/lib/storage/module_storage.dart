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
import 'package:luna_core/models/module.dart';
import 'package:luna_core/storage/istorage_provider.dart';

import 'package:luna_core/utils/logging.dart';
import 'package:luna_mobile/core/constants/constants.dart';

// ToDo: Refactor module storage to clean up redundancy/perf

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

      Uint8List? jsonData = await getJSONDataBytes(moduleName);

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
  Future<List<Module>> loadAllModules() async {
    return await LogManager().logFunction('ModuleStorage.loadAllModules',
        () async {
      List<Module> modules = [];
      List<Uint8List> modulesBytes = await _storageProvider.getAllFiles(
          container: _userPath, recursiveSearch: false);

      for (Uint8List moduleBytes in modulesBytes) {
        if (_isZipFile(moduleBytes)) {
          Archive? archive = await _getArchiveFromBytes(moduleBytes);

          if (archive != null) {
            for (final ArchiveFile file in archive) {
              Module? module = _processArchiveFile(file);
              if (module != null) {
                modules.add(module);
              }
            }
          }
        }
      }
      return modules;
    });
  }

  /// Retrieves JSON data of given moduleName from the Module.luna archive package
  Future<Uint8List?> getJSONDataBytes(String moduleName) async {
    return await LogManager().logFunction('ModuleStorage.getJSONDataBytes',
        () async {
      return _extractAssetFromModule(moduleName, "data/$moduleName.json");
    });
  }

  /// Retrieves an image asset from a Module.luna archive package
  Future<Uint8List?> getImageBytes(
      String moduleName, String imageFileName) async {
    return await LogManager().logFunction('ModuleStorage.getImageBytes',
        () async {
      return _extractAssetFromModule(
          moduleName, "resources/images/$imageFileName");
    });
  }

  /// Retrieves an audio asset from a Module.luna archive package
  Future<Uint8List?> getAudioBytes(
      String moduleName, String audioFileName) async {
    return await LogManager().logFunction('ModuleStorage.getAudioBytes',
        () async {
      return _extractAssetFromModule(
          moduleName, "resources/audio/$audioFileName");
    });
  }

  /// Adds a new Module to the storage provider
  Future<Module> createEmptyModuleFile(
      String moduleName, String jsonData) async {
    return await LogManager().logFunction('ModuleStorage.addModule', () async {
      Module module = Module.fromJson(jsonDecode(jsonData));
      String moduleFileName = _getModuleFileName(moduleName);
      String fullModulePath = _getModuleFileNameWithPath(moduleName);

      if (await _storageProvider.isFileExists(fullModulePath)) {
        LogManager().logTrace(
          "Module '$moduleFileName' already exists and will be overwritten",
          LunaSeverityLevel.Warning,
        );
      }

      Archive moduleArchive = Archive();

      await _updateOrAddAssetToArchive(moduleArchive,
          "data/${_getModuleJsonFileName(moduleName)}", utf8.encode(jsonData));

      await _saveArchiveToFileSystem(moduleName, moduleArchive);
      return module;
    });
  }

  /// Adds a new Module file to the storage provider
  /// archiveFileData: the moduleName.luna file to transfer to the default
  /// module store location from the storage provider
  /// ToDo: Simplify this with previously existing helpers
  Future<bool> importModuleFile(
      String moduleName, Uint8List archiveFileData) async {
    return await LogManager().logFunction(
      'ModuleStorage.addModuleFile',
      () async {
        String moduleFileName = _getModuleFileName(moduleName);
        String fullModulePath = _getModuleFileNameWithPath(moduleName);

        if (await _storageProvider.isFileExists(fullModulePath)) {
          LogManager().logTrace(
            "Module '$moduleFileName' already exists and will be overwritten",
            LunaSeverityLevel.Warning,
          );
        }

        return _storageProvider.saveFile(fullModulePath, archiveFileData,
            createContainer: true);
      },
    );
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

  /// add directory path to module
  Future<bool> addFolderToModule(
      String moduleName, String directoryPath) async {
    if (!directoryPath.endsWith('/')) {
      directoryPath += '/';
    }

    Archive? archive = await _getModuleArchive(moduleName);

    ArchiveFile emptyDirectory = ArchiveFile(directoryPath, 0, Uint8List(0))
      ..isFile = false
      ..compress = false;

    archive?.addFile(emptyDirectory);

    return true;
  }

  /// Adds a generic asset to a Module.luna archive package.
  ///
  /// This method is used to add any type of asset (image, audio) to a module
  /// by adding the asset file to the module's archive.
  ///
  /// Parameters:
  /// - [moduleName]: The name of the module to which the asset should be added.
  /// - [assetFileName]: The file path of the asset within the module's directory structure.
  /// - [assetBytes]: The byte data of the asset file.
  ///
  /// Returns:
  /// - true if the asset was successfully added to the module,
  ///   or false if failed.
  Future<bool> addModuleAsset(
      String moduleName, String assetFileName, Uint8List? assetBytes) async {
    return await LogManager().logFunction('ModuleStorage.addModuleAsset',
        () async {
      if (assetBytes == null) {
        return false;
      }
      Archive? archive = await _getModuleArchive(moduleName);

      if (archive == null) {
        return false;
      }

      if (await _updateOrAddAssetToArchive(
          archive, assetFileName, assetBytes)) {
        return _saveArchiveToFileSystem(moduleName, archive);
      }
      return false;
    });
  }

  /// Adds a generic asset batch to a Module.luna archive package.
  ///
  /// This method is used to add any type of assets (image, audio) to a module
  /// by adding the asset file to the module's archive in batch format.
  ///
  /// Parameters:
  /// - [moduleName]: The name of the module to which the asset should be added.
  /// - [filesPathBytesMap]: The path and data pairs of the assets within the module's directory structure.
  ///
  /// Returns:
  /// - true if the asset was successfully added to the module,
  ///   or false if failed.
  Future<bool> addModuleAssets(
      String moduleName, Map<String, Uint8List?> filesPathBytesMap) async {
    return await LogManager().logFunction('ModuleStorage.addModuleAssets',
        () async {
      if (filesPathBytesMap.isEmpty) {
        return false;
      }
      Archive? archive = await _getModuleArchive(moduleName);

      if (archive == null) {
        return false;
      }

      filesPathBytesMap.forEach((key, value) async {
        await _updateOrAddAssetToArchive(archive, key, value!);
      });

      return _saveArchiveToFileSystem(moduleName, archive);
    });
  }

  /// public wrapper method getAsset
  Future<Uint8List?> getAsset(String moduleName, String assetFileName) {
    return _extractAssetFromModule(moduleName, assetFileName);
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
    final inputStream = InputStream(zippedBytes);
    return ZipDecoder().decodeBuffer(inputStream, verify: true);
  }

  Future<bool> _updateOrAddAssetToArchive(
      Archive archive, String filePath, Uint8List fileData) async {
    ArchiveFile tempFile = ArchiveFile(filePath, fileData.length, fileData);
    archive.addFile(tempFile);
    return true;
  }

  Module? _processArchiveFile(ArchiveFile file) {
    bool isFile = file.isFile;
    bool isNotMacosSystemFile =
        !file.name.startsWith(AppConstants.macosSystemFilePrefix);
    bool isJsonFile = file.name.endsWith(".json");
    bool isContentNotEmpty = file.content.isNotEmpty;

    if (isFile && isNotMacosSystemFile && isJsonFile && isContentNotEmpty) {
      String jsonModule = utf8.decode(file.content as List<int>);

      return Module.fromJson(jsonDecode(jsonModule));
    }

    return null;
  }

  bool _isZipFile(Uint8List bytes) {
    const zipSignature = [0x50, 0x4B, 0x03, 0x04];
    if (bytes.length < 4) {
      return false;
    }
    for (int i = 0; i < 4; i++) {
      if (bytes[i] != zipSignature[i]) {
        return false;
      }
    }
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
