import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/shape/divider_component.dart';
import 'package:luna_core/models/point/point_2d_percentage.dart';
import 'package:luna_core/renderers/divider_component_renderer.dart';
import 'package:luna_core/renderers/line_painter.dart';

void main() {
  testWidgets('DividerComponentRenderer creates a proper line',
      (WidgetTester tester) async {
    // Create dummy data for DividerComponent with start and end points
    final DividerComponent dummyComponent = DividerComponent(
      startPoint: Point2DPercentage(0.2, 0.15), // 20% from left, 15% from top
      endPoint: Point2DPercentage(0.8, 0.15), // 80% from left, 15% from top
      thickness: 2.0, // 2 pixels thick
      color: Colors.blue, // Blue line
    );

    // Render the DividerComponentRenderer with the dummy data
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DividerComponentRenderer()
              .renderComponent(dummyComponent, const Size(800, 600)),
        ),
      ),
    );

    // Find the specific CustomPaint widget with LinePainter
    final CustomPaint customPaint = tester.widget<CustomPaint>(
      find.byWidgetPredicate(
          (widget) => widget is CustomPaint && widget.painter is LinePainter),
    );

    // Extract the LinePainter and validate its properties
    final LinePainter painter = customPaint.painter as LinePainter;

    // Assert the properties of the line
    expect(painter.startX, closeTo(160.0, 0.00001)); // 0.2 * 800
    expect(painter.startY, closeTo(90.0, 0.00001)); // 0.15 * 600
    expect(painter.endX, closeTo(640.0, 0.00001)); // 0.8 * 800
    expect(painter.endY, closeTo(90.0, 0.00001)); // Horizontal line
    expect(painter.thickness, closeTo(2.0, 0.00001));
    expect(painter.color, Colors.blue);
  });
}
