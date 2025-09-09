import 'package:flutter/material.dart' hide Transform;
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/paragraph.dart';
import 'package:luna_authoring_system/pptx_data_objects/run.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:luna_authoring_system/pptx_data_objects/textbody.dart';
import 'package:luna_authoring_system/pptx_data_objects/textbox_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_core/units/point.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_simple_type_text_font_size.dart';
import 'package:luna_authoring_system/pptx_data_objects/simple_type_text_underline_type.dart';

void main() {
  group('Tests for Textbody class', () {
    // Test constants
    const lang = Locale('en', 'US');
    const text = 'Hello';

    // Shared test objects
    final run = Run(languageID: lang, text: text, 
      fontSize: PptxSimpleTypeTextFontSize(1200), bold: false, italics: false, 
      underlineType: SimpleTypeTextUnderlineType.none, color: Color(0xFF000000));
    final paragraph = Paragraph(runs: [run]);
    final textbody = Textbody(paragraphs: [paragraph]);
    final transform = Transform(
          Point(EMU(0), EMU(0)),
          Point(EMU(0), EMU(0)),
        );

    test('Constructor initializes properties correctly', () {
      final textbox = TextboxShape(transform: transform, textbody: textbody);
      
      expect(textbox.transform, equals(transform));
      expect(textbox.textbody, equals(textbody));
      expect(textbox.type, equals(ShapeType.textbox));
    });

    test('Constructor throws error when required parameters are missing', () {
      expect(
        () => Function.apply(TextboxShape.new, []),
        throwsA(isA<NoSuchMethodError>()),
      );
    });
  });
}