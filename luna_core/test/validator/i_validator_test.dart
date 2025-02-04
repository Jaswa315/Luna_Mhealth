import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_core/validator/validator_error.dart';
import 'package:luna_core/validator/validator_error_type.dart';

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
      errors.first.errorType,
      ValidatorErrorType.pptxWidthAndHeightMustBothBeInitialized,
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
      errors.any(
        (error) =>
            error.errorType ==
            ValidatorErrorType.pptxWidthAndHeightMustBothBeInitialized,
      ),
      true,
    );
    expect(
      errors.any(
        (error) => error.errorType == ValidatorErrorType.pptxWidthMustBePositive,
      ),
      true,
    );
  });

  test('Combining three validators with one returning two errors should return four errors', () {
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
      errors.any(
        (error) =>
            error.errorType ==
            ValidatorErrorType.pptxWidthAndHeightMustBothBeInitialized,
      ),
      true,
    );
    expect(
      errors.any(
        (error) => error.errorType == ValidatorErrorType.pptxWidthMustBePositive,
      ),
      true,
    );
    expect(
      errors.any(
        (error) => error.errorType == ValidatorErrorType.pptxHeightMustBePositive,
      ),
      true,
    );
    expect(
      errors.any(
        (error) => error.errorType == ValidatorErrorType.pptxTitleHasNoVisibleCharacters,
      ),
      true,
    );
  });
}

// Manually implemented mock validator class
class _MockValidatorWithOneError implements IValidator {
  @override
  Set<ValidatorError> validate() {
    // Return a set with a single error
    return {
      ValidatorError(
        ValidatorErrorType.pptxWidthAndHeightMustBothBeInitialized,
      ),
    };
  }
}

// Manually implemented mock validator class with another error
class _MockValidatorWithAnotherError implements IValidator {
  @override
  Set<ValidatorError> validate() {
    // Return a set with a single error
    return {
      ValidatorError(ValidatorErrorType.pptxWidthMustBePositive),
    };
  }
}

// Manually implemented mock validator class with two errors
class _MockValidatorWithTwoErrors implements IValidator {
  @override
  Set<ValidatorError> validate() {
    // Return a set with two errors
    return {
      ValidatorError(ValidatorErrorType.pptxHeightMustBePositive),
      ValidatorError(ValidatorErrorType.pptxTitleHasNoVisibleCharacters),
    };
  }
}