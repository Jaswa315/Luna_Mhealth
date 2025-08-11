import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/utils/string_conversion.dart';

void main() {
  group('StringConversion', () {
    test('stringToUint8List converts string to Uint8List correctly', () {
      const testString = 'Hello, Luna!';
      final expected = Uint8List.fromList(testString.codeUnits);
      final result = StringConversion.stringToUint8List(testString);
      expect(result, expected);
    });

    test('uint8ListToString converts Uint8List to string correctly', () {
      final bytes = Uint8List.fromList('Hello, Luna!'.codeUnits);
      final result = StringConversion.uint8ListToString(bytes);
      expect(result, 'Hello, Luna!');
    });
  });
}
