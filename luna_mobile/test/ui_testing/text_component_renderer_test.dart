import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/components/text_component/text_component.dart';
import 'package:luna_core/models/components/text_component/text_part.dart';
import 'package:luna_core/units/percent.dart';
import 'package:luna_mobile/renderers/text_part_painter.dart';
import 'package:luna_mobile/renderers/text_component_renderer.dart';
import 'package:luna_core/units/bounding_box.dart';

class TestApp extends StatelessWidget {
  final TextComponent testComponent;

  const TestApp({super.key, required this.testComponent});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TextComponentRenderer()
            .renderComponent(testComponent, const Size(800, 600)),
      ),
    );
  }
}

void main() {
  testWidgets('TextComponentRenderer creates a proper text box',
      (WidgetTester tester) async {
    // Create test data for TextComponent with bounding box and text parts
    final TextComponent testComponent = TextComponent(
      boundingBox: BoundingBox(
        topLeftCorner: Offset(0, 0),
        width: Percent(0.5),
        height: Percent(0.5),
      ),
      textChildren: [
        TextPart(
          text: 'Hello, ',
          fontSize: 20,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
        ),
        TextPart(
          text: 'World!',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      ],
      // Optionally set other properties like backgroundColor, borderColor, etc.
    );

    // Render the TestApp with the test data
    await tester.pumpWidget(TestApp(testComponent: testComponent));

    // Find the specific CustomPaint widget with RichTextPainter
    final CustomPaint customPaint = tester.widget<CustomPaint>(
      find.byWidgetPredicate(
          (widget) => widget is CustomPaint && widget.painter is TextPartPainter),
    );

    // Extract the RichTextPainter and validate its properties
    final TextPartPainter painter = customPaint.painter as TextPartPainter;

    // Validate values
    expect((painter.topLeft.dx),
        closeTo(0, 0.001));
    expect((painter.topLeft.dy),
        closeTo(0, 0.001));
    expect((painter.width),
        closeTo(400.0, 0.001));
    expect((painter.height),
        closeTo(300.0, 0.001));
    expect(painter.textParts.length, 2);
    expect(painter.textParts[0].text, 'Hello, ');
    expect(painter.textParts[0].fontWeight, FontWeight.normal);
    expect(painter.textParts[0].fontStyle, FontStyle.normal);
    expect(painter.textParts[1].text, 'World!');
    expect(painter.textParts[1].fontWeight, FontWeight.bold);
    expect(painter.textParts[1].fontStyle, FontStyle.italic);
  });
}