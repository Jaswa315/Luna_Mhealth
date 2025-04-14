import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/point_2d.dart';
import 'package:luna_core/units/emu.dart';

void main() {
  group('Tests for Point2D', () {
    test('An error is thrown when x and y is not initialzed at CTOR.', () {
      expect(
        () => Function.apply(Point2D.new, []),
        throwsA(isA<NoSuchMethodError>()),
      );
    });
    test('An error is thrown when only one argument is given at CTOR.', () {
      expect(
        () => Function.apply(Point2D.new, [
          1,
        ]),
        throwsA(isA<NoSuchMethodError>()),
      );
    });
    test('Point2D can be initialzed with EMU values at CTOR.', () {
      Point2D point = Point2D(EMU(10), EMU(20));
      expect(point.x.value, 10);
      expect(point.y.value, 20);
    });
  });
}
