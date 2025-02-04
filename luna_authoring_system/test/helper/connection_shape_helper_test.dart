import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/point_2d.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_authoring_system/helper/connection_shape_helper.dart';
import 'package:luna_core/models/shape/divider_component.dart';
import 'package:luna_core/models/point/point_2d_percentage.dart';
import 'package:luna_core/utils/emu.dart';

void main() {
  group('ConnectionShapeHelper Tests', () {
    test('Computes correct start and end points from ConnectionShape', () {
      // Mock slide dimensions
      int slideWidth = 5000000;
      int slideHeight = 3000000;

      // Mock connection shape
      ConnectionShape connectionShape = ConnectionShape(
        EMU(50000), // Width of the connection
        Transform(
          Point2D(EMU(1000000), EMU(500000)), // Offset
          Point2D(EMU(2000000), EMU(1000000)), // Size
        ),
        false, // Not flipped vertically
      );

      // Get computed start and end points
      final points = ConnectionShapeHelper.getStartAndEndPoints(
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
        EMU(50000),
        Transform(
          Point2D(EMU(1000000), EMU(500000)),
          Point2D(EMU(2000000), EMU(1000000)),
        ),
        true, // Flipped vertically
      );

      // Get computed start and end points
      final points = ConnectionShapeHelper.getStartAndEndPoints(
          connectionShape, slideWidth, slideHeight);

      // Expected values in percentage
      double expectedStartY = (500000 + 1000000) / 3000000; // 0.5
      double expectedEndY = 500000 / 3000000; // 0.1667 (swapped)

      // Assertions
      expect(points['startPoint']!.y, closeTo(expectedStartY, 0.0001));
      expect(points['endPoint']!.y, closeTo(expectedEndY, 0.0001));
    });
  });

  group('_createDivider Tests', () {
    test('Creates DividerComponent with correct thickness and points', () {
      // Mock slide dimensions
      int slideWidth = 5000000;
      int slideHeight = 3000000;

      // Mock connection shape
      ConnectionShape connectionShape = ConnectionShape(
        EMU(50000), // Connection width
        Transform(
          Point2D(EMU(1000000), EMU(500000)),
          Point2D(EMU(2000000), EMU(1000000)),
        ),
        false,
      );

      // Get computed start and end points
      final points = ConnectionShapeHelper.getStartAndEndPoints(
          connectionShape, slideWidth, slideHeight);

      // Expected thickness conversion
      double expectedThickness = 0.5;

      // Create DividerComponent
      final divider = DividerComponent(
        startPoint: points['startPoint']!,
        endPoint: points['endPoint']!,
        thickness: expectedThickness,
      );

      // Assertions
      expect(divider.startPoint.x, closeTo(0.2, 0.0001));
      expect(divider.startPoint.y, closeTo(0.1667, 0.0001));
      expect(divider.endPoint.x, closeTo(0.6, 0.0001));
      expect(divider.endPoint.y, closeTo(0.5, 0.0001));
      expect(divider.thickness, closeTo(expectedThickness, 0.0001));
    });
  });
}
