import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/utils/dimension.dart';
import 'package:luna_core/enums/unit_type.dart';

void main() {
  group('Dimension', () {
    test('should create Dimension with EMU unit', () {
      final dim = Dimension.emu(1200.0);
      expect(dim.value, equals(1200.0));
      expect(dim.unit, equals(UnitType.emu));
    });

    test('should create Dimension with display pixel unit', () {
      final dim = Dimension.pixels(300.5);
      expect(dim.value, equals(300.5));
      expect(dim.unit, equals(UnitType.displayPixels));
    });

    test('should create Dimension with percent unit', () {
      final dim = Dimension.percent(75.0);
      expect(dim.value, equals(75.0));
      expect(dim.unit, equals(UnitType.percent));
    });

    test('toString() should return formatted string', () {
      final dim = Dimension.percent(50.0);
      expect(dim.toString(), equals('50.0 percent'));
    });

    test('multiple instances should be independent', () {
      final dim1 = Dimension.emu(1000.0);
      final dim2 = Dimension.pixels(500.0);

      expect(dim1.unit, isNot(equals(dim2.unit)));
      expect(dim1.value, isNot(equals(dim2.value)));
    });

    test('should throw AssertionError for negative values', () {
      expect(() => Dimension.emu(-100), throwsA(isA<AssertionError>()));
      expect(() => Dimension.pixels(-10), throwsA(isA<AssertionError>()));
      expect(() => Dimension.percent(-5), throwsA(isA<AssertionError>()));
    });
  });
}
