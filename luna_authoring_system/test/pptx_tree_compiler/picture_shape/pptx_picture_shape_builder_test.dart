import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/transform/pptx_transform_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/picture_shape.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/picture_shape/pptx_picture_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/relationship/pptx_relationship_parser.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_hierarchy.dart';
import 'dart:io';

void main() {
  group('Tests for a pptx file that has one picture in a slide', () {
    final pptxFile = File('test/test_assets/1 Picture.pptx');
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
    PptxPictureShapeBuilder pptxPictureShapeBuilder = PptxPictureShapeBuilder(
        PptxTransformBuilder(), PptxRelationshipParser(pptxLoader));

    test('getPictureShapes returns a list with one PictureShape', () {
      // Arrange
      final shapeTree =
          pptxLoader.getJsonFromPptx('ppt/slides/slide1.xml')['p:sld']['p:cSld']
              ['p:spTree']['p:pic'];
      pptxPictureShapeBuilder.slideIndex = 1;
      pptxPictureShapeBuilder.hierarchy = PptxHierarchy.slide;

      // Act
      final shapes = pptxPictureShapeBuilder.getPictureShapes(shapeTree);

      // Assert
      expect(shapes.length, 1);
      expect(shapes.first, isA<PictureShape>());
    });
  });

  group('Tests for a pptx file that has two pictures in a slide', () {
    final pptxFile = File('test/test_assets/2 Pictures.pptx');
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
    PptxPictureShapeBuilder pptxPictureShapeBuilder = PptxPictureShapeBuilder(
        PptxTransformBuilder(), PptxRelationshipParser(pptxLoader));

    test('getPictureShapes returns a list with two PictureShapes', () {
      // Arrange
      final shapeTree =
          pptxLoader.getJsonFromPptx('ppt/slides/slide1.xml')['p:sld']['p:cSld']
              ['p:spTree']['p:pic'];
      pptxPictureShapeBuilder.slideIndex = 1;
      pptxPictureShapeBuilder.hierarchy = PptxHierarchy.slide;

      // Act
      final shapes = pptxPictureShapeBuilder.getPictureShapes(shapeTree);

      // Assert
      expect(shapes.length, 2);
      expect(shapes[0], isA<PictureShape>());
      expect(shapes[1], isA<PictureShape>());
    });
  });

  group('Tests for a pptx file that has one picture in a slide layout', () {
    final pptxFile = File('test/test_assets/1 Picture in slide layout.pptx');
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
    PptxPictureShapeBuilder pptxPictureShapeBuilder = PptxPictureShapeBuilder(
        PptxTransformBuilder(), PptxRelationshipParser(pptxLoader));

    test('getPictureShapes returns a list with one PictureShape', () {
      // Arrange
      final shapeTree = pptxLoader.getJsonFromPptx(
              'ppt/slideLayouts/slideLayout1.xml')['p:sldLayout']['p:cSld']
          ['p:spTree']['p:pic'];
      pptxPictureShapeBuilder.slideIndex = 1;
      pptxPictureShapeBuilder.hierarchy = PptxHierarchy.slideLayout;

      // Act
      final shapes = pptxPictureShapeBuilder.getPictureShapes(shapeTree);

      // Assert
      expect(shapes.length, 1);
      expect(shapes.first, isA<PictureShape>());
    });
  });

  group('Tests for a pptx file that has one picture in a slide master', () {
    final pptxFile = File('test/test_assets/1 Picture in slide master.pptx');
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
    PptxPictureShapeBuilder pptxPictureShapeBuilder = PptxPictureShapeBuilder(
        PptxTransformBuilder(), PptxRelationshipParser(pptxLoader));

    test('getPictureShapes returns a list with one PictureShape', () {
      // Arrange
      final shapeTree = pptxLoader.getJsonFromPptx(
              'ppt/slideMasters/slideMaster1.xml')['p:sldMaster']['p:cSld']
          ['p:spTree']['p:pic'];
      pptxPictureShapeBuilder.slideIndex = 1;
      pptxPictureShapeBuilder.hierarchy = PptxHierarchy.slideMaster;

      // Act
      final shapes = pptxPictureShapeBuilder.getPictureShapes(shapeTree);

      // Assert
      expect(shapes.length, 1);
      expect(shapes.first, isA<PictureShape>());
    });
  });
}
