// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:luna_core/utils/versioning.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {

  group('VersionManager Tests', () {

    test('VersionManager - Test Singleton', () {
      VersionManager manager1 = VersionManager();
      VersionManager manager2 = VersionManager();

      expect(identical(manager1, manager2));

    });

    test('VersionManager - Test Version Equivalence', () async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      VersionManager manager = VersionManager();

      expect(packageInfo.version == manager.version);

    });


  });

}