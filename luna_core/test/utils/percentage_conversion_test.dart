import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/units/point_2d_percentage.dart';
import 'package:luna_core/utils/percentage_conversion.dart';

void main() {
  group('PercentageConversion Tests', () {
    test('Converts Point2DPercentage to display pixel Offset correctly', () {
      // Define test inputs
      final Point2DPercentage point = Point2DPercentage(0.5, 0.75);
      final Size containerSize = const Size(400, 800);

      // Expected output
      final Offset expectedOffset =
          Offset(200.0, 600.0); // 0.5 * 400, 0.75 * 800

      // Run the conversion function
      final Offset result = PercentageConversion.updatePercentageToDisplayPixel(
          point, containerSize);

      // Validate the results
      expect(result.dx, closeTo(expectedOffset.dx, 0.00001));
      expect(result.dy, closeTo(expectedOffset.dy, 0.00001));
    });

    test('Handles zero percentage values correctly', () {
      final Point2DPercentage point = Point2DPercentage(0.0, 0.0);
      final Size containerSize = const Size(400, 800);

      final Offset expectedOffset = Offset(0.0, 0.0);
      final Offset result = PercentageConversion.updatePercentageToDisplayPixel(
          point, containerSize);

      expect(result.dx, closeTo(expectedOffset.dx, 0.00001));
      expect(result.dy, closeTo(expectedOffset.dy, 0.00001));
    });

    test('Handles full percentage values correctly', () {
      final Point2DPercentage point = Point2DPercentage(1.0, 1.0);
      final Size containerSize = const Size(400, 800);

      final Offset expectedOffset = Offset(400.0, 800.0);
      final Offset result = PercentageConversion.updatePercentageToDisplayPixel(
          point, containerSize);

      expect(result.dx, closeTo(expectedOffset.dx, 0.00001));
      expect(result.dy, closeTo(expectedOffset.dy, 0.00001));
    });

    test('Handles different container sizes correctly', () {
      final Point2DPercentage point = Point2DPercentage(0.3, 0.6);
      final Size containerSize = const Size(500, 1000);

      final Offset expectedOffset =
          Offset(150.0, 600.0); // 0.3 * 500, 0.6 * 1000
      final Offset result = PercentageConversion.updatePercentageToDisplayPixel(
          point, containerSize);

      expect(result.dx, closeTo(expectedOffset.dx, 0.00001));
      expect(result.dy, closeTo(expectedOffset.dy, 0.00001));
    });
  });
}
