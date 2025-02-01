import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/shape/divider_component.dart';
import 'package:luna_core/models/point/point_2d_percentage.dart';

/// A test suite for the `DividerComponent` class.
/// This suite contains tests to ensure that the
/// `DividerComponent` class correctly converts between JSON and DividerComponent objects.

void main() {
  group('DividerComponent Tests', () {
    test('Converts JSON to DividerComponent correctly', () {
      // Input JSON
      final json = {
        'type': 'divider',
        'startPoint': {'x': 0.1, 'y': 0.2},
        'endPoint': {'x': 0.4, 'y': 0.5},
        'color': 0xFF0D47A1, // ARGB color value
        'thickness': 5.0, // Thickness in pixels
        'style': 1, // Solid style
      };

      // Convert JSON to DividerComponent
      final divider = DividerComponent.fromJson(json);

      // Assertions
      expect(divider.startPoint.x, closeTo(0.1, 0.00001));
      expect(divider.startPoint.y, closeTo(0.2, 0.00001));
      expect(divider.endPoint.x, closeTo(0.4, 0.00001));
      expect(divider.endPoint.y, closeTo(0.5, 0.00001));
      expect(divider.color, const Color(0xFF0D47A1));
      expect(divider.thickness, closeTo(5.0, 0.00001)); // Thickness in pixels
      expect(divider.style, BorderStyle.solid);
    });

    test('Converts DividerComponent to JSON correctly', () {
      // Create a DividerComponent instance
      final divider = DividerComponent(
        startPoint: Point2DPercentage(0.1, 0.2),
        endPoint: Point2DPercentage(0.4, 0.5),
        color: const Color(0xFF0D47A1),
        thickness: 5.0,
        style: BorderStyle.solid,
      );

      // Convert DividerComponent to JSON
      final json = divider.toJson();

      // Assertions
      expect(json['type'], 'divider');
      expect(json['startPoint']['x'], closeTo(0.1, 0.00001));
      expect(json['startPoint']['y'], closeTo(0.2, 0.00001));
      expect(json['endPoint']['x'], closeTo(0.4, 0.00001));
      expect(json['endPoint']['y'], closeTo(0.5, 0.00001));
      expect(json['color'], 0xFF0D47A1);
      expect(json['thickness'], closeTo(5.0, 0.00001));
      expect(json['style'], 1); // Enum index
    });
  });
}
