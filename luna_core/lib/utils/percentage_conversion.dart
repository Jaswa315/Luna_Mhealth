import 'package:flutter/material.dart';
import 'package:luna_core/units/display_pixel.dart';
import 'package:luna_core/units/percent.dart';
import 'package:luna_core/units/point.dart';

/// A utility class for converting normalized percentage points to display pixel coordinates.
class PercentageConversion {
  /// Converts a normalized [Point] into a [Point] of [DisplayPixel]s,
  /// based on the provided [containerSize].
  ///
  /// The [containerSize] represents the size of the screen or parent widget in display pixels.
  ///
  /// Example:
  /// ```dart
  /// Point point = Point(Percent(0.5), Percent(0.75));
  /// Size containerSize = Size(300, 600);
  /// Point displayPoint = PercentageConversion.updatePercentageToDisplayPixel(point, containerSize);
  /// // displayPoint.x = DisplayPixel(150), displayPoint.y = DisplayPixel(450)
  /// ```
  static Point updatePercentageToDisplayPixel(
    Point point,
    Size containerSize,
  ) {
    final displayX =
        DisplayPixel(containerSize.width * (point.x as Percent).value);
    final displayY =
        DisplayPixel(containerSize.height * (point.y as Percent).value);

    return Point(displayX, displayY);
  }
}
