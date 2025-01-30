import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_authoring_system/validator/pptx_dimensions_validator.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_core/validator/validator_error_type.dart';
import 'package:luna_core/validator/validator_error.dart';
import 'package:luna_core/utils/emu.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Validation error if pptx width is null', () {
    PptxTree pptxTree = PptxTree();

    IValidator validator = PptxDimensionsValidator(pptxTree);

    Set<ValidatorError> errors = validator.validate();

    expect(errors.length, 1);
    expect(errors.first.errorType, ValidatorErrorType.pptxWidthAndHeightMustBothBeInitialized);
  });

  test('Validation error if pptx height is null', () {
    PptxTree pptxTree = PptxTree();

    IValidator validator = PptxDimensionsValidator(pptxTree);

    Set<ValidatorError> errors = validator.validate();

    expect(errors.length, 1);
    expect(errors.first.errorType, ValidatorErrorType.pptxWidthAndHeightMustBothBeInitialized);
  });
  
  test('Works if pptx width and height are positive', () {
    PptxTree pptxTree = PptxTree();
    pptxTree.width = EMU(1);
    pptxTree.height = EMU(1);
    IValidator validator = PptxDimensionsValidator(pptxTree);

    Set<ValidatorError> errors = validator.validate();

    expect(errors.isEmpty, true);
  });

    test('Validation error if pptx height is not positive', () {
    PptxTree pptxTree = PptxTree();
    pptxTree.width = EMU(1);
    pptxTree.height = EMU(0);
    IValidator validator = PptxDimensionsValidator(pptxTree);

    Set<ValidatorError> errors = validator.validate();

    expect(errors.length, 1);
    expect(errors.first.errorType, ValidatorErrorType.pptxHeightMustBePositive);
  });

  test('Works if pptx width and height is positive', () {
    PptxTree pptxTree = PptxTree();
    pptxTree.width = EMU(1);
    pptxTree.height = EMU(1);
    IValidator validator = PptxDimensionsValidator(pptxTree);

    Set<ValidatorError> errors = validator.validate();

    expect(errors.isEmpty, true);
  });

}
