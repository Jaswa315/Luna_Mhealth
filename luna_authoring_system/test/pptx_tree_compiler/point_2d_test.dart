import 'package:flutter_test/flutter_test.dart';
import 'package:built_value/built_value.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/point_2d.dart';

void main() {
  group('Tests for Point2D', () {
    test('BuiltValueNullFieldError is thrown when x is missing', () {
      expect(() => Point2D((b) => b..y = 0.0),
          throwsA(predicate((e) => e is BuiltValueNullFieldError)));
    });

    test('BuiltValueNullFieldError is thrown when y is missing', () {
      expect(() => Point2D((b) => b..x = 0.0),
          throwsA(predicate((e) => e is BuiltValueNullFieldError)));
    });
  });
}
