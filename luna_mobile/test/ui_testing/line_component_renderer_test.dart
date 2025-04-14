import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/components/line_component.dart';
import 'package:luna_core/units/point_2d_percentage.dart';
import 'package:luna_mobile/renderers/line_component_renderer.dart';
import 'package:luna_mobile/renderers/line_painter.dart';

/// A test wrapper to render the `LineComponentRenderer`
class TestApp extends StatelessWidget {
  final LineComponent dummyComponent;

  const TestApp({super.key, required this.dummyComponent});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LineComponentRenderer()
            .renderComponent(dummyComponent, const Size(800, 600)),
      ),
    );
  }
}

void main() {
  testWidgets('LineComponentRenderer creates a proper line using Offset',
      (WidgetTester tester) async {
    // Create dummy data for LineComponent with start and end points
    final LineComponent dummyComponent = LineComponent(
      startPoint: Point2DPercentage(0.2, 0.15), // 20% from left, 15% from top
      endPoint: Point2DPercentage(0.8, 0.15), // 80% from left, 15% from top
      thickness: 2, // 2 pixels thick
      color: Colors.blue, // Blue line
      style: BorderStyle.solid,
    );

    // Render the TestApp with the dummy data
    await tester.pumpWidget(TestApp(dummyComponent: dummyComponent));

    // Find the specific CustomPaint widget with LinePainter
    final CustomPaint customPaint = tester.widget<CustomPaint>(
      find.byWidgetPredicate(
          (widget) => widget is CustomPaint && widget.painter is LinePainter),
    );

    // Extract the LinePainter and validate its properties
    final LinePainter painter = customPaint.painter as LinePainter;

    // Expected Offset positions
    final Offset expectedStart = Offset(160.0, 90.0); // 0.2 * 800, 0.15 * 600
    final Offset expectedEnd = Offset(640.0, 90.0); // 0.8 * 800, 0.15 * 600

    // Assert the properties of the line using Offset
    expect(painter.start, equals(expectedStart));
    expect(painter.end, equals(expectedEnd));
    expect(painter.thickness, closeTo(2, 0.00001));
    expect(painter.color, Colors.blue);
  });
}
