import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/paragraph.dart';
import 'package:luna_authoring_system/pptx_data_objects/run.dart';
import 'package:luna_authoring_system/pptx_data_objects/textbody.dart';

void main() {
  group('Tests for Textbody class', () {
    // Test constants
    const lang1 = Locale('en', 'us');
    const text1 = 'Hello';
    const lang2 = Locale('es', 'ES');
    const text2 = 'Hola';
    const lang3 = Locale('fr', 'FR');
    const text3 = 'Bonjour';

    // Shared test runs
    final run1 = Run(languageID: lang1, text: text1);
    final run2 = Run(languageID: lang2, text: text2);
    final run3 = Run(languageID: lang3, text: text3);

    // Shared test paragraphs
    final paragraph1 = Paragraph(runs: [run1]);
    final paragraph2 = Paragraph(runs: [run2, run3]);
    final emptyParagraph = Paragraph(runs: []);

    test('Constructor initializes with single paragraph', () {
      final textbody = Textbody(paragraphs: [paragraph1]);
      
      expect(textbody.paragraphs, hasLength(1));
      expect(textbody.paragraphs.first.runs.first.languageID, lang1);
      expect(textbody.paragraphs.first.runs.first.text, text1);
    });

    test('Constructor initializes with multiple paragraphs', () {
      final textbody = Textbody(paragraphs: [paragraph1, emptyParagraph, paragraph2]);
      
      expect(textbody.paragraphs, hasLength(3));
      expect(textbody.paragraphs[0].runs.first.languageID, lang1);
      expect(textbody.paragraphs[0].runs.first.text, text1);
      expect(textbody.paragraphs[1].runs, isEmpty);
      expect(textbody.paragraphs[2].runs.first.languageID, lang2);
      expect(textbody.paragraphs[2].runs.first.text, text2);
      expect(textbody.paragraphs[2].runs.last.languageID, lang3);
      expect(textbody.paragraphs[2].runs.last.text, text3);
    });

    test('Constructor throws error when required parameters are missing', () {
      expect(
        () => Function.apply(Textbody.new, []),
        throwsA(isA<NoSuchMethodError>()),
      );
    });
  });
}