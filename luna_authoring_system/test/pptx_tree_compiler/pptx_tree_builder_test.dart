import 'package:luna_authoring_system/pptx_tree_compiler/pptx_tree_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/utils/emu.dart';
import 'dart:io';

void main() {
  group('Tests for PptxTreeBuilder using A line.pptx', () {
    final pptxFile = File('test/test_assets/A line.pptx');
    PptxTreeBuilder pptxTreeBuilder = PptxTreeBuilder(pptxFile);

    test('parsePptx method initialzes title.', () async {
      PptxTree pptxTree = pptxTreeBuilder.getPptxTree();
      expect(pptxTree.title, "A line");
    });

    test('parsePptx method initialzes author.', () async {
      PptxTree pptxTree = pptxTreeBuilder.getPptxTree();

      expect(pptxTree.author, "Andrew Nah");
    });
    test('parsePptx method initialzes width.', () async {
      PptxTree pptxTree = pptxTreeBuilder.getPptxTree();

      expect(pptxTree.width, isA<EMU>());
      expect(pptxTree.width.value, 12192000);
    });

    test('parsePptx method initialzes height.', () async {
      PptxTree pptxTree = pptxTreeBuilder.getPptxTree();

      expect(pptxTree.height, isA<EMU>());
      expect(pptxTree.height.value, 6858000);
    });

    test('parsePptx method initialzes slides.', () async {
      PptxTree pptxTree = pptxTreeBuilder.getPptxTree();

      expect(pptxTree.slides, isA<List<Slide>>());
    });

    test('A line is parsed', () async {
      PptxTree pptxTree = pptxTreeBuilder.getPptxTree();
      ConnectionShape cShape = pptxTree.slides[0].shapes![0] as ConnectionShape;

      expect(cShape.type, ShapeType.connection);
      expect(cShape.width.value, 6350);
      expect(cShape.transform.offset.x.value, 2655518);
      expect(cShape.transform.offset.y.value, 2580362);
      expect(cShape.transform.size.x.value, 2755726);
      expect(cShape.transform.size.y.value, 1929008);
    });

    ///testing in a pptx file where flipV = 1
    test('flipV attribute is correctly parsed for connection shapes', () async {
      PptxTree pptxTree = pptxTreeBuilder.getPptxTree();
      ConnectionShape cShape = pptxTree.slides[0].shapes![0] as ConnectionShape;

      expect(cShape.isFlippedVertically, isTrue);
    });
  });

  group('Tests for PptxTreeBuilder using A line in slidelayout.pptx', () {
    final pptxFile = File('test/test_assets/Empty slide with slideLayout.pptx');
    PptxTreeBuilder pptxTreeBuilder = PptxTreeBuilder(pptxFile);

    test('parsePptx method initialzes author.', () async {
      PptxTree pptxTree = pptxTreeBuilder.getPptxTree();

      expect(pptxTree.author, "Jon Socha");
    });
    test('parsePptx method initialzes width.', () async {
      PptxTree pptxTree = pptxTreeBuilder.getPptxTree();

      expect(pptxTree.width, isA<EMU>());
      expect(pptxTree.width.value, 4114800);
    });

    test('parsePptx method initialzes height.', () async {
      PptxTree pptxTree = pptxTreeBuilder.getPptxTree();

      expect(pptxTree.height, isA<EMU>());
      expect(pptxTree.height.value, 7315200);
    });

    test('parsePptx method initialzes slides.', () async {
      PptxTree pptxTree = pptxTreeBuilder.getPptxTree();

      expect(pptxTree.slides, isA<List<Slide>>());
    });

    test('A line is parsed', () async {
      PptxTree pptxTree = pptxTreeBuilder.getPptxTree();
      ConnectionShape cShape = pptxTree.slides[0].shapes![0] as ConnectionShape;

      expect(cShape.type, ShapeType.connection);
      expect(cShape.width.value, 6350);
      expect(cShape.transform.offset.x.value, 179189);
      expect(cShape.transform.offset.y.value, 645068);
      expect(cShape.transform.size.x.value, 3756423);
      expect(cShape.transform.size.y.value, 0);
    });

    ///testing in a pptx file where flipV = 1
    test('flipV attribute is correctly parsed for connection shapes', () async {
      PptxTree pptxTree = pptxTreeBuilder.getPptxTree();
      ConnectionShape cShape = pptxTree.slides[0].shapes![0] as ConnectionShape;

      expect(cShape.isFlippedVertically, isFalse);
    });
  });
}
