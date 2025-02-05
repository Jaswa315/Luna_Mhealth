import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_authoring_system/validator/pptx_dimensions_validator.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_core/validator/validator_error.dart';
import 'package:luna_authoring_system/validator/pptx_dimension_errors.dart';
import 'package:luna_core/utils/emu.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Validation error if pptx width is null', () {
    final pptxTree = PptxTree();
    // Leave pptxTree.width null to simulate an uninitialized width.
    IValidator validator = PptxDimensionsValidator(pptxTree);

    final Set<ValidatorError> errors = validator.validate();

    expect(errors.length, 1);
    expect(
      errors.first,
      isA<PPTXWidthAndHeightMustBothBeInitializedError>(),
    );
  });

  test('Validation error if pptx height is null', () {
    final pptxTree = PptxTree();
    // Leave pptxTree.height null to simulate an uninitialized height.
    IValidator validator = PptxDimensionsValidator(pptxTree);

    final Set<ValidatorError> errors = validator.validate();

    expect(errors.length, 1);
    expect(
      errors.first,
      isA<PPTXWidthAndHeightMustBothBeInitializedError>(),
    );
  });
  
  test('Works if pptx width and height are positive', () {
    final pptxTree = PptxTree();
    pptxTree.width = EMU(1);
    pptxTree.height = EMU(1);
    IValidator validator = PptxDimensionsValidator(pptxTree);

    final Set<ValidatorError> errors = validator.validate();

    expect(errors.isEmpty, isTrue);
  });

  test('Validation error if pptx height is not positive', () {
    final pptxTree = PptxTree();
    pptxTree.width = EMU(1);
    pptxTree.height = EMU(0); // 0 is not positive
    IValidator validator = PptxDimensionsValidator(pptxTree);

    final Set<ValidatorError> errors = validator.validate();

    expect(errors.length, 1);
    expect(
      errors.first,
      isA<PPTXHeightMustBePositiveError>(),
    );
  });

  test('Works if pptx width and height is positive', () {
    final pptxTree = PptxTree();
    pptxTree.width = EMU(1);
    pptxTree.height = EMU(1);
    IValidator validator = PptxDimensionsValidator(pptxTree);

    final Set<ValidatorError> errors = validator.validate();

    expect(errors.isEmpty, isTrue);
  });
}
