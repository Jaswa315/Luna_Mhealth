import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/point_2d.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_authoring_system/helper/line_positioner.dart';
import 'package:luna_core/models/components/line_component.dart';
import 'package:luna_core/models/point/point_2d_percentage.dart';
import 'package:luna_core/utils/emu.dart';

void main() {
  group('StartEndPointPositioner Tests', () {
    test('Computes correct start and end points from ConnectionShape', () {
      // Mock slide dimensions
      int slideWidth = 5000000;
      int slideHeight = 3000000;

      // Mock connection shape
      ConnectionShape connectionShape = ConnectionShape(
        width: EMU(50000), // Width of the connection
        transform: Transform(
          Point2D(EMU(1000000), EMU(500000)), // Offset
          Point2D(EMU(2000000), EMU(1000000)), // Size
        ),
        isFlippedVertically: false, // Not flipped vertically
      );

      // Get computed start and end points
      final points = LinePositioner.getStartAndEndPoints(
          connectionShape, slideWidth, slideHeight);

      // Expected values in percentage
      double expectedStartX = 1000000 / 5000000; // 0.2
      double expectedStartY = 500000 / 3000000; // 0.1667
      double expectedEndX = (1000000 + 2000000) / 5000000; // 0.6
      double expectedEndY = (500000 + 1000000) / 3000000; // 0.5

      // Assertions
      expect(points['startPoint']!.x, closeTo(expectedStartX, 0.0001));
      expect(points['startPoint']!.y, closeTo(expectedStartY, 0.0001));
      expect(points['endPoint']!.x, closeTo(expectedEndX, 0.0001));
      expect(points['endPoint']!.y, closeTo(expectedEndY, 0.0001));
    });

    test('Handles flipped vertically by swapping startY and endY', () {
      // Mock slide dimensions
      int slideWidth = 5000000;
      int slideHeight = 3000000;

      // Mock connection shape with flipping enabled
      ConnectionShape connectionShape = ConnectionShape(
        width: EMU(50000),
        transform: Transform(
          Point2D(EMU(1000000), EMU(500000)),
          Point2D(EMU(2000000), EMU(1000000)),
        ),
        isFlippedVertically: true, // Flipped vertically
      );

      // Get computed start and end points
      final points = LinePositioner.getStartAndEndPoints(
          connectionShape, slideWidth, slideHeight);

      // Expected values in percentage
      double expectedStartY = (500000 + 1000000) / 3000000; // 0.5
      double expectedEndY = 500000 / 3000000; // 0.1667 (swapped)

      // Assertions
      expect(points['startPoint']!.y, closeTo(expectedStartY, 0.0001));
      expect(points['endPoint']!.y, closeTo(expectedEndY, 0.0001));
    });
  });

  group('_createLine Tests', () {
    test('Creates LineComponent with correct thickness and points', () {
      // Mock slide dimensions
      int slideWidth = 5000000;
      int slideHeight = 3000000;

      // Mock connection shape
      ConnectionShape connectionShape = ConnectionShape(
        width: EMU(50000), // Connection width
        transform: Transform(
          Point2D(EMU(1000000), EMU(500000)),
          Point2D(EMU(2000000), EMU(1000000)),
        ),
        isFlippedVertically: false,
      );

      // Get computed start and end points
      final points = LinePositioner.getStartAndEndPoints(
          connectionShape, slideWidth, slideHeight);

      // Expected thickness conversion
      double expectedThickness = 0.5;

      // Create LineComponent
      final line = LineComponent(
        color: connectionShape.color,
        style: connectionShape.style,
        startPoint: points['startPoint']!,
        endPoint: points['endPoint']!,
        thickness: expectedThickness,
      );

      // Assertions
      expect(line.startPoint.x, closeTo(0.2, 0.0001));
      expect(line.startPoint.y, closeTo(0.1667, 0.0001));
      expect(line.endPoint.x, closeTo(0.6, 0.0001));
      expect(line.endPoint.y, closeTo(0.5, 0.0001));
      expect(line.thickness, closeTo(expectedThickness, 0.0001));
    });
  });
}
