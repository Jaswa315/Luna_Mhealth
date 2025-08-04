import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/paragraph.dart';
import 'package:luna_authoring_system/pptx_data_objects/run.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_simple_type_text_font_size.dart';
import 'package:luna_authoring_system/pptx_data_objects/simple_type_text_underline_type.dart';

void main() {
  group('Tests for Paragraph class', () {

    test('Constructor initializes with empty runs list', () {
      final paragraph = Paragraph(runs: []);
      expect(paragraph.runs, isEmpty);
    });

    test('Constructor initializes with single run', () {
      final run1 = Run(languageID: Locale('en', 'us'), text: 'Hello', 
        fontSize: PptxSimpleTypeTextFontSize(1200), bold: false, italics: false, 
        underlineType: SimpleTypeTextUnderlineType.none);
      final paragraph = Paragraph(runs: [run1]);
      
      expect(paragraph.runs, hasLength(1));
      expect(paragraph.runs.first.languageID, Locale('en', 'us'));
      expect(paragraph.runs.first.text, 'Hello');
      expect(paragraph.runs.first.fontSize.value, 1200);
      expect(paragraph.runs.first.bold, false);
      expect(paragraph.runs.first.italics, false);
      expect(paragraph.runs.first.underlineType, SimpleTypeTextUnderlineType.none);
    });

    test('Constructor initializes with multiple runs', () {
      final run1 = Run(languageID: Locale('es', 'ES'), text: 'Hola', 
        fontSize: PptxSimpleTypeTextFontSize(1500), bold: true, italics: true, 
        underlineType: SimpleTypeTextUnderlineType.sng);
      final run2 = Run(languageID: Locale('fr', 'FR'), text: 'Bonjour', 
        fontSize: PptxSimpleTypeTextFontSize(1800), bold: false, italics: true, 
        underlineType: SimpleTypeTextUnderlineType.dbl);
      final paragraph = Paragraph(runs: [run1, run2]);
      
      expect(paragraph.runs, hasLength(2));
      expect(paragraph.runs[0].languageID, Locale('es', 'ES'));
      expect(paragraph.runs[0].text, 'Hola');
      expect(paragraph.runs[1].languageID, Locale('fr', 'FR'));
      expect(paragraph.runs[1].text, 'Bonjour');
      expect(paragraph.runs[1].fontSize.value, 1800);
      expect(paragraph.runs[1].bold, false);
      expect(paragraph.runs[1].italics, true);
      expect(paragraph.runs[1].underlineType, SimpleTypeTextUnderlineType.dbl);
    });

    test('Constructor throws error when required parameters are missing', () {
      expect(
        () => Function.apply(Paragraph.new, []),
        throwsA(isA<NoSuchMethodError>()),
      );
    });
  });
}