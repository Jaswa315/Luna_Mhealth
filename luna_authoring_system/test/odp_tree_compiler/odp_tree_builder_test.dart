import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/odp_tree_compiler/odp_tree_builder.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';

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
  });
}