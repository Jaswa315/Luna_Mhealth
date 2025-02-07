import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/validator/point_2d_percentage_validator.dart';
import 'package:luna_core/validator/issue/point_2d_issue.dart';
import 'package:luna_core/validator/validation_issue.dart';

void main() {
  group('Point2DPercentageValidator Tests', () {
    test('Valid values (x=0.5, y=0.5) should pass without issues', () {
      final validator = Point2DPercentageValidator(0.5, 0.5);
      final issues = validator.validate();

      expect(issues.isEmpty, isTrue);
    });

    test('X less than 0 (-0.1) should return Point2DXLessThanZeroissue', () {
      final validator = Point2DPercentageValidator(-0.1, 0.5);
      final issues = validator.validate();

      expect(issues.length, 1);
      expect(issues.first, isA<Point2DXLessThanZero>());
    });

    test('X greater than 1 (1.1) should return Point2DXGreaterThanOneissue', () {
      final validator = Point2DPercentageValidator(1.1, 0.5);
      final issues = validator.validate();

      expect(issues.length, 1);
      expect(issues.first, isA<Point2DXGreaterThanOne>());
    });

    test('Y less than 0 (-0.1) should return Point2DYLessThanZeroissue', () {
      final validator = Point2DPercentageValidator(0.5, -0.1);
      final issues = validator.validate();

      expect(issues.length, 1);
      expect(issues.first, isA<Point2DYLessThanZero>());
    });

    test('Y greater than 1 (1.1) should return Point2DYGreaterThanOneissue', () {
      final validator = Point2DPercentageValidator(0.5, 1.1);
      final issues = validator.validate();

      expect(issues.length, 1);
      expect(issues.first, isA<Point2DYGreaterThanOne>());
    });

    test('Both X and Y invalid (-0.5, 1.2) should return two issues', () {
      final validator = Point2DPercentageValidator(-0.5, 1.2);
      final issues = validator.validate();

      expect(issues.length, 2);
      expect(issues.any((issue) => issue is Point2DXLessThanZero), isTrue);
      expect(issues.any((issue) => issue is Point2DYGreaterThanOne), isTrue);
    });

    test('Both X and Y invalid (-0.5, -0.5) should return two issues', () {
      final validator = Point2DPercentageValidator(-0.5, -0.5);
      final issues = validator.validate();

      expect(issues.length, 2);
      expect(issues.any((issue) => issue is Point2DXLessThanZero), isTrue);
      expect(issues.any((issue) => issue is Point2DYLessThanZero), isTrue);
    });

    test('Both X and Y invalid (1.5, 1.5) should return two issues', () {
      final validator = Point2DPercentageValidator(1.5, 1.5);
      final issues = validator.validate();

      expect(issues.length, 2);
      expect(issues.any((issue) => issue is Point2DXGreaterThanOne), isTrue);
      expect(issues.any((issue) => issue is Point2DYGreaterThanOne), isTrue);
    });
  });
}
