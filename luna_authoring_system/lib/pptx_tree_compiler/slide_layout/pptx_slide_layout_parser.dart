import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_layout/pptx_slide_layout_constants.dart';
import 'package:luna_core/utils/types.dart';

/// This class is responsible for parsing the slide layout xml file.
class PptxSlideLayoutParser {
  final PptxXmlToJsonConverter _pptxLoader;

  PptxSlideLayoutParser(this._pptxLoader);

  /// Get the placeholder shape from the parent slide layout that corresponds
  /// to the given parent index and placeholder index.
  Json getPlaceholderShape(int parentIndex, int placeholderIndex, String shapeType) {
    
    final parentShapeMap = _pptxLoader.getJsonFromPptx(
      'ppt/slideLayouts/slideLayout$parentIndex.xml',
    )[eSlideLayout][eCommonSlideData][eShapeTree][shapeType];

    if (parentShapeMap == null) {
      throw Exception('Parent shape map is null for index $parentIndex');
    }

    if (parentShapeMap is List) {
      for (final shape in parentShapeMap) {
        if (int.parse(shape[eNvSpPr][eNvPr][ePlaceholder][eIdx]) == placeholderIndex) {
          return shape;
        }
      }
    } else if (parentShapeMap is Map) {
      if (int.parse(parentShapeMap[eNvSpPr][eNvPr][ePlaceholder][eIdx]) == placeholderIndex) {
        return parentShapeMap as Json;
      }
    }
    throw Exception('Placeholder shape with index $placeholderIndex not found in parent slide layout.');
  }
}