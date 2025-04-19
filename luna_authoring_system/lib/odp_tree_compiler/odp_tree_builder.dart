library odp_parser;

import 'dart:io';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_core/utils/types.dart';

/// =================================================================================================
/// ODP XML ELEMENTS CONSTANTS
/// =================================================================================================
/// The XML element for the document containing metadata.
const String eMetaDocument = 'office:document-meta';

/// The XML element for the metadata.
const String eMeta = 'office:meta';

/// The XML element for the title of the PowerPoint.
const String eTitle = 'dc:title';

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
    Json coreMap = _odpLoader.getJsonFromPptx("meta.xml");
    _odpTree.title = coreMap[eMetaDocument]?[eMeta]?[eTitle] ?? "Untitled";
  }

  PptxTree getOdpTree() {
    _updateTitle();

    return _odpTree;
  }
}