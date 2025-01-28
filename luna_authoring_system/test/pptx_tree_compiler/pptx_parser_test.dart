import 'package:luna_authoring_system/pptx_tree_compiler/pptx_parser.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/utils/emu.dart';

void main() {
  group('Tests for PptxParser using A line.pptx', () {
    PptxParser pptxParser = PptxParser('test/test_assets/A line.pptx');

    test('parsePptx method initialzes title.', () async {
      PptxTree pptxTree = pptxParser.getPptxTree();

      expect(pptxTree.title, "A line");
    });

    test('parsePptx method initialzes author.', () async {
      PptxTree pptxTree = pptxParser.getPptxTree();

      expect(pptxTree.author, "Andrew Nah");
    });

    test('parsePptx method initialzes width.', () async {
      PptxTree pptxTree = pptxParser.getPptxTree();

      expect(pptxTree.width, isA<EMU>());
      expect(pptxTree.width.value, 12192000);
    });

    test('parsePptx method initialzes height.', () async {
      PptxTree pptxTree = pptxParser.getPptxTree();

      expect(pptxTree.height, isA<EMU>());
      expect(pptxTree.height.value, 6858000);
    });

    test('parsePptx method initialzes slides.', () async {
      PptxTree pptxTree = pptxParser.getPptxTree();

      expect(pptxTree.slides, isA<List<Slide>>());
    });

    test('A line is parsed', () async {
      PptxTree pptxTree = pptxParser.getPptxTree();
      ConnectionShape cShape = pptxTree.slides[0].shapes![0] as ConnectionShape;

      expect(cShape.type, ShapeType.connection);
      expect(cShape.weight.value, 6350);
      expect(cShape.transform.offset.x.value, 2655518);
      expect(cShape.transform.offset.y.value, 2580362);
      expect(cShape.transform.size.x.value, 2755726);
      expect(cShape.transform.size.y.value, 1929008);
    });
  });
}
