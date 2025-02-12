// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:luna_core/utils/logging.dart';
import 'package:luna_core/utils/version_manager.dart' as vm;

/// Class to provide helper methods to inialize the Luna authoring system
class AuthoringInitializer {

  static bool _initialized = false;

  /// Setup method for the Luna Authoring System
  /// Sets up singletons such as version manager and logmanager
  /// Initializes the app and loads configuration
  static initializeAuthoring() async{

    if (AuthoringInitializer._initialized){throw Exception('Authoring System already initialized.');}
    WidgetsFlutterBinding.ensureInitialized();
    await GlobalConfiguration().loadFromAsset("app_settings");
    // initialize log manager
    await LogManager.createInstance();
    // initialize Version manager
    await vm.VersionManager().setVersion();
    _initialized = true;
  }

}