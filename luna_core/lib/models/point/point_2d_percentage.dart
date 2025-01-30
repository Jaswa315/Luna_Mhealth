class Point2DPercentage {
  /// Represents a point in a 2-dimensional space using normalized coordinates (0 to 1).
  ///
  /// This class is primarily used for defining the relative position of shapes
  /// in .pptx files, where x and y values represent percentages of the total
  /// width and height, respectively.
  ///
  /// ### Example Usage:
  ///
  /// Point2DPercentage point = Point2DPercentage(0.5, 0.75);
  /// print("X: ${point.x}, Y: ${point.y}"); // Output: X: 0.5, Y: 0.75
  ///

  ///
  /// In this example:
  /// - x = 0.5 means the point is at 50% of the total width.
  /// - y = 0.75 means the point is at 75% of the total height.
  ///
  /// ### Constraints:
  /// - x and y must be between 0.0 and 1.0.
  /// - If values are out of range, an ArgumentError is thrown.

  /// The x-coordinate in the range [0,1], representing the horizontal position.
  ///
  /// - 0.0 represents the leftmost position.
  /// - 1.0 represents the rightmost position.
  /// - 0.5 means centered horizontally.
  final double x;

  /// The y-coordinate in the range [0,1], representing the vertical position.
  ///
  /// - 0.0 represents the topmost position.
  /// - 1.0 represents the bottommost position.
  /// - 0.75 places the point 75% down from the top.
  final double y;

  /// Creates a Point2DPercentage ensuring x and y are strictly within [0,1].
  ///
  /// Throws an ArgumentError if either value is out of range.
  Point2DPercentage(double x, double y)
      : x = (x < 0.0 || x > 1.0)
            ? throw ArgumentError.value(x, 'x', 'Must be between 0 and 1')
            : x,
        y = (y < 0.0 || y > 1.0)
            ? throw ArgumentError.value(y, 'y', 'Must be between 0 and 1')
            : y;
}
