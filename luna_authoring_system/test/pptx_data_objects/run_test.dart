import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/run.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_simple_type_text_font_size.dart';
import 'package:luna_authoring_system/pptx_data_objects/simple_type_text_underline_type.dart';

void main() {
  group('Tests for Run class', () {

    test('Constructor initializes with correct properties', () {
      final run1 = Run(
        languageID: Locale('en', 'US'),
        text: 'Sample text',
        fontSize: PptxSimpleTypeTextFontSize(1200),
        bold: false,
        italics: false,
        underlineType: SimpleTypeTextUnderlineType.none,
        color: Color(0xFF000000));

      expect(run1.languageID.languageCode, 'en');
      expect(run1.languageID.countryCode, 'US');
      expect(run1.languageCode, 'en-US');
      expect(run1.text, 'Sample text');
      expect(run1.fontSize.value, 1200);
      expect(run1.bold, false);
      expect(run1.italics, false);
      expect(run1.underlineType, SimpleTypeTextUnderlineType.none);
      expect(run1.color, Color(0xFF000000));
    });

    test('Constructor initializes with invalid languageID', () {
      final run = Run(languageID: Locale('xx', 'xx'),
      text: 'Sample text',
      fontSize: PptxSimpleTypeTextFontSize(1200),
      bold: false,
      italics: false,
      underlineType: SimpleTypeTextUnderlineType.dbl,
      color: Color(0xFF000000));
      
      expect(run.languageID.languageCode, 'xx');
      expect(run.languageID.countryCode, 'xx');
      expect(run.languageCode, 'xx-xx');
      expect(run.text, 'Sample text');
      expect(run.fontSize.value, 1200);
      expect(run.bold, false);
      expect(run.italics, false);
      expect(run.underlineType, SimpleTypeTextUnderlineType.dbl);
    });

    test('Constructor throws error from invalid font size(0)', () {
      expect(
        () => Run(
          languageID: Locale('en', 'US'),
          text: 'Sample text',
          fontSize: PptxSimpleTypeTextFontSize(0),
          bold: false,
          italics: false,
          underlineType: SimpleTypeTextUnderlineType.none,
          color: Color(0xFF000000)
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Constructor throws error when required parameters are missing', () {
      expect(
        () => Function.apply(Run.new, []),
        throwsA(isA<NoSuchMethodError>()),
      );
    });
  });
}