import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_layout_relationship/pptx_slide_layout_relationship_constants.dart';
import 'package:luna_core/utils/types.dart';

/// This class parses the slide layout index from the slide relationships.
/// It is used to determine the layout of a slide in a PowerPoint presentation.
class PptxSlideLayoutRelationshipParser {
  PptxXmlToJsonConverter _pptxLoader;
  PptxSlideLayoutRelationshipParser(this._pptxLoader);

  int _parseSlideLayoutTargetString(String target) {
    RegExp regex = RegExp(r'slideLayout(\d+)\.xml');
    Match? match = regex.firstMatch(target);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    throw Exception("Invalid slide layout target string: $target");
  }

  int getSlideLayoutIndex(int slideIndex) {
    // Every slide has a .rels file that contains the relationships.
    dynamic slideRelationships = _pptxLoader.getJsonFromPptx("ppt/slides/_rels/slide$slideIndex.xml.rels")[eRelationships];

    if (slideRelationships is List) {
      for (Json relationship in slideRelationships) {
        if (relationship[eType] == eSlideLayoutKey) {
          return _parseSlideLayoutTargetString(relationship[eTarget]);
        }
      }
    } else if (slideRelationships is Map) {
      if (slideRelationships[eRelationship][eType] == eSlideLayoutKey) {
        return _parseSlideLayoutTargetString(slideRelationships[eRelationship][eTarget]);
      }
    } else {
      throw Exception("Invalid slide relationships format: $slideRelationships");
    }
    throw Exception("Slide layout not found in ppt/slides/_rels/slide$slideIndex.xml.rels");
  }
}
