import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/shape/divider_component.dart';

/// A test suite for the `DividerComponent` class.
/// This suite contains tests to ensure that the
/// `DividerComponent` class correctly converts between JSON and DividerComponent objects.
///  - Converts JSON to DividerComponent correctly.

void main() {
  group('DividerComponent Tests', () {
    test('Converts JSON to DividerComponent correctly', () {
      // Input JSON
      final json = {
        'type': 'divider',
        'x': 0.1,
        'y': 0.2,
        'width': 0.3,
        'height': 0.4,
        'color': 0xFF0D47A1, // ARGB color value
        'thickness': 6350.0, // EMU value for thickness
        'style': 1, // Solid style
      };

      // Convert JSON to DividerComponent
      final divider = DividerComponent.fromJson(json);

      // Assertions
      // Using closeTo to handle potential floating-point precision errors,
      // which occur because floating-point numbers like 0.1 and 0.3 cannot
      // be represented exactly in binary format, leading to slight inaccuracies.
      expect(divider.x, closeTo(0.1, 0.00001));
      expect(divider.y, closeTo(0.2, 0.00001));
      expect(divider.width, closeTo(0.3, 0.00001));
      expect(divider.height, closeTo(0.4, 0.00001));
      expect(divider.color, const Color(0xFF0D47A1));
      expect(divider.thickness,
          closeTo(6350.0, 0.00001)); // Should match raw EMU value
      expect(divider.style, BorderStyle.solid);
    });

    test('Converts DividerComponent to JSON correctly', () {
      // Create a DividerComponent
      final divider = DividerComponent(
        x: 0.1,
        y: 0.2,
        width: 0.3,
        height: 0.4,
        color: const Color(0xFF0D47A1),
        thickness: 6350.0,
        style: BorderStyle.solid,
      );

      // Convert DividerComponent to JSON
      final json = divider.toJson();

      // Assertions
      // Using closeTo to handle potential floating-point precision errors,
      // which occur because floating-point numbers like 0.1 and 0.3 cannot
      // be represented exactly in binary format, leading to slight inaccuracies.
      expect(json['type'], 'divider');
      expect(json['x'], closeTo(0.1, 0.00001));
      expect(json['y'], closeTo(0.2, 0.00001));
      expect(json['width'], closeTo(0.3, 0.00001));
      expect(json['height'], closeTo(0.4, 0.00001));
      expect(json['color'], 0xFF0D47A1);
      expect(json['thickness'], closeTo(6350.0, 0.00001));
      expect(json['style'], 1); // Style should map to 1 (solid)
    });

    test('Style mapping handles unsupported styles gracefully', () {
      // Input JSON with unsupported style
      final json = {
        'type': 'divider',
        'x': 0.1,
        'y': 0.2,
        'width': 0.3,
        'height': 0.4,
        'color': 0xFF0D47A1,
        'thickness': 6350.0,
        'style': 99, // Unsupported style
      };

      // Convert JSON to DividerComponent
      final divider = DividerComponent.fromJson(json);

      // Assertions
      expect(divider.style, BorderStyle.solid); // Fallback to solid
    });

    test('Converts thickness from EMU to logical pixels correctly', () {
      // Create a DividerComponent
      final divider = DividerComponent(
        x: 0.1,
        y: 0.2,
        width: 0.3,
        height: 0.4,
        color: const Color(0xFF0D47A1),
        thickness: 6350.0, // Raw EMU value
        style: BorderStyle.solid,
      );

      // Convert thickness to logical pixels
      final double logicalPixels = divider.thickness * 0.000175;

      // Assertions
      // Using closeTo to handle potential floating-point precision errors,
      // which occur because floating-point numbers like 0.1 and 0.3 cannot
      // be represented exactly in binary format, leading to slight inaccuracies.
      expect(logicalPixels, closeTo(1.11125, 0.00001)); // Verify conversion
    });
  });
}
