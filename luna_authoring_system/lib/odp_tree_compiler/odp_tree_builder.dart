library odp_parser;

import 'dart:io';
import 'package:luna_authoring_system/odp_tree_compiler/odp_xml_element_constants.dart';
import 'package:luna_authoring_system/odp_tree_compiler/unit_conversion_constants.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_core/units/emu.dart';
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

  EMU convertCmToEMU(double cm) {
    return EMU((cm * emusPerCentimeter).toInt());
  }

  String extractNumber(String str) {
    return str.replaceAll(RegExp(r'[^0-9.]'), '');
  }

  EMU getPageDimension(Json stylesMap, String pageDimensionName) {
    String pageLayoutName = stylesMap[eStylesDocument]?[eMasterStyles]?
      [eMasterPage]?[ePageLayoutName];
    int pageLayoutIndex = int.parse(extractNumber(pageLayoutName));
    String pageDimension = stylesMap[eStylesDocument]?[eAutomaticStyles]?
      [ePageLayout]?[pageLayoutIndex]?[ePageLayoutProperties]?[pageDimensionName];
    double dimension = double.parse(extractNumber(pageDimension));
    return convertCmToEMU(dimension);
  }

  void _updateWidth() {
    Json stylesMap = _odpLoader.getJsonFromPptx("styles.xml");
    _odpTree.width = getPageDimension(stylesMap, ePageWidth);
  }

  void _updateHeight() {
    Json stylesMap = _odpLoader.getJsonFromPptx("styles.xml");
    _odpTree.height = getPageDimension(stylesMap, ePageHeight);
  }

  PptxTree getOdpTree() {
    _updateTitle();
    _updateAuthor();
    _updateWidth();
    _updateHeight();

    return _odpTree;
  }
}