import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_core/validator/validator_error.dart';

/// Mock error classes for testing purposes.

class MockErrorOne extends ValidatorError {
  @override
  String get errorCode => 'mock_error_one';
}

class MockErrorTwo extends ValidatorError {
  @override
  String get errorCode => 'mock_error_two';
}

class MockErrorThree extends ValidatorError {
  @override
  String get errorCode => 'mock_error_three';
}

class MockErrorFour extends ValidatorError {
  @override
  String get errorCode => 'mock_error_four';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Single validator with one error should return single error', () {
    // Mock validator that always returns a single error.
    final mockValidator = _MockValidatorWithOneError();

    // Run the validation.
    Set<ValidatorError> errors = mockValidator.validate();

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
    Set<ValidatorError> errors = {};
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
    Set<ValidatorError> errors = {};
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
  Set<ValidatorError> validate() {
    return {MockErrorOne()};
  }
}

/// Mock validator that always returns a different single error.
class _MockValidatorWithAnotherError implements IValidator {
  @override
  Set<ValidatorError> validate() {
    return {MockErrorTwo()};
  }
}

/// Mock validator that returns two errors.
class _MockValidatorWithTwoErrors implements IValidator {
  @override
  Set<ValidatorError> validate() {
    return {MockErrorThree(), MockErrorFour()};
  }
}
