import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/rendering.dart';
import 'package:luna_authoring_system/pptx_data_objects/picture_shape.dart';
import 'package:luna_core/units/point.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:luna_authoring_system/pptx_data_objects/simple_type_percentage.dart';
import 'package:luna_authoring_system/pptx_data_objects/source_rectangle.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_core/units/emu.dart';

void main() {
  bool isFlippedVertically = false;

  group('Tests for PictureShape', () {
    test('The shape type of the picture shape is set by default.', () {
      PictureShape pShape = PictureShape(
        transform: Transform(
          Point(EMU(0), EMU(0)),
          Point(EMU(0), EMU(0)),
        ),
        url: "",
        sourceRectangle: SourceRectangle(),
      );

      expect(pShape.type, ShapeType.picture);
    });

    test('No error is thrown when all required parameters are provided.', () {
      expect(
        () => PictureShape(
          transform: Transform(
            Point(EMU(0), EMU(0)),
            Point(EMU(0), EMU(0)),
          ),
          url: "../image1.png",
          sourceRectangle: SourceRectangle(
            left: null,
            top: SimpleTypePercentage(100),
            right: null,
            bottom: SimpleTypePercentage(100),
          ),
        ),
        returnsNormally,
      );
    });

    test('Throws error when required parameters are missing.', () {
      expect(
        () => Function.apply(PictureShape.new, []),
        throwsA(isA<NoSuchMethodError>()),
      );
    });
  });
}
