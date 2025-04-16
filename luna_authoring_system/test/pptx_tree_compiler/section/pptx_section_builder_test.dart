import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/section/pptx_section_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_count/pptx_slide_count_parser.dart';
import 'package:luna_authoring_system/pptx_data_objects/section.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/units/emu.dart';
import 'dart:io';

void main() {
  group('Tests for PptxSectionBuilder using a pptx that has multiple sections.', () {
    final pptxFile = File('test/test_assets/Sections.pptx');
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
    PptxSectionBuilder pptxSectionBuilder = PptxSectionBuilder(pptxLoader, PptxSlideCountParser(pptxLoader));

    test('getSection method gets section object.', () async {
      Section section = pptxSectionBuilder.getSection();
      expect(section, isA<Section>());
      expect(section.value, {
        "Default Section": [1],
        "Section 2": [2, 3, 4],
        "Section 3": [],
        "Section 4": [5, 6, 7]
      });
    });
  });

  group('Tests for PptxSectionBuilder using a pptx file that has no section.', () {
    final pptxFile = File('test/test_assets/A line.pptx');
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
    PptxSectionBuilder pptxSectionBuilder = PptxSectionBuilder(pptxLoader, PptxSlideCountParser(pptxLoader));

    test(
        'getSection method gets section object with default name if there is no section.',
        () async {
      Section section = pptxSectionBuilder.getSection();
      expect(section, isA<Section>());
      expect(section.value, {
        Section.defaultSectionName: [1],
      });
    });
  });
}
