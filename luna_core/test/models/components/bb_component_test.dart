import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/models/components/bb_component.dart';
import 'package:luna_core/models/bounding_box.dart';
import 'package:luna_core/utils/emu.dart';
import 'package:luna_core/utils/display_pixel.dart';
import 'dart:ui';

void main() {
  group('BBComponent', () {
    test('should create BBComponent with valid bounding box', () {
      final boundingBox = BoundingBox(
        topLeftCorner: Offset(10.0, 20.0),
        width: EMU(5000),
        height: DisplayPixel(100.0),
      );

      final component = BBComponent(boundingBox: boundingBox);

      expect(component.boundingBox.topLeftCorner.dx, 10.0);
      expect(component.boundingBox.topLeftCorner.dy, 20.0);
      expect((component.boundingBox.width as EMU).value, 5000);
      expect((component.boundingBox.height as DisplayPixel).value, 100.0);
    });

    test('should serialize BBComponent to JSON correctly', () {
      final boundingBox = BoundingBox(
        topLeftCorner: Offset(5.0, 15.0),
        width: EMU(3000),
        height: DisplayPixel(75.0),
      );

      final component = BBComponent(boundingBox: boundingBox);
      final json = component.toJson();

      expect(json['type'], 'bbComponent');
      expect(json['boundingBox']['topLeftCorner']['dx'], 5.0);
      expect(json['boundingBox']['topLeftCorner']['dy'], 15.0);
      expect(json['boundingBox']['width']['unit'], 'emu');
      expect(json['boundingBox']['width']['value'], 3000);
      expect(json['boundingBox']['height']['unit'], 'displayPixels');
      expect(json['boundingBox']['height']['value'], 75.0);
    });

    test('should deserialize BBComponent from JSON correctly', () {
      final json = {
        'type': 'bbComponent',
        'boundingBox': {
          'topLeftCorner': {'dx': 3.0, 'dy': 6.0},
          'width': {'unit': 'emu', 'value': 4000},
          'height': {'unit': 'displayPixels', 'value': 50.0}
        }
      };

      final component = BBComponent.fromJson(json);

      expect(component.boundingBox.topLeftCorner.dx, 3.0);
      expect(component.boundingBox.topLeftCorner.dy, 6.0);
      expect((component.boundingBox.width as EMU).value, 4000);
      expect((component.boundingBox.height as DisplayPixel).value, 50.0);
    });

    test('should allow zero values for position and dimensions', () {
      final boundingBox = BoundingBox(
        topLeftCorner: Offset(0.0, 0.0),
        width: EMU(0),
        height: DisplayPixel(0),
      );

      final component = BBComponent(boundingBox: boundingBox);

      expect(component.boundingBox.topLeftCorner.dx, 0.0);
      expect(component.boundingBox.topLeftCorner.dy, 0.0);
      expect((component.boundingBox.width as EMU).value, 0);
      expect((component.boundingBox.height as DisplayPixel).value, 0);
    });

    test('should throw assertion error for negative topLeftCorner.dx', () {
      expect(
        () => BoundingBox(
          topLeftCorner: Offset(-1.0, 0.0),
          width: EMU(1000),
          height: DisplayPixel(100.0),
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('should throw assertion error for negative topLeftCorner.dy', () {
      expect(
        () => BoundingBox(
          topLeftCorner: Offset(0.0, -5.0),
          width: EMU(1000),
          height: DisplayPixel(100.0),
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
