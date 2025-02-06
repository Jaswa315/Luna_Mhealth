import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_authoring_system/validator/pptx_title_validator.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/validator/error/pptx_title_validation_error.dart';
import 'package:luna_core/luna_constants.dart';
import 'package:luna_core/validator/validator_error.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Pptx Title cannot be empty', () {
    final pptxTree = PptxTree();
    pptxTree.title = "";
    IValidator validator = PptxTitleValidator(pptxTree);

    final Set<ValidatorError> errors = validator.validate();

    expect(errors.length, 1);
    expect(errors.first, isA<PPTXTitleHasNoVisibleCharactersError>());
  });

  test('Pptx Title must have visible characters', () {
    final pptxTree = PptxTree();
    pptxTree.title = "  ";
    IValidator validator = PptxTitleValidator(pptxTree);

    final Set<ValidatorError> errors = validator.validate();

    expect(errors.length, 1);
    expect(errors.first, isA<PPTXTitleHasNoVisibleCharactersError>());
  });

  test('Pptx Title cannot be too long', () {
    final pptxTree = PptxTree();
    // Build a string one character longer than the maximum allowed title length.
    pptxTree.title = 'a' * (LunaConstants.maximumPptxTitleLength + 1);
    IValidator validator = PptxTitleValidator(pptxTree);

    final Set<ValidatorError> errors = validator.validate();

    expect(errors.length, 1);
    expect(errors.first, isA<PPTXTitleIsTooLongError>());
  });

  test('Pptx Title is just short enough', () {
    final pptxTree = PptxTree();
    pptxTree.title = 'a' * (LunaConstants.maximumPptxTitleLength);
    IValidator validator = PptxTitleValidator(pptxTree);

    final Set<ValidatorError> errors = validator.validate();

    expect(errors.isEmpty, true);
  });
}
