import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/units/display_pixel.dart';

void main() {
  group('DisplayPixel', () {
    test('creates DisplayPixel with valid values', () {
      expect(DisplayPixel(0).value, equals(0));
      expect(DisplayPixel(1.0).value, equals(1.0));
      expect(DisplayPixel(0.5).value, equals(0.5));
      expect(DisplayPixel(10.75).value, equals(10.75));
    });

    test('throws error for negative values', () {
      expect(() => DisplayPixel(-0.1), throwsA(isA<ArgumentError>()));
      expect(() => DisplayPixel(-10), throwsA(isA<ArgumentError>()));
    });

    test('toString returns correct pixel string', () {
      expect(DisplayPixel(1.0).toString(), equals('1.0px'));
      expect(DisplayPixel(0.5).toString(), equals('0.5px'));
      expect(DisplayPixel(0).toString(), equals('0.0px'));
    });

    test('boundary value (0) is accepted', () {
      expect(() => DisplayPixel(0), returnsNormally);
    });
  });
}
