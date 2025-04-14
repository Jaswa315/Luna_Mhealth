import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/units/bounding_box.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_core/units/percent.dart';
import 'package:luna_core/units/display_pixel.dart';

void main() {
  group('BoundingBox', () {
    test('creates bounding box with expected values', () {
      final box = BoundingBox(
        topLeftCorner: Offset(10.0, 20.0),
        width: DisplayPixel(300.0),
        height: Percent(50.0),
      );

      expect(box.topLeftCorner.dx, 10.0);
      expect(box.topLeftCorner.dy, 20.0);
      expect(box.width.toString(), DisplayPixel(300.0).toString());
      expect(box.height.toString(), Percent(50.0).toString());
    });

    test('creates bounding box with zero width and height', () {
      final box = BoundingBox(
        topLeftCorner: Offset(0.0, 0.0),
        width: DisplayPixel(0.0),
        height: EMU(0),
      );

      expect(box.width.toString(), DisplayPixel(0.0).toString());
      expect(box.height.toString(), EMU(0).toString());
    });

    test('toString returns expected formatted string', () {
      final box = BoundingBox(
        topLeftCorner: Offset(1.0, 2.0),
        width: DisplayPixel(100.0),
        height: Percent(25.0),
      );

      final str = box.toString();
      expect(str, contains('BoundingBox'));
      expect(str, contains('Offset(1.0, 2.0)'));
      expect(str, contains('100.0'));
      expect(str, contains('25.0%'));
    });

    test('serializes and deserializes to/from JSON correctly', () {
      final original = BoundingBox(
        topLeftCorner: Offset(5.0, 10.0),
        width: Percent(75.0),
        height: EMU(10000),
      );

      final json = original.toJson();
      final parsed = BoundingBox.fromJson(json);

      expect(parsed.topLeftCorner, original.topLeftCorner);
      expect(parsed.width.toString(), original.width.toString());
      expect(parsed.height.toString(), original.height.toString());
    });

    test('throws ArgumentError for negative values', () {
      expect(
          () => BoundingBox(
                topLeftCorner: Offset(-1.0, 0.0),
                width: DisplayPixel(100.0),
                height: Percent(25.0),
              ),
          throwsA(isA<AssertionError>()));

      expect(
          () => BoundingBox(
                topLeftCorner: Offset(0.0, 0.0),
                width: DisplayPixel(-100.0),
                height: Percent(25.0),
              ),
          throwsA(isA<ArgumentError>()));

      expect(
          () => BoundingBox(
                topLeftCorner: Offset(0.0, 0.0),
                width: DisplayPixel(100.0),
                height: Percent(-25.0),
              ),
          throwsA(isA<ArgumentError>()));
    });

    test('throws ArgumentError for unknown unit in fromJson', () {
      final json = {
        'topLeftCorner': {'dx': 0.0, 'dy': 0.0},
        'width': {'value': 100, 'unit': 'invalidUnit'},
        'height': {'value': 50, 'unit': 'percent'}
      };

      expect(() => BoundingBox.fromJson(json), throwsA(isA<ArgumentError>()));
    });
  });
}
