import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/run.dart';

void main() {
  group('Tests for Run class', () {
    // Test constants
    const lang = 'en-US';
    const text = 'Sample text';
    test('Constructor assigns values correctly', () {
      final run = Run(lang: lang, text: text);
      expect(run.lang, lang);
      expect(run.text, text);
    });

    test('Constructor throws error when required parameters are missing', () {
      expect(
        () => Function.apply(Run.new, []),
        throwsA(isA<NoSuchMethodError>()),
      );
    });
  });
}