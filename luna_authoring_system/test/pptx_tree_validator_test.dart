// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:luna_authoring_system/validator/data_tree_validator.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_tree.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GlobalConfiguration().loadFromAsset("app_settings");
  group('Data Tree Validator Test', () {
    test(
        'Given module and component bottom right coordinates, validate out of bounds component as false',
        () {
      DataTreeValidator dataTreeValidator = DataTreeValidator(PptxTree());
      double modulePageWidth = 500.0;
      double modulePageHeight = 500.0;
      double componentRightX = 480.0 + 100.0;
      double componentBottomY = 480.0 + 100.0;

      bool isValid = dataTreeValidator.isComponentInBounds(
          modulePageWidth, modulePageHeight, componentRightX, componentBottomY);

      expect(isValid, false);
    });

    test('A data tree with 0 width and 0 height assigned is invalid', () {
      DataTreeValidator dataTreeValidator = DataTreeValidator(PptxTree());
      bool isValid = dataTreeValidator.isDataTreeModuleDimensionsValid(0, 0);
      expect(isValid, false);
    });

    test('Empty validation hook with no implementation returns false and throws an error', () {
      DataTreeValidator dataTreeValidator = DataTreeValidator(PptxTree());

      expect(
          () => dataTreeValidator.validate(),
          throwsA(isA<Exception>().having((e) => e.toString(), 'message',
              contains("Validator is not implemented"))));
    });
  });
}
