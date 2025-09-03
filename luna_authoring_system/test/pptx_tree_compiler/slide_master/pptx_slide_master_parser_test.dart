import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_master/pptx_slide_master_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_master/pptx_slide_master_parser.dart';

void main() {
  group('Text with default text font sizes from slide master', () {
    final pptxFile = File('test/test_assets/1 textbox from placeholder in slide layout.pptx');
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
    PptxSlideMasterParser pptxSlideMasterParser = PptxSlideMasterParser(pptxLoader);

    test('getFontSizeFromSlideMaster returns correct font size for body text style', () {
      int fontSize = pptxSlideMasterParser.getFontSizeFromSlideMaster(1, body);

      expect(fontSize, 2800);
    });

    test('getFontSizeFromSlideMaster returns correct font size for other text style', () {
      int fontSize = pptxSlideMasterParser.getFontSizeFromSlideMaster(1, other);

      expect(fontSize, 1800);
    });
  });
}