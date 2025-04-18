import 'package:flutter/material.dart';
import 'package:luna_core/units/display_pixel.dart';
import 'package:luna_core/units/point.dart';

/// A custom painter class for drawing a straight line on a canvas.
///
/// This class extends `CustomPainter` and is used to render a straight line
/// with specified start and end coordinates, thickness, and color.
class LinePainter extends CustomPainter {
  /// The starting point of the line as an `Offset`.
  final Point start;

  /// The ending point of the line as an `Offset`.
  final Point end;

  /// The thickness of the line, specified in pixels.
  final double thickness;

  /// The color of the line.
  final Color color;

  /// Creates a `LinePainter` with the specified start and end points,
  /// thickness, and color.
  ///
  /// [start], [end], [thickness], and [color] must all be non-null and required.
  LinePainter({
    required this.start,
    required this.end,
    required this.thickness,
    required this.color,
  });

  /// Paints the line on the given canvas.
  ///
  /// This method is called whenever the `CustomPaint` widget needs to render
  /// or repaint its contents.
  @override
  void paint(Canvas canvas, Size size) {
    final startX = (start.x as DisplayPixel).value;
    final startY = (start.y as DisplayPixel).value;
    final endX = (end.x as DisplayPixel).value;
    final endY = (end.y as DisplayPixel).value;

    debugPrint(
      "LinePainter: Start=($startX, $startY), End=($endX, $endY), Thickness=$thickness",
    );

    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
  }

  /// Determines whether the painter should repaint.
  ///
  /// Always returns `true`, meaning the canvas will be repainted whenever
  /// the parent widget is rebuilt.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint for dynamic rendering
  }
}
