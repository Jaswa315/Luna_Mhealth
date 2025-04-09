import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/utils/percent.dart';

void main() {
  group('Percent', () {
    test('creates Percent with valid values', () {
      expect(Percent(0).value, equals(0));
      expect(Percent(50).value, equals(50));
      expect(Percent(100).value, equals(100));
      expect(Percent(99.99).value, closeTo(99.99, 0.001));
    });

    test('throws error for values below 0', () {
      expect(() => Percent(-0.1), throwsA(isA<ArgumentError>()));
      expect(() => Percent(-10), throwsA(isA<ArgumentError>()));
    });

    test('throws error for values above 100', () {
      expect(() => Percent(100.01), throwsA(isA<ArgumentError>()));
      expect(() => Percent(200), throwsA(isA<ArgumentError>()));
    });

    test('toString returns formatted percentage string', () {
      expect(Percent(42.5).toString(), equals('42.5%'));
      expect(Percent(0).toString(), equals('0.0%'));
      expect(Percent(100).toString(), equals('100.0%'));
    });

    test('boundary values are accepted', () {
      expect(() => Percent(0), returnsNormally);
      expect(() => Percent(100), returnsNormally);
    });
  });
}
