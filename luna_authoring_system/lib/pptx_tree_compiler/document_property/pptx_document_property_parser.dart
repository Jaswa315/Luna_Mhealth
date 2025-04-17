import 'package:luna_authoring_system/pptx_tree_compiler/document_property/pptx_document_property_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_core/utils/types.dart';

/// This class parses docProps.xml to get the title and author in the .pptx file.
class PptxDocumentPropertyParser {
  PptxXmlToJsonConverter _pptxLoader;
  late final Json _coreMap;
  late final String _title;
  late final String _author;
  static const String untitled = "Untitled";
  static const String unknownAuthor = "Unknown Author";
  
  PptxDocumentPropertyParser(this._pptxLoader) {
    _coreMap = _pptxLoader.getJsonFromPptx("docProps/core.xml");
    _title = _parseTitle();
    _author = _parseAuthor();
  }

  String _parseTitle() {
    return _coreMap[eCoreProperties]?[eTitle] ?? untitled;
  }

  String _parseAuthor() {
    return _coreMap[eCoreProperties]?[eAuthor] ?? unknownAuthor;
  }

  String get title => _title;
  String get author => _author;
}
