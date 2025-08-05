import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/paragraph.dart';
import 'package:luna_authoring_system/pptx_data_objects/run.dart';
import 'package:luna_authoring_system/pptx_data_objects/textbody.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_simple_type_text_font_size.dart';
import 'package:luna_authoring_system/pptx_data_objects/simple_type_text_underline_type.dart';

void main() {
  group('Tests for Textbody class', () {
    test('Constructor initializes with single paragraph', () {
      final run1 = Run(languageID: Locale('en', 'us'), text: 'Hello', 
      fontSize: PptxSimpleTypeTextFontSize(1200), bold: false, italics: false, 
      underlineType: SimpleTypeTextUnderlineType.none);
      final paragraph1 = Paragraph(runs: [run1]);
      final textbody = Textbody(paragraphs: [paragraph1]);
      
      expect(textbody.paragraphs, hasLength(1));
      expect(textbody.paragraphs.first.runs.first.languageID, Locale('en', 'us'));
      expect(textbody.paragraphs.first.runs.first.text, 'Hello');
      expect(textbody.paragraphs.first.runs.first.fontSize.value, 1200);
      expect(textbody.paragraphs.first.runs.first.bold, false);
      expect(textbody.paragraphs.first.runs.first.italics, false);
      expect(textbody.paragraphs.first.runs.first.underlineType, SimpleTypeTextUnderlineType.none);
    });

    test('Constructor initializes with multiple paragraphs', () {
      final run1 = Run(languageID: Locale('en', 'us'), text: 'Hello', 
      fontSize: PptxSimpleTypeTextFontSize(1200), bold: false, italics: false, 
      underlineType: SimpleTypeTextUnderlineType.none);
      final run2 = Run(languageID: Locale('es', 'ES'), text: 'Hola', 
      fontSize: PptxSimpleTypeTextFontSize(1500), bold: true, italics: true, 
      underlineType: SimpleTypeTextUnderlineType.sng);
      final paragraph1 = Paragraph(runs: [run1]);
      final paragraph2 = Paragraph(runs: [run1, run2]);
      final emptyParagraph = Paragraph(runs: []);
      final textbody = Textbody(paragraphs: [paragraph1, emptyParagraph, paragraph2]);
      
      expect(textbody.paragraphs, hasLength(3));
      expect(textbody.paragraphs[0].runs.first.languageID, Locale('en', 'us'));
      expect(textbody.paragraphs[0].runs.first.text, 'Hello');
      expect(textbody.paragraphs[1].runs, isEmpty);
      expect(textbody.paragraphs[2].runs.first.languageID, Locale('en', 'us'));
      expect(textbody.paragraphs[2].runs.first.text, 'Hello');
      expect(textbody.paragraphs[2].runs.last.languageID, Locale('es', 'ES'));
      expect(textbody.paragraphs[2].runs.last.text, 'Hola');
    });

    test('Constructor throws error when required parameters are missing', () {
      expect(
        () => Function.apply(Textbody.new, []),
        throwsA(isA<NoSuchMethodError>()),
      );
    });
  });
}