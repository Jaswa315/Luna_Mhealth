import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/presentation_property/pptx_presentation_property_parser.dart';
import 'dart:io';

void main() {
  test('PptxPresentationPropertyParser sets slide width and slide height in CTOR.', () async {
    final pptxFile = File('test/test_assets/A line.pptx');
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
    PptxPresentationPropertyParser pptxPresentationPropertyParser = PptxPresentationPropertyParser(pptxLoader);
    expect(pptxPresentationPropertyParser.width.value, 12192000);
    expect(pptxPresentationPropertyParser.height.value, 6858000);
  });
}