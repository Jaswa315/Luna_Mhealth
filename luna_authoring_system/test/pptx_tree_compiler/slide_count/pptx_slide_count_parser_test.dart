import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_count/pptx_slide_count_parser.dart';
import 'dart:io';

void main() {
  group('Tests for PptxSlideCountParser using a pptx file that 0 slide.', () {
    final pptxFile = File('test/test_assets/0 slide.pptx');
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
    PptxSlideCountParser pptxSlideCountParser = PptxSlideCountParser(pptxLoader);

    test('getSlideCount method gets an integer.', () async {
      int slideCount = pptxSlideCountParser.getSlideCount();
      expect(slideCount, 0);
    });
  });

  group('Tests for PptxSlideCountParser using a pptx file that 1 slide.', () {
    final pptxFile = File('test/test_assets/1 slide.pptx');
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
    PptxSlideCountParser pptxSlideCountParser = PptxSlideCountParser(pptxLoader);
    test('getSlideCount method gets an integer.', () async {
      int slideCount = pptxSlideCountParser.getSlideCount();
      expect(slideCount, 1);
    });
  });

  group('Tests for PptxSlideCountParser using a pptx file that n slides.', () {
    final pptxFile = File('test/test_assets/2 slides.pptx');
    PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
    PptxSlideCountParser pptxSlideCountParser = PptxSlideCountParser(pptxLoader);
    test('getSlideCount method gets an integer.', () async {
      int slideCount = pptxSlideCountParser.getSlideCount();
      expect(slideCount, 2);
    });
  });
}
