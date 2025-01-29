import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/interfaces/validator.dart';
import 'package:luna_authoring_system/validator/pptx_title_validator.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/validator/exception/authoring_system_data_tree_validation_exception.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Pptx Tree Validator Tests', () {
    test('Pptx Tree Module Title cannot be empty', () {
      PptxTree pptxTree =
          PptxTree();
      pptxTree.title = "";
      IValidator validator = PptxTitleValidator(pptxTree);

      expect(() => validator.validate(),
          throwsA(isA<AuthoringSystemDataTreeValidationException>()));
    });
  });
}
