// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/// ModuleStorage
/// Purpose: Module Storage class for module file handling.  Operates on an
/// IStorageProvider.  Handles unpacking, packing, and validation of modules

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:luna_mhealth_mobile/models/module.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:luna_mhealth_mobile/models/page.dart';
import 'package:luna_mhealth_mobile/storage/istorage_provider.dart';

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

  Future<bool> saveModule(Module module) async {
    bool retval = false;

    String jsonContent = module.toString();
    String moduleName = module.name;
    moduleName.trim().replaceAll(" ", "_");
    String path =
        userPath == '' ? "$moduleName.luna" : '$userPath/$moduleName.luna';

    try {
      // Module JSON
      Archive archive = Archive();
      archive.addFile(ArchiveFile(
          '$moduleName.json', jsonContent.length, utf8.encode(jsonContent)));

      // Audio Logic      
      await AddFilesToArchive(moduleName, archive, "TempAudioFolder", "audio");
      // Image Logic
      await AddFilesToArchive(moduleName, archive, "TempImagesFolder", "images");

      // Compression
      List<int>? zippedModule = ZipEncoder().encode(archive);
      if (zippedModule != null) {
        await storageProvider.saveFile(path, Uint8List.fromList(zippedModule),
            createContainer: true);
        return true;
      }
    } catch (e) {
      // TODO: Get rid of this and add real logging code
      print('Error saving module: $moduleName. Exception: $e.');
    }
    return retval;
  }

  Future<void> AddFilesToArchive(String moduleName, Archive archive, String configLocation, String rootPath) async {
    List<String> imageFileNames = await storageProvider.getAllFileNames(
        container:
            "$GlobalConfiguration().getValue('$configLocation')$moduleName/");
    for (String fileName in imageFileNames) {
      Uint8List? imageData = await storageProvider.loadFile(fileName);
      if (imageData != null) {
        archive.addFile(ArchiveFile("$rootPath/${fileName.split('/').last}",
            imageData.length, imageData));
      } else {        
        print('Error saving image: $moduleName, $fileName.');
        throw FileSystemException('Error saving image for $moduleName', fileName);
      }        
    }
  }

  void ClearAllTempFiles() async {
    List<String> imageFileNames = await storageProvider.getAllFileNames(
        container: GlobalConfiguration().getValue("TempImageFolder"));
    List<String> audioFileNames = await storageProvider.getAllFileNames(
        container: GlobalConfiguration().getValue("TempAudioFolder"));

    for (String fileName in (imageFileNames + audioFileNames)) {
      storageProvider.deleteFile(fileName);
    }
  }

  Future<Module?> loadModule(String moduleName) async {
    Module? retModule;
    moduleName.trim().replaceAll(" ", "_");

    String path =
        userPath == '' ? "$moduleName.luna" : '$userPath/$moduleName.luna';
    try {
      final zippedBytes = await storageProvider.loadFile(path);
      if (zippedBytes == null) {
        return null;
      }

      Archive unZippedArchive = ZipDecoder().decodeBytes(zippedBytes);

      for (final ArchiveFile file in unZippedArchive) {
        if (file.isFile) {
          final List<int> data = file.content as List<int>;
          if (file.name == '$moduleName.json') {
            retModule = Module.fromJson(jsonDecode(utf8.decode(data)));
          }
          await LoadModuleAssetIntoTempDir(file, moduleName, data, "TempAudioFolder", "audio");
          await LoadModuleAssetIntoTempDir(file, moduleName, data, "TempImagesFolder", "images");
        }
      }
    } catch (e) {
      // TODO: Get rid of this and add real logging code
      print('Error loading module: $moduleName. Exception: $e.');
    }
    return retModule;
  }

  Future<void> LoadModuleAssetIntoTempDir(ArchiveFile file, String moduleName, List<int> data, String tempConfigLocation, String folderName) async {
    if (file.name.startsWith('folderName/')) {
      final fileName = file.name.replaceAll('$folderName/$moduleName/', '');
      final aseetFileName =
          GlobalConfiguration().getValue("$tempConfigLocation") + fileName;
      await storageProvider.saveFile(
          aseetFileName, Uint8List.fromList(data),
          createContainer: true);
    }
  }
}