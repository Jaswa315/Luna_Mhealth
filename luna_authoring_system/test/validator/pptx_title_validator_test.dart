import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_authoring_system/validator/pptx_title_validator.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/validator/issue/pptx_title_issue.dart';
import 'package:luna_core/luna_constants.dart';
import 'package:luna_core/validator/validation_issue.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Pptx Title cannot be empty', () {
    final pptxTree = PptxTree();
    pptxTree.title = "";
    IValidator validator = PptxTitleValidator(pptxTree);

    final Set<ValidationIssue> issues = validator.validate();

    expect(issues.length, 1);
    expect(issues.first, isA<PPTXTitleHasNoVisibleCharacters>());
  });

  test('Pptx Title must have visible characters', () {
    final pptxTree = PptxTree();
    pptxTree.title = "  ";
    IValidator validator = PptxTitleValidator(pptxTree);

    final Set<ValidationIssue> issues = validator.validate();

    expect(issues.length, 1);
    expect(issues.first, isA<PPTXTitleHasNoVisibleCharacters>());
  });

  test('Pptx Title cannot be too long', () {
    final pptxTree = PptxTree();
    // Build a string one character longer than the maximum allowed title length.
    pptxTree.title = 'a' * (LunaConstants.maximumPptxTitleLength + 1);
    IValidator validator = PptxTitleValidator(pptxTree);

    final Set<ValidationIssue> issues = validator.validate();

    expect(issues.length, 1);
    expect(issues.first, isA<PPTXTitleIsTooLong>());
  });

  test('Pptx Title is just short enough', () {
    final pptxTree = PptxTree();
    pptxTree.title = 'a' * (LunaConstants.maximumPptxTitleLength);
    IValidator validator = PptxTitleValidator(pptxTree);

    final Set<ValidationIssue> issues = validator.validate();

    expect(issues.isEmpty, true);
  });
}
