import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/run.dart';

void main() {
  group('Tests for Run class', () {
    // Test constants
    const englishUS = Locale('en', 'US');
    const invalidLanguageID = Locale('xx', 'xx');
    const testTextEnglish = 'Sample text';

    test('Constructor initializes with correct properties for lang and country code', () {
      final run = Run(languageID: englishUS, text: testTextEnglish);
      expect(run.languageID.languageCode, 'en');
      expect(run.languageID.countryCode, 'US');
      expect(run.languageCode, 'en-US');
      expect(run.text, testTextEnglish);
    });

    test('Constructor initializes with invalid languageID', () {
      final run = Run(languageID: invalidLanguageID, text: testTextEnglish);
      expect(run.languageID.languageCode, 'xx');
      expect(run.languageID.countryCode, 'xx');
      expect(run.languageCode, 'xx-xx');
      expect(run.text, testTextEnglish);
    });

    test('Constructor throws error when required parameters are missing', () {
      expect(
        () => Function.apply(Run.new, []),
        throwsA(isA<NoSuchMethodError>()),
      );
    });
  });
}