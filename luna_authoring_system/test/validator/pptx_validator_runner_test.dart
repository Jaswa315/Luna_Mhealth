import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/validator/pptx_validator_runner.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/validator/issue/pptx_issues/pptx_title_has_no_visible_characters.dart';
import 'package:luna_authoring_system/validator/issue/pptx_issues/pptx_title_is_too_long.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_authoring_system/validator/i_validator.dart';

class ValidatorHasOneIssue implements IValidator {
  @override
  Set<IValidationIssue> validate() {
    return {PptxTitleHasNoVisibleCharacters()};
  }
}

class ValidatorHasTwoIssues implements IValidator {
  @override
  Set<IValidationIssue> validate() {
    return {PptxTitleHasNoVisibleCharacters(), PptxTitleIsTooLong()};
  }
}

class ValidatorHasZeroIssues implements IValidator {
  @override
  Set<IValidationIssue> validate() {
    return {};
  }
}

void main() {
  group('PptxValidatorRunner', () {
    late ValidationIssuesStore store;

    // Initialize the ValidationIssuesStore before each test
    // This ensures a fresh store for each test case.
    setUp(() {
      store = ValidationIssuesStore();
    });

    test(
        'ValidatorRunner should call validator that has 1 issue and validator store stores the issue',
        () {
      final mockValidator = ValidatorHasOneIssue();

      final runner = PptxValidatorRunner(mockValidator);
      runner.runValidators(store);

      expect(store.issues.isNotEmpty, true);
      expect(store.issues.length, 1);
      expect(store.issues.first, isA<PptxTitleHasNoVisibleCharacters>());
      expect(store.hasIssues, isTrue);
    });

    test(
        'ValidatorRunner should call validator that has 2 issues and validator store stores the issue',
        () {
      final mockValidator = ValidatorHasTwoIssues();

      final runner = PptxValidatorRunner(mockValidator);
      runner.runValidators(store);

      expect(store.issues.isNotEmpty, true);
      expect(store.issues.length, 2);
      expect(store.issues.first, isA<PptxTitleHasNoVisibleCharacters>());
      expect(store.hasIssues, isTrue);
    });

    test(
        'ValidatorRunner should call validator that has 0 issues and hence validator store should not store any issues',
        () {
      final mockValidator = ValidatorHasZeroIssues();

      final runner = PptxValidatorRunner(mockValidator);
      runner.runValidators(store);

      expect(store.issues.isEmpty, true);
      expect(store.issues.length, 0);
      expect(store.hasIssues, isFalse);
    });
  });
}
