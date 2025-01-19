import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/connection_shape.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/shape_type.dart';

void main() {
  group('Tests for ConnectionShape', () {
    test('The shape type of the connection shape is set by default.', (){
      ConnectionShape cShape = ConnectionShape();

      expect(cShape.type, ShapeType.connection);
    });
  });
}