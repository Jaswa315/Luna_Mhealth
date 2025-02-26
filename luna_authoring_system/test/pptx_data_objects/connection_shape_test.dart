import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/rendering.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_authoring_system/pptx_data_objects/point_2d.dart';
import 'package:luna_core/utils/emu.dart';

void main() {
  bool isFlippedVertically = false;

  group('Tests for ConnectionShape', () {
    test('The shape type of the connection shape is set by default.', () {
      ConnectionShape cShape = ConnectionShape(
        transform: Transform(
          Point2D(EMU(0), EMU(0)),
          Point2D(EMU(0), EMU(0)),
        ),
        isFlippedVertically: isFlippedVertically,
      );

      expect(cShape.type, ShapeType.connection);
    });

    test('Width is set to default (6350 EMU) when not provided.', () {
      ConnectionShape cShape = ConnectionShape(
        transform: Transform(
          Point2D(EMU(0), EMU(0)),
          Point2D(EMU(0), EMU(0)),
        ),
        isFlippedVertically: isFlippedVertically,
      );

      expect(cShape.width.value, 6350);
    });

    test('Width is assigned correctly when provided.', () {
      ConnectionShape cShape = ConnectionShape(
        width: EMU(8000),
        transform: Transform(
          Point2D(EMU(0), EMU(0)),
          Point2D(EMU(0), EMU(0)),
        ),
        isFlippedVertically: isFlippedVertically,
      );

      expect(cShape.width.value, 8000);
    });

    test('Color is set to default (#000000) when not provided.', () {
      ConnectionShape cShape = ConnectionShape(
        transform: Transform(
          Point2D(EMU(0), EMU(0)),
          Point2D(EMU(0), EMU(0)),
        ),
        isFlippedVertically: isFlippedVertically,
      );

      expect(cShape.color,
          const Color.fromARGB(255, 0, 0, 0)); // Ensuring default color
    });

    test('Color is correctly assigned when provided.', () {
      ConnectionShape cShape = ConnectionShape(
        color: const Color.fromARGB(255, 10, 20, 30),
        transform: Transform(
          Point2D(EMU(0), EMU(0)),
          Point2D(EMU(0), EMU(0)),
        ),
        isFlippedVertically: isFlippedVertically,
      );

      expect(cShape.color, const Color.fromARGB(255, 10, 20, 30));
    });

    test('Style is set to default (solid) when not provided.', () {
      ConnectionShape cShape = ConnectionShape(
        transform: Transform(
          Point2D(EMU(0), EMU(0)),
          Point2D(EMU(0), EMU(0)),
        ),
        isFlippedVertically: isFlippedVertically,
      );

      expect(cShape.style, BorderStyle.solid);
    });

    test('Style is correctly assigned when set to solid.', () {
      ConnectionShape cShape = ConnectionShape(
        style: BorderStyle.solid,
        transform: Transform(
          Point2D(EMU(0), EMU(0)),
          Point2D(EMU(0), EMU(0)),
        ),
        isFlippedVertically: isFlippedVertically,
      );

      expect(cShape.style, BorderStyle.solid);
    });

    test('Style is correctly assigned when set to none.', () {
      ConnectionShape cShape = ConnectionShape(
        style: BorderStyle.none,
        transform: Transform(
          Point2D(EMU(0), EMU(0)),
          Point2D(EMU(0), EMU(0)),
        ),
        isFlippedVertically: isFlippedVertically,
      );

      expect(cShape.style, BorderStyle.none);
    });

    test('isFlippedVertically is correctly assigned.', () {
      ConnectionShape cShape = ConnectionShape(
        transform: Transform(
          Point2D(EMU(0), EMU(0)),
          Point2D(EMU(0), EMU(0)),
        ),
        isFlippedVertically: true, // Assigning true
      );

      expect(cShape.isFlippedVertically, true);
    });

    test('No error is thrown when all required parameters are provided.', () {
      expect(
        () => ConnectionShape(
          width: EMU(8000),
          color: const Color.fromARGB(255, 0, 0, 0),
          style: BorderStyle.solid,
          transform: Transform(
            Point2D(EMU(0), EMU(0)),
            Point2D(EMU(0), EMU(0)),
          ),
          isFlippedVertically: false,
        ),
        returnsNormally,
      );
    });

    test('Throws error when required parameters are missing.', () {
      expect(
        () => Function.apply(ConnectionShape.new, []),
        throwsA(isA<NoSuchMethodError>()),
      );
    });
  });
}
