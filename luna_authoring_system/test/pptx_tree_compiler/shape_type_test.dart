import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/shape_type.dart';

void main() {
  group('Tests for ShapeType', () {
    test('ShapeType.values returns ShapeTypes that we want in luna.',
        () async {
      expect(ShapeType.values.toSet(),
          {ShapeType.picture, ShapeType.connection, ShapeType.textbox});
    });

    test('ShapeType.name matches the expected value.', ()async{
      expect(ShapeType.picture.name, 'picture');
      expect(ShapeType.connection.name, 'connection');
      expect(ShapeType.textbox.name, 'textbox');
    });
  });
}
