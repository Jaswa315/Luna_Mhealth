import 'package:flutter/material.dart';
import 'package:luna_core/models/components/text_component/text_part.dart';

/// A custom painter class for rendering text parts on a canvas.
/// This class extends `CustomPainter` and is used to draw text parts
/// with specified position, dimensions, and styles.
class TextPartPainter extends CustomPainter {
  /// The top-left position where the text should be drawn.
  final Offset topLeft;
  
  /// The width of the area in which the text should be drawn.
  final double width;
  
  /// The height of the area in which the text should be drawn.
  final double height;
 
  /// The list of text parts to be rendered.
  final List<TextPart> textParts;

  /// Creates a `TextPartPainter` with the specified position, dimensions,
  /// and text parts.
  TextPartPainter({
    required this.topLeft,
    required this.width,
    required this.height,
    required this.textParts,
  });

  /// Paints the text parts on the given canvas.
  /// This method is called whenever the `CustomPaint` widget needs to render
  /// or repaint its contents.
  @override
  void paint(Canvas canvas, Size size) {
    // Create text spans from text parts
    final textSpans = textParts.map((part) {
      return part.getTextSpan();
    }).toList();
    
    // Setup TextPainter with rich text
    final textPainter = TextPainter(
      text: TextSpan(children: textSpans),
      textDirection: TextDirection.ltr,
    );
    
    // Layout with constraints
    textPainter.layout(maxWidth: width);
    
    // Draw text
    textPainter.paint(canvas, Offset(topLeft.dx, topLeft.dy));
  }

  /// Determines whether the painter should repaint.
  /// Always returns `true`, meaning the canvas will be repainted whenever
  /// the parent widget is rebuilt.
  @override
  bool shouldRepaint(covariant TextPartPainter oldDelegate) {
    return true;
  }
}