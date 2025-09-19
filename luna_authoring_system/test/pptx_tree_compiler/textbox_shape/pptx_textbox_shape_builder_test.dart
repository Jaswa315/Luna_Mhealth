import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_hierarchy.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:luna_authoring_system/pptx_data_objects/textbox_shape.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/relationship/pptx_relationship_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_layout/pptx_slide_layout_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_master/pptx_slide_master_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/textbox_shape/pptx_textbox_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/textbox_shape/pptx_textbox_shape_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/transform/pptx_transform_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_simple_type_text_font_size.dart';
import 'package:luna_authoring_system/pptx_data_objects/simple_type_text_underline_type.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_core/utils/types.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/mock.mocks.dart';
import 'dart:io';

void main() {
  late PptxTextboxShapeBuilder pptxTextboxShapeBuilder;
  late MockPptxTransformBuilder mockPptxTransformBuilder;
  late MockPptxRelationshipParser mockPptxRelationshipParser;
  late MockPptxSlideLayoutParser mockPptxSlideLayoutParser;
  late MockPptxSlideMasterParser mockPptxSlideMasterParser;
  final MockTransform mockTransform = MockTransform();
  const Json mockTransformMap = {"": {}};
  const String mockText = "Hello World";
  const String mockText1 = "Foo";
  const String mockText2 = "Bar";
  const String englishLanguageCode = "en-US";

  const Json mockTextboxSingleTextRunShapeMap = {
      eNvSpPr: {
        eCNvPr: {
          eName: 'Text Placeholder 1',
        },
        eNvPr: {
        },
      },
      eShapeProperty: {
        eTransform: mockTransformMap,
      },
      eTextBody: {
        eP: {
          eR: {
              eRPr: {
                eLang: englishLanguageCode,
                eSz: '1800',
                eB: '1',
                eI: '1',
                eU: 'sng',
              },
              eT: mockText,
          },
        },
      },
    };

  setUp(() {
    mockPptxTransformBuilder = MockPptxTransformBuilder();
    when(mockPptxTransformBuilder.getTransform(mockTransformMap))
        .thenReturn(mockTransform);
    mockPptxRelationshipParser = MockPptxRelationshipParser();
    mockPptxSlideLayoutParser = MockPptxSlideLayoutParser();
    mockPptxSlideMasterParser = MockPptxSlideMasterParser();
    pptxTextboxShapeBuilder =
        PptxTextboxShapeBuilder(mockPptxTransformBuilder, mockPptxRelationshipParser, mockPptxSlideLayoutParser, mockPptxSlideMasterParser);
  });

  test('A text box shape with single paragraph and text run is parsed', () async {
    Json mockTextboxShapeMap = mockTextboxSingleTextRunShapeMap;

    List<Shape> textboxShapes =
        pptxTextboxShapeBuilder.getShapes(mockTextboxShapeMap);
    TextboxShape textboxShape = textboxShapes[0] as TextboxShape;

    expect(textboxShapes.length, 1);
    expect(textboxShape.type, ShapeType.textbox);
    expect(textboxShape.transform, mockTransform);
    expect(textboxShape.textbody.paragraphs.length, 1);
    expect(textboxShape.textbody.paragraphs[0].runs.length, 1);
    expect(textboxShape.textbody.paragraphs[0].runs[0].text, mockText);
    expect(textboxShape.textbody.paragraphs[0].runs[0].languageCode, englishLanguageCode);
    expect(textboxShape.textbody.paragraphs[0].runs[0].fontSize.value, 1800);
    expect(textboxShape.textbody.paragraphs[0].runs[0].bold, true);
    expect(textboxShape.textbody.paragraphs[0].runs[0].italics, true);
    expect(textboxShape.textbody.paragraphs[0].runs[0].underlineType, SimpleTypeTextUnderlineType.sng);
  });

  test('A text box shape with single paragraph and multiple text runs is parsed', () async {
    const Json mockTextboxMultiTextRunShapeMap = {
      eNvSpPr: {
        eCNvPr: {
          eName: 'Textbox 1',
        },
        eNvPr: {
        },
      },
      eShapeProperty: {
        eTransform: mockTransformMap,
      },
      eTextBody: {
        eP: {
          eR: [
            {
              eRPr: {
                eLang: englishLanguageCode,
                eSz: '1800',
              },
              eT: mockText1,
            },
            {
              eRPr: {
                eLang: englishLanguageCode,
                eSz: '1800',
                eU: 'dash',
              },
              eT: mockText2,
            },
          ],
        },
      },
    };
    Json mockTextboxShapeMap = mockTextboxMultiTextRunShapeMap;

    List<Shape> textboxShapes =
        pptxTextboxShapeBuilder.getShapes(mockTextboxShapeMap);
    TextboxShape textboxShape = textboxShapes[0] as TextboxShape;

    expect(textboxShape.textbody.paragraphs.length, 1);
    expect(textboxShape.textbody.paragraphs[0].runs.length, 2);
    expect(textboxShape.textbody.paragraphs[0].runs[0].text, mockText1);
    expect(textboxShape.textbody.paragraphs[0].runs[0].bold, false);
    expect(textboxShape.textbody.paragraphs[0].runs[0].italics, false);
    expect(textboxShape.textbody.paragraphs[0].runs[0].underlineType, SimpleTypeTextUnderlineType.none);
    expect(textboxShape.textbody.paragraphs[0].runs[1].text, mockText2);
    expect(textboxShape.textbody.paragraphs[0].runs[1].underlineType, SimpleTypeTextUnderlineType.dash);
  });

  test('A text box shape with multiple paragraphs and single text run is parsed', () async {
    const Json mockTextboxMultiParagraphShapeMap = {
      eNvSpPr: {
        eCNvPr: {
          eName: 'Textbox 1',
        },
        eNvPr: {
        },
      },
      eShapeProperty: {
        eTransform: mockTransformMap,
      },
      eTextBody: {
        eP: [
          {
            eR: {
              eRPr: {
                eLang: englishLanguageCode,
                eSz: '1200',
              },
              eT: mockText1,
            },
          },
          {
            eR: {
              eRPr: {
                eLang: englishLanguageCode,
                eSz: '1200',
              },
              eT: mockText2,
            },
          },
        ],
      },
    };
    Json mockTextboxShapeMap = mockTextboxMultiParagraphShapeMap;

    List<Shape> textboxShapes =
        pptxTextboxShapeBuilder.getShapes(mockTextboxShapeMap);
    TextboxShape textboxShape = textboxShapes[0] as TextboxShape;

    expect(textboxShape.textbody.paragraphs.length, 2);
    expect(textboxShape.textbody.paragraphs[0].runs.length, 1);
    expect(textboxShape.textbody.paragraphs[0].runs[0].text, mockText1);
    expect(textboxShape.textbody.paragraphs[1].runs.length, 1);
    expect(textboxShape.textbody.paragraphs[1].runs[0].text, mockText2);
  });

  test('2 text box shapes are parsed', () async {
    List<Json> mockTextboxShapeMap = [
      mockTextboxSingleTextRunShapeMap,
      mockTextboxSingleTextRunShapeMap,
    ];

    List<Shape> textboxShapes =
        pptxTextboxShapeBuilder.getShapes(mockTextboxShapeMap);
        
    expect(textboxShapes.length, 2);
  });

  test('A text box shape with empty paragraph is parsed', () async {
    const Json mockTextboxWithEmptyParagraphShapeMap = {
      eNvSpPr: {
        eCNvPr: {
          eName: 'Textbox 1',
        },
        eNvPr: {
        },
      },
      eShapeProperty: {
        eTransform: mockTransformMap,
      },
      eTextBody: {
        eP: [
          {
            eR: {
              eRPr: {
                eLang: englishLanguageCode,
                eSz: '1800',
              },
              eT: mockText,
            },
          },
          {
          },
        ],
      },
    };
    Json mockTextboxShapeMap = mockTextboxWithEmptyParagraphShapeMap;

    List<Shape> textboxShapes =
        pptxTextboxShapeBuilder.getShapes(mockTextboxShapeMap);
    TextboxShape textboxShape = textboxShapes[0] as TextboxShape;

    expect(textboxShapes.length, 1);
    expect(textboxShape.type, ShapeType.textbox);
    expect(textboxShape.transform, mockTransform);
    expect(textboxShape.textbody.paragraphs[1].runs.length, 0);
  });

  test('A text box shape from placeholder is parsed', () async {
    final pptxFile = File('test/test_assets/1 textbox from placeholder in slide layout.pptx');
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
    PptxTextboxShapeBuilder pptxTextboxShapeBuilder = PptxTextboxShapeBuilder(
        PptxTransformBuilder(), PptxRelationshipParser(pptxLoader), PptxSlideLayoutParser(pptxLoader), PptxSlideMasterParser(pptxLoader));

    final shapeTree = pptxLoader.getJsonFromPptx(
              'ppt/slides/slide1.xml')['p:sld']['p:cSld']
          ['p:spTree']['p:sp'];
      pptxTextboxShapeBuilder.slideIndex = 1;
      pptxTextboxShapeBuilder.hierarchy = PptxHierarchy.slide;

    final shapes = pptxTextboxShapeBuilder.getShapes(shapeTree);

    expect(shapes.length, 1);
    expect(shapes.first, isA<TextboxShape>());
    TextboxShape textboxShape = shapes.first as TextboxShape;
    expect(textboxShape.type, ShapeType.textbox);
    expect(textboxShape.textbody.paragraphs[0].runs[0].text, "Hello World");
    expect((textboxShape.transform.offset.x as EMU).value, 1274763);
    expect((textboxShape.transform.offset.y as EMU).value, 1644650);
    expect((textboxShape.transform.size.x as EMU).value, 2778125);
    expect((textboxShape.transform.size.y as EMU).value, 1081088);
  });

  group('Textbox shapes with default font sizes parsed', () {
    final pptxFile = File('test/test_assets/Text with default font sizes.pptx');
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
    PptxTextboxShapeBuilder pptxTextboxShapeBuilder = PptxTextboxShapeBuilder(
        PptxTransformBuilder(), PptxRelationshipParser(pptxLoader), PptxSlideLayoutParser(pptxLoader), PptxSlideMasterParser(pptxLoader));
    final shapeTree = pptxLoader.getJsonFromPptx(
              'ppt/slides/slide1.xml')['p:sld']['p:cSld']
          ['p:spTree']['p:sp'];
      pptxTextboxShapeBuilder.slideIndex = 1;
      pptxTextboxShapeBuilder.hierarchy = PptxHierarchy.slide;
    final shapes = pptxTextboxShapeBuilder.getShapes(shapeTree);

    test('A text box shape with default body font size is parsed', () async {
      TextboxShape textboxShape = shapes[0] as TextboxShape;
      expect(textboxShape.textbody.paragraphs[0].runs[0].text, "Placeholder Text");
      expect(textboxShape.textbody.paragraphs[0].runs[0].fontSize.value, 2800);
    });

    test('A text box shape with default other font size is parsed', () async {
      TextboxShape textboxShape = shapes[1] as TextboxShape;
      expect(textboxShape.textbody.paragraphs[0].runs[0].text, "Non-placeholder Text");
      expect(textboxShape.textbody.paragraphs[0].runs[0].fontSize.value, 1800);
    }); 
  });

<<<<<<< HEAD
  group('Textbox shapes with font colors parsed', () {
    final pptxFile = File('test/test_assets/Text with different font colors.pptx');
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
    PptxTextboxShapeBuilder pptxTextboxShapeBuilder = PptxTextboxShapeBuilder(
        PptxTransformBuilder(), PptxRelationshipParser(pptxLoader), PptxSlideLayoutParser(pptxLoader), PptxSlideMasterParser(pptxLoader));
    final shapeTree = pptxLoader.getJsonFromPptx(
              'ppt/slides/slide1.xml')['p:sld']['p:cSld']
          ['p:spTree']['p:sp'];
      pptxTextboxShapeBuilder.slideIndex = 1;
      pptxTextboxShapeBuilder.hierarchy = PptxHierarchy.slide;
    final shapes = pptxTextboxShapeBuilder.getShapes(shapeTree);

    test('A text box shape with red font color is parsed', () async {
      TextboxShape textboxShape = shapes[0] as TextboxShape;
      expect(textboxShape.textbody.paragraphs[0].runs[0].text, "Text with red font color");
      expect(textboxShape.textbody.paragraphs[0].runs[0].color, const Color(0xFFC00000));
    });

    test('A text box shape with blue font color is parsed', () async {
      TextboxShape textboxShape = shapes[1] as TextboxShape;
      expect(textboxShape.textbody.paragraphs[0].runs[0].text, "Text with blue font color");
      expect(textboxShape.textbody.paragraphs[0].runs[0].color, const Color(0xFF0070C0));
    }); 
=======
  test('A text box shape with empty text run is parsed', () async {
    const Json mockTextboxWithEmptyTextRunShapeMap = {
      eNvSpPr: {
        eCNvPr: {
          eName: 'Textbox 1',
        },
        eNvPr: {
        },
      },
      eShapeProperty: {
        eTransform: mockTransformMap,
      },
      eTextBody: {
        eP: [
          {
            eR: {
              eRPr: {
                eLang: englishLanguageCode,
                eSz: '1800',
              },
              eT: '',
            },
          },
        ],
      },
    };
    Json mockTextboxShapeMap = mockTextboxWithEmptyTextRunShapeMap;

    List<Shape> textboxShapes =
        pptxTextboxShapeBuilder.getShapes(mockTextboxShapeMap);
    TextboxShape textboxShape = textboxShapes[0] as TextboxShape;

    expect(textboxShape.textbody.paragraphs[0].runs[0].text, ' ');
>>>>>>> 9d468529a7190a31f527b83a3d709558442c68f3
  });
}