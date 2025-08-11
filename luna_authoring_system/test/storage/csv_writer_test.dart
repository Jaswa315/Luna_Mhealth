import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/utils/string_conversion.dart';

void main() {
  test('StringConversion roundtrip conversion test', () {
    final testString = 'Hello, Luna!';
    
    // Convert to bytes
    final bytes = StringConversion.stringToUint8List(testString);
    
    // Convert back to string
    final result = StringConversion.uint8ListToString(bytes);
    
    // Validate roundtrip
    expect(result, testString);
  });
}
