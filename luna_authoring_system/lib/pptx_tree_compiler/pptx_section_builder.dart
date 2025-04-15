import 'package:luna_authoring_system/pptx_data_objects/section.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_element_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_core/utils/types.dart';

/// =================================================================================================
/// PPTX PptxSectionBuilder CLASS
/// =================================================================================================

/// PptxSectionBuilder class parses presentation.xml file and presentation.xml.rels file.
/// This class is capable of creating Section object that represents section in PowerPoint file.
/// It will only parse the required info to form a luna module.
class PptxSectionBuilder {

  late PptxXmlToJsonConverter _pptxLoader;
  PptxSectionBuilder(this._pptxLoader);

  Map<String, String> _getSlideIdToRelationshipIdMap() {
    Map<String, String> result = {};
    Json presentationMap = _pptxLoader.getJsonFromPptx("ppt/presentation.xml");
    dynamic slideIdList = presentationMap[ePresentation][eSlideIdList][eSlideId];

    if (slideIdList is List) {
      for (var element in slideIdList) {
        result[element[eSldId]] = element[eRId];
      }
    } else if (slideIdList is Json) {
      result[slideIdList[eSldId]] = slideIdList[eRId];
    } else {
      throw Exception("Invalid slideIdList format: $slideIdList. Expected List or Map.");
    }

    return result;
  }

  void _updateRelationshipIdToSlideIndexMap(Map<String, int> rIdToSlideIndex, Json relationship) {
    RegExp regex = RegExp(r'slides/slide(\d+)\.xml');
    Match? match = regex.firstMatch(relationship[eTarget]);
    if (match != null) {
      rIdToSlideIndex[relationship[eId]] = int.parse(match.group(1)!);
    } else {
      throw Exception("Slide index not found for this relationship: $relationship");
    }
  }

  Map<String, int> _getRelationshipIdToSlideIndexMap() {
    Map<String, int> result = {};
    dynamic presentationRelsMap = _pptxLoader
        .getJsonFromPptx("ppt/_rels/presentation.xml.rels")[eRelationships][eRelationship];

    if (presentationRelsMap is List) {
      for (Json relationship in presentationRelsMap) {
        if (relationship[eType] == eSlideKey) {
          _updateRelationshipIdToSlideIndexMap(result, relationship);
        }
      }
    } else if (presentationRelsMap is Map) {
      if (presentationRelsMap[eRelationship][eType] == eSlideKey) {
        _updateRelationshipIdToSlideIndexMap(result, presentationRelsMap[eRelationship]);
      }
    } else {
      throw Exception("Invalid presentation relationships: $presentationRelsMap");
    }

    return result;
  }

  dynamic _getSectionMap(Json presentationMap) {
    dynamic extensions = presentationMap[ePresentation][eExtensionList][eExtension];
    if (extensions is List) {
      for (Json extension in extensions) {
        if (extension[eUri] == eSectionKey) {
          return extension[eP14SectionList];
        }
      }
    } else if (extensions is Map) {
      if (extensions[eUri] == eSectionKey) {
        return extensions[eP14SectionList];
      }
    } else {
      throw Exception("Invalid presentation map: $presentationMap");
    }

    return null;
  }

  Map<String, int> _getSlideIdToSlideIndexMap(Map<String, String> sldIdToRId, Map<String, int> rIdToSlideIndex) {
    Map<String, int> sldIdToSlideIndex = {};
    for (var entry in sldIdToRId.entries) {
      String sldId = entry.key;
      String rId = entry.value;

      if (rIdToSlideIndex.containsKey(rId)) {
        sldIdToSlideIndex[sldId] = rIdToSlideIndex[rId]!;
      } else {
        throw Exception("Slide ID $sldId does not have a corresponding slide index.");
      }
    }

    return sldIdToSlideIndex;
  } 

  List<int> _getSlideIdsFromSectionMap(dynamic slideIdListMap, Map<String, int> sldIdToSlideIndex) {
    List<int> result = [];

    if (slideIdListMap == "") {
      // an empty list means no slides in this section.
      return result;
    }

    dynamic slideIds = slideIdListMap[eP14SlideId];

    if (slideIds is List) {
      for (Json slideId in slideIds) {
        result.add(sldIdToSlideIndex[slideId[eSldId]]!);
      }
    } else if (slideIds is Map) {
      result.add(sldIdToSlideIndex[slideIds[eSldId]]!);
    } else {
      throw Exception("Invalid slideIdList map: $slideIdListMap");
    }

    return result;
  }

  Section _getSectionFromXml(dynamic sectionMap, Map<String, int> sldIdToSlideIndex) {
    Map<String, List<int>> result = {};

    if (sectionMap is List) {
      for (Json section in sectionMap) {
        result[section[eName]] = _getSlideIdsFromSectionMap(section[eP14SlideIdList], sldIdToSlideIndex);
      }
    } else if (sectionMap is Map) {
      result[sectionMap[eName]] = _getSlideIdsFromSectionMap(sectionMap[eP14SlideIdList], sldIdToSlideIndex);
    } else {
      throw Exception("Invalid section map: $sectionMap");
    }

    return Section(result);
  }

  int _getSlideCount() {
    Json appMap = _pptxLoader.getJsonFromPptx("docProps/app.xml");

    return int.parse(appMap[eProperties][eSlides]);
  }

  Section _getDefaultSection() {
    // If there is no section, create a default section with all slides.
    // Add 1 as the slide index starts from 1.
    return Section({
      Section.defaultSectionName:
          List<int>.generate(_getSlideCount(), (index) => index + 1),
    });
  }
  
  Section getSection() {
    Json presentationMap = _pptxLoader.getJsonFromPptx("ppt/presentation.xml");
    dynamic sectionMap = _getSectionMap(presentationMap);

    if (sectionMap == null) {
      return _getDefaultSection();
    } else {
      Map<String, String> sldIdToRId = _getSlideIdToRelationshipIdMap();
      Map<String, int> rIdToSlideIndex = _getRelationshipIdToSlideIndexMap();
      Map<String, int> sldIdToSlideIndex = _getSlideIdToSlideIndexMap(sldIdToRId, rIdToSlideIndex);

      return _getSectionFromXml(sectionMap[eP14Section], sldIdToSlideIndex);
    }
  }
}