import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/builder/page_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_core/units/point.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/components/component.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_authoring_system/builder/module_builder.dart';

/// **Mock ConnectionShape for Testing**
class MockConnectionShape extends ConnectionShape {
  MockConnectionShape()
      : super(
          width: EMU(100000),
          transform: Transform(
            Point(EMU(500000), EMU(500000)),
            Point(EMU(1000000), EMU(1000000)),
          ),
          isFlippedVertically: false,
        );
}

void main() {
  group('PageBuilder Tests', () {
    late PageBuilder builder;
    ModuleBuilder moduleBuilder = ModuleBuilder();

    setUp(() {
      moduleBuilder.setDimensions(EMU(1920000).value, EMU(1080000).value);
      builder = PageBuilder();
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
      final slideNumber = 1;
      builder.buildPage(shapes, slideNumber);

      final page = builder.build();

      expect(page.components.length, equals(3));
    });

    test('Should not retain old components after calling buildPage()', () {
      final firstShapes = [MockConnectionShape()];
      final slideNumber = 1;
      builder.buildPage(firstShapes, slideNumber);
      expect(builder.build().components.length, equals(1));

      final newShapes = [MockConnectionShape(), MockConnectionShape()];
      builder.buildPage(newShapes, slideNumber);

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

    test('Should build a page with the correct slide number', () {
      final shapes = [MockConnectionShape()];
      final slideNumber = 1;
      builder.buildPage(shapes, slideNumber);

      final page = builder.build();

      expect(page.slideNumber, equals(slideNumber));
    });

    test('Should handle an empty ConnectionShape list without errors', () {
      builder.buildPage([], 1);

      final page = builder.build();

      expect(page.components, isEmpty);
    });
  });
}
