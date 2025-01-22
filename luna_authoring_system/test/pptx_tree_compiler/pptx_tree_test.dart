import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/utils/logging.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_core/utils/emu.dart';
import 'package:built_collection/built_collection.dart';

void main() {
  group('Tests for PptxTree', () {
    test('width is initialized with null value', () async {
      PptxTree pptxTree = PptxTree();

      expect(pptxTree.width, null);
    });

    test('height is initialized with null value', () async {
      PptxTree pptxTree = PptxTree();

      expect(pptxTree.height, null);
    });

    test('width can be updated with EMU value', () async {
      PptxTree pptxTree = PptxTree();
      int width = 1;

      pptxTree = pptxTree
          .rebuild((b) => b..width = EMU((b) => b..value = width).toBuilder());

      expect(pptxTree.width?.value, width);
    });

    test('height can be updated with EMU value', () async {
      PptxTree pptxTree = PptxTree();
      int height = 1;

      pptxTree = pptxTree.rebuild(
          (b) => b..height = EMU((b) => b..value = height).toBuilder());

      expect(pptxTree.height?.value, height);
    });

    test('title is initialized with null value', () async {
      PptxTree pptxTree = PptxTree();

      expect(pptxTree.title, null);
    });

    test('title can be updated with a String value', () async {
      PptxTree pptxTree = PptxTree();
      String title = 'test title';

      pptxTree = pptxTree.rebuild((b) => b..title = title);

      expect(pptxTree.title!, title);
    });

    test('author is initialized with null value', () async {
      PptxTree pptxTree = PptxTree();

      expect(pptxTree.author, null);
    });

    test('author can be updated with a String value', () async {
      PptxTree pptxTree = PptxTree();
      String author = 'test author';

      pptxTree = pptxTree.rebuild((b) => b..author = author);

      expect(pptxTree.author!, author);
    });
  });
}
