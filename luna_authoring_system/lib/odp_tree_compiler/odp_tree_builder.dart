library odp_parser;

import 'dart:io';
import 'dart:math';
import 'package:luna_authoring_system/odp_tree_compiler/odp_xml_element_constants.dart';
import 'package:luna_authoring_system/odp_tree_compiler/unit_conversion_constants.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_core/units/point.dart';
import 'package:luna_core/utils/types.dart';

/// =================================================================================================
/// PPTX OdpTreeBuilder CLASS
/// =================================================================================================

/// The OdpTreeBuilder takes a .odp file and is capable of making a
/// OdpTree object that represents given OpenDocument Presentation file.
/// It will only parse the required info to form a luna module.
class OdpTreeBuilder {
  late PptxXmlToJsonConverter _odpLoader;

  PptxTree _odpTree = PptxTree();

  OdpTreeBuilder(File odpFile) {
    _odpLoader = PptxXmlToJsonConverter(odpFile);
  }

  void _updateTitle() {
    Json metaMap = _odpLoader.getJsonFromPptx("meta.xml");
    _odpTree.title = metaMap[eMetaDocument]?[eMeta]?[eTitle];
  }

  void _updateAuthor() {
    Json metaMap = _odpLoader.getJsonFromPptx("meta.xml");
    _odpTree.author = metaMap[eMetaDocument]?[eMeta]?[eAuthor];
  }

  EMU _convertCmToEMU(double cm) {
    return EMU((cm * emusPerCentimeter).toInt());
  }

  String _extractNumber(String str) {
    return str.replaceAll(RegExp(r'[^0-9.]'), '');
  }

  EMU _getPageDimension(Json stylesMap, String pageDimensionName) {
    String pageLayoutName = stylesMap[eStylesDocument]?[eMasterStyles]?
      [eMasterPage]?[ePageLayoutName];
    int pageLayoutIndex = int.parse(_extractNumber(pageLayoutName));
    String pageDimension = stylesMap[eStylesDocument]?[eAutomaticStyles]?
      [ePageLayout]?[pageLayoutIndex]?[ePageLayoutProperties]?[pageDimensionName];
    return _convertCmToEMU(double.parse(_extractNumber(pageDimension)));
  }

  void _updateWidth() {
    Json stylesMap = _odpLoader.getJsonFromPptx("styles.xml");
    _odpTree.width = _getPageDimension(stylesMap, ePageWidth);
  }

  void _updateHeight() {
    Json stylesMap = _odpLoader.getJsonFromPptx("styles.xml");
    _odpTree.height = _getPageDimension(stylesMap, ePageHeight);
  }

  int _getSlideCount() {
    Json contentMap = _odpLoader.getJsonFromPptx("content.xml");
    final slides = contentMap[eContentDocument]?[eBody]?[ePresentation]?[ePage];
    return (slides is List) ? slides.length : 1;
  }

  EMU _getOffsetFromCoordinates(String startCoordinate, String endCoordinate) {
    return _convertCmToEMU(min(double.parse(_extractNumber(startCoordinate)), 
        double.parse(_extractNumber(endCoordinate))));
  }

  Point _getOffset(Json shapeMap) {
    EMU offsetX = _getOffsetFromCoordinates(shapeMap[eX1], shapeMap[eX2]);
    EMU offsetY = _getOffsetFromCoordinates(shapeMap[eY1], shapeMap[eY2]);
    return Point(offsetX, offsetY);
  }

  EMU _getSizeFromCoordinates(String startCoordinate, String endCoordinate) {
    return _convertCmToEMU((double.parse(_extractNumber(endCoordinate)) - 
        double.parse(_extractNumber(startCoordinate))).abs());
  }

  Point _getSize(Json shapeMap) {
    EMU sizeX = _getSizeFromCoordinates(shapeMap[eX1], shapeMap[eX2]);
    EMU sizeY = _getSizeFromCoordinates(shapeMap[eY1], shapeMap[eY2]);
    return Point(sizeX, sizeY); 
  }

  Transform _getTransform(Json shapeMap) {
    Point offset = _getOffset(shapeMap);
    Point size = _getSize(shapeMap);
    return Transform(offset, size);
  }

  ConnectionShape _getConnectionShape(Json shapeMap) {
    Transform transform = _getTransform(shapeMap);
    bool isFlippedVertically = double.parse(_extractNumber(shapeMap[eY2]))<
        double.parse(_extractNumber(shapeMap[eY1]));
    return ConnectionShape(
      transform : transform,
      isFlippedVertically: isFlippedVertically
    );
  }

  List<Shape> _getShapes(Json contentMap, int slideIndex) {
    List<Shape> shapes = [];
    Json shapeTree = contentMap[eContentDocument]?[eBody]?[ePresentation]?[ePage]?[slideIndex] ??
      contentMap[eContentDocument]?[eBody]?[ePresentation]?[ePage];
    shapeTree.forEach((key, value) {
      switch (key) {
        case eConnectionShape:
          shapes.add(_getConnectionShape(shapeTree[key]));
          break;
      }
    });
    return shapes;
  }

  void _updateSlides() {
    List<Slide> slides = [];
    for (int i = 0; i < _getSlideCount(); i++) {
      Slide slide = Slide();
      slide.shapes = _getShapes(_odpLoader.getJsonFromPptx("content.xml"), i);
      slides.add(slide);
    }
    _odpTree.slides = slides;
  }

  PptxTree getOdpTree() {
    _updateTitle();
    _updateAuthor();
    _updateWidth();
    _updateHeight();
    _updateSlides();

    return _odpTree;
  }
}