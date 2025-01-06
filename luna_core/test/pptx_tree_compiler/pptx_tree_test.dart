// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/utils/logging.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:luna_core/luna_data_model_compiler/pptx_tree_compiler/pptx_tree.dart';
import 'package:luna_core/utils/emu.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await GlobalConfiguration().loadFromAsset("app_settings");
    await LogManager.createInstance();
  });

  group('Tests for PptxTree', () {
    test('width is initialized with null value', () async {
      PptxTree pptxTree = PptxTree();

      expect(pptxTree.width, null);
    });

    test('height is initialized with null value', () async {
      PptxTree pptxTree = PptxTree();

      expect(pptxTree.height, null);
    });

    test('PptxTree is initialized with null values', () async {
      PptxTree pptxTree = PptxTree();

      expect(pptxTree.width, null);
      expect(pptxTree.height, null);
    });
  });

  group('Tests for EMU', () {
    test('Argument error is thrown when input is negative', () async {
      expect(() => EMU((b) => b..value = -1), throwsA(isArgumentError));
    });

    test('Value can be initialized with zero', () async {
      EMU emu = EMU((b) => b..value = 0);

      expect(emu.value, 0);
    });

    test('Value can be initialized with positive integer', () async {
      EMU emu = EMU((b) => b..value = 1);

      expect(emu.value, 1);
    });
  });
}
