import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/utils/emu.dart';

void main() {
  group('Tests for EMU', () {
    test('Argument error is thrown when input is negative', () async {
      expect(() => EMU(-1), throwsA(isArgumentError));
    });

    test('Value can be initialized with zero', () async {
      EMU emu = EMU(0);

      expect(emu.value, 0);
    });

    test('Value can be initialized with positive integer', () async {
      EMU emu = EMU(1);

      expect(emu.value, 1);
    });
  });
}
