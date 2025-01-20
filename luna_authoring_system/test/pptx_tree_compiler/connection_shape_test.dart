import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/connection_shape.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/shape_type.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/transform.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/point_2d.dart';
import 'package:luna_core/utils/emu.dart';

void main() {
  group('Tests for ConnectionShape', () {
    test('The shape type of the connection shape is set by default.', () {
      ConnectionShape cShape = ConnectionShape();

      expect(cShape.type, ShapeType.connection);
    });

    test('Transform can be updated through connection shape builder.', () {
      ConnectionShape cShape = ConnectionShape((b) => b
        ..transform = Transform((tb) => tb
              ..offset = Point2D((pb) => pb
                ..x = EMU((eb) => eb..value = 0).toBuilder()
                ..y = EMU((eb) => eb.value = 1).toBuilder()).toBuilder()
              ..size = Point2D((pb) => pb
                ..x = EMU((eb) => eb.value = 2).toBuilder()
                ..y = EMU((eb) => eb.value = 3).toBuilder()).toBuilder())
            .toBuilder());

      expect(cShape.transform?.offset?.x.value, 0);
      expect(cShape.transform?.offset?.y.value, 1);
      expect(cShape.transform?.size?.x.value, 2);
      expect(cShape.transform?.size?.y.value, 3);
    });
  });
}
