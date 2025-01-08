import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/utils/emu.dart';

void main() {
  group('Tests for EMU', () {
    test('Argument error is thrown when input is negative', () async {
      expect(() => EMU((b) => b..value = -1), throwsA(isArgumentError));
    });

    test('Value can be initialized with zero', () async {
      EMU emu = EMU((b) => b..value = 0);

      expect(emu.value, 0);
    });

    test('Value can be initialized with positive integer', () async {
      EMU emu = EMU((b) => b..value = 1);

      expect(emu.value, 1);
    });
  });
}
