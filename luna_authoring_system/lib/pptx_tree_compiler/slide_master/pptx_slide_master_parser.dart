import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_master/pptx_slide_master_constants.dart';

/// This class is responsible for parsing the slide master xml file.
class PptxSlideMasterParser {
  final PptxXmlToJsonConverter _pptxXmlToJsonConverter;

  PptxSlideMasterParser(this._pptxXmlToJsonConverter);

  /// Get the font size from the slide master text styles
  /// based on the given text style type.
  int getFontSizeFromSlideMaster(int parentIndex, String textStyle) {
    final slideMasterMap = _pptxXmlToJsonConverter.getJsonFromPptx(
      'ppt/slideMasters/slideMaster$parentIndex.xml',
    )[eSlideMaster][eTextStyles];

    if (textStyle == body) {
      return int.parse(slideMasterMap[eBodyStyle][eLvl1pPr][eDefRPr][eSz]);
    }
    return int.parse(slideMasterMap[eOtherStyle][eLvl1pPr][eDefRPr][eSz]);
  }
}