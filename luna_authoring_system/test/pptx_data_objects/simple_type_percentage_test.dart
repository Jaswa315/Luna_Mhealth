import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/simple_type_percentage.dart';

void main() {
  group('Alpha Class Tests', () {
    test('Alpha object stores valid value.', () {
      SimpleTypePercentage STPercentage1 = SimpleTypePercentage(0);
      SimpleTypePercentage STPercentage2 = SimpleTypePercentage(50000);
      SimpleTypePercentage STPercentage3 = SimpleTypePercentage(100000);

      expect(STPercentage1.value, 0);
      expect(STPercentage2.value, 50000);
      expect(STPercentage3.value, 100000);
    });

    test('Valid Alpha values should not throw an error.', () {
      expect(() => SimpleTypePercentage(0), returnsNormally);
      expect(() => SimpleTypePercentage(50000), returnsNormally);
      expect(() => SimpleTypePercentage(100000), returnsNormally);
    });

    test('Invalid Alpha values should throw an ArgumentError.', () {
      expect(() => SimpleTypePercentage(-1), throwsArgumentError);
      expect(() => SimpleTypePercentage(100001), throwsArgumentError);
    });

    test('Edge cases for Alpha values returns Normally.', () {
      expect(
          () => SimpleTypePercentage(
              SimpleTypePercentage.minSimpleTypePercentage),
          returnsNormally);
      expect(
          () => SimpleTypePercentage(
              SimpleTypePercentage.maxSimpleTypePercentage),
          returnsNormally);
    });
  });
}
