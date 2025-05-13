import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/odp_tree_compiler/odp_tree_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_core/units/emu.dart';

void main() {
  group('Tests for OdpTreeBuilder using A horizontal line.odp', () {
    final odpFile = File('test/test_assets/A horizontal line.odp');
    OdpTreeBuilder odpTreeBuilder = OdpTreeBuilder(odpFile);
    PptxTree odpTree = odpTreeBuilder.getOdpTree();
    test('odpTree method initializes title.', () async {
      expect(odpTree.title, "A horizontal line");
    });

    test('odpTree method initializes author.', () async {
      expect(odpTree.author, "Kameron Vuong");
    });

    test('odpTree method initializes width.', () async {
      expect(odpTree.width, isA<EMU>());
      expect(odpTree.width.value, 10080000);
    });

    test('odpTree method initializes height.', () async {
      expect(odpTree.height, isA<EMU>());
      expect(odpTree.height.value, 5670000);
    });

    test('odpTree method initializes slides.', () async {
      expect(odpTree.slides, isA<List<Slide>>());
      expect(odpTree.slides.length, 1);
    });

    test('A horizontal line is parsed', () async {
      Slide slide = odpTree.slides[0];
      expect(slide.shapes, isA<List<Shape>>());
      expect(slide.shapes!.length, 1);
      ConnectionShape horizontalLine = slide.shapes![0] as ConnectionShape;
      expect(horizontalLine.type, ShapeType.connection);
      expect(horizontalLine.width.value, 6350);
      expect((horizontalLine.transform.offset.x as EMU).value, 1828800);
      expect((horizontalLine.transform.offset.y as EMU).value, 3657600);
      expect((horizontalLine.transform.size.x as EMU).value, 4800600);
      expect((horizontalLine.transform.size.y as EMU).value, 0);
      expect(horizontalLine.isFlippedVertically, false);
    });
    
  });
}