import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/theme.dart';
import 'package:luna_core/utils/emu.dart';

void main() {
  group('Theme', () {
    test('should initialize with given themeId and empty thicknessMap', () {
      final theme = Theme(1);

      expect(theme.themeId, 1);
      expect(theme.thicknessMap, isEmpty);
    });

    test('should add thickness to the map', () {
      final theme = Theme(1);
      final emuValue = EMU(10);

      theme.addThickness(1, emuValue);

      expect(theme.thicknessMap[1], emuValue);
    });

    test('should get thickness from the map', () {
      final theme = Theme(1);
      final emuValue = EMU(10);

      theme.addThickness(1, emuValue);

      expect(theme.getThickness(1), emuValue);
    });

    test('should return default EMU value if key does not exist', () {
      final theme = Theme(1);

      expect(theme.getThickness(1).value, EMU(0).value);
    });
  });
}
