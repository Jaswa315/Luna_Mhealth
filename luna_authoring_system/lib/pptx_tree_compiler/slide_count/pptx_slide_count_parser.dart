import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_count/pptx_slide_count_constants.dart';
import 'package:luna_core/utils/types.dart';

/// This class parses app.xml to get the total slide count in the .pptx file.
/// The number of slide count is used for forming default section,
/// and iterating through the slides to parse the slide content.
class PptxSlideCountParser {
  PptxXmlToJsonConverter _pptxLoader;
  late final int _slideCount;

  PptxSlideCountParser(this._pptxLoader) {
    _slideCount = _getSlideCount();
  }

  int _getSlideCount() {
    Json appMap = _pptxLoader.getJsonFromPptx("docProps/app.xml");

    return int.parse(appMap[eProperties][eSlides]);
  }

  int get slideCount => _slideCount;
}
