import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/validator/i_validator.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';

/// Mock error classes for testing purposes.

class MockErrorOne extends IValidationIssue {
  @override
  String get issueCode => 'mock_error_one';
}

class MockErrorTwo extends IValidationIssue {
  @override
  String get issueCode => 'mock_error_two';
}

class MockErrorThree extends IValidationIssue {
  @override
  String get issueCode => 'mock_error_three';
}

class MockErrorFour extends IValidationIssue {
  @override
  String get issueCode => 'mock_error_four';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Single validator with one error should return single error', () {
    // Mock validator that always returns a single error.
    final mockValidator = _MockValidatorWithOneError();

    // Run the validation.
    Set<IValidationIssue> errors = mockValidator.validate();

    // Verify the results.
    expect(errors.length, 1);
    expect(errors.first, isA<MockErrorOne>());
  });

  test('Combining two validators should return two errors', () {
    // Mock validator 1 that returns one error.
    final mockValidator1 = _MockValidatorWithOneError();

    // Mock validator 2 that returns another error.
    final mockValidator2 = _MockValidatorWithAnotherError();

    // Run the validations and combine errors.
    Set<IValidationIssue> errors = {};
    errors.addAll(mockValidator1.validate());
    errors.addAll(mockValidator2.validate());

    // Verify the results.
    expect(errors.length, 2);
    expect(errors.any((error) => error is MockErrorOne), isTrue);
    expect(errors.any((error) => error is MockErrorTwo), isTrue);
  });

  test('Combining three validators with one returning two errors should return four errors', () {
    // Mock validator 1 that returns one error.
    final mockValidator1 = _MockValidatorWithOneError();

    // Mock validator 2 that returns another error.
    final mockValidator2 = _MockValidatorWithAnotherError();

    // Mock validator 3 that returns two errors.
    final mockValidator3 = _MockValidatorWithTwoErrors();

    // Run the validations and combine errors.
    Set<IValidationIssue> errors = {};
    errors.addAll(mockValidator1.validate());
    errors.addAll(mockValidator2.validate());
    errors.addAll(mockValidator3.validate());

    // Verify the results.
    expect(errors.length, 4);
    expect(errors.any((error) => error is MockErrorOne), isTrue);
    expect(errors.any((error) => error is MockErrorTwo), isTrue);
    expect(errors.any((error) => error is MockErrorThree), isTrue);
    expect(errors.any((error) => error is MockErrorFour), isTrue);
  });
}

/// Mock validator that always returns a single error.
class _MockValidatorWithOneError implements IValidator {
  @override
  Set<IValidationIssue> validate() {
    return {MockErrorOne()};
  }
}

/// Mock validator that always returns a different single error.
class _MockValidatorWithAnotherError implements IValidator {
  @override
  Set<IValidationIssue> validate() {
    return {MockErrorTwo()};
  }
}

/// Mock validator that returns two errors.
class _MockValidatorWithTwoErrors implements IValidator {
  @override
  Set<IValidationIssue> validate() {
    return {MockErrorThree(), MockErrorFour()};
  }
}
