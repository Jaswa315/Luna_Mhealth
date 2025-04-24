import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide/pptx_slide_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_count/pptx_slide_count_parser.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'dart:io';

PptxSlideBuilder getPptxSlideBuilder(String pptxFilePath) {
  final pptxFile = File(pptxFilePath);
  PptxXmlToJsonConverter pptxLoader = PptxXmlToJsonConverter(pptxFile);
  PptxSlideCountParser pptxSlideCountParser = PptxSlideCountParser(pptxLoader);

  return PptxSlideBuilder(pptxLoader, pptxSlideCountParser);
}
void main() {
  group('PptxSlideBuilder Tests', () {
    test('A single connection shape is retrieved from the slide hierarchy.', () {
      PptxSlideBuilder pptxSlideBuilder = getPptxSlideBuilder('test/test_assets/A line.pptx');
      List<Slide> slides = pptxSlideBuilder.getSlides();

      expect(slides.length, 1);
      expect(slides[0].shapes![0].type, ShapeType.connection);
    });

    test('A single connection shape is retrieved from the slide layout hierarchy.', () {
      PptxSlideBuilder pptxSlideBuilder = getPptxSlideBuilder('test/test_assets/A line in slideLayout.pptx');
      List<Slide> slides = pptxSlideBuilder.getSlides();

      expect(slides.length, 1);
      expect(slides[0].shapes![0].type, ShapeType.connection);
    });

    test('A single connection shape is retrieved from the slide master hierarchy.', () {
      PptxSlideBuilder pptxSlideBuilder = getPptxSlideBuilder('test/test_assets/A line in slideMaster.pptx');
      List<Slide> slides = pptxSlideBuilder.getSlides();

      expect(slides.length, 1);
      expect(slides[0].shapes![0].type, ShapeType.connection);
    });

    test('connection shapes are retrieved from all hierarchy.', () {
      PptxSlideBuilder pptxSlideBuilder = getPptxSlideBuilder('test/test_assets/A line in all hierarchy.pptx');
      List<Slide> slides = pptxSlideBuilder.getSlides();

      expect(slides.length, 1);
      expect(slides[0].shapes![0].type, ShapeType.connection);
      expect(slides[0].shapes![1].type, ShapeType.connection);
      expect(slides[0].shapes![2].type, ShapeType.connection);
    });
  });
}
