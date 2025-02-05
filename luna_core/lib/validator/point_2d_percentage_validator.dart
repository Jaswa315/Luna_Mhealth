import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_core/validator/validator_error.dart';
import 'package:luna_core/validator/error/point_2d_validation_error.dart';

/// Validator to check if a Point2DPercentage value is within the valid range [0.0, 1.0].
class Point2DPercentageValidator extends IValidator {
  final double x;
  final double y;

  Point2DPercentageValidator(this.x, this.y);

  @override
  Set<ValidatorError> validate() {
    final errors = <ValidatorError>{};

    if (x < 0.0) {
      errors.add(Point2DXLessThanZeroError());
    }
    if (x > 1.0) {
      errors.add(Point2DXGreaterThanOneError());
    }
    if (y < 0.0) {
      errors.add(Point2DYLessThanZeroError());
    }
    if (y > 1.0) {
      errors.add(Point2DYGreaterThanOneError());
    }

    return errors;
  }
}
