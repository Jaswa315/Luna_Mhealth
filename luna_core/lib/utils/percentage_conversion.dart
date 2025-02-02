import 'package:flutter/material.dart';
import 'package:luna_core/models/point/point_2d_percentage.dart';

/// A utility class for converting normalized percentage points to display pixel coordinates.
class PercentageConversion {
  /// Converts a normalized [Point2DPercentage] into an absolute [Offset] in display pixels,
  /// based on the provided [containerSize].
  ///
  /// The [point] should have x and y values between 0 and 1. The [containerSize] represents
  /// the size of the screen or parent widget in display pixels.
  ///
  /// Example:
  /// ```dart
  /// Point2DPercentage point = Point2DPercentage(0.5, 0.75);
  /// Size containerSize = Size(300, 600);
  /// Offset displayPixels = PercentageConversion.updatePercentageToDisplayPixel(point, containerSize);
  /// // displayPixels is Offset(150, 450)
  /// ```
  static Offset updatePercentageToDisplayPixel(
    Point2DPercentage point,
    Size containerSize,
  ) {
    return Offset(
      point.x * containerSize.width,
      point.y * containerSize.height,
    );
  }
}
