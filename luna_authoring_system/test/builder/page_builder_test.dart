import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/builder/page_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/point_2d.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_core/models/page.dart';
import 'package:luna_core/models/components/component.dart';
import 'package:luna_core/utils/emu.dart';

/// **Mock ConnectionShape for Testing**
class MockConnectionShape extends ConnectionShape {
  MockConnectionShape()
      : super(
          width: EMU(100000),
          transform: Transform(
            Point2D(EMU(500000), EMU(500000)),
            Point2D(EMU(1000000), EMU(1000000)),
          ),
          isFlippedVertically: false,
        );
}

void main() {
  group('PageBuilder Tests', () {
    late PageBuilder builder;
    late int moduleWidth;
    late int moduleHeight;

    setUp(() {
      moduleWidth = 1920000;
      moduleHeight = 1080000;
      builder = PageBuilder(moduleWidth, moduleHeight);
    });

    test('Should create an empty page by default', () {
      final page = builder.build();
      expect(page.components, isEmpty);
    });

    test('Should add a single ConnectionShape component', () {
      final shape = MockConnectionShape();
      builder.addComponent(shape);

      final page = builder.build();

      expect(page.components.length, equals(1));
    });

    test('Should add multiple ConnectionShape components using buildPage()',
        () {
      final shapes = [
        MockConnectionShape(),
        MockConnectionShape(),
        MockConnectionShape()
      ];
      builder.buildPage(shapes);

      final page = builder.build();

      expect(page.components.length, equals(3));
    });

    test('Should not retain old components after calling buildPage()', () {
      final firstShapes = [MockConnectionShape()];
      builder.buildPage(firstShapes);
      expect(builder.build().components.length, equals(1));

      final newShapes = [MockConnectionShape(), MockConnectionShape()];
      builder.buildPage(newShapes);

      expect(builder.build().components.length,
          equals(2)); // Old components should be cleared
    });

    test('Should correctly build a page with ConnectionShape components', () {
      final shape1 = MockConnectionShape();
      final shape2 = MockConnectionShape();

      builder.addComponent(shape1).addComponent(shape2);

      final page = builder.build();

      expect(page.components.length, equals(2));
    });

    test('Should handle an empty ConnectionShape list without errors', () {
      builder.buildPage([]);

      final page = builder.build();

      expect(page.components, isEmpty);
    });
  });
}
