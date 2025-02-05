import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_core/validator/validator_error.dart';
// Import your new PPTX error classes.
import 'package:luna_core/validator/pptx_errors.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Single validator with one error should return single error', () {
    // Mock validator that always returns an error
    final mockValidator = _MockValidatorWithOneError();

    // Run the validation
    Set<ValidatorError> errors = mockValidator.validate();

    // Verify the results
    expect(errors.length, 1);
    expect(
      errors.first,
      isA<PPTXWidthAndHeightMustBothBeInitializedError>(),
    );
  });

  test('Combining two validators should return two errors', () {
    // Mock validator 1 that returns one error
    final mockValidator1 = _MockValidatorWithOneError();

    // Mock validator 2 that returns another error
    final mockValidator2 = _MockValidatorWithAnotherError();

    // Run the validations and combine errors
    Set<ValidatorError> errors = {};
    errors.addAll(mockValidator1.validate());
    errors.addAll(mockValidator2.validate());

    // Verify the results
    expect(errors.length, 2);
    expect(
      errors.any((error) => error is PPTXWidthAndHeightMustBothBeInitializedError),
      isTrue,
    );
    expect(
      errors.any((error) => error is PPTXWidthMustBePositiveError),
      isTrue,
    );
  });

  test(
      'Combining three validators with one returning two errors should return four errors',
      () {
    // Mock validator 1 that returns one error
    final mockValidator1 = _MockValidatorWithOneError();

    // Mock validator 2 that returns another error
    final mockValidator2 = _MockValidatorWithAnotherError();

    // Mock validator 3 that returns two errors
    final mockValidator3 = _MockValidatorWithTwoErrors();

    // Run the validations and combine errors
    Set<ValidatorError> errors = {};
    errors.addAll(mockValidator1.validate());
    errors.addAll(mockValidator2.validate());
    errors.addAll(mockValidator3.validate());

    // Verify the results
    expect(errors.length, 4);
    expect(
      errors.any((error) => error is PPTXWidthAndHeightMustBothBeInitializedError),
      isTrue,
    );
    expect(
      errors.any((error) => error is PPTXWidthMustBePositiveError),
      isTrue,
    );
    expect(
      errors.any((error) => error is PPTXHeightMustBePositiveError),
      isTrue,
    );
    expect(
      errors.any((error) => error is PPTXTitleHasNoVisibleCharactersError),
      isTrue,
    );
  });
}

// Mock validator classes updated to use the new error classes:

class _MockValidatorWithOneError implements IValidator {
  @override
  Set<ValidatorError> validate() {
    // Return a set with a single error (using the new error class)
    return {
      PPTXWidthAndHeightMustBothBeInitializedError(),
    };
  }
}

class _MockValidatorWithAnotherError implements IValidator {
  @override
  Set<ValidatorError> validate() {
    // Return a set with a single error (using the new error class)
    return {
      PPTXWidthMustBePositiveError(),
    };
  }
}

class _MockValidatorWithTwoErrors implements IValidator {
  @override
  Set<ValidatorError> validate() {
    // Return a set with two errors (using the new error classes)
    return {
      PPTXHeightMustBePositiveError(),
      PPTXTitleHasNoVisibleCharactersError(),
    };
  }
}
