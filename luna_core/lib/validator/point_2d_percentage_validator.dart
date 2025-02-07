import 'package:luna_core/validator/issue/point_2d_issue.dart';
import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_core/validator/validation_issue.dart';

/// Validator to check if a Point2DPercentage value is within the valid range [0.0, 1.0].
class Point2DPercentageValidator extends IValidator {
  final double x;
  final double y;

  Point2DPercentageValidator(this.x, this.y);

  @override
  Set<ValidationIssue> validate() {
    final validationIssues = <ValidationIssue>{};

    if (x < 0.0) {
      validationIssues.add(Point2DXLessThanZero());
    }
    if (x > 1.0) {
      validationIssues.add(Point2DXGreaterThanOne());
    }
    if (y < 0.0) {
      validationIssues.add(Point2DYLessThanZero());
    }
    if (y > 1.0) {
      validationIssues.add(Point2DYGreaterThanOne());
    }

    return validationIssues;
  }
}
