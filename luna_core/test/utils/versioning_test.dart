// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:luna_core/utils/version_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {

  TestWidgetsFlutterBinding.ensureInitialized();  
  //platform channels are not available in unit tests
  //taken from package_info_plus github (https://github.com/fluttercommunity/plus_plugins/blob/main/packages/package_info_plus/package_info_plus/test/package_info_test.dart)
  const channel = MethodChannel('dev.fluttercommunity.plus/package_info');
  final log = <MethodCall>[];

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    channel,
    (MethodCall methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'getAll':
          return <String, dynamic>{
            'appName': 'Luna',
            'buildNumber': '1',
            'packageName': 'luna.core',
            'version': '1.0',
            'installerStore': null,
          };
        default:
          assert(false);
          return null;
      }
    },
  );

  tearDown(() {
    log.clear();
  });

  group('VersionManager Tests', () {

    test('VersionManager - Test Singleton', () {
      VersionManager manager1 = VersionManager();
      VersionManager manager2 = VersionManager();

      expect(identical(manager1, manager2), true);

    });

    test('VersionManager - Test Version Equivalence', () async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      VersionManager manager = VersionManager();
      manager.resetVersion();
      await manager.setVersion();
      expect((packageInfo.version == manager.version), true);

    });

    test('VersionManager - Version fails if setVersion not called', () async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      VersionManager manager = VersionManager();
      manager.resetVersion();
      expect(() => manager.version, throwsA(isA<UnsupportedError>()));

    });


  });

}