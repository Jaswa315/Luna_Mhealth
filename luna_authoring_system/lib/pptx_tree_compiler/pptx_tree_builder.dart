library pptx_parser;

import 'dart:io';

import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/document_property/pptx_document_property_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/presentation_property/pptx_presentation_property_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/section/pptx_section_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide/pptx_slide_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_count/pptx_slide_count_parser.dart';

/// The PptxTreeBuilder takes a .pptx file and is capable of making a
/// PptxTree object that represents given PowerPoint file.
/// It will only parse the required info to form a luna module.
class PptxTreeBuilder {
  late PptxXmlToJsonConverter _pptxLoader;
  late PptxDocumentPropertyBuilder _pptxDocumentPropertyParser;
  late PptxPresentationPropertyParser _pptxPresentationPropertyParser;
  late PptxSectionBuilder _pptxSectionBuilder;
  late PptxSlideCountParser _pptxSlideCountParser;
  late PptxSlideBuilder _pptxSlideBuilder;

  PptxTree _pptxTree = PptxTree();

  PptxTreeBuilder(File pptxFile) {
    _pptxLoader = PptxXmlToJsonConverter(pptxFile);
    _pptxDocumentPropertyParser = PptxDocumentPropertyBuilder(_pptxLoader);
    _pptxPresentationPropertyParser = PptxPresentationPropertyParser(_pptxLoader);
    _pptxSlideCountParser = PptxSlideCountParser(_pptxLoader);
    _pptxSectionBuilder = PptxSectionBuilder(_pptxLoader, _pptxSlideCountParser);
    _pptxSlideBuilder = PptxSlideBuilder(_pptxLoader, _pptxSlideCountParser);
  }

  void _updateTitle() {
    _pptxTree.title = _pptxDocumentPropertyParser.title;
  }

  void _updateAuthor() {
    _pptxTree.author = _pptxDocumentPropertyParser.author;
  }

  void _updateWidth() {
    _pptxTree.width = _pptxPresentationPropertyParser.width;
  }

  void _updateHeight() {
    _pptxTree.height = _pptxPresentationPropertyParser.height;
  }

  void _updateSection() {
    _pptxTree.section = _pptxSectionBuilder.getSection();
  }

  void _updateSlides() {
    _pptxTree.slides = _pptxSlideBuilder.getSlides();
  }

  PptxTree getPptxTree() {
    _updateTitle();
    _updateAuthor();
    _updateWidth();
    _updateHeight();
    _updateSection();
    _updateSlides();

    return _pptxTree;
  }
}
