import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/shape/pptx_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/shape/pptx_shape_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_element_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_core/utils/types.dart';
import 'dart:io';

void main() {
  group('PptxShapeBuilder Tests', () {
    late PptxShapeBuilder shapeBuilder;
    late PptxXmlToJsonConverter pptxLoader;

    setUp(() {
      shapeBuilder = PptxShapeBuilder();
      pptxLoader = PptxXmlToJsonConverter(File('test/test_assets/A line.pptx'));
    });

        test('getShapes returns an empty list when shapeTree is empty', () {
      Json shapeTree = {};

      List<Shape> shapes = shapeBuilder.getShapes(shapeTree);

      expect(shapes, isEmpty);
    });

    test('getShapes returns connection shapes when eConnectionShape is present',
        () {
      Json shapeTree =
          pptxLoader.getJsonFromPptx("ppt/slides/slide1.xml")[eSlide]
              [eCommonSlideData][eShapeTree];

      List<Shape> shapes = shapeBuilder.getShapes(shapeTree);

      expect(shapes.length, 1);
      expect(shapes[0], isA<Shape>());
    });

    test('getShapes returns connection shapes when eConnectionShape is present',
        () {
      Json shapeTree =
          pptxLoader.getJsonFromPptx("ppt/slides/slide1.xml")[eSlide]
              [eCommonSlideData][eShapeTree];

      List<Shape> shapes = shapeBuilder.getShapes(shapeTree);

      expect(shapes.length, 1);
      expect(shapes[0], isA<Shape>());
    });

    test('getShapes ignores unknown keys in the shapeTree', () {
      Json shapeTree = {'unknownKey': []};

      List<Shape> shapes = shapeBuilder.getShapes(shapeTree);

      expect(shapes.length, 0);
    });
  });
}
