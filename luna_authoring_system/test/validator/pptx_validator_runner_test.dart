import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/validator/pptx_validator_runner.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/validator/issue/pptx_issues/pptx_title_has_no_visible_characters.dart';
import 'package:luna_authoring_system/validator/issue/pptx_issues/pptx_title_is_too_long.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';

void main() {
  group('PptxValidatorRunner', () {
    late ValidationIssuesStore store;
    late PptxValidatorRunner runner;

    setUp(() {
      store = ValidationIssuesStore();
      runner = PptxValidatorRunner();
    });

    test('adds issues when title is empty', () {
      final pptxTree = PptxTree();
      pptxTree.title = ''; // whitespace + long
      pptxTree.slides = [];

      runner.runValidatiors(pptxTree, store);
      expect(store.issues.first, isA<PptxTitleHasNoVisibleCharacters>());
      expect(store.hasIssues, isTrue);
    });

    test('no issues when title is valid', () {
      final pptxTree = PptxTree();
      pptxTree.title = 'A valid title';
      pptxTree.slides = [];
      runner.runValidatiors(pptxTree, store);
      expect(store.issues.isEmpty, isTrue);
    });

    test('no issues with title and empty slide list', () {
      final pptxTree = PptxTree();
      pptxTree.title = 'Title';
      pptxTree.slides = [];

      runner.runValidatiors(pptxTree, store);

      expect(store.issues, isEmpty);
    });
  });
}
