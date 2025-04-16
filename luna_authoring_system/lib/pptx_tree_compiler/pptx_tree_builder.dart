library pptx_parser;

import 'dart:io';

import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/connection_shape/pptx_connection_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_element_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/section/pptx_section_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_count/pptx_slide_count_parser.dart';
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
  late PptxSectionBuilder _pptxSectionBuilder;
  late PptxSlideCountParser _pptxSlideCountParser;
  late PptxConnectionShapeBuilder _pptxConnectionShapeBuilder;

  PptxTree _pptxTree = PptxTree();

  PptxTreeBuilder(File pptxFile) {
    _pptxLoader = PptxXmlToJsonConverter(pptxFile);
    _pptxSlideCountParser = PptxSlideCountParser(_pptxLoader);
    _pptxSectionBuilder = PptxSectionBuilder(_pptxLoader, _pptxSlideCountParser);
    _pptxConnectionShapeBuilder = PptxConnectionShapeBuilder();
  }

  void _updateTitle() {
    Json coreMap = _pptxLoader.getJsonFromPptx("docProps/core.xml");
    _pptxTree.title = coreMap[eCoreProperties]?[eTitle] ?? "Untitled";
  }

  void _updateAuthor() {
    Json coreMap = _pptxLoader.getJsonFromPptx("docProps/core.xml");
    _pptxTree.author = coreMap[eCoreProperties]?[eAuthor] ?? "Unknown Author";
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

  int _getSlideLayoutIndex(int slideIndex) {
    // Every slide has a .rels file that contains the relationships.
    dynamic slideRelationships = _pptxLoader.getJsonFromPptx(
        "ppt/slides/_rels/slide$slideIndex.xml.rels")[eRelationships];

    if (slideRelationships is List) {
      for (Json relationship in slideRelationships) {
        if (relationship[eType] == eSlideLayoutKey) {
          return _parseSlideLayoutTargetString(relationship[eTarget]);
        }
      }
    } else if (slideRelationships is Map) {
      if (slideRelationships[eRelationship][eType] == eSlideLayoutKey) {
        return _parseSlideLayoutTargetString(
            slideRelationships[eRelationship][eTarget]);
      }
    } else {
      throw Exception(
          "Invalid slide relationships format: $slideRelationships");
    }
    throw Exception(
        "Slide layout not found in ppt/slides/_rels/slide$slideIndex.xml.rels");
  }

  int _parseSlideLayoutTargetString(String target) {
    RegExp regex = RegExp(r'slideLayout(\d+)\.xml');
    Match? match = regex.firstMatch(target);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    throw Exception("Invalid slide layout target string: $target");
  }

  List<Shape> _parseShapeTree(Json shapeTree) {
    List<Shape> shapes = [];

    shapeTree.forEach((key, value) {
      switch (key) {
        case eConnectionShape:
          shapes.addAll(_pptxConnectionShapeBuilder.getConnectionShapes(shapeTree[key]));
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
      slide.shapes = _parseShapeTree(_pptxLoader.getJsonFromPptx(
              "ppt/slideLayouts/slideLayout${_getSlideLayoutIndex(i)}.xml")[
          eSlideLayoutData][eCommonSlideData][eShapeTree]);

      // add slide elements afterwards.
      slide.shapes?.addAll(_parseShapeTree(
          _pptxLoader.getJsonFromPptx("ppt/slides/slide$i.xml")[eSlide]
              [eCommonSlideData][eShapeTree]));
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
