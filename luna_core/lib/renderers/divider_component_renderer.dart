// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/material.dart';
import 'package:luna_core/models/shape/divider_component.dart';
import 'base_component_renderer.dart';

/// A renderer class for the DividerComponent.
class DividerComponentRenderer extends BaseComponentRenderer<DividerComponent> {
  @override
  Widget renderComponent(dynamic component, Size screenSize) {
    if (component is DividerComponent) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Dynamically calculate start and end positions based on current constraints
          final double startX = component.x * constraints.maxWidth;
          final double startY = component.y * constraints.maxHeight;
          final double endX = (component.width) * constraints.maxWidth;
          final double endY = (component.height) * constraints.maxHeight;

          final double thicknessInPixels =
              component.thickness; // Convert EMU to points

          return CustomPaint(
            painter: LinePainter(
              startX: startX,
              startY: startY,
              endX: endX,
              endY: endY,
              thickness: thicknessInPixels,
              color: component.color,
            ),
            size: Size(constraints.maxWidth, constraints.maxHeight),
          );
        },
      );
    } else {
      throw ArgumentError(
          'Invalid component type for DividerComponentRenderer');
    }
  }
}

/// A custom painter for drawing the line.
class LinePainter extends CustomPainter {
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final double thickness;
  final Color color;

  LinePainter({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.thickness,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint(
        "LinePainter: Start=($startX, $startY), End=($endX, $endY), Thickness=$thickness");

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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint for dynamic rendering
  }
}
