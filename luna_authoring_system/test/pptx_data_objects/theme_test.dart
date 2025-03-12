import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/theme.dart';
import 'package:luna_core/utils/emu.dart';

void main() {
  group('Theme Class Unit Tests', () {
    test('Should initialize with given themeId and an empty thicknessMap', () {
      final theme = Theme(1);
      expect(theme.themeId, equals(1));
      expect(theme.hasThickness(1), isFalse);
    });

    test('Should add thickness value and retrieve it correctly', () {
      final theme = Theme(1);
      final emuValue = EMU(10);

      theme.setThickness(1, emuValue);
      expect(theme.getThickness(1).value, equals(emuValue.value));
    });

    test('Should return default EMU(0) when key does not exist', () {
      final theme = Theme(1);
      expect(theme.getThickness(100).value, equals(EMU(0).value));
    });

    test('Should check if a thickness key exists', () {
      final theme = Theme(1);
      final emuValue = EMU(15);

      theme.setThickness(2, emuValue);
      expect(theme.hasThickness(2), isTrue);
      expect(theme.hasThickness(99), isFalse);
    });

    test('Should remove thickness entry correctly', () {
      final theme = Theme(1);
      final emuValue = EMU(20);

      theme.setThickness(3, emuValue);
      expect(theme.hasThickness(3), isTrue);

      theme.removeThickness(3);
      expect(theme.hasThickness(3), isFalse);
      expect(theme.getThickness(3).value, equals(EMU(0).value));
    });

    /// **Edge Case Handling Tests**
    test('Should handle large values correctly', () {
      final theme = Theme(1);
      final largeValue = EMU(999999);

      theme.setThickness(5, largeValue);
      expect(theme.getThickness(5).value,
          equals(largeValue.value)); // Compare value
    });

    test('Should handle multiple insertions correctly', () {
      final theme = Theme(1);
      theme.setThickness(1, EMU(10));
      theme.setThickness(2, EMU(20));
      theme.setThickness(3, EMU(30));

      expect(theme.getThickness(1).value, equals(EMU(10).value));
      expect(theme.getThickness(2).value, equals(EMU(20).value));
      expect(theme.getThickness(3).value, equals(EMU(30).value));
    });

    test('Should update existing values correctly', () {
      final theme = Theme(1);
      theme.setThickness(1, EMU(10));
      expect(theme.getThickness(1).value, equals(EMU(10).value));

      theme.setThickness(1, EMU(50)); // Updating value
      expect(
          theme.getThickness(1).value, equals(EMU(50).value)); // Compare value
    });

    /// **Invalid Input Handling Tests**
    test(
        'Should throw exception when setting an invalid thickness (negative value)',
        () {
      final theme = Theme(1);
      expect(
          () => theme.setThickness(4, EMU(-5)), throwsA(isA<ArgumentError>()));
    });

    test(
        'Should throw exception when setting an invalid thickness (zero value)',
        () {
      final theme = Theme(1);
      expect(
          () => theme.setThickness(5, EMU(0)), throwsA(isA<ArgumentError>()));
    });

    test('Should handle bulk operations efficiently', () {
      final theme = Theme(1);

      for (int i = 1; i < 1000; i++) {
        theme.setThickness(i, EMU(i * 10));
      }

      for (int i = 1; i < 1000; i++) {
        expect(theme.getThickness(i).value,
            equals(EMU(i * 10).value)); // Compare value
      }
    });
  });
}
