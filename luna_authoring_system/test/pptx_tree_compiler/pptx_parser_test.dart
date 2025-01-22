import 'package:luna_authoring_system/pptx_tree_compiler/pptx_parser.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/utils/emu.dart';

void main() {
  group('Tests for PptxParser', () {
    test('parsePptx initialze PptxTree', () async {
      PptxParser pptxParser = PptxParser('test/test_assets/A line.pptx');
      PptxTree pptxTree = PptxTree();

      pptxTree = pptxParser.getPptxTree();

      expect(pptxTree.title, "A line");
      expect(pptxTree.author, "Andrew Nah");
      expect(pptxTree.width, isA<EMU>());
      expect(pptxTree.width.value, 12192000);
      expect(pptxTree.height, isA<EMU>());
      expect(pptxTree.height.value, 6858000);
    });
  });
}
