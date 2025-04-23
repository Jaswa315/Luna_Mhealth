import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/builder/component_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_core/units/point.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:luna_core/models/components/component.dart';
import 'package:luna_core/models/components/line_component.dart';
import 'package:luna_core/units/emu.dart';
import 'package:flutter/rendering.dart';
import 'package:luna_core/units/percent.dart';
import 'package:luna_core/units/display_pixel.dart';
import 'package:luna_authoring_system/builder/module_builder.dart';

/// **Mock ConnectionShape for Testing**
class MockConnectionShape extends ConnectionShape {
  MockConnectionShape()
      : super(
          width: EMU(12700 * 6), // 6pt width
          transform: Transform(
            Point(EMU(12700 * 1), EMU(12700 * 2)), // 1pt x, 2pt y offset
            Point(EMU(12700 * 3), EMU(12700 * 4)), // 3pt width, 4pt height
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
      Transform(Point(EMU(0), EMU(0)), Point(EMU(0), EMU(0)));

  @override
  set transform(Transform transform) {}
}

void main() {
  group('ComponentBuilder Tests', () {
    ModuleBuilder moduleBuilder = ModuleBuilder();

    setUp(() {
      moduleBuilder.setDimensions(EMU(1920).value, EMU(1080).value);
    });

    test('Should throw an error if shape is not a ConnectionShape for now', () {
      final shape = MockUnsupportedShape();

      expect(
        () => ComponentBuilder(shape).build(),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Should correctly set thickness from ConnectionShape', () {
      final shape = MockConnectionShape();
      final component = ComponentBuilder(shape).build() as LineComponent;

      expect(component.thickness, greaterThan(0));
    });

    test('Should correctly set color and style from ConnectionShape', () {
      final shape = MockConnectionShape();
      final component = ComponentBuilder(shape).build() as LineComponent;

      expect(component.color, equals(shape.color));
      expect(component.style, equals(shape.style));
    });
  });
}
