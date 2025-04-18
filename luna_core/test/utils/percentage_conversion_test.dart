import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/units/point.dart';
import 'package:luna_core/units/percent.dart';
import 'package:luna_core/units/display_pixel.dart';
import 'package:luna_core/utils/percentage_conversion.dart';

void main() {
  group('PercentageConversion Tests', () {
    test('Converts Point to display pixel Offset correctly', () {
      // Define test inputs
      final Point point = Point(Percent(0.5), Percent(0.75));
      final Size containerSize = const Size(400, 800);

      // Expected output
      final Offset expectedOffset =
          Offset(200.0, 600.0); // 0.5 * 400, 0.75 * 800

      // Run the conversion function
      final Point result = PercentageConversion.updatePercentageToDisplayPixel(
          point, containerSize);

      // Validate the results
      expect((result.x as DisplayPixel).value,
          closeTo(expectedOffset.dx, 0.00001));
      expect((result.y as DisplayPixel).value,
          closeTo(expectedOffset.dy, 0.00001));
    });

    test('Handles zero percentage values correctly', () {
      final Point point = Point(Percent(0.0), Percent(0.0));
      final Size containerSize = const Size(400, 800);

      final Offset expectedOffset = Offset(0.0, 0.0);
      final Point result = PercentageConversion.updatePercentageToDisplayPixel(
          point, containerSize);

      expect((result.x as DisplayPixel).value,
          closeTo(expectedOffset.dx, 0.00001));
      expect((result.y as DisplayPixel).value,
          closeTo(expectedOffset.dy, 0.00001));
    });

    test('Handles full percentage values correctly', () {
      final Point point = Point(Percent(1.0), Percent(1.0));
      final Size containerSize = const Size(400, 800);

      final Offset expectedOffset = Offset(400.0, 800.0);
      final Point result = PercentageConversion.updatePercentageToDisplayPixel(
          point, containerSize);

      expect((result.x as DisplayPixel).value,
          closeTo(expectedOffset.dx, 0.00001));
      expect((result.y as DisplayPixel).value,
          closeTo(expectedOffset.dy, 0.00001));
    });

    test('Handles different container sizes correctly', () {
      final Point point = Point(Percent(0.3), Percent(0.6));
      final Size containerSize = const Size(500, 1000);

      final Offset expectedOffset =
          Offset(150.0, 600.0); // 0.3 * 500, 0.6 * 1000
      final Point result = PercentageConversion.updatePercentageToDisplayPixel(
          point, containerSize);

      expect((result.x as DisplayPixel).value,
          closeTo(expectedOffset.dx, 0.00001));
      expect((result.y as DisplayPixel).value,
          closeTo(expectedOffset.dy, 0.00001));
    });
  });
}
