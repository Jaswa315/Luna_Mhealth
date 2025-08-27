import 'package:flutter/material.dart';
import 'package:luna_core/models/components/text_component/text_part.dart';

class TextPartPainter extends CustomPainter {
  final Offset topLeft;
  final double width;
  final double height;
  final List<TextPart> textParts;

  TextPartPainter({
    required this.topLeft,
    required this.width,
    required this.height,
    required this.textParts,
  });

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

  @override
  bool shouldRepaint(covariant TextPartPainter oldDelegate) {
    return true;
  }
}