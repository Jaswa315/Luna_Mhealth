library pptx_parser;

import 'dart:io';

import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/connection_shape/pptx_connection_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/document_property/pptx_document_property_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_element_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/section/pptx_section_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_count/pptx_slide_count_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_layout_relationship/pptx_slide_layout_relationship_parser.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_core/utils/types.dart';

/// =================================================================================================
/// PPTX PptxTreeBuilder CLASS
/// =================================================================================================

/// The PptxTreeBuilder takes a .pptx file and is capable of making a
/// PptxTree object that represents given PowerPoint file.
/// It will only parse the required info to form a luna module.
class PptxTreeBuilder {
  late PptxXmlToJsonConverter _pptxLoader;
  late PptxDocumentPropertyParser _pptxDocumentPropertyParser;
  late PptxSectionBuilder _pptxSectionBuilder;
  late PptxSlideCountParser _pptxSlideCountParser;
  late PptxConnectionShapeBuilder _pptxConnectionShapeBuilder;
  late PptxSlideLayoutRelationshipParser _pptxSlideLayoutRelationshipParser;

  PptxTree _pptxTree = PptxTree();

  PptxTreeBuilder(File pptxFile) {
    _pptxLoader = PptxXmlToJsonConverter(pptxFile);
    _pptxDocumentPropertyParser = PptxDocumentPropertyParser(_pptxLoader);
    _pptxSlideCountParser = PptxSlideCountParser(_pptxLoader);
    _pptxSectionBuilder = PptxSectionBuilder(_pptxLoader, _pptxSlideCountParser);
    _pptxConnectionShapeBuilder = PptxConnectionShapeBuilder();
    _pptxSlideLayoutRelationshipParser = PptxSlideLayoutRelationshipParser(_pptxLoader);
  }

  void _updateTitle() {
    _pptxTree.title = _pptxDocumentPropertyParser.title;
  }

  void _updateAuthor() {
    _pptxTree.author = _pptxDocumentPropertyParser.author;
  }

  void _updateWidth() {
    Json presentationMap = _pptxLoader.getJsonFromPptx("ppt/presentation.xml");

    _pptxTree.width =
        EMU(int.parse(presentationMap[ePresentation][eSlideSize]?[eCX] ?? "0"));
  }

  void _updateHeight() {
    Json presentationMap = _pptxLoader.getJsonFromPptx("ppt/presentation.xml");

    _pptxTree.height =
        EMU(int.parse(presentationMap[ePresentation][eSlideSize]?[eCY] ?? "0"));
  }

  void _updateSection() {
    _pptxTree.section = _pptxSectionBuilder.getSection();
  }

  List<Shape> _parseShapeTree(Json shapeTree) {
    List<Shape> shapes = [];

    shapeTree.forEach((key, value) {
      switch (key) {
        case eConnectionShape:
          shapes.addAll(
            _pptxConnectionShapeBuilder.getConnectionShapes(shapeTree[key]),
          );
          break;
      }
    });

    return shapes;
  }

  void _updateSlides() {
    List<Slide> slides = [];
    for (int i = 1; i <= _pptxSlideCountParser.slideCount; i++) {
      Slide slide = Slide();
      // add slide layout elements first.
      slide.shapes = _parseShapeTree(
        _pptxLoader.getJsonFromPptx(
          "ppt/slideLayouts/slideLayout${_pptxSlideLayoutRelationshipParser.getSlideLayoutIndex(i)}.xml",
        )[eSlideLayoutData][eCommonSlideData][eShapeTree],
      );

      // add slide elements afterwards.
      slide.shapes?.addAll(_parseShapeTree(
        _pptxLoader.getJsonFromPptx(
          "ppt/slides/slide$i.xml",
        )[eSlide][eCommonSlideData][eShapeTree],
      ));

      slides.add(slide);
    }

    _pptxTree.slides = slides;
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
