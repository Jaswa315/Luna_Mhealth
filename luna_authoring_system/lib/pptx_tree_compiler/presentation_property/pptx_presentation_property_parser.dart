import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/presentation_property/pptx_presentation_property_constants.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_core/utils/types.dart';

/// This class is responsible for parsing presentation's width and
/// height from presentation.xml.
class PptxPresentationPropertyParser {
  late final PptxXmlToJsonConverter _pptxLoader;
  late final Json _presentationMap;
  late final EMU _width;
  late final EMU _height;

  PptxPresentationPropertyParser(this._pptxLoader) {
    _presentationMap = _pptxLoader.getJsonFromPptx("ppt/presentation.xml");
    _width = _parseWidth();
    _height = _parseHeight();
  }

  EMU _parseWidth() {
    try {
      return EMU(int.parse(_presentationMap[ePresentation][eSlideSize]?[eCX]));
    } catch (e) {
      throw Exception(
        "Error parsing slide width in presentationMap: ${_presentationMap[ePresentation][eSlideSize]}",
      );
    }
  }

  EMU _parseHeight() {
    try {
      return EMU(int.parse(_presentationMap[ePresentation][eSlideSize]?[eCY]));
    } catch (e) {
      throw Exception(
        "Error parsing slide height in presentationMap: ${_presentationMap[ePresentation][eSlideSize]}",
      );
    }
  }

  EMU get width => _width;
  EMU get height => _height;
}
