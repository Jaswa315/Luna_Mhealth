import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/section/pptx_section_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_count/pptx_slide_count_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_layout_relationship/pptx_slide_layout_relationship_parser.dart';
import 'package:luna_authoring_system/pptx_data_objects/section.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/units/emu.dart';
import 'dart:io';

void main() {
  group('Tests for PptxSectionBuilder using a pptx that has multiple sections.',
      () {
    final pptxFile = File('test/test_assets/Sections.pptx');
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
    PptxSlideLayoutRelationshipParser pptxSlideLayoutRelationshipParser =
        PptxSlideLayoutRelationshipParser(pptxLoader);

    test('getSlideLayoutIndex method gets integer value.', () async {
      int slideIndex = 1;
      int slideLayoutIndex =
          pptxSlideLayoutRelationshipParser.getSlideLayoutIndex(slideIndex);

      expect(slideLayoutIndex, 1);
    });
  });
}
