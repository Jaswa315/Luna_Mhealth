import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/validator/i_validator.dart';
import 'package:luna_authoring_system/validator/pptx_title_validator.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/validator/issue/pptx_title_has_no_visible_characters.dart';
import 'package:luna_authoring_system/validator/issue/pptx_title_is_too_long.dart';
import 'package:luna_authoring_system/luna_constants.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Pptx Title cannot be empty', () {
    final pptxTree = PptxTree();
    pptxTree.title = "";
    IValidator validator = PptxTitleValidator(pptxTree);

    final Set<IValidationIssue> issues = validator.validate();

    expect(issues.length, 1);
    expect(issues.first, isA<PptxTitleHasNoVisibleCharacters>());
  });

  test('Pptx Title must have visible characters', () {
    final pptxTree = PptxTree();
    pptxTree.title = "  ";
    IValidator validator = PptxTitleValidator(pptxTree);

    final Set<IValidationIssue> issues = validator.validate();

    expect(issues.length, 1);
    expect(issues.first, isA<PptxTitleHasNoVisibleCharacters>());
  });

  test('Pptx Title cannot be too long', () {
    final pptxTree = PptxTree();
    // Build a string one character longer than the maximum allowed title length.
    pptxTree.title = 'a' * (LunaConstants.maximumPptxTitleLength + 1);
    IValidator validator = PptxTitleValidator(pptxTree);

    final Set<IValidationIssue> issues = validator.validate();

    expect(issues.length, 1);
    expect(issues.first, isA<PptxTitleIsTooLong>());
  });

  test('Pptx Title is just short enough', () {
    final pptxTree = PptxTree();
    pptxTree.title = 'a' * (LunaConstants.maximumPptxTitleLength);
    IValidator validator = PptxTitleValidator(pptxTree);

    final Set<IValidationIssue> issues = validator.validate();

    expect(issues.isEmpty, true);
  });
}
