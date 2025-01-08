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

    test('width can be updated with EMU value', () async {
      PptxTree pptxTree = PptxTree();
      int width = 1;

      pptxTree = pptxTree
          .rebuild((b) => b..width = EMU((b) => b..value = width).toBuilder());

      expect(pptxTree.width?.value, width);
    });

    test('height can be updated with EMU value', () async {
      PptxTree pptxTree = PptxTree();
      int height = 1;

      pptxTree = pptxTree.rebuild(
          (b) => b..height = EMU((b) => b..value = height).toBuilder());

      expect(pptxTree.height?.value, height);
    });
  });
}
