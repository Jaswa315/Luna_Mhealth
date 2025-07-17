import 'package:luna_authoring_system/pptx_tree_compiler/connection_shape/pptx_connection_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/connection_shape/pptx_connection_shape_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/shape/pptx_shape_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide/pptx_slide_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/transform/pptx_transform_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_hierarchy.dart';
import 'package:luna_authoring_system/pptx_data_objects/section.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_core/utils/types.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import '../../mocks/mock.mocks.dart';

void main() {
  late PptxConnectionShapeBuilder pptxConnectionShapeBuilder;
  late MockPptxTransformBuilder mockPptxTransformBuilder;
  final MockTransform mockTransform = MockTransform();
  const Json mockTransformMap = {"": {}};
  const String mockSrgbColor = "FF0000";
  const String mockAlpha = "255";
  const String mockLineWidth = "6350";
  const Json mockRedConnectionShapeMap = {
    eShapeProperty: {
      eTransform: mockTransformMap,
      eLine: {
        eSolidFill: {
          eSrgbColor: {eValue: mockSrgbColor}
        },
        eAlpha: mockAlpha,
        eLineWidth: mockLineWidth
      }
    }
  };

  setUp(() {
    mockPptxTransformBuilder = MockPptxTransformBuilder();
    when(mockPptxTransformBuilder.getTransform(mockTransformMap))
        .thenReturn(mockTransform);
    pptxConnectionShapeBuilder =
        PptxConnectionShapeBuilder(mockPptxTransformBuilder);
  });

  test('Invalid connection shape amp returns Exception', () {
    int invalidConnectionShape = 1;

    expect(
        () => pptxConnectionShapeBuilder
            .getShapes(invalidConnectionShape),
        throwsA(isA<Exception>()));
  });

  test('A red line is parsed', () async {
    Json mockConnectionShapeMap = mockRedConnectionShapeMap;

    List<Shape> connectionShapes =
        pptxConnectionShapeBuilder.getShapes(mockConnectionShapeMap);
    ConnectionShape cShape = connectionShapes[0] as ConnectionShape;

    expect(connectionShapes.length, 1);
    expect(cShape.type, ShapeType.connection);
    expect(cShape.width.value, int.parse(mockLineWidth));
    expect(cShape.color.alpha, 1);
    expect(
        cShape.color.red, int.parse(mockSrgbColor.substring(0, 2), radix: 16));
    expect(cShape.color.green,
        int.parse(mockSrgbColor.substring(2, 4), radix: 16));
    expect(
        cShape.color.blue, int.parse(mockSrgbColor.substring(4, 6), radix: 16));
    expect(cShape.transform, mockTransform);
    verify(mockPptxTransformBuilder.getTransform(mockTransformMap));
  });

  test('Two red lines are parsed', () async {
    List<Json> mockConnectionShapeMap = [
      mockRedConnectionShapeMap,
      mockRedConnectionShapeMap,
    ];
    List<Shape> connectionShapes =
        pptxConnectionShapeBuilder.getShapes(mockConnectionShapeMap);
    ConnectionShape cShape = connectionShapes[0] as ConnectionShape;

    expect(connectionShapes.length, 2);
    expect(cShape.type, ShapeType.connection);
    expect(cShape.width.value, int.parse(mockLineWidth));
    expect(cShape.color.alpha, 1);
    expect(
        cShape.color.red, int.parse(mockSrgbColor.substring(0, 2), radix: 16));
    expect(cShape.color.green,
        int.parse(mockSrgbColor.substring(2, 4), radix: 16));
    expect(
        cShape.color.blue, int.parse(mockSrgbColor.substring(4, 6), radix: 16));
    expect(cShape.transform, mockTransform);
    verify(mockPptxTransformBuilder.getTransform(mockTransformMap));
  });
}
