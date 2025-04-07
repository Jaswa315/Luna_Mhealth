import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/bounding_box.dart';
import 'package:luna_core/utils/dimension.dart';
import 'package:luna_core/enums/unit_type.dart';

void main() {
  group('BoundingBox', () {
    test('creates bounding box with expected values', () {
      final box = BoundingBox(
        start: Offset(10.0, 20.0),
        width: Dimension.pixels(300.0),
        height: Dimension.percent(50.0),
      );

      expect(box.start.dx, 10.0);
      expect(box.start.dy, 20.0);
      expect(box.width.value, 300.0);
      expect(box.width.unit, UnitType.displayPixels);
      expect(box.height.value, 50.0);
      expect(box.height.unit, UnitType.percent);
    });

    test('creates bounding box with zero width and height', () {
      final box = BoundingBox(
        start: Offset(0.0, 0.0),
        width: Dimension.pixels(0.0),
        height: Dimension.emu(0.0),
      );

      expect(box.width.value, 0.0);
      expect(box.height.value, 0.0);
    });

    test('toString returns expected formatted string', () {
      final box = BoundingBox(
        start: Offset(1.0, 2.0),
        width: Dimension.pixels(100.0),
        height: Dimension.percent(25.0),
      );

      final str = box.toString();
      expect(str, contains('BoundingBox'));
      expect(str, contains('Offset(1.0, 2.0)'));
      expect(str, contains('100.0 displayPixels'));
      expect(str, contains('25.0 percent'));
    });

    test('serializes and deserializes to/from JSON correctly', () {
      final original = BoundingBox(
        start: Offset(5.0, 10.0),
        width: Dimension.percent(75.0),
        height: Dimension.emu(10000.0),
      );

      final json = original.toJson();
      final parsed = BoundingBox.fromJson(json);

      expect(parsed.start, original.start);
      expect(parsed.width.value, original.width.value);
      expect(parsed.width.unit, original.width.unit);
      expect(parsed.height.value, original.height.value);
      expect(parsed.height.unit, original.height.unit);
    });
  });
}
