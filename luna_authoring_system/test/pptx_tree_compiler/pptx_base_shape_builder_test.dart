import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_base_shape_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/transform/pptx_transform_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_core/utils/types.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../mocks/mock.mocks.dart';

void main() {
  final TestShapeBuilder shapeBuilder = TestShapeBuilder();
  const Json mockShapeMap = {"shape": "test"};
  const List<Json> mockShapeMapList = [mockShapeMap, mockShapeMap];

  test('Constructor properly initializes with transform builder', () {
    expect(shapeBuilder, isNotNull);
  });

  test('buildShape() returns a Shape instance', () {
    final shape = shapeBuilder.buildShape(mockShapeMap);
    expect(shape, isA<Shape>());
  });

  test('getShapes() handles Map input', () {
    expect(shapeBuilder.getShapes(mockShapeMap).length, 1);
  });

  test('getShapes() handles List input', () {
    expect(shapeBuilder.getShapes(mockShapeMapList).length, 2);
  });

  test('getShapes() throws on invalid input', () {
    expect(() => shapeBuilder.getShapes('invalid'), throwsException);
  });
}

// Test implementation of the abstract class
class TestShapeBuilder extends PptxBaseShapeBuilder<Shape> {

  @override
  Shape buildShape(Json shapeMap) => MockShape();
}