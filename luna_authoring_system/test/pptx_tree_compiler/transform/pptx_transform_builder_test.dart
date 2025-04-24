import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/transform/pptx_transform_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/transform/pptx_transform_constants.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_core/units/point.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';

void main() {
  group('PptxTransformBuilder Tests', () {
    late PptxTransformBuilder transformBuilder;

    setUp(() {
      transformBuilder = PptxTransformBuilder();
    });

    test('getTransform correctly parses valid transformMap', () {
      final transformMap = {
        eOffset: {eX: '1000', eY: '2000'},
        eSize: {eCX: '3000', eCY: '4000'}
      };

      Transform transform = transformBuilder.getTransform(transformMap);

      expect(transform.offset.x.toString(), equals('1000'));
      expect(transform.offset.y.toString(), equals('2000'));
      expect(transform.size.x.toString(), equals('3000'));
      expect(transform.size.y.toString(), equals('4000'));
    });

    test('getTransform throws an error for missing eOffset key', () {
      final transformMap = {
        eSize: {eCX: '3000', eCY: '4000'}
      };

      expect(
        () => transformBuilder.getTransform(transformMap),
        throwsA(isA<NoSuchMethodError>()),
      );
    });

    test('getTransform throws an error for invalid numeric values', () {
      final transformMap = {
        eOffset: {eX: 'invalid', eY: '2000'},
        eSize: {eCX: '3000', eCY: '4000'}
      };

      expect(
        () => transformBuilder.getTransform(transformMap),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
