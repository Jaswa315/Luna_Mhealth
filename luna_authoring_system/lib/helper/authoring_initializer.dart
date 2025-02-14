// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:luna_core/utils/logging.dart';
import 'package:luna_core/utils/version_manager.dart' as vm;
import 'package:path/path.dart' as p;

/// Class to provide helper methods to inialize the Luna authoring system
class AuthoringInitializer {

  static bool _initialized = false;

  /// Setup method for the Luna Authoring System
  /// Sets up singletons such as version manager and logmanager
  /// Initializes the app and loads configuration
  static initializeAuthoring() async{

    if (AuthoringInitializer._initialized){return;}
    WidgetsFlutterBinding.ensureInitialized();
    await GlobalConfiguration().loadFromAsset("app_settings");
    // initialize log manager
    await LogManager.createInstance();
    // initialize Version manager
    await vm.VersionManager().setVersion();
    _initialized = true;
  }


  /// [arguements] 
  /// [arguements] 0 is pptx filepath
  /// [arguements] 1 is module file name
  static processInputs(List<String> arguements) {

    // ignore: unnecessary_null_comparison
    if (arguements[0] == null || arguements[1] == null) {
      // Files are under Documents/ by default on Macos
      // On Windows, Files are generated under C:\Users\username\Documents.
      // ignore: avoid_print
      print(
        'Usage: flutter run --dart-define=pptxFilePath=<pptx_file_path> --dart-define=moduleName=<module_name>',
      );

      // Exit with code -1 to indicate an error
      exit(-1);
    }

    return _getPptxFile(arguements[0]);
  }

  static File _getPptxFile(String pptxFilePath){

    // validate file extension.
    final fileExtension = p.extension(pptxFilePath);
    final pptxFile = File(pptxFilePath);

    if (fileExtension.toLowerCase() != '.pptx') {
      throw ArgumentError(
        'Invalid file extension: $fileExtension. Only .pptx files are allowed.',
      );
    }

    if (!pptxFile.existsSync()){
      throw ArgumentError(
        'PPTX file at $pptxFilePath does not exists.',
      );
    }

    return pptxFile;
  }

}