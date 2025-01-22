import 'package:flutter/material.dart';

/// A custom painter class for drawing a straight line on a canvas.
///
/// This class extends `CustomPainter` and is used to render a straight line
/// with specified start and end coordinates, thickness, and color. It is
/// particularly useful for custom graphical elements that cannot be
/// implemented with standard Flutter widgets.
class LinePainter extends CustomPainter {
  /// The X-coordinate of the starting point of the line.
  final double startX;

  /// The Y-coordinate of the starting point of the line.
  final double startY;

  /// The X-coordinate of the ending point of the line.
  final double endX;

  /// The Y-coordinate of the ending point of the line.
  final double endY;

  /// The thickness of the line, specified in pixels.
  final double thickness;

  /// The color of the line.
  final Color color;

  /// Creates a `LinePainter` with the specified start and end coordinates,
  /// thickness, and color.
  ///
  /// [startX], [startY], [endX], [endY], [thickness], and [color] must all
  /// be non-null and required.
  LinePainter({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.thickness,
    required this.color,
  });

  /// Paints the line on the given canvas.
  ///
  /// This method is called whenever the `CustomPaint` widget needs to render
  /// or repaint its contents. It uses the `Paint` object to define the line
  /// color, thickness, and style, and the `canvas.drawLine` method to draw
  /// the line between the specified start and end points.
  @override
  void paint(Canvas canvas, Size size) {
    debugPrint(
      "LinePainter: Start=($startX, $startY), End=($endX, $endY), Thickness=$thickness",
    );

    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(startX, startY),
      Offset(endX, endY),
      paint,
    );
  }

  /// Determines whether the painter should repaint.
  ///
  /// Always returns `true`, meaning the canvas will be repainted whenever
  /// the parent widget is rebuilt. This is useful for dynamic rendering
  /// where the line properties (e.g., coordinates, thickness, or color)
  /// might change over time.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint for dynamic rendering
  }
}
