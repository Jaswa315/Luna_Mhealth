import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/srgb_color.dart';

void main() {
  group('Tests for Srgb Class', () {
    test('SrgbColor object stores valid value', () {
      SrgbColor srgb1 = SrgbColor('3E6EC2');
      SrgbColor srgb2 = SrgbColor('FFFFFF');
      SrgbColor srgb3 = SrgbColor('000000');

      expect(srgb1.value, '3E6EC2');
      expect(srgb2.value, 'FFFFFF');
      expect(srgb3.value, '000000');
    });

    test('Valid SRGB value should not throw an error', () {
      expect(() => SrgbColor('3E6EC2'), returnsNormally);
      expect(() => SrgbColor('FFFFFF'), returnsNormally);
      expect(() => SrgbColor('000000'), returnsNormally);
    });

    test('Strings shorter than length of 6 should throw an ArgumentError', () {
      expect(() => SrgbColor('00000'), throwsArgumentError);
      expect(() => SrgbColor(''), throwsArgumentError);
    });

    test('Strings longer than length of 6 should throw an ArgumentError', () {
      expect(() => SrgbColor('0000000'), throwsArgumentError);
    });
    
    test('Strings containing invalid character should throw an ArgumentError', () {
      expect(() => SrgbColor('3E6ECG'), throwsArgumentError);
      expect(() => SrgbColor('12345Z'), throwsArgumentError); // Invalid character
    });
  });
}