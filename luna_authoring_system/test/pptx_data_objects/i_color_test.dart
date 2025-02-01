import 'dart:ui' show Color;
import 'package:luna_authoring_system/pptx_data_objects/i_color.dart';
import 'package:flutter_test/flutter_test.dart';

class RedColor extends IColor {
  @override
  Color toColor() {
    return Color(0xFFFF5733);
  }

  RedColor() {
    this.color = toColor();
  }
}

void main() {
  group('Tests for Concrete color class', () {
    test('Concrete color class has color attribute', () {
      RedColor rColor = RedColor();

      expect(rColor.color, isA<Color>());
    });
  });
}
