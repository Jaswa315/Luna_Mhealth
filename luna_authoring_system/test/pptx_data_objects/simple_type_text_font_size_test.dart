import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/simple_type_text_font_size.dart';

void main() {
  group('SimpleTypeTextFontSize Class Tests', () {
    test('SimpleTypeTextFontSize object stores valid value.', () {
      SimpleTypeTextFontSize fontSize1 = SimpleTypeTextFontSize(100);
      SimpleTypeTextFontSize fontSize2 = SimpleTypeTextFontSize(1200);
      SimpleTypeTextFontSize fontSize3 = SimpleTypeTextFontSize(40000);

      expect(fontSize1.value, 100);
      expect(fontSize2.value, 1200);
      expect(fontSize3.value, 40000);
    });

    test('Valid SimpleTypeTextFontSize values should not throw an error.', () {
      expect(() => SimpleTypeTextFontSize(100), returnsNormally);
      expect(() => SimpleTypeTextFontSize(1200), returnsNormally);
      expect(() => SimpleTypeTextFontSize(40000), returnsNormally);
    });

    test('Valid SimpleTypeTextFontSize values should throw an error.', () {
      expect(() => SimpleTypeTextFontSize(99), throwsArgumentError);
      expect(() => SimpleTypeTextFontSize(400001), throwsArgumentError);
    });
  });
}