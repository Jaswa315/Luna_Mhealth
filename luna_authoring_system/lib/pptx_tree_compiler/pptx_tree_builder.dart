library pptx_parser;

import 'dart:io';

import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/connection_shape/pptx_connection_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/document_property/pptx_document_property_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/picture_shape/pptx_picture_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/presentation_property/pptx_presentation_property_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/relationship/pptx_relationship_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/section/pptx_section_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/shape/pptx_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide/pptx_slide_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_count/pptx_slide_count_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_layout/pptx_slide_layout_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_master/pptx_slide_master_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/textbox_shape/pptx_textbox_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/transform/pptx_transform_builder.dart';

/// The PptxTreeBuilder takes a .pptx file and is capable of making a
/// PptxTree object that represents given PowerPoint file.
/// It will only parse the required info to form a luna module.
class PptxTreeBuilder {
  late PptxXmlToJsonConverter _pptxLoader;
  late PptxDocumentPropertyBuilder _pptxDocumentPropertyParser;
  late PptxPresentationPropertyBuilder _pptxPresentationPropertyParser;
  late PptxSectionBuilder _pptxSectionBuilder;
  late PptxSlideCountParser _pptxSlideCountParser;
  late PptxShapeBuilder _pptxShapeBuilder;
  late PptxTransformBuilder _pptxTransformBuilder;
  late PptxConnectionShapeBuilder _pptxConnectionShapeBuilder;
  late PptxPictureShapeBuilder _pptxPictureShapeBuilder;
  late PptxRelationshipParser _pptxRelationshipParser;
  late PptxSlideBuilder _pptxSlideBuilder;
  late PptxTextboxShapeBuilder _pptxTextboxShapeBuilder;
  late PptxSlideLayoutParser _pptxSlideLayoutParser;
  late PptxSlideMasterParser _pptxSlideMasterParser;

  PptxTree _pptxTree = PptxTree();

  PptxTreeBuilder(File pptxFile) {
    _pptxLoader = PptxXmlToJsonConverter(pptxFile);
    _pptxDocumentPropertyParser = PptxDocumentPropertyBuilder(_pptxLoader);
    _pptxPresentationPropertyParser = PptxPresentationPropertyBuilder(_pptxLoader);
    _pptxSlideCountParser = PptxSlideCountParser(_pptxLoader);
    _pptxSectionBuilder = PptxSectionBuilder(_pptxLoader, _pptxSlideCountParser);
    _pptxTransformBuilder = PptxTransformBuilder();
    _pptxConnectionShapeBuilder = PptxConnectionShapeBuilder(_pptxTransformBuilder);
    _pptxRelationshipParser = PptxRelationshipParser(_pptxLoader);
    _pptxPictureShapeBuilder = PptxPictureShapeBuilder(_pptxTransformBuilder, _pptxRelationshipParser);
    _pptxSlideLayoutParser = PptxSlideLayoutParser(_pptxLoader);
    _pptxSlideMasterParser = PptxSlideMasterParser(_pptxLoader);
    _pptxTextboxShapeBuilder = PptxTextboxShapeBuilder(_pptxTransformBuilder, _pptxRelationshipParser, _pptxSlideLayoutParser, _pptxSlideMasterParser);
    _pptxShapeBuilder = PptxShapeBuilder(_pptxConnectionShapeBuilder, _pptxPictureShapeBuilder, _pptxTextboxShapeBuilder);
    _pptxSlideBuilder = PptxSlideBuilder(_pptxLoader, _pptxSlideCountParser, _pptxShapeBuilder, _pptxRelationshipParser);
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
