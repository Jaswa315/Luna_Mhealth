import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/shape/divider_component.dart';
import 'package:luna_core/models/point/point_2d_percentage.dart';
import 'package:luna_mobile/renderers/divider_component_renderer.dart';
import 'package:luna_mobile/renderers/line_painter.dart';

/// A test wrapper to render the `DividerComponentRenderer`
class TestApp extends StatelessWidget {
  final DividerComponent dummyComponent;

  const TestApp({super.key, required this.dummyComponent});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: DividerComponentRenderer()
            .renderComponent(dummyComponent, const Size(800, 600)),
      ),
    );
  }
}

void main() {
  testWidgets('DividerComponentRenderer creates a proper line using Offset',
      (WidgetTester tester) async {
    // Create dummy data for DividerComponent with start and end points
    final DividerComponent dummyComponent = DividerComponent(
      startPoint: Point2DPercentage(0.2, 0.15), // 20% from left, 15% from top
      endPoint: Point2DPercentage(0.8, 0.15), // 80% from left, 15% from top
      thickness: 2, // 2 pixels thick
      color: Colors.blue, // Blue line
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
