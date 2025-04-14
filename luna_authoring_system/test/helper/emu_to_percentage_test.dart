import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/helper/emu_conversions.dart';
import 'package:luna_core/units/emu.dart';

void main() {
  group('EmuToPercentage Tests', () {
    test('Updates EMU to percentage correctly with precise values', () {
      expect(EmuConversions.updateEmuToPercentage(EMU(5000000), EMU(30000000)),
          closeTo(0.16666, 0.00001));
      expect(EmuConversions.updateEmuToPercentage(EMU(0), EMU(10000000)),
          equals(0.0));
      expect(EmuConversions.updateEmuToPercentage(EMU(10000000), EMU(10000000)),
          equals(1.0));
    });

    test('Throws error when dividing by zero', () {
      expect(() => EmuConversions.updateEmuToPercentage(EMU(5000000), EMU(0)),
          throwsA(isA<ArgumentError>()));
    });

    test('Handles large EMU values correctly', () {
      expect(EmuConversions.updateEmuToPercentage(EMU(20000000), EMU(40000000)),
          closeTo(0.5, 0.00001));
      expect(EmuConversions.updateEmuToPercentage(EMU(7500000), EMU(15000000)),
          closeTo(0.5, 0.00001));
    });

    test('Handles small EMU values correctly', () {
      expect(EmuConversions.updateEmuToPercentage(EMU(1), EMU(3)),
          closeTo(0.33333, 0.00001));
      expect(EmuConversions.updateEmuToPercentage(EMU(1), EMU(6)),
          closeTo(0.16666, 0.00001));
      expect(EmuConversions.updateEmuToPercentage(EMU(0), EMU(2)), equals(0.0));
    });
  });
}
