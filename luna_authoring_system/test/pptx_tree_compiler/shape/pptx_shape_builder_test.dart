import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_hierarchy.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/connection_shape/pptx_connection_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/shape/pptx_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/shape/pptx_shape_constants.dart';
import 'package:luna_core/utils/types.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import '../../mocks/mock.mocks.dart';

void main() {
  late PptxShapeBuilder shapeBuilder;
  late MockPptxConnectionShapeBuilder mockConnectionShapeBuilder;
  late MockConnectionShape mockConnectionShape;
  late List<Shape> mockShapes;
  const int slideIndex = 1;
  const PptxHierarchy hierarchy = PptxHierarchy.slide;

  setUp(() {
    mockConnectionShape = MockConnectionShape();
    mockShapes = [mockConnectionShape];
    mockConnectionShapeBuilder = MockPptxConnectionShapeBuilder();
    when(mockConnectionShapeBuilder.getConnectionShapes(any))
        .thenReturn(mockShapes);
    shapeBuilder = PptxShapeBuilder(mockConnectionShapeBuilder);
  });

  group('PptxShapeBuilder Tests', () {
    test('getShapes returns an empty list when shapeTree is empty', () {
      Json shapeTree = {};
      List<Shape> shapes = shapeBuilder.getShapes(shapeTree, slideIndex, hierarchy);
      expect(shapes, isEmpty);
    });

    test('getShapes returns connection shapes when eConnectionShape is present',
        () {
      Json shapeTree = {
        eConnectionShape: [{}]
      };

      List<Shape> shapes = shapeBuilder.getShapes(shapeTree, slideIndex, hierarchy);

      expect(shapes.length, mockShapes.length);
      verify(mockConnectionShapeBuilder.getConnectionShapes(any)).called(1);
    });

    test('getShapes ignores unknown keys in the shapeTree', () {
      Json shapeTree = {'unknownKey': []};

      List<Shape> shapes = shapeBuilder.getShapes(shapeTree, slideIndex, hierarchy);

      expect(shapes.length, 0);
    });
  });
}
