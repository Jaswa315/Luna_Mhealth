// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:luna_mhealth_mobile/core/constants/constants.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/click_state.dart';
import '../models/module.dart';

/// A provider class that manages the state of a click event.
class ClickStateProvider with ChangeNotifier {
  ClickState _clickState = ClickState();

  /// Returns the current click state.
  ClickState get clickState => _clickState;

  // A flag to keep track of whether the modules are loaded.
  bool _modulesLoaded = false;
  // A list to store the loaded modules.
  List<Module> _loadedModules = [];

  /// Getter for modulesLoaded.
  bool get modulesLoaded => _modulesLoaded;

  /// Getter for loadedModules.
  List<Module> get loadedModules => _loadedModules;

  /// Method to load modules.
  Future<void> loadModules() async {
    print('Loading modules...');
    // Example logic to fetch modules
    try {
      List<Module> modules =
          await _fetchModules(); // Fetch modules with actual logic

      if (modules.isNotEmpty) {
        //_loadedModules.clear();
        _loadedModules.addAll(modules);
        _modulesLoaded = true;
        notifyListeners(); // Notify listeners to rebuild Consumer widgets
      }

      print('Modules loaded. Total modules: ${_loadedModules.length}');
    } catch (e) {
      // Handle exceptions by logging or displaying a message
      print('Failed to load modules: $e');
    }
  }

  /// Placeholder function that simulates fetching modules
  Future<List<Module>> _fetchModules() async {
    // Return a list of modules
    return _selectAndExtractZip().then((module) {
      return [module];
    });
  }

  /// Method to handle a click event.
  Future<Module> _selectAndExtractZip() async {
    try {
      // Use FilePicker to select the zip file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (result != null) {
        print(
            'All picked files: ${result.files.map((f) => f.name).join(', ')}');
        print('Selected file: ${result.files.single.name}');
        File zipFile = File(result.files.single.path!);
        // Extract the zip file
        return await _extractZip(zipFile);
      } else {
        // User canceled the picker
        print('No file selected.');
        throw Exception('No file selected');
      }
    } catch (e, stacktrace) {
      print('Error selecting file: $e');
      print('StackTrace: $stacktrace');
      throw Exception('Error selecting file');
    }
  }

  Future<Module> _extractZip(File zipFile) async {
    final String moduleBasePath = p.basenameWithoutExtension(zipFile.path);
    print('Extracting zip file: ${zipFile.path} to $moduleBasePath');
    // Read the zip file
    final bytes = zipFile.readAsBytesSync();
    // Decode the zip file
    final archive = ZipDecoder().decodeBytes(bytes);

    // Get the temporary directory
    final directory = await getTemporaryDirectory();

    // Extract the contents of the zip archive to the temporary directory
    for (final file in archive) {
      final String filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File('${directory.path}/$filename')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory('${directory.path}/$filename').create(recursive: true);
      }
    }
    print(
        'Extraction completed. Loading module...${'${directory.path}/$moduleBasePath'}');

    // Load the module from the extracted files
    return _loadModuleFromExtractedFiles('${directory.path}/$moduleBasePath');
  }

  Future<Module> _loadModuleFromExtractedFiles(String directoryPath) async {
    try {
      final file = File('$directoryPath/${AppConstants.lunaIRModuleName}');
      print('Loading module from extracted files: ${file.path}');
      final String content = await file.readAsString();
      print('Module content: $content');
      final Map<String, dynamic> jsonData = jsonDecode(content);
      print('JSON data: $jsonData');

      Module module = Module.fromJson(jsonData, directoryPath);
      print('Module loaded: ${module.title}');

      return module;
    } catch (e, stacktrace) {
      print('Error loading module from extracted files: $e');
      print('StackTrace: $stacktrace');
      throw Exception('Error loading module from extracted files');
    }
  }
}
