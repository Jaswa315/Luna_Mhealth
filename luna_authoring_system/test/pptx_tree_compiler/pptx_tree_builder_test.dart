import 'package:luna_authoring_system/pptx_tree_compiler/pptx_tree_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/picture_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/section.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/units/emu.dart';
import 'dart:io';

void main() {
  group('Tests for PptxTreeBuilder using A line.pptx', () {
    final pptxFile = File('test/test_assets/A line.pptx');
    PptxTreeBuilder pptxTreeBuilder = PptxTreeBuilder(pptxFile);
    PptxTree pptxTree = pptxTreeBuilder.getPptxTree();
    test('parsePptx method initialzes title.', () async {
      expect(pptxTree.title, "A line");
    });

    test('parsePptx method initialzes author.', () async {
      expect(pptxTree.author, "Andrew Nah");
    });
    test('parsePptx method initialzes width.', () async {
      expect(pptxTree.width, isA<EMU>());
      expect(pptxTree.width.value, 12192000);
    });

    test('parsePptx method initialzes height.', () async {
      expect(pptxTree.height, isA<EMU>());
      expect(pptxTree.height.value, 6858000);
    });

    test('parsePptx method initialzes slides.', () async {
      expect(pptxTree.slides, isA<List<Slide>>());
    });

    test('A line is parsed', () async {
      ConnectionShape cShape = pptxTree.slides[0].shapes![0] as ConnectionShape;

      expect(cShape.type, ShapeType.connection);
      expect(cShape.width.value, 6350);
      expect((cShape.transform.offset.x as EMU).value, 2655518);
      expect((cShape.transform.offset.y as EMU).value, 2580362);
      expect((cShape.transform.size.x as EMU).value, 2755726);
      expect((cShape.transform.size.y as EMU).value, 1929008);
    });

    ///testing in a pptx file where flipV = 1
    test('flipV attribute is correctly parsed for connection shapes', () async {
      ConnectionShape cShape = pptxTree.slides[0].shapes![0] as ConnectionShape;

      expect(cShape.isFlippedVertically, isTrue);
    });

    test(
        'The name of the section is parsed as default name if there is no section configured.',
        () async {
      expect(pptxTree.section, isA<Section>());
      expect(pptxTree.section.value, {
        Section.defaultSectionName: [1]
      });
    });
  });

  group('Tests for PptxTreeBuilder using Empty slide with slideLayout.pptx',
      () {
    final pptxFile = File('test/test_assets/Empty slide with slideLayout.pptx');
    PptxTreeBuilder pptxTreeBuilder = PptxTreeBuilder(pptxFile);
    PptxTree pptxTree = pptxTreeBuilder.getPptxTree();

    test('parsePptx method initialzes author.', () async {
      expect(pptxTree.author, "An Author Name");
    });
    test('parsePptx method initialzes width.', () async {
      expect(pptxTree.width, isA<EMU>());
      expect(pptxTree.width.value, 4114800);
    });

    test('parsePptx method initialzes height.', () async {
      expect(pptxTree.height, isA<EMU>());
      expect(pptxTree.height.value, 7315200);
    });

    test('parsePptx method initialzes slides.', () async {
      expect(pptxTree.slides, isA<List<Slide>>());
    });

    test('A Red line is parsed', () async {
      ConnectionShape cShape = pptxTree.slides[0].shapes![0] as ConnectionShape;

      expect(cShape.type, ShapeType.connection);
      expect(cShape.width.value, 19050);
      expect((cShape.transform.offset.x as EMU).value, 179189);
      expect((cShape.transform.offset.y as EMU).value, 645068);
      expect((cShape.transform.size.x as EMU).value, 3756423);
      expect(cShape.color.alpha, 255);
      expect(cShape.color.red, 255);
      expect(cShape.color.green, 0);
      expect(cShape.color.blue, 0);
    });

    ///testing in a pptx file where flipV = 1
    test('flipV attribute is correctly parsed for connection shapes', () async {
      ConnectionShape cShape = pptxTree.slides[0].shapes![0] as ConnectionShape;

      expect(cShape.isFlippedVertically, isFalse);
    });
  });

  group('Tests for PptxTreeBuilder using Sections.pptx', () {
    final pptxFile = File('test/test_assets/Sections.pptx');
    PptxTreeBuilder pptxTreeBuilder = PptxTreeBuilder(pptxFile);
    PptxTree pptxTree = pptxTreeBuilder.getPptxTree();

    test('Section is parsed.', () async {
      expect(pptxTree.section, isA<Section>());
      expect(pptxTree.section.value, {
        "Default Section": [1],
        "Section 2": [2, 3, 4],
        "Section 3": [],
        "Section 4": [5, 6, 7]
      });
    });

    test('Picture shpaes are extracted.', () async {
      final pptxFile = File('test/test_assets/2 Pictures.pptx');
      PptxTreeBuilder pptxTreeBuilder = PptxTreeBuilder(pptxFile);
      PptxTree pptxTree = pptxTreeBuilder.getPptxTree();
      List<Shape> shapes = pptxTree.slides[0].shapes!;
      expect(shapes[0], isA<PictureShape>());
      expect(shapes[1], isA<PictureShape>());
    });
  });
}
