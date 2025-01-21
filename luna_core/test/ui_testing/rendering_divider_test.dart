import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/shape/divider_component.dart';
import 'package:luna_core/renderers/divider_component_renderer.dart';

void main() {
  testWidgets('DividerComponentRenderer creates a proper line',
      (WidgetTester tester) async {
    // Create dummy data for DividerComponent
    final DividerComponent dummyComponent = DividerComponent(
      x: 0.2, // 20% from the left
      y: 0.15, // 15% from the top
      width: 0.8, // 80% of the screen width
      height: 0.0, // Flat horizontal line
      thickness: 1.2, // 1.2 pixels thick
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
    expect(painter.startX, 160.0); // 0.2 * 800
    expect(painter.startY, 90.0); // 0.15 * 600
    expect(painter.endX, 640.0); // 0.8 * 800
    expect(painter.endY, 0.0); // Flat line
    expect(painter.thickness, 2.0);
    expect(painter.color, Colors.blue);
  });
}
