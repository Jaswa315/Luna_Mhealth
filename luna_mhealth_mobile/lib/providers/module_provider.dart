// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:luna_mhealth_mobile/core/services/file_management_service.dart';
import 'package:luna_mhealth_mobile/core/services/module_handler_service.dart';

import '../models/module.dart';

/// A provider class that manages the state and functionality of a module.
///
/// This class extends the [ChangeNotifier] class, allowing it to notify
/// listeners when its state changes.
class ModuleProvider with ChangeNotifier {
  bool _areModulesLoaded = false;
  List<Module> _modules = [];

  /// Getter for areModulesLoaded.
  bool get areModulesLoaded => _areModulesLoaded;

  /// Getter for moduleList.
  List<Module> get moduleList => _modules;

  final FileManagementService _fileManagementService = FileManagementService();

  /// Method to retrieve and load modules.
  Future<void> loadAvailableModules() async {
    try {
      _handleModules(await ModuleHandler.getModules());
    } catch (e) {
      _handleModules([]);
    }
  }

  /// Method to fetch and initialize modules.
  Future<void> selectAndStoreModuleFile() async {
    try {
      File selectedFile = await _fileManagementService.pickAndStoreFile();
      await ModuleHandler.saveModuleFileToStorage(selectedFile);
      await loadAvailableModules();
    } catch (e) {
      // Handle the error here
      print('Error occurred while selecting and storing module file: $e');
    }
  }

  void _handleModules(List<Module> modules) {
    if (modules.isNotEmpty) {
      _modules = modules;
      _areModulesLoaded = true;
      notifyListeners();
    }
  }
}
