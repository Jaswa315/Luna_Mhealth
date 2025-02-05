import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/validator/point_2d_percentage_validator.dart';
import 'package:luna_core/validator/validator_error.dart';

void main() {
  group('Point2DPercentageValidator Tests', () {
    test('Valid values (x=0.5, y=0.5) should pass without errors', () {
      final validator = Point2DPercentageValidator(0.5, 0.5);
      final errors = validator.validate();

      expect(errors.isEmpty, isTrue);
    });

    test('X less than 0 (-0.1) should return Point2DXLessThanZeroError', () {
      final validator = Point2DPercentageValidator(-0.1, 0.5);
      final errors = validator.validate();

      expect(errors.length, 1);
      expect(errors.first, isA<Point2DXLessThanZeroError>());
    });

    test('X greater than 1 (1.1) should return Point2DXGreaterThanOneError', () {
      final validator = Point2DPercentageValidator(1.1, 0.5);
      final errors = validator.validate();

      expect(errors.length, 1);
      expect(errors.first, isA<Point2DXGreaterThanOneError>());
    });

    test('Y less than 0 (-0.1) should return Point2DYLessThanZeroError', () {
      final validator = Point2DPercentageValidator(0.5, -0.1);
      final errors = validator.validate();

      expect(errors.length, 1);
      expect(errors.first, isA<Point2DYLessThanZeroError>());
    });

    test('Y greater than 1 (1.1) should return Point2DYGreaterThanOneError', () {
      final validator = Point2DPercentageValidator(0.5, 1.1);
      final errors = validator.validate();

      expect(errors.length, 1);
      expect(errors.first, isA<Point2DYGreaterThanOneError>());
    });

    test('Both X and Y invalid (-0.5, 1.2) should return two errors', () {
      final validator = Point2DPercentageValidator(-0.5, 1.2);
      final errors = validator.validate();

      expect(errors.length, 2);
      expect(errors.any((error) => error is Point2DXLessThanZeroError), isTrue);
      expect(errors.any((error) => error is Point2DYGreaterThanOneError), isTrue);
    });

    test('Both X and Y invalid (-0.5, -0.5) should return two errors', () {
      final validator = Point2DPercentageValidator(-0.5, -0.5);
      final errors = validator.validate();

      expect(errors.length, 2);
      expect(errors.any((error) => error is Point2DXLessThanZeroError), isTrue);
      expect(errors.any((error) => error is Point2DYLessThanZeroError), isTrue);
    });

    test('Both X and Y invalid (1.5, 1.5) should return two errors', () {
      final validator = Point2DPercentageValidator(1.5, 1.5);
      final errors = validator.validate();

      expect(errors.length, 2);
      expect(errors.any((error) => error is Point2DXGreaterThanOneError), isTrue);
      expect(errors.any((error) => error is Point2DYGreaterThanOneError), isTrue);
    });
  });
}
