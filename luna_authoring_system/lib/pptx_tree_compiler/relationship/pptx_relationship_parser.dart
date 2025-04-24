import 'package:luna_authoring_system/pptx_data_objects/pptx_hierarchy.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/relationship/pptx_relationship_constants.dart';
import 'package:luna_core/utils/types.dart';

/// This class parses the slide relationships in .xml.rels files,
/// to get the target elements in the xml.
class PptxRelationshipParser {
  PptxXmlToJsonConverter _pptxLoader;
  PptxRelationshipParser(this._pptxLoader);

  /// Parse the target string to get the index of the parent.
  int _parseParentTargetString(String target, PptxHierarchy pptxHierarchy) {
    RegExp regex = RegExp('${pptxHierarchy.parent!.name}(\\d+)\\.xml');
    Match? match = regex.firstMatch(target);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    throw Exception("Invalid slide layout target string: $target");
  }

  /// Get the parent index of the current hierarchy.
  int getParentIndex(int currentIndex, PptxHierarchy pptxHierarchy) {
    // Every slide/slideLayout/slideMaster has a .rels file that contains the relationships.
    dynamic slideRelationships = _pptxLoader.getJsonFromPptx(
      "ppt/${pptxHierarchy.name}s/_rels/${pptxHierarchy.name}$currentIndex.xml.rels",
    )[eRelationships][eRelationship];

    if (slideRelationships is List) {
      for (Json relationship in slideRelationships) {
        // Assuming the current _pptxHierarchy has a parent hierarchy.
        if (relationship[eType] == pptxHierarchy.parent!.relationshipType) {
          return _parseParentTargetString(relationship[eTarget], pptxHierarchy);
        }
      }
    } else if (slideRelationships is Map) {
      // Assuming the current _pptxHierarchy has a parent hierarchy.
      if (slideRelationships[eType] ==
          pptxHierarchy.parent!.relationshipType) {
        return _parseParentTargetString(slideRelationships[eTarget], pptxHierarchy);
      }
    } else {
      throw Exception("Invalid slide relationships format: $slideRelationships");
    }
    throw Exception(
      "Slide layout not found in ppt/${pptxHierarchy.name}s/_rels/${pptxHierarchy.name}$currentIndex.xml.rels",
    );
  }
}
