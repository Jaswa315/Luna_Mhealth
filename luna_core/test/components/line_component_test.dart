import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/components/line_component.dart';
import 'package:luna_core/models/point/point_2d_percentage.dart';

/// A test suite for the `LineComponent` class.
/// This suite contains tests to ensure that the
/// `LineComponent` class correctly converts between JSON and LineComponent objects.

void main() {
  group('LineComponent Tests', () {
    test('Converts JSON to LineComponent correctly', () {
      // Input JSON
      final json = {
        'type': 'line',
        'startPoint': {'x': 0.1, 'y': 0.2},
        'endPoint': {'x': 0.4, 'y': 0.5},
        'color': 0xFF0D47A1, // ARGB color value
        'thickness': 5.0, // Thickness in pixels
        'style': 1, // Solid style
      };

      // Convert JSON to LineComponent
      final line = LineComponent.fromJson(json);

      // Assertions
      expect(line.startPoint.x, closeTo(0.1, 0.00001));
      expect(line.startPoint.y, closeTo(0.2, 0.00001));
      expect(line.endPoint.x, closeTo(0.4, 0.00001));
      expect(line.endPoint.y, closeTo(0.5, 0.00001));
      expect(line.color, const Color(0xFF0D47A1));
      expect(line.thickness, closeTo(5.0, 0.00001)); // Thickness in pixels
      expect(line.style, BorderStyle.solid);
    });

    test('Converts LineComponent to JSON correctly', () {
      // Create a LineComponent instance
      final line = LineComponent(
        startPoint: Point2DPercentage(0.1, 0.2),
        endPoint: Point2DPercentage(0.4, 0.5),
        color: const Color(0xFF0D47A1),
        thickness: 5,
        style: BorderStyle.solid,
      );

      // Convert LineComponent to JSON
      final json = line.toJson();

      // Assertions
      expect(json['type'], 'line');
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
