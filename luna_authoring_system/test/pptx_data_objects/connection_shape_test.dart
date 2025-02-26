import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_authoring_system/pptx_data_objects/point_2d.dart';
import 'package:luna_core/utils/emu.dart';

void main() {
  bool isFlippedVertically = false;

  group('Tests for ConnectionShape', () {
    test('The shape type of the connection shape is set by default.', () {
      EMU emu = EMU(0);

      ConnectionShape cShape = ConnectionShape(
        width: emu,
        transform: Transform(
          Point2D(emu, emu),
          Point2D(emu, emu),
        ),
        isFlippedVertically: isFlippedVertically,
      );

      expect(cShape.type, ShapeType.connection);
    });

    test('The shape property is set to default (1) if not provided.', () {
      ConnectionShape cShape = ConnectionShape(
        transform: Transform(
          Point2D(EMU(0), EMU(0)),
          Point2D(EMU(0), EMU(0)),
        ),
        isFlippedVertically: isFlippedVertically,
      );

      expect(cShape.shape, 1); // Ensuring default shape value is 1
    });

    test('Shape property is correctly assigned when provided.', () {
      ConnectionShape cShape = ConnectionShape(
        shape: 0, // Assigning a specific value
        transform: Transform(
          Point2D(EMU(0), EMU(0)),
          Point2D(EMU(0), EMU(0)),
        ),
        isFlippedVertically: isFlippedVertically,
      );

      expect(cShape.shape, 0); // Ensuring the assigned shape value persists
    });

    test('Transform properties are correctly initialized.', () {
      ConnectionShape cShape = ConnectionShape(
        transform: Transform(Point2D(EMU(0), EMU(1)), Point2D(EMU(2), EMU(3))),
        isFlippedVertically: isFlippedVertically,
      );

      expect(cShape.transform.offset.x.value, 0);
      expect(cShape.transform.offset.y.value, 1);
      expect(cShape.transform.size.x.value, 2);
      expect(cShape.transform.size.y.value, 3);
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

      expect(cShape.color, "#000000"); // Ensuring default color
    });

    test('Color is correctly assigned when provided.', () {
      ConnectionShape cShape = ConnectionShape(
        color: "#FF5733",
        transform: Transform(
          Point2D(EMU(0), EMU(0)),
          Point2D(EMU(0), EMU(0)),
        ),
        isFlippedVertically: isFlippedVertically,
      );

      expect(cShape.color, "#FF5733");
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

    test('An error is thrown when only one argument is given at CTOR.', () {
      expect(
        () => Function.apply(ConnectionShape.new, []),
        throwsA(isA<NoSuchMethodError>()),
      );
    });

    test('No error is thrown when all required parameters are provided.', () {
      expect(
        () => ConnectionShape(
          width: EMU(8000),
          color: "#123456",
          shape: 0,
          transform: Transform(
            Point2D(EMU(0), EMU(0)),
            Point2D(EMU(0), EMU(0)),
          ),
          isFlippedVertically: false,
        ),
        returnsNormally,
      );
    });
  });
}
