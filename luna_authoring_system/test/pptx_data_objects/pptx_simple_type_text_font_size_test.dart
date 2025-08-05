import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_simple_type_text_font_size.dart';

void main() {
  group('PptxSimpleTypeTextFontSize Class Tests', () {
    test('PptxSimpleTypeTextFontSize object stores valid value.', () {
      PptxSimpleTypeTextFontSize fontSize1 = PptxSimpleTypeTextFontSize(100);
      PptxSimpleTypeTextFontSize fontSize2 = PptxSimpleTypeTextFontSize(1200);
      PptxSimpleTypeTextFontSize fontSize3 = PptxSimpleTypeTextFontSize(40000);

      expect(fontSize1.value, 100);
      expect(fontSize2.value, 1200);
      expect(fontSize3.value, 40000);
    });

    test('Valid SimpleTypeTextFontSize values should not throw an error.', () {
      expect(() => PptxSimpleTypeTextFontSize(100), returnsNormally);
      expect(() => PptxSimpleTypeTextFontSize(1200), returnsNormally);
      expect(() => PptxSimpleTypeTextFontSize(40000), returnsNormally);
    });

    test('Valid SimpleTypeTextFontSize values should throw an error.', () {
      expect(() => PptxSimpleTypeTextFontSize(99), throwsArgumentError);
      expect(() => PptxSimpleTypeTextFontSize(400001), throwsArgumentError);
    });
  });
}