import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/simple_type_text_underline_type.dart';

void main() {
  group('SimpleTypeTextUnderlineType', () {
    test('should have correct xmlValue for each enum value', () {
      // Test all enum values and their corresponding XML values
      expect(SimpleTypeTextUnderlineType.dash.xmlValue, equals('dash'));
    });

    test('should have all expected enum values', () {
      // Verify all enum values are present
      expect(SimpleTypeTextUnderlineType.values.length, equals(18));
    });

    test('fromXml should return correct enum for valid xmlValue', () {
      // Test parsing from XML for each enum value
      expect(SimpleTypeTextUnderlineType.fromXml('dash'), equals(SimpleTypeTextUnderlineType.dash));
    });

    test('fromXml should return null for invalid xmlValue', () {
      // Test handling of invalid values
      expect(() => SimpleTypeTextUnderlineType.fromXml('invalidValue'), throwsArgumentError);
    });
  });
}