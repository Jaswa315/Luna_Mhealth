import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/custom_exception_types/parent_shape_map_not_found_exception.dart';
import 'package:luna_authoring_system/custom_exception_types/placeholder_shape_not_found_exception.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_layout/pptx_slide_layout_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_layout/pptx_slide_layout_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/textbox_shape/pptx_textbox_shape_constants.dart' show eTextboxShape;
import 'package:luna_core/utils/types.dart';
import 'dart:io';

void main() {
  group('Text placeholder tests for 1 placeholder in slide layout - parentShapeMap is Map', () {
    final pptxFile = File('test/test_assets/1 textbox from placeholder in slide layout.pptx');
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
    PptxSlideLayoutParser pptxSlideLayoutParser = PptxSlideLayoutParser(pptxLoader);

    test('getPlaceholderShape returns correct placeholder shape for valid parent index and placeholder index', () {
      Json placeholderShape = pptxSlideLayoutParser.getPlaceholderShape(12, 11, eTextboxShape);

      expect(placeholderShape, isNotNull);
    });

    test('getPlaceholderShape throws exception for invalid placeholder index', () {
      PptxSlideLayoutParser pptxSlideLayoutParser = PptxSlideLayoutParser(pptxLoader);

      expect(
        () => pptxSlideLayoutParser.getPlaceholderShape(12, 0, eTextboxShape),
        throwsA(isA<PlaceholderShapeNotFoundException>()),
      );
    });

    test('getPlaceholderShape throws exception for invalid parent index', () {
      PptxSlideLayoutParser pptxSlideLayoutParser = PptxSlideLayoutParser(pptxLoader);

      expect(
        () => pptxSlideLayoutParser.getPlaceholderShape(0, 10, eTextboxShape),
        throwsException,
      );
    });

    test('getPlaceholderShape throws exception for invalid shapeType', () {
      PptxSlideLayoutParser pptxSlideLayoutParser = PptxSlideLayoutParser(pptxLoader);

      expect(
        () => pptxSlideLayoutParser.getPlaceholderShape(12, 10, 'nonExistentShapeType'),
        throwsA(isA<ParentShapeMapNotFoundException>()),
      );
    });
  });

  group('Text placeholder tests for multiple placeholders in slide layout - parentShapeMap is List', () {
    final pptxFile = File('test/test_assets/2 textbox from placeholder in slide layout.pptx');
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
    PptxSlideLayoutParser pptxSlideLayoutParser = PptxSlideLayoutParser(pptxLoader);

    test('getPlaceholderShape returns correct placeholder shape for valid parent index and placeholder index', () {
      Json placeholderShape1 = pptxSlideLayoutParser.getPlaceholderShape(12, 13, eTextboxShape);
      Json placeholderShape2 = pptxSlideLayoutParser.getPlaceholderShape(12, 14, eTextboxShape);

      expect(placeholderShape1, isNotNull);
      expect(placeholderShape2, isNotNull);
      
    });

    test('getPlaceholderShape throws exception for invalid placeholder index', () {
      PptxSlideLayoutParser pptxSlideLayoutParser = PptxSlideLayoutParser(pptxLoader);

      expect(
        () => pptxSlideLayoutParser.getPlaceholderShape(12, 0, eTextboxShape),
        throwsA(isA<PlaceholderShapeNotFoundException>()),
      );
    });

    test('getPlaceholderShape throws exception for invalid parent index', () {
      PptxSlideLayoutParser pptxSlideLayoutParser = PptxSlideLayoutParser(pptxLoader);

      expect(
        () => pptxSlideLayoutParser.getPlaceholderShape(0, 14, eTextboxShape),
        throwsException,
      );
    });

    test('getPlaceholderShape throws exception for invalid shapeType', () {
      PptxSlideLayoutParser pptxSlideLayoutParser = PptxSlideLayoutParser(pptxLoader);

      expect(
        () => pptxSlideLayoutParser.getPlaceholderShape(12, 10, 'nonExistentShapeType'),
        throwsA(isA<ParentShapeMapNotFoundException>()),
      );
    });
  });
}