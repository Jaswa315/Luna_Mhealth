import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/builder/component_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_authoring_system/pptx_data_objects/point_2d.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:luna_core/models/components/component.dart';
import 'package:luna_core/models/components/line_component.dart';
import 'package:luna_core/units/emu.dart';
import 'package:flutter/rendering.dart';

/// **Mock ConnectionShape for Testing**
class MockConnectionShape extends ConnectionShape {
  MockConnectionShape()
      : super(
          width: EMU(1000000),
          transform: Transform(
            Point2D(EMU(500000), EMU(500000)),
            Point2D(EMU(1000000), EMU(1000000)),
          ),
          isFlippedVertically: false,
        );
}

/// **Mock Unsupported Shape for Testing**
class MockUnsupportedShape extends Shape {
  @override
  ShapeType get type => ShapeType.textbox; //Not a ConnectionShape

  @override
  Transform get transform =>
      Transform(Point2D(EMU(0), EMU(0)), Point2D(EMU(0), EMU(0)));

  @override
  set transform(Transform transform) {}
}

void main() {
  group('ComponentBuilder Tests', () {
    late int moduleWidth;
    late int moduleHeight;

    setUp(() {
      moduleWidth = 1920;
      moduleHeight = 1080;
    });

    test('Should build a LineComponent from a ConnectionShape', () {
      final shape = MockConnectionShape();
      final component =
          ComponentBuilder(moduleWidth, moduleHeight, shape).build();

      expect(component, isA<LineComponent>());
    });

    test('Should throw an error if shape is not a ConnectionShape for now', () {
      final shape = MockUnsupportedShape();

      expect(
        () => ComponentBuilder(moduleWidth, moduleHeight, shape).build(),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Should correctly set start and end points from ConnectionShape', () {
      final shape = MockConnectionShape();
      final component = ComponentBuilder(moduleWidth, moduleHeight, shape)
          .build() as LineComponent;

      expect(component.startPoint, isNotNull);
      expect(component.endPoint, isNotNull);
    });

    test('Should correctly set thickness from ConnectionShape', () {
      final shape = MockConnectionShape();
      final component = ComponentBuilder(moduleWidth, moduleHeight, shape)
          .build() as LineComponent;

      expect(component.thickness, isNonZero);
    });

    test('Should correctly set color and style from ConnectionShape', () {
      final shape = MockConnectionShape();
      final component = ComponentBuilder(moduleWidth, moduleHeight, shape)
          .build() as LineComponent;

      expect(component.color, equals(shape.color));
      expect(component.style, equals(shape.style));
    });
  });
}
