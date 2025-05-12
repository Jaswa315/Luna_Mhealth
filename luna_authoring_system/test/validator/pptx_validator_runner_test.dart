import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/validator/pptx_validator_runner.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/validator/issue/pptx_title_has_no_visible_characters.dart';
import 'package:luna_authoring_system/validator/issue/pptx_title_is_too_long.dart';

void main() {
  group('PptxValidatorRunner', () {
    test('throws ArgumentError when title is empty and too long', () {
      // Create a PptxTree with an invalid title
      final pptxTree = PptxTree();
      pptxTree.title = '   '; // only whitespace – considered empty
      // Simulate long title
      pptxTree.title += 'a' * 300; // exceeds max length
      pptxTree.slides = [];

      expect(
        () => PptxValidatorRunner.runValidatiors(pptxTree),
        throwsA(predicate((e) =>
            e is ArgumentError &&
            e.message.toString().contains('Validation failed'))),
      );
    });

    test('passes when title is valid', () {
      final pptxTree = PptxTree();
      pptxTree.title = 'A valid PPTX title';
      pptxTree.slides = [];

      expect(
        () => PptxValidatorRunner.runValidatiors(pptxTree),
        returnsNormally,
      );
    });
  });
}
