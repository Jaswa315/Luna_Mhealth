import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/components/line_component.dart';
import 'package:luna_mobile/custom_exception_types/unsupported_component_type_exception.dart';
import 'package:luna_mobile/renderers/line_component_renderer.dart';
import 'package:luna_mobile/renderers/renderer_factory.dart';

void main() {
  group('renderer factory s', () {
    test('getRenderer returns correct renderer for supported component type', () {
      final componentType = LineComponent;
      final renderer = RendererFactory.getRenderer(componentType);

      expect(renderer, isA<LineComponentRenderer>());
    });

    test('getRenderer throws UnsupportedComponentTypeException for unsupported component type', () {
      final componentType = String; // Using String as an unsupported type

      expect(
        () => RendererFactory.getRenderer(componentType),
        throwsA(isA<UnsupportedComponentTypeException>()),
      );
    });
  });
}