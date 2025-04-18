import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/simple_type_percentage.dart';
import 'package:luna_authoring_system/pptx_data_objects/source_rectangle.dart';

void main() {
  group('SourceRectangle Class Tests', () {
    test('SourceRectangle object stores 0 by default if given null.', () {
      SourceRectangle sourceRectangle = SourceRectangle();

      expect(sourceRectangle.left.value, 0);
      expect(sourceRectangle.top.value, 0);
      expect(sourceRectangle.right.value, 0);
      expect(sourceRectangle.bottom.value, 0);
    });

    test('SourceRectangle object stores valid values.', () {
      SourceRectangle sourceRectangle = SourceRectangle(
        left: SimpleTypePercentage(100),
        top: SimpleTypePercentage(200),
        right: SimpleTypePercentage(300),
        bottom: SimpleTypePercentage(400),
      );

      expect(sourceRectangle.left.value, 100);
      expect(sourceRectangle.top.value, 200);
      expect(sourceRectangle.right.value, 300);
      expect(sourceRectangle.bottom.value, 400);
    });

    test(
        'SourceRectangle object sets the value as 0 if some of the attributes are given null.',
        () {
      SourceRectangle sourceRectangle = SourceRectangle(
        left: SimpleTypePercentage(100),
        top: null,
        right: SimpleTypePercentage(300),
        bottom: null,
      );

      expect(sourceRectangle.left.value, 100);
      expect(sourceRectangle.top.value, 0);
      expect(sourceRectangle.right.value, 300);
      expect(sourceRectangle.bottom.value, 0);
    });
  });
}
