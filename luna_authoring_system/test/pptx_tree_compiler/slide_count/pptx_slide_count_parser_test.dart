import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_count/pptx_slide_count_parser.dart';
import 'dart:io';

int getSlideCountFromPptx(String pptxFilePath) {
  final pptxFile = File(pptxFilePath);
  PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
  PptxSlideCountParser pptxSlideCountParser = PptxSlideCountParser(pptxLoader);

  return pptxSlideCountParser.slideCount;
}

void main() {
  test('slideCount is 0 if the .pptx file has 0 slide.', () async {
    int slideCount = getSlideCountFromPptx('test/test_assets/0 slide.pptx');
    expect(slideCount, 0);
  });

  test('slideCount is 1 if the .pptx file has 1 slide.', () async {
    int slideCount = getSlideCountFromPptx('test/test_assets/1 slide.pptx');
    expect(slideCount, 1);
  });

  test('slideCount is 2 if the .pptx file has 2 slides.', () async {
    int slideCount = getSlideCountFromPptx('test/test_assets/2 slides.pptx');
    expect(slideCount, 2);
  });
}
