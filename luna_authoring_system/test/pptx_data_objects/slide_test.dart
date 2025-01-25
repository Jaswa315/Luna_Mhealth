import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/point_2d.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_core/utils/emu.dart';
import 'package:built_collection/built_collection.dart';

void main() {
  group('Tests for Slide', () {
    test('shapes is null by default', () async {
      Slide slide = Slide();

      expect(slide.shapes, null);
    });

    test('shapes can be updated with a list of shapes', () async {
      Slide slide = Slide();

      List<Shape> shapes = [];
      EMU emu = EMU(0);
      for (int i = 0; i < 3; i++) {
        shapes.add(ConnectionShape(
            emu, Transform(Point2D(emu, emu), Point2D(emu, emu))));
      }

      slide.shapes = shapes;

      expect(slide.shapes, shapes);
    });
  });
}
