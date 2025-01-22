import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_core/utils/emu.dart';

void main() {
  group('Tests for PptxTree', () {
    test('title can be updated with a String value', () async {
      PptxTree pptxTree = PptxTree();
      String title = 'test title';

      pptxTree.title = title;

      expect(pptxTree.title, title);
    });

    test('author can be updated with a String value', () async {
      PptxTree pptxTree = PptxTree();
      String author = 'test author';

      pptxTree.author = author;

      expect(pptxTree.author, author);
    });

    test('width can be updated with EMU value', () async {
      PptxTree pptxTree = PptxTree();
      EMU width = EMU(1);

      pptxTree.width = width;

      expect(pptxTree.width, width);
    });

    test('height can be updated with EMU value', () async {
      PptxTree pptxTree = PptxTree();
      EMU height = EMU(1);

      pptxTree.height = height;

      expect(pptxTree.height, height);
    });
  });
}
