import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/components/line_component.dart';
import 'package:luna_core/models/point/point_2d_percentage.dart';

void main() {
  group('LineComponent Tests', () {
    test('Creates LineComponent with valid values', () {
      final line = LineComponent(
        startPoint: Point2DPercentage(0.1, 0.2),
        endPoint: Point2DPercentage(0.4, 0.5),
        color: const Color(0xFF0D47A1),
        thickness: 5.0,
        style: BorderStyle.solid,
      );

      expect(line.startPoint.x, 0.1);
      expect(line.startPoint.y, 0.2);
      expect(line.endPoint.x, 0.4);
      expect(line.endPoint.y, 0.5);
      expect(line.color, const Color(0xFF0D47A1));
      expect(line.thickness, 5.0);
      expect(line.style, BorderStyle.solid);
    });

    test('Converts LineComponent to JSON correctly', () {
      final line = LineComponent(
        startPoint: Point2DPercentage(0.1, 0.2),
        endPoint: Point2DPercentage(0.4, 0.5),
        color: const Color(0xFF0D47A1),
        thickness: 5.0,
        style: BorderStyle.solid,
      );

      final json = line.toJson();

      expect(json['type'], 'line');
      expect(json['startPoint']['x'], 0.1);
      expect(json['startPoint']['y'], 0.2);
      expect(json['endPoint']['x'], 0.4);
      expect(json['endPoint']['y'], 0.5);
      expect(json['color'], 0xFF0D47A1);
      expect(json['thickness'], 5.0);
      expect(json['style'], 1); // Enum index for BorderStyle.solid
    });

    test('Creates LineComponent from valid JSON', () {
      final json = {
        'type': 'line',
        'startPoint': {'x': 0.1, 'y': 0.2},
        'endPoint': {'x': 0.4, 'y': 0.5},
        'color': 0xFF0D47A1,
        'thickness': 5.0,
        'style': 1, // BorderStyle.solid
      };

      final line = LineComponent.fromJson(json);

      expect(line.startPoint.x, 0.1);
      expect(line.startPoint.y, 0.2);
      expect(line.endPoint.x, 0.4);
      expect(line.endPoint.y, 0.5);
      expect(line.color, const Color(0xFF0D47A1));
      expect(line.thickness, 5.0);
      expect(line.style, BorderStyle.solid);
    });

    test('Throws error when invalid style index is provided', () {
      final json = {
        'type': 'line',
        'startPoint': {'x': 0.1, 'y': 0.2},
        'endPoint': {'x': 0.4, 'y': 0.5},
        'color': 0xFF0D47A1,
        'thickness': 5.0,
        'style': 99, // Invalid style index
      };

      expect(() => LineComponent.fromJson(json), throwsA(isA<RangeError>()));
    });

    test('Throws error when color is missing', () {
      final json = {
        'type': 'line',
        'startPoint': {'x': 0.1, 'y': 0.2},
        'endPoint': {'x': 0.4, 'y': 0.5},
        // 'color' is missing
        'thickness': 5.0,
        'style': 1,
      };

      expect(() => LineComponent.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('Throws error when thickness is missing', () {
      final json = {
        'type': 'line',
        'startPoint': {'x': 0.1, 'y': 0.2},
        'endPoint': {'x': 0.4, 'y': 0.5},
        'color': 0xFF0D47A1,
        // 'thickness' is missing
        'style': 1,
      };

      expect(() => LineComponent.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('Throws error when both color and thickness are missing', () {
      final json = {
        'type': 'line',
        'startPoint': {'x': 0.1, 'y': 0.2},
        'endPoint': {'x': 0.4, 'y': 0.5},
        // 'color' and 'thickness' are missing
        'style': 1,
      };

      expect(() => LineComponent.fromJson(json), throwsA(isA<TypeError>()));
    });
  });
}
