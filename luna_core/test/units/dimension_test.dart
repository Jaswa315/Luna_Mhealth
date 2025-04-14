import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_core/units/percent.dart';
import 'package:luna_core/units/display_pixel.dart';

void main() {
  group('Dimension subclasses', () {
    test('should create EMU with correct value', () {
      final dim = EMU(1200);
      expect(dim.value, equals(1200));
    });

    test('should create DisplayPixel with correct value', () {
      final dim = DisplayPixel(300.5);
      expect(dim.value, equals(300.5));
    });

    test('should create Percent with correct value', () {
      final dim = Percent(75.0);
      expect(dim.value, equals(75.0));
    });

    test('toString() should return formatted string', () {
      final dim = Percent(50.0);
      expect(dim.toString(), equals('50.0%'));
    });

    test('multiple instances should be independent', () {
      final dim1 = EMU(1000);
      final dim2 = DisplayPixel(500.0);

      expect(dim1.value, isNot(equals(dim2.value)));
    });

    test('should throw ArgumentError for invalid values', () {
      expect(() => EMU(-100), throwsA(isA<ArgumentError>()));
      expect(() => DisplayPixel(-10), throwsA(isA<ArgumentError>()));
      expect(() => Percent(-5), throwsA(isA<ArgumentError>()));
    });
  });
}
