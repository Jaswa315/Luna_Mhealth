import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_core/validator/validator_error.dart';
import 'package:luna_core/validator/validator_error_type.dart';
import 'package:luna_core/validator/validator_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Newly initialized validator manager should return no errors', () {
    ValidatorManager validatorManager = ValidatorManager();

    Set<ValidatorError> errors = validatorManager.validateAll();

    expect(errors.isEmpty, true);
  });

  test('Single validator with one error should return single error', () {
    ValidatorManager validatorManager = ValidatorManager();

    // Mock validator that always returns an error
    final mockValidator = _MockValidatorWithOneError();

    // Add the mock validator to the manager
    validatorManager.addValidator(mockValidator);

    // Run the validation
    Set<ValidatorError> errors = validatorManager.validateAll();

    // Verify the results
    expect(errors.length, 1);
    expect(errors.first.errorType,
        ValidatorErrorType.pptxWidthAndHeightMustBothBeInitialized);
  });

  test('Two validators which each return one error should return two errors', () {
    ValidatorManager validatorManager = ValidatorManager();

    // Mock validator 1 that returns one error
    final mockValidator1 = _MockValidatorWithOneError();

    // Mock validator 2 that returns another error
    final mockValidator2 = _MockValidatorWithAnotherError();

    // Add both mock validators to the manager
    validatorManager.addValidator(mockValidator1);
    validatorManager.addValidator(mockValidator2);

    // Run the validation
    Set<ValidatorError> errors = validatorManager.validateAll();

    // Verify the results
    expect(errors.length, 2);
    expect(
        errors.any((error) =>
            error.errorType ==
            ValidatorErrorType.pptxWidthAndHeightMustBothBeInitialized),
        true);
    expect(
        errors.any((error) =>
            error.errorType == ValidatorErrorType.pptxWidthMustBePositive),
        true);
  });

    test('Three validators with one returning two errors should return four errors', () {
    ValidatorManager validatorManager = ValidatorManager();

    // Mock validator 1 that returns one error
    final mockValidator1 = _MockValidatorWithOneError();

    // Mock validator 2 that returns another error
    final mockValidator2 = _MockValidatorWithAnotherError();

    // Mock validator 3 that returns two errors
    final mockValidator3 = _MockValidatorWithTwoErrors();

    // Add all mock validators to the manager
    validatorManager.addValidator(mockValidator1);
    validatorManager.addValidator(mockValidator2);
    validatorManager.addValidator(mockValidator3);

    // Run the validation
    Set<ValidatorError> errors = validatorManager.validateAll();

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
          ValidatorErrorType.pptxWidthAndHeightMustBothBeInitialized),
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
