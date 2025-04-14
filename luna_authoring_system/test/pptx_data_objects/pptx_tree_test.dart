import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_core/units/emu.dart';

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

    test('An error is thrown when slides is accessed before initialization.',
        () async {
      expect(
        () => PptxTree().slides,
        throwsA(isA<Error>()),
      );
    });

    test('slides can be updated with a list of slides', () async {
      PptxTree pptxTree = PptxTree();

      List<Slide> slides = [];
      for (int i = 0; i < 3; i++) {
        slides.add(Slide());
      }

      pptxTree.slides = slides;

      expect(pptxTree.slides, slides);
    });
  });
}
