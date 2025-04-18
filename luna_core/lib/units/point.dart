import 'package:luna_core/units/i_dimension.dart';

class Point {
  /// Represents a point in a 2-dimensional space using dimension values such as Percent, EMU, or DisplayPixel.
  ///
  /// This class is used for defining the position of components in .pptx files or mobile UI layouts.
  ///
  /// ### Example Usage:
  ///
  /// Point point = Point(Percent(0.5), Percent(0.75));
  /// print("X: ${point.x}, Y: ${point.y}"); // Output: X: 0.5%, Y: 0.75%
  ///
  /// ### Constraints:
  /// - The dimensions provided must be valid implementations of IDimension.

  /// The x-coordinate represented as a dimension (e.g., Percent, EMU).
  final IDimension x;

  /// The y-coordinate represented as a dimension (e.g., Percent, EMU).
  final IDimension y;

  /// Private constructor ensures dimensions go through validation in the factory.
  const Point._(this.x, this.y);

  /// Constructor that accepts dimensions for x and y.
  factory Point(IDimension x, IDimension y) {
    return Point._(x, y);
  }
}
