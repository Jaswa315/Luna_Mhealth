import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/run.dart';
import 'package:luna_authoring_system/pptx_data_objects/simple_type_text_font_size.dart';

void main() {
  group('Tests for Run class', () {
    // Test constants
    const englishUS = Locale('en', 'US');
    const invalidLanguageID = Locale('xx', 'xx');
    const testTextEnglish = 'Sample text';
    var validFontSize = SimpleTypeTextFontSize(1200);

    test('Constructor initializes with correct properties for lang and country code', () {
      final run1 = Run(
        languageID: englishUS,
        text: testTextEnglish,
        fontSize: validFontSize,
        bold: false,
        italics: false,
        underline: false);

      final run2 = Run(
        languageID: englishUS,
        text: testTextEnglish,
        fontSize: validFontSize,
        bold: true,
        italics: true,
        underline: true);

      expect(run1.languageID.languageCode, 'en');
      expect(run1.languageID.countryCode, 'US');
      expect(run1.languageCode, 'en-US');
      expect(run1.text, testTextEnglish);
      expect(run1.fontSize, validFontSize);
      expect(run1.bold, false);
      expect(run1.italics, false);
      expect(run1.underline, false);

      expect(run2.languageID.languageCode, 'en');
      expect(run2.languageID.countryCode, 'US');
      expect(run2.languageCode, 'en-US');
      expect(run2.text, testTextEnglish);
      expect(run2.fontSize, validFontSize);
      expect(run2.bold, true);
      expect(run2.italics, true);
      expect(run2.underline, true);
    });

    test('Constructor initializes with invalid languageID', () {
      final run = Run(languageID: invalidLanguageID,
      text: testTextEnglish,
      fontSize: validFontSize,
      bold: false,
      italics: false,
      underline: false);
      expect(run.languageID.languageCode, 'xx');
      expect(run.languageID.countryCode, 'xx');
      expect(run.languageCode, 'xx-xx');
      expect(run.text, testTextEnglish);
      expect(run.fontSize, validFontSize);
      expect(run.bold, false);
      expect(run.italics, false);
      expect(run.underline, false);
    });

    test('Constructor throws error from invalid font size(0)', () {
      expect(
        () => Run(
          languageID: englishUS,
          text: testTextEnglish,
          fontSize: SimpleTypeTextFontSize(0),
          bold: false,
          italics: false,
          underline: false,
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