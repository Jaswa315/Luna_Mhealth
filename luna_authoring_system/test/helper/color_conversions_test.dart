import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/helper/color_conversions.dart';
import 'package:luna_authoring_system/pptx_data_objects/alpha.dart';
import 'package:luna_authoring_system/pptx_data_objects/srgb_color.dart';

void main() {
  group('ColorConversions Tests', () {
    test('Valid SrgbColor and Alpha should return correct Color', () {
      // Test case 1: Fully opaque blue
      SrgbColor srgbColor1 = SrgbColor('0000FF'); // Blue
      Alpha alpha1 = Alpha(100000); // Fully opaque
      Color result1 = ColorConversions.updateSrgbColorAndAlphaToFlutterColor(srgbColor1, alpha1);
      expect(result1, const Color.fromARGB(255, 0, 0, 255));

      // Test case 2: 50% transparent red
      SrgbColor srgbColor2 = SrgbColor('FF0000'); // Red
      Alpha alpha2 = Alpha(50000); // 50% opacity
      Color result2 = ColorConversions.updateSrgbColorAndAlphaToFlutterColor(srgbColor2, alpha2);
      expect(result2, const Color.fromARGB(128, 255, 0, 0));

      // Test case 3: Fully transparent green
      SrgbColor srgbColor3 = SrgbColor('00FF00'); // Green
      Alpha alpha3 = Alpha(0); // Fully transparent
      Color result3 = ColorConversions.updateSrgbColorAndAlphaToFlutterColor(srgbColor3, alpha3);
      expect(result3, const Color.fromARGB(0, 0, 255, 0));
    });
  });
}