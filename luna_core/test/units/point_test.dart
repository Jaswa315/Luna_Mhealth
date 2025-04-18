import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/units/point.dart';
import 'package:luna_core/units/percent.dart';

void main() {
  group('Unit Tests for Point', () {
    // Ensures both x and y are required during initialization.
    test('An error is thrown when x and y are not initialized at constructor.',
        () {
      expect(
        () => Function.apply(Point.new, []),
        throwsA(isA<NoSuchMethodError>()),
      );
    });

    // Ensures providing only one argument results in an error.
    test('An error is thrown when only one argument is given at constructor.',
        () {
      expect(
        () => Function.apply(Point.new, [Percent(0.5)]),
        throwsA(isA<NoSuchMethodError>()),
      );
    });

    // Ensures valid x and y values between 0 and 1 are accepted.
    test('Creates Point with valid Percent values (0 to 1)', () {
      final point = Point(Percent(0.3), Percent(0.7));
      expect((point.x as Percent).value, equals(0.3));
      expect((point.y as Percent).value, equals(0.7));

      final edgeCasePoint = Point(Percent(0.0), Percent(1.0));
      expect((edgeCasePoint.x as Percent).value, equals(0.0));
      expect((edgeCasePoint.y as Percent).value, equals(1.0));
    });
  });
}
