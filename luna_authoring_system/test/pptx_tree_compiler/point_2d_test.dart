import 'package:flutter_test/flutter_test.dart';
import 'package:built_value/built_value.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/point_2d.dart';
import 'package:luna_core/utils/emu.dart';

void main() {
  group('Tests for Point2D', () {
    test('BuiltValueNestedFieldError is thrown when x is missing', () {
      expect(
          () => Point2D((pb) => pb..y = EMU((eb) => eb..value = 0).toBuilder()),
          throwsA(predicate((e) => e is BuiltValueNestedFieldError)));
    });

    test('BuiltValueNestedFieldError is thrown when y is missing', () {
      expect(() => Point2D((b) => b..x = EMU((b) => b..value = 0).toBuilder()),
          throwsA(predicate((e) => e is BuiltValueNestedFieldError)));
    });
  });
}
