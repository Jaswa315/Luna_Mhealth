import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/builder/line_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:luna_core/models/components/component.dart';
import 'package:luna_core/models/components/line_component.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_core/units/point.dart';
import 'package:flutter/rendering.dart';
import 'package:luna_authoring_system/builder/module_builder.dart';

/// **Mock ConnectionShape for Testing**
class MockConnectionShape extends ConnectionShape {
  MockConnectionShape()
      : super(
          width: EMU(1000000),
          transform: Transform(
            Point(EMU(500000), EMU(500000)),
            Point(EMU(1000000), EMU(1000000)),
          ),
          isFlippedVertically: false,
        );
}

void main() {
  group('LineBuilder Tests', () {
    setUp(() {
      ModuleBuilder moduleBuilder = ModuleBuilder();
      moduleBuilder.setDimensions(EMU(5000000).value, EMU(3000000).value);
    });

    test('Should build a LineComponent from a ConnectionShape', () {
      final shape = MockConnectionShape();
      final lineComponent = LineBuilder()
          .setStartAndEndPoints(shape)
          .setThickness(shape)
          .setColor(shape)
          .setStyle(shape)
          .build();

      expect(lineComponent, isA<LineComponent>());
    });

    test('Should correctly set start and end points from ConnectionShape', () {
      final shape = MockConnectionShape();
      final lineComponent = LineBuilder()
          .setStartAndEndPoints(shape)
          .setThickness(shape)
          .setColor(shape)
          .setStyle(shape)
          .build();

      expect(lineComponent.startPoint, isNotNull);
      expect(lineComponent.endPoint, isNotNull);
    });

    test('Should correctly set thickness from ConnectionShape', () {
      final shape = MockConnectionShape();
      final lineComponent = LineBuilder()
          .setStartAndEndPoints(shape)
          .setThickness(shape)
          .setColor(shape)
          .setStyle(shape)
          .build();

      expect(lineComponent.thickness, isNonZero);
    });

    test('Should correctly set color from ConnectionShape', () {
      final shape = MockConnectionShape();
      final lineComponent = LineBuilder()
          .setStartAndEndPoints(shape)
          .setThickness(shape)
          .setColor(shape)
          .setStyle(shape)
          .build();

      expect(lineComponent.color, equals(shape.color));
    });

    test('Should correctly set style from ConnectionShape', () {
      final shape = MockConnectionShape();
      final lineComponent = LineBuilder()
          .setStartAndEndPoints(shape)
          .setThickness(shape)
          .setColor(shape)
          .setStyle(shape)
          .build();

      expect(lineComponent.style, equals(shape.style));
    });

    test(
        'Should throw an error if build() is called before setting start and end points',
        () {
      final shape = MockConnectionShape();

      expect(
        () => LineBuilder()
            .setThickness(shape)
            .setColor(shape)
            .setStyle(shape)
            .build(),
        throwsA(
          predicate((e) =>
              e is Error && e.toString().contains("LateInitializationError")),
        ),
      );
    });
  });
}
