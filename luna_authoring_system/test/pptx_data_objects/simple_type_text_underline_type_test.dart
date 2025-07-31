import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/simple_type_text_underline_type.dart';

void main() {
  group('SimpleTypeTextUnderlineType', () {
    test('should have correct xmlValue for each enum value', () {
      // Test all enum values and their corresponding XML values
      expect(SimpleTypeTextUnderlineType.dash.xmlValue, equals('dash'));
      expect(SimpleTypeTextUnderlineType.dashHeavy.xmlValue, equals('dashHeavy'));
      expect(SimpleTypeTextUnderlineType.dashLong.xmlValue, equals('dashLong'));
      expect(SimpleTypeTextUnderlineType.dashLongHeavy.xmlValue, equals('dashLongHeavy'));
      expect(SimpleTypeTextUnderlineType.dbl.xmlValue, equals('dbl'));
      expect(SimpleTypeTextUnderlineType.dotDash.xmlValue, equals('dotDash'));
      expect(SimpleTypeTextUnderlineType.dotDashHeavy.xmlValue, equals('dotDashHeavy'));
      expect(SimpleTypeTextUnderlineType.dotDotDash.xmlValue, equals('dotDotDash'));
      expect(SimpleTypeTextUnderlineType.dotDotDashHeavy.xmlValue, equals('dotDotDashHeavy'));
      expect(SimpleTypeTextUnderlineType.dotted.xmlValue, equals('dotted'));
      expect(SimpleTypeTextUnderlineType.dottedHeavy.xmlValue, equals('dottedHeavy'));
      expect(SimpleTypeTextUnderlineType.heavy.xmlValue, equals('heavy'));
      expect(SimpleTypeTextUnderlineType.none.xmlValue, equals('none'));
      expect(SimpleTypeTextUnderlineType.sng.xmlValue, equals('sng'));
      expect(SimpleTypeTextUnderlineType.wavy.xmlValue, equals('wavy'));
      expect(SimpleTypeTextUnderlineType.wavyDbl.xmlValue, equals('wavyDbl'));
      expect(SimpleTypeTextUnderlineType.wavyHeavy.xmlValue, equals('wavyHeavy'));
      expect(SimpleTypeTextUnderlineType.words.xmlValue, equals('words'));
    });

    test('should have all expected enum values', () {
      // Verify all enum values are present
      expect(SimpleTypeTextUnderlineType.values.length, equals(18));
    });

    test('fromXml should return correct enum for valid xmlValue', () {
      // Test parsing from XML for each enum value
      expect(SimpleTypeTextUnderlineType.fromXml('dash'), equals(SimpleTypeTextUnderlineType.dash));
      expect(SimpleTypeTextUnderlineType.fromXml('dashHeavy'), equals(SimpleTypeTextUnderlineType.dashHeavy));
      expect(SimpleTypeTextUnderlineType.fromXml('dashLong'), equals(SimpleTypeTextUnderlineType.dashLong));
      expect(SimpleTypeTextUnderlineType.fromXml('dashLongHeavy'), equals(SimpleTypeTextUnderlineType.dashLongHeavy));
      expect(SimpleTypeTextUnderlineType.fromXml('dbl'), equals(SimpleTypeTextUnderlineType.dbl));
      expect(SimpleTypeTextUnderlineType.fromXml('dotDash'), equals(SimpleTypeTextUnderlineType.dotDash));
      expect(SimpleTypeTextUnderlineType.fromXml('dotDashHeavy'), equals(SimpleTypeTextUnderlineType.dotDashHeavy));
      expect(SimpleTypeTextUnderlineType.fromXml('dotDotDash'), equals(SimpleTypeTextUnderlineType.dotDotDash));
      expect(SimpleTypeTextUnderlineType.fromXml('dotDotDashHeavy'), equals(SimpleTypeTextUnderlineType.dotDotDashHeavy));
      expect(SimpleTypeTextUnderlineType.fromXml('dotted'), equals(SimpleTypeTextUnderlineType.dotted));
      expect(SimpleTypeTextUnderlineType.fromXml('dottedHeavy'), equals(SimpleTypeTextUnderlineType.dottedHeavy));
      expect(SimpleTypeTextUnderlineType.fromXml('heavy'), equals(SimpleTypeTextUnderlineType.heavy));
      expect(SimpleTypeTextUnderlineType.fromXml('none'), equals(SimpleTypeTextUnderlineType.none));
      expect(SimpleTypeTextUnderlineType.fromXml('sng'), equals(SimpleTypeTextUnderlineType.sng));
      expect(SimpleTypeTextUnderlineType.fromXml('wavy'), equals(SimpleTypeTextUnderlineType.wavy));
      expect(SimpleTypeTextUnderlineType.fromXml('wavyDbl'), equals(SimpleTypeTextUnderlineType.wavyDbl));
      expect(SimpleTypeTextUnderlineType.fromXml('wavyHeavy'), equals(SimpleTypeTextUnderlineType.wavyHeavy));
      expect(SimpleTypeTextUnderlineType.fromXml('words'), equals(SimpleTypeTextUnderlineType.words));
    });

    test('fromXml should return null for invalid xmlValue', () {
      // Test handling of invalid values
      expect(SimpleTypeTextUnderlineType.fromXml('invalid'), isNull);
      expect(SimpleTypeTextUnderlineType.fromXml(''), isNull);
    });
  });
}