import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/validator/point_2d_percentage_validator.dart';
import 'package:luna_core/validator/validator_error.dart';
import 'package:luna_core/validator/validator_error_type.dart';

void main() {
  group('Point2DPercentageValidator Tests', () {
    test('Valid values (x=0.5, y=0.5) should pass without errors', () {
      var validator = Point2DPercentageValidator(0.5, 0.5);
      var errors = validator.validate();

      expect(errors.isEmpty, true);
    });

    test('X less than 0 (-0.1) should return point2DXLessThanZero error', () {
      var validator = Point2DPercentageValidator(-0.1, 0.5);
      var errors = validator.validate();

      expect(errors.length, 1);
      expect(errors.first.errorType,
          ValidatorErrorType.point2DXPercentageLessThanZero);
    });

    test('X greater than 1 (1.1) should return point2DXGreaterThanOne error',
        () {
      var validator = Point2DPercentageValidator(1.1, 0.5);
      var errors = validator.validate();

      expect(errors.length, 1);
      expect(errors.first.errorType,
          ValidatorErrorType.point2DXPercentageGreaterThanOne);
    });

    test('Y less than 0 (-0.1) should return point2DYLessThanZero error', () {
      var validator = Point2DPercentageValidator(0.5, -0.1);
      var errors = validator.validate();

      expect(errors.length, 1);
      expect(errors.first.errorType,
          ValidatorErrorType.point2DYPercentageLessThanZero);
    });

    test('Y greater than 1 (1.1) should return point2DYGreaterThanOne error',
        () {
      var validator = Point2DPercentageValidator(0.5, 1.1);
      var errors = validator.validate();

      expect(errors.length, 1);
      expect(errors.first.errorType,
          ValidatorErrorType.point2DYPercentageGreaterThanOne);
    });

    test('Both X and Y invalid (-0.5, 1.2) should return two errors', () {
      var validator = Point2DPercentageValidator(-0.5, 1.2);
      var errors = validator.validate();

      expect(errors.length, 2);
      expect(
          errors.any((error) =>
              error.errorType ==
              ValidatorErrorType.point2DXPercentageLessThanZero),
          true);
      expect(
          errors.any((error) =>
              error.errorType ==
              ValidatorErrorType.point2DYPercentageGreaterThanOne),
          true);
    });

    test('All four errors should be detected (-0.5, -0.5)', () {
      var validator = Point2DPercentageValidator(-0.5, -0.5);
      var errors = validator.validate();

      expect(errors.length, 2);
      expect(
          errors.any((error) =>
              error.errorType ==
              ValidatorErrorType.point2DXPercentageLessThanZero),
          true);
      expect(
          errors.any((error) =>
              error.errorType ==
              ValidatorErrorType.point2DYPercentageLessThanZero),
          true);
    });

    test('All four errors should be detected (1.5, 1.5)', () {
      var validator = Point2DPercentageValidator(1.5, 1.5);
      var errors = validator.validate();

      expect(errors.length, 2);
      expect(
          errors.any((error) =>
              error.errorType ==
              ValidatorErrorType.point2DXPercentageGreaterThanOne),
          true);
      expect(
          errors.any((error) =>
              error.errorType ==
              ValidatorErrorType.point2DYPercentageGreaterThanOne),
          true);
    });
  });
}
