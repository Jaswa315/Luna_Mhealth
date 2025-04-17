import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/document_property/pptx_document_property_parser.dart';
import 'dart:io';

void main() {
  test('PptxDocumentPropertParser sets author and title in CTOR.', () async {
    final pptxFile = File('test/test_assets/Empty slide with slideLayout.pptx');
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
    PptxDocumentPropertyParser pptxDocumentPropertyParser = PptxDocumentPropertyParser(pptxLoader);
    expect(pptxDocumentPropertyParser.author, "An Author Name");
    expect(pptxDocumentPropertyParser.title, "A Title Name");
  });
}
