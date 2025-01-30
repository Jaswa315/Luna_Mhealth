import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_authoring_system/validator/pptx_title_validator.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_core/validator/validator_error_type.dart';
import 'package:luna_core/validator/validator_error.dart';
import 'package:luna_core/luna_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Pptx Title cannot be empty', () {
    PptxTree pptxTree = PptxTree();
    pptxTree.title = "";
    IValidator validator = PptxTitleValidator(pptxTree);

    Set<ValidatorError> errors = validator.validate();

    expect(errors.length, 1);
    expect(errors.first.errorType, ValidatorErrorType.pptxTitleHasNoVisibleCharacters);
  });

  test('Pptx Title must have visible characters', () {
    PptxTree pptxTree = PptxTree();
    pptxTree.title = "  ";
    IValidator validator = PptxTitleValidator(pptxTree);

    Set<ValidatorError> errors = validator.validate();

    expect(errors.length, 1);
    expect(errors.first.errorType, ValidatorErrorType.pptxTitleHasNoVisibleCharacters);
  });

    test('Pptx Title cannot be too long', () {
    PptxTree pptxTree = PptxTree();
    // build a string one more character larger than the maximum title length allowed
    pptxTree.title  = 'a' * (LunaConstants.maximumPptxTitleLength + 1); 
    IValidator validator = PptxTitleValidator(pptxTree);

    Set<ValidatorError> errors = validator.validate();

    expect(errors.length, 1);
    expect(errors.first.errorType, ValidatorErrorType.pptxTitleIsTooLong);
  });

  test('Pptx Title is just short enough', () {
    PptxTree pptxTree = PptxTree();
    pptxTree.title  = 'a' * (LunaConstants.maximumPptxTitleLength); 
    IValidator validator = PptxTitleValidator(pptxTree);

    Set<ValidatorError> errors = validator.validate();

    expect(errors.isEmpty, true);
  });
}
