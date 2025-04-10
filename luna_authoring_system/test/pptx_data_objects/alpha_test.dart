import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/alpha.dart';

void main() {
  group('Alpha Class Tests', () {
    test('Alpha object stores valid value.', () {
      Alpha alpha1 = Alpha(0);
      Alpha alpha2 = Alpha(50000);
      Alpha alpha3 = Alpha(100000);

      expect(alpha1.value, 0);
      expect(alpha2.value, 50000);
      expect(alpha3.value, 100000);
    });

    test('Valid Alpha values should not throw an error.', () {
      expect(() => Alpha(0), returnsNormally);
      expect(() => Alpha(50000), returnsNormally);
      expect(() => Alpha(100000), returnsNormally);
    });

    test('Invalid Alpha values should throw an ArgumentError.', () {
      expect(() => Alpha(-1), throwsArgumentError);
      expect(() => Alpha(100001), throwsArgumentError);
    });

    test('Edge cases for Alpha values returns Normally.', () {
      expect(() => Alpha(Alpha.minAlpha), returnsNormally);
      expect(() => Alpha(Alpha.maxAlpha), returnsNormally);
    });
  });
}
