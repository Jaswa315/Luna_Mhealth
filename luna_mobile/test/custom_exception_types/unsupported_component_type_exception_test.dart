import 'package:flutter_test/flutter_test.dart';
import 'package:luna_mobile/custom_exception_types/unsupported_component_type_exception.dart';

void main() {
  test('UnsupportedRendererException constructs correctly', () {
    final exception = UnsupportedComponentTypeException(
      'UnsupportedComponent',
      ['LineComponent', 'TextComponent'],
      'Custom error message',
    );

    expect(exception.unsupportedComponentType, 'UnsupportedComponent');
    expect(exception.supportedComponentTypes, ['LineComponent', 'TextComponent']);
    expect(exception.message,
        'Custom error message');
  });

  test('UnsupportedRendererException default message', () {
    final exception = UnsupportedComponentTypeException(
      'UnsupportedComponent',
      ['LineComponent', 'TextComponent'],
    );

    expect(exception.message,
        'Component "UnsupportedComponent" is not supported. Supported component types for rendering: LineComponent, TextComponent');
  });
}