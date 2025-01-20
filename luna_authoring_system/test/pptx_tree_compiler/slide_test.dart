import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/shape.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/connection_shape.dart';
import 'package:built_collection/built_collection.dart';

void main() {
  group('Tests for Slide', () {
    test('slideNumber is null by default', () async {
      Slide slide = Slide();

      expect(slide.slideNumber, null);
    });

    test('shapes is null by default', () async {
      Slide slide = Slide();

      expect(slide.shapes, null);
    });

    test('slideNumber can be updated with a int value', () async {
      Slide slide = Slide();
      int slideNumber = 3;

      slide = slide.rebuild((b) => b..slideNumber = slideNumber);

      expect(slide.slideNumber, slideNumber);
    });

    test('shapes can be updated with a built list of shapes', () async {
      Slide slide = Slide();
      List<Shape> shapes = [];

      for (int i = 0; i < 3; i++) {
        shapes.add(ConnectionShape());
      }
      slide = slide.rebuild((b) => b..shapes = shapes.toBuiltList().toBuilder());

      expect(slide.shapes!, shapes);
    });
  });
}
