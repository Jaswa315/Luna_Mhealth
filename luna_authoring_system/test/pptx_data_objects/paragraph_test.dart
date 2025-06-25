import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/paragraph.dart';
import 'package:luna_authoring_system/pptx_data_objects/run.dart';

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
    final run1 = Run(lang: lang1, text: text1);
    final run2 = Run(lang: lang2, text: text2);
    final run3 = Run(lang: lang3, text: text3);

    test('Constructor initializes with empty runs list', () {
      final paragraph = Paragraph(runs: []);
      expect(paragraph.runs, isEmpty);
    });

    test('Constructor initializes with single run', () {
      final paragraph = Paragraph(runs: [run1]);
      
      expect(paragraph.runs, hasLength(1));
      expect(paragraph.runs.first.lang, lang1);
      expect(paragraph.runs.first.text, text1);
    });

    test('Constructor initializes with multiple runs', () {
      final paragraph = Paragraph(runs: [run1, run2, run3]);
      
      expect(paragraph.runs, hasLength(3));
      expect(paragraph.runs[0].lang, lang1);
      expect(paragraph.runs[0].text, text1);
      expect(paragraph.runs[1].lang, lang2);
      expect(paragraph.runs[1].text, text2);
      expect(paragraph.runs[2].lang, lang3);
      expect(paragraph.runs[2].text, text3);
    });

    test('Constructor throws error when required parameters are missing', () {
      expect(
        () => Function.apply(Paragraph.new, []),
        throwsA(isA<NoSuchMethodError>()),
      );
    });
  });
}