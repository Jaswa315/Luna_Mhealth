import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/units/point_2d_percentage.dart';

void main() {
  group('Unit Tests for Point2DPercentage', () {
    // Ensures both x and y are required during initialization.
    test('An error is thrown when x and y are not initialized at constructor.',
        () {
      expect(
        () => Function.apply(Point2DPercentage.new, []),
        throwsA(isA<NoSuchMethodError>()),
      );
    });

    // Ensures providing only one argument results in an error.
    test('An error is thrown when only one argument is given at constructor.',
        () {
      expect(
        () => Function.apply(Point2DPercentage.new, [0.5]),
        throwsA(isA<NoSuchMethodError>()),
      );
    });

    // Ensures valid x and y values between 0 and 1 are accepted.
    test('Creates Point2DPercentage with valid values (0 to 1)', () {
      final point = Point2DPercentage(0.3, 0.7);
      expect(point.x, equals(0.3));
      expect(point.y, equals(0.7));

      final edgeCasePoint = Point2DPercentage(0.0, 1.0);
      expect(edgeCasePoint.x, equals(0.0));
      expect(edgeCasePoint.y, equals(1.0));
    });
  });
}
