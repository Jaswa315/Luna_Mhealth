import 'package:luna_authoring_system/pptx_data_objects/pptx_hierarchy.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/relationship/pptx_relationship_constants.dart';
import 'package:luna_core/utils/types.dart';

/// This class parses the slide relationships in .xml.rels files.
class PptxRelationshipParser {
  PptxXmlToJsonConverter _pptxLoader;
  PptxHierarchy _pptxHierarchy;
  PptxRelationshipParser(this._pptxLoader, this._pptxHierarchy);

  /// Parse the target string to get the index of the parent: (slideLayout/slideMaster/theme)
  int _parseParentTargetString(String target) {
    RegExp regex = RegExp('${_pptxHierarchy.parent!.name}(\\d+)\\.xml');
    Match? match = regex.firstMatch(target);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    throw Exception("Invalid slide layout target string: $target");
  }

  /// Get the parent index of the current slide/slideLayout/slideMaster.
  /// ex) the slideLayout/slideMaster/theme index of the current slide/slideLayout/slideMaster.
  int getParentIndex(int currentIndex) {
    // Every slide/slideLayout/slideMaster has a .rels file that contains the relationships.
    dynamic slideRelationships = _pptxLoader.getJsonFromPptx(
      "ppt/${_pptxHierarchy.name}s/_rels/${_pptxHierarchy.name}$currentIndex.xml.rels",
    )[eRelationships][eRelationship];

    if (slideRelationships is List) {
      for (Json relationship in slideRelationships) {
        // Assuming the current _pptxHierarchy is either slide/slideLayout/slideMaster.
        if (relationship[eType] == _pptxHierarchy.parent!.relationshipType) {
          return _parseParentTargetString(relationship[eTarget]);
        }
      }
    } else if (slideRelationships is Map) {
      // Assuming the current _pptxHierarchy is either slide/slideLayout/slideMaster.
      if (slideRelationships[eType] ==
          _pptxHierarchy.parent!.relationshipType) {
        return _parseParentTargetString(slideRelationships[eTarget]);
      }
    } else {
      throw Exception("Invalid slide relationships format: $slideRelationships");
    }
    throw Exception(
      "Slide layout not found in ppt/${_pptxHierarchy.name}s/_rels/${_pptxHierarchy.name}$currentIndex.xml.rels",
    );
  }
}
