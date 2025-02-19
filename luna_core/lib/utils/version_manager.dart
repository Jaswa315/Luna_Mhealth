// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';


/// [VersionManager] provides access to get the version of the app.
///
/// Using [VersionManager] allows for getting access to the version of the app 
/// without having to repeatedly call package_info_plus utilities
///
/// Requirements:
///
/// await setVersion() must be called prior to fetching the version and after singleton initilization.
///
class VersionManager {
  static VersionManager _instance = VersionManager._internal();

  String _curVersion;
  static const String _emptyVersion = "-1";
  
  VersionManager._internal() : _curVersion = _emptyVersion;

  /// Returns a singleton instance of VersionManager 
  factory VersionManager() {
    return _instance;
  }

  /// Public getter to access `_curVersion`
  String get version {
    if (_curVersion == _emptyVersion){ 
      throw UnsupportedError("Current Version not Set, call setVersion to proceed");
    }
    
    return _curVersion;
  }

  /// Gets the current version of the app and sets the version of Version Manager
  /// Asynchronous due to package_info
  setVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _curVersion = packageInfo.version;
  }

  /// Method to set version for testing
  /// Overriding packageInfo is possible but annoying
  /// See https://github.com/fluttercommunity/plus_plugins/blob/main/packages/package_info_plus/package_info_plus/test/package_info_test.dart
  @visibleForTesting
  setTestVersion(String ver){
    _curVersion = ver;
  }

  /// Reset version. only should be used for testing
  @visibleForTesting
  resetVersion(){_curVersion = _emptyVersion;}

  /// Method to overide [VersionManager] instance
  static resetInstance(VersionManager newInstance) {
    _instance = newInstance;
  }

}
