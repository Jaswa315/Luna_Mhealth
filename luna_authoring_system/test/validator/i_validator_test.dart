import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/validator/i_validator.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/luna_constants.dart';

/// Mock issue classes for testing purposes.

class MockIssueOne extends IValidationIssue {
  String toText() {
    return 'mock_issue_one';
  }

  ValidationSeverity get severity => ValidationSeverity.warning;
}

class MockIssueTwo extends IValidationIssue {
  String toText() {
    return 'mock_issue_two';
  }

  ValidationSeverity get severity => ValidationSeverity.warning;
}

class MockIssueThree extends IValidationIssue {
  String toText() {
    return 'mock_issue_three';
  }

  ValidationSeverity get severity => ValidationSeverity.warning;
}

class MockIssueFour extends IValidationIssue {
  String toText() {
    return 'mock_issue_four';
  }

  ValidationSeverity get severity => ValidationSeverity.warning;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Single validator with one issue should return single issue', () {
    // Mock validator that always returns a single issue.
    final mockValidator = _MockValidatorWithOneIssue();

    // Run the validation.
    Set<IValidationIssue> issues = mockValidator.validate();

    // Verify the results.
    expect(issues.length, 1);
    expect(issues.first, isA<MockIssueOne>());
  });

  test('Combining two validators should return two issues', () {
    // Mock validator 1 that returns one issue.
    final mockValidator1 = _MockValidatorWithOneIssue();

    // Mock validator 2 that returns another issue.
    final mockValidator2 = _MockValidatorWithAnotherIssue();

    // Run the validations and combine issues.
    Set<IValidationIssue> issues = {};
    issues.addAll(mockValidator1.validate());
    issues.addAll(mockValidator2.validate());

    // Verify the results.
    expect(issues.length, 2);
    expect(issues.any((issue) => issue is MockIssueOne), isTrue);
    expect(issues.any((issue) => issue is MockIssueTwo), isTrue);
  });

  test(
      'Combining three validators with one returning two issues should return four issues',
      () {
    // Mock validator 1 that returns one issue.
    final mockValidator1 = _MockValidatorWithOneIssue();

    // Mock validator 2 that returns another issue.
    final mockValidator2 = _MockValidatorWithAnotherIssue();

    // Mock validator 3 that returns two issues.
    final mockValidator3 = _MockValidatorWithTwoIssues();

    // Run the validations and combine issues.
    Set<IValidationIssue> issues = {};
    issues.addAll(mockValidator1.validate());
    issues.addAll(mockValidator2.validate());
    issues.addAll(mockValidator3.validate());

    // Verify the results.
    expect(issues.length, 4);
    expect(issues.any((issue) => issue is MockIssueOne), isTrue);
    expect(issues.any((issue) => issue is MockIssueTwo), isTrue);
    expect(issues.any((issue) => issue is MockIssueThree), isTrue);
    expect(issues.any((issue) => issue is MockIssueFour), isTrue);
  });
}

/// Mock validator that always returns a single issue.
class _MockValidatorWithOneIssue implements IValidator {
  @override
  Set<IValidationIssue> validate() {
    return {MockIssueOne()};
  }
}

/// Mock validator that always returns a different single issue.
class _MockValidatorWithAnotherIssue implements IValidator {
  @override
  Set<IValidationIssue> validate() {
    return {MockIssueTwo()};
  }
}

/// Mock validator that returns two issues.
class _MockValidatorWithTwoIssues implements IValidator {
  @override
  Set<IValidationIssue> validate() {
    return {MockIssueThree(), MockIssueFour()};
  }
}
