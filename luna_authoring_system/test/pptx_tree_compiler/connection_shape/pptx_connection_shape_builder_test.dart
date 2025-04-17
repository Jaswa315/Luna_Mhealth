import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_element_constants.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/connection_shape/pptx_connection_shape_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/section.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/units/emu.dart';
import 'dart:io';

void main() {
  group('Tests for PptxTreeBuilder using A line.pptx', () {
    final pptxFile = File('test/test_assets/A line.pptx');
    PptxConnectionShapeBuilder pptxConnectionShapeBuilder =
        PptxConnectionShapeBuilder();
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);

    test('A line is parsed', () async {
      List<Shape> connectionShapes =
          pptxConnectionShapeBuilder.getConnectionShapes(
              await pptxLoader.getJsonFromPptx("ppt/slides/slide1.xml")[eSlide]
                  [eCommonSlideData][eShapeTree][eConnectionShape]);
      ConnectionShape cShape = connectionShapes[0] as ConnectionShape;

      expect(cShape.type, ShapeType.connection);
      expect(cShape.width.value, 6350);
      expect(cShape.transform.offset.x.value, 2655518);
      expect(cShape.transform.offset.y.value, 2580362);
      expect(cShape.transform.size.x.value, 2755726);
      expect(cShape.transform.size.y.value, 1929008);
      expect(cShape.isFlippedVertically, isTrue);
    });
  });

  group('Tests for PptxTreeBuilder using Empty slide with slideLayout.pptx',
      () {
    final pptxFile = File('test/test_assets/Empty slide with slideLayout.pptx');
    PptxConnectionShapeBuilder pptxConnectionShapeBuilder =
        PptxConnectionShapeBuilder();
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);

    test('A Red line is parsed', () async {
      List<Shape> connectionShapes = pptxConnectionShapeBuilder
          .getConnectionShapes(await pptxLoader.getJsonFromPptx(
                  "ppt/slideLayouts/slideLayout13.xml")[eSlideLayoutData]
              [eCommonSlideData][eShapeTree][eConnectionShape]);
      ConnectionShape cShape = connectionShapes[0] as ConnectionShape;

      expect(cShape.type, ShapeType.connection);
      expect(cShape.width.value, 19050);
      expect(cShape.transform.offset.x.value, 179189);
      expect(cShape.transform.offset.y.value, 645068);
      expect(cShape.transform.size.x.value, 3756423);
      expect(cShape.color.alpha, 255);
      expect(cShape.color.red, 255);
      expect(cShape.color.green, 0);
      expect(cShape.color.blue, 0);
      expect(cShape.isFlippedVertically, isFalse);
    });
  });
}
