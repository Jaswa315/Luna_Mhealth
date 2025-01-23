import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/validator/interface/i_data_tree_validator.dart';
import 'package:luna_authoring_system/validator/data_tree_module_title_validator.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/validator/exception/authoring_system_data_tree_validation_exception.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Data Tree Validator Tests', () {
    test('Data Tree Module Title cannot be empty', () {
      PptxTree pptxTree =
          PptxTree();
      pptxTree.title = "";
      IDataTreeValidator validator = DataTreeModuleTitleValidator(pptxTree);

      expect(() => validator.validate(),
          throwsA(isA<AuthoringSystemDataTreeValidationException>()));
    });
  });
}
