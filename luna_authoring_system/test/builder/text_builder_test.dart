import 'dart:math';
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/builder/module_builder.dart';
import 'package:luna_authoring_system/builder/text_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/paragraph.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_simple_type_text_font_size.dart';
import 'package:luna_authoring_system/pptx_data_objects/run.dart';
import 'package:luna_authoring_system/pptx_data_objects/simple_type_text_underline_type.dart';
import 'package:luna_authoring_system/pptx_data_objects/textbody.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_core/models/components/text_component/text_component.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_core/units/percent.dart';
import 'package:luna_core/units/point.dart';
import 'package:mockito/mockito.dart';
import '../mocks/mock.mocks.dart';

void main() {
  group('TextBuilder Tests', () {
    test('Should build a TextComponent from a TextboxShape', () {
      final mockTextboxShape = MockTextboxShape();
      ModuleBuilder moduleBuilder = ModuleBuilder();
      moduleBuilder.setDimensions(EMU(5000000).value, EMU(3000000).value);

      when(mockTextboxShape.textbody).thenReturn(Textbody(
        paragraphs: [
          Paragraph(
            runs: [
              Run(
                text: 'Hello World',
                languageID: Locale('en', 'US'),
                fontSize: PptxSimpleTypeTextFontSize(1200),
                bold: false,
                italics: false,
                underlineType: SimpleTypeTextUnderlineType.none,
                color: Color(0xFF000000),
              ),
            ],
          ),
        ],
      ));

      when(mockTextboxShape.transform).thenReturn(Transform(
        Point(EMU(500000), EMU(500000)),
        Point(EMU(1000000), EMU(1000000)),
      ));

      final shape = mockTextboxShape;
      final textComponent = TextBuilder()
          .setTextChildren(shape)
          .setBoundingBox(shape)
          .build();

      expect(textComponent, isA<TextComponent>());
    });

    test('Should correctly set text children from TextboxShape', () {
      final mockTextboxShape = MockTextboxShape();
      ModuleBuilder moduleBuilder = ModuleBuilder();
      moduleBuilder.setDimensions(EMU(5000000).value, EMU(3000000).value);

      when(mockTextboxShape.textbody).thenReturn(Textbody(
        paragraphs: [
          Paragraph(
            runs: [
              Run(
                text: 'Hello World',
                languageID: Locale('en', 'US'),
                fontSize: PptxSimpleTypeTextFontSize(1200),
                bold: true,
                italics: true,
                underlineType: SimpleTypeTextUnderlineType.none,
                color: Color(0xFF000000),
              ),
              Run(
                text: 'Foo Bar',
                languageID: Locale('en', 'US'),
                fontSize: PptxSimpleTypeTextFontSize(1800),
                bold: false,
                italics: false,
                underlineType: SimpleTypeTextUnderlineType.sng,
                color: Color(0xFFC00000),
              ),
            ],
          ),
        ],
      ));

      when(mockTextboxShape.transform).thenReturn(Transform(
        Point(EMU(500000), EMU(500000)),
        Point(EMU(1000000), EMU(1000000)),
      ));

      final textComponent = TextBuilder()
          .setTextChildren(mockTextboxShape)
          .setBoundingBox(mockTextboxShape)
          .build();

      expect(textComponent.textChildren.length, 2);
      expect(textComponent.textChildren.first.text, 'Hello World');
      expect(textComponent.textChildren.first.fontSize, 12.0);
      expect(textComponent.textChildren.first.fontWeight, FontWeight.bold);
      expect(textComponent.textChildren.first.fontStyle, FontStyle.italic);
      expect(textComponent.textChildren.first.fontUnderline, TextDecoration.none);
      expect(textComponent.textChildren.first.color, Color(0xFF000000));
      expect(textComponent.textChildren.last.text, 'Foo Bar');
      expect(textComponent.textChildren.last.fontSize, 18.0);
      expect(textComponent.textChildren.last.fontWeight, FontWeight.normal);
      expect(textComponent.textChildren.last.fontStyle, FontStyle.normal);
      expect(textComponent.textChildren.last.fontUnderline, TextDecoration.underline);
      expect(textComponent.textChildren.last.color, Color(0xFFC00000));
    });

    test('Should correctly set bounding box from TextboxShape', () {
      final mockTextboxShape = MockTextboxShape();
      ModuleBuilder moduleBuilder = ModuleBuilder();
      moduleBuilder.setDimensions(EMU(5000000).value, EMU(3000000).value);

      when(mockTextboxShape.textbody).thenReturn(Textbody(
        paragraphs: [
          Paragraph(
            runs: [
              Run(
                text: 'Hello World',
                languageID: Locale('en', 'US'),
                fontSize: PptxSimpleTypeTextFontSize(1200),
                bold: false,
                italics: false,
                underlineType: SimpleTypeTextUnderlineType.none,
                color: Color(0xFF000000),
              ),
            ],
          ),
        ],
      ));

      when(mockTextboxShape.transform).thenReturn(Transform(
        Point(EMU(500000), EMU(500000)),
        Point(EMU(1000000), EMU(1000000)),
      ));

      final textComponent = TextBuilder()
          .setTextChildren(mockTextboxShape)
          .setBoundingBox(mockTextboxShape)
          .build();

      expect(textComponent.boundingBox, isNotNull);
      expect(textComponent.boundingBox.topLeftCorner.dx, 0.1);
      expect(textComponent.boundingBox.topLeftCorner.dy, 500000 / 3000000);
      expect((textComponent.boundingBox.width as Percent).value, 1000000 / 5000000);
      expect((textComponent.boundingBox.height as Percent).value, 1000000 / 3000000);
    });

    test('Should throw an error if build() is called before setting start and end points', () {
      final mockTextboxShape = MockTextboxShape();

      when(mockTextboxShape.textbody).thenReturn(Textbody(
        paragraphs: [
          Paragraph(
            runs: [
              Run(
                text: 'Hello World',
                languageID: Locale('en', 'US'),
                fontSize: PptxSimpleTypeTextFontSize(1200),
                bold: false,
                italics: false,
                underlineType: SimpleTypeTextUnderlineType.none,
                color: Color(0xFF000000),
              ),
            ],
          ),
        ],
      ));

      when(mockTextboxShape.transform).thenReturn(Transform(
        Point(EMU(500000), EMU(500000)),
        Point(EMU(1000000), EMU(1000000)),
      ));

      expect(
        () => TextBuilder()
          .setTextChildren(mockTextboxShape)
          .build(),
        throwsA(
          predicate((e) =>
              e is Error && e.toString().contains("LateInitializationError")),
        ),
      );
    });
  });
}