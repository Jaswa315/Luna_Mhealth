import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_authoring_system/pptx_data_objects/point_2d.dart';
import 'package:luna_core/utils/emu.dart';

void main() {
  group('Tests for ConnectionShape', () {
    test('The shape type of the connection shape is set by default.', () {
      EMU emu = EMU(0);
      ConnectionShape cShape = ConnectionShape(
        emu,
        Transform(Point2D(emu, emu), Point2D(emu, emu)),
      );

      expect(cShape.type, ShapeType.connection);
    });

    test('Transform can be updated with transform class.', () {
      ConnectionShape cShape = ConnectionShape(
        EMU(0),
        Transform(Point2D(EMU(0), EMU(1)), Point2D(EMU(2), EMU(3))),
      );

      expect(cShape.transform?.offset?.x.value, 0);
      expect(cShape.transform?.offset?.y.value, 1);
      expect(cShape.transform?.size?.x.value, 2);
      expect(cShape.transform?.size?.y.value, 3);
    });

    test(
        'An error is thrown when weight and transform are not initialzed at CTOR.',
        () {
      expect(
        () => Function.apply(ConnectionShape.new, []),
        throwsA(isA<NoSuchMethodError>()),
      );
    });

    test('An error is thrown when only one argument is given at CTOR.', () {
      expect(
        () => Function.apply(ConnectionShape.new, []),
        throwsA(isA<NoSuchMethodError>()),
      );
    });
  });
}
