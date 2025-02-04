import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_core/validator/validator_error.dart';
import 'package:luna_core/validator/validator_error_type.dart';

/// Validator to check if a Point2DPercentage value is within the valid range [0.0, 1.0].
class Point2DPercentageValidator extends IValidator {
  final double x;
  final double y;

  Point2DPercentageValidator(this.x, this.y);

  @override
  Set<ValidatorError> validate() {
    Set<ValidatorError> errors = {};

    if (x < 0.0) {
      errors.add(
          ValidatorError(ValidatorErrorType.point2DXPercentageLessThanZero));
    }
    if (x > 1.0) {
      errors.add(
          ValidatorError(ValidatorErrorType.point2DXPercentageGreaterThanOne));
    }
    if (y < 0.0) {
      errors.add(
          ValidatorError(ValidatorErrorType.point2DYPercentageLessThanZero));
    }
    if (y > 1.0) {
      errors.add(
          ValidatorError(ValidatorErrorType.point2DYPercentageGreaterThanOne));
    }

    return errors;
  }
}
