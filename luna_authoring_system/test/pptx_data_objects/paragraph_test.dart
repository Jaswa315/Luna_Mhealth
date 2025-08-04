import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/paragraph.dart';
import 'package:luna_authoring_system/pptx_data_objects/run.dart';
import 'package:luna_authoring_system/pptx_data_objects/simple_type_text_font_size.dart';
import 'package:luna_authoring_system/pptx_data_objects/simple_type_text_underline_type.dart';

void main() {
  group('Tests for Paragraph class', () {
    // Test constants
    const lang1 = Locale('en', 'us');
    const text1 = 'Hello';
    const lang2 = Locale('es', 'ES');
    const text2 = 'Hola';
    const lang3 = Locale('fr', 'FR');
    const text3 = 'Bonjour';

    // Shared test runs
    final run1 = Run(languageID: lang1, text: text1, 
      fontSize: SimpleTypeTextFontSize(1200), bold: false, italics: false, 
      underlineType: SimpleTypeTextUnderlineType.none);
    final run2 = Run(languageID: lang2, text: text2, 
      fontSize: SimpleTypeTextFontSize(1500), bold: true, italics: true, 
      underlineType: SimpleTypeTextUnderlineType.sng);
    final run3 = Run(languageID: lang3, text: text3, 
      fontSize: SimpleTypeTextFontSize(1800), bold: false, italics: true, 
      underlineType: SimpleTypeTextUnderlineType.dbl);

    test('Constructor initializes with empty runs list', () {
      final paragraph = Paragraph(runs: []);
      expect(paragraph.runs, isEmpty);
    });

    test('Constructor initializes with single run', () {
      final paragraph = Paragraph(runs: [run1]);
      
      expect(paragraph.runs, hasLength(1));
      expect(paragraph.runs.first.languageID, lang1);
      expect(paragraph.runs.first.text, text1);
      expect(paragraph.runs.first.fontSize.value, 1200);
      expect(paragraph.runs.first.bold, false);
      expect(paragraph.runs.first.italics, false);
      expect(paragraph.runs.first.underlineType, SimpleTypeTextUnderlineType.none);
    });

    test('Constructor initializes with multiple runs', () {
      final paragraph = Paragraph(runs: [run1, run2, run3]);
      
      expect(paragraph.runs, hasLength(3));
      expect(paragraph.runs[0].languageID, lang1);
      expect(paragraph.runs[0].text, text1);
      expect(paragraph.runs[1].languageID, lang2);
      expect(paragraph.runs[1].text, text2);
      expect(paragraph.runs[2].languageID, lang3);
      expect(paragraph.runs[2].text, text3);
      expect(paragraph.runs[2].fontSize.value, 1800);
      expect(paragraph.runs[2].bold, false);
      expect(paragraph.runs[2].italics, true);
      expect(paragraph.runs[2].underlineType, SimpleTypeTextUnderlineType.dbl);
    });

    test('Constructor throws error when required parameters are missing', () {
      expect(
        () => Function.apply(Paragraph.new, []),
        throwsA(isA<NoSuchMethodError>()),
      );
    });
  });
}