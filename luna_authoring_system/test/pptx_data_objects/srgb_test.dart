import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/srgb.dart';

void main() {
  group('Tests for Srgb Class', () {
    test('Valid SRGB value should not throw an error', () {
      expect(() => Srgb('3E6EC2'), returnsNormally);
      expect(() => Srgb('FFFFFF'), returnsNormally);
      expect(() => Srgb('000000'), returnsNormally);
    });

    test('Strings shorter than length of 6 should throw an ArgumentError', () {
      expect(() => Srgb('00000'), throwsArgumentError);
      expect(() => Srgb('0000'), throwsArgumentError);
      expect(() => Srgb('000'), throwsArgumentError);
      expect(() => Srgb('00'), throwsArgumentError);
      expect(() => Srgb('0'), throwsArgumentError);
      expect(() => Srgb(''), throwsArgumentError);
    });

    test('Strings longer than length of 6 should throw an ArgumentError', () {
      expect(() => Srgb('0000000'), throwsArgumentError);
      expect(() => Srgb('00000000'), throwsArgumentError);
      expect(() => Srgb('000000000'), throwsArgumentError);
    });
    
    test('Strings containing invalid character should throw an ArgumentError', () {
      expect(() => Srgb('3E6ECG'), throwsArgumentError);
      expect(() => Srgb('12345Z'), throwsArgumentError); // Invalid character
    });
  });
}