library pptx_parser;

import 'dart:io';
import 'dart:ui';

import 'package:luna_authoring_system/helper/color_conversions.dart';
import 'package:luna_authoring_system/pptx_data_objects/alpha.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/point_2d.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_data_objects/srgb_color.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_element_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_core/utils/types.dart';

/// =================================================================================================
/// PPTX PptxTreeBuilder CLASS
/// =================================================================================================

/// The PptxTreeBuilder takes a .pptx file and is capable of making a
/// PptxTree object that represents given PowerPoint file.
/// It will only parse the required info to form a luna module.
class PptxTreeBuilder {
  late PptxXmlToJsonConverter _pptxLoader;
  PptxTree _pptxTree = PptxTree();

  PptxTreeBuilder(File pptxFile) {
    _pptxLoader = PptxXmlToJsonConverter(pptxFile);
  }

  void _updateTitle() {
    Json coreMap = _pptxLoader.getJsonFromPptx("docProps/core.xml");
    String eCoreProperties = 'cp:coreProperties';
    _pptxTree.title = coreMap[eCoreProperties]?[eTitle] ?? "Untitled";
  }

  void _updateAuthor() {
    Json coreMap = _pptxLoader.getJsonFromPptx("docProps/core.xml");
    String eCoreProperties = 'cp:coreProperties';
    _pptxTree.author = coreMap[eCoreProperties]?[eAuthor] ?? "Unknown Author";
  }

  void _updateWidth() {
    Json presentationMap = _pptxLoader.getJsonFromPptx("ppt/presentation.xml");

    _pptxTree.width =
        EMU(int.parse(presentationMap[ePresentation][eSlideSize]?[eCX] ?? "0"));
  }

  void _updateHeight() {
    Json presentationMap = _pptxLoader.getJsonFromPptx("ppt/presentation.xml");

    _pptxTree.height =
        EMU(int.parse(presentationMap[ePresentation][eSlideSize]?[eCY] ?? "0"));
  }

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

  Map<String, List<int>> _getSection(dynamic sectionMap, Map<String, int> sldIdToSlideIndex) {
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

    return result;
  }

  void _updateSection() {
    Json presentationMap = _pptxLoader.getJsonFromPptx("ppt/presentation.xml");
    dynamic sectionMap = _getSectionMap(presentationMap);

    if (sectionMap == null) {
      // If there is no section, create a default section with all slides.
      // Add 1 as the slide index starts from 1.
      _pptxTree.section = {
        PptxTree.defaultSectionName:
            List<int>.generate(_getSlideCount(), (index) => index + 1),
      };
    } else {
      Map<String, String> sldIdToRId = _getSlideIdToRelationshipIdMap();
      Map<String, int> rIdToSlideIndex = _getRelationshipIdToSlideIndexMap();
      Map<String, int> sldIdToSlideIndex = _getSlideIdToSlideIndexMap(sldIdToRId, rIdToSlideIndex);
      _pptxTree.section = _getSection(sectionMap[eP14Section], sldIdToSlideIndex);
    }
  }

  int _getSlideCount() {
    Json appMap = _pptxLoader.getJsonFromPptx("docProps/app.xml");

    return int.parse(appMap[eProperties][eSlides]);
  }

  int _getSlideLayoutIndex(int slideIndex) {
    // Every slide has a .rels file that contains the relationships.
    dynamic slideRelationships = _pptxLoader.getJsonFromPptx(
        "ppt/slides/_rels/slide$slideIndex.xml.rels")[eRelationships];

    if (slideRelationships is List) {
      for (Json relationship in slideRelationships) {
        if (relationship[eType] == eSlideLayoutKey) {
          return _parseSlideLayoutTargetString(relationship[eTarget]);
        }
      }
    } else if (slideRelationships is Map) {
      if (slideRelationships[eRelationship][eType] == eSlideLayoutKey) {
        return _parseSlideLayoutTargetString(
            slideRelationships[eRelationship][eTarget]);
      }
    } else {
      throw Exception(
          "Invalid slide relationships format: $slideRelationships");
    }
    throw Exception(
        "Slide layout not found in ppt/slides/_rels/slide$slideIndex.xml.rels");
  }

  int _parseSlideLayoutTargetString(String target) {
    RegExp regex = RegExp(r'slideLayout(\d+)\.xml');
    Match? match = regex.firstMatch(target);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    throw Exception("Invalid slide layout target string: $target");
  }

  List<Shape> _parseShapeTree(Json shapeTree) {
    List<Shape> shapes = [];

    shapeTree.forEach((key, value) {
      switch (key) {
        case eConnectionShape:
          if (shapeTree[key] is List) {
            for (Json connectionShape in shapeTree[key]) {
              shapes.add(_getConnectionShape(connectionShape));
            }
          } else if (shapeTree[key] is Map) {
            shapes.add(_getConnectionShape(shapeTree[key]));
          } else {
            throw Exception(
                "Invalid connection shape format: ${shapeTree[key]}");
          }
          break;
      }
    });

    return shapes;
  }

  Transform _getTransform(Json transformMap) {
    Point2D offset = Point2D(
      EMU(int.parse(transformMap[eOffset][eX])),
      EMU(int.parse(transformMap[eOffset][eY])),
    );

    Point2D size = Point2D(
      EMU(int.parse(transformMap[eSize][eCX])),
      EMU(int.parse(transformMap[eSize][eCY])),
    );

    return Transform(
      offset,
      size,
    );
  }

  Color _getLineColor(Json lineMap) {
    SrgbColor color = SrgbColor(lineMap[eLine]?[eSolidFill]?[eSrgbColor]
            ?[eValue] ??
        SrgbColor.defaultColor);
    Alpha alpha =
        Alpha(int.parse(lineMap[eLine]?[eAlpha] ?? "${Alpha.maxAlpha}"));
    Color lineColor =
        ColorConversions.updateSrgbColorAndAlphaToFlutterColor(color, alpha);

    return lineColor;
  }

  EMU _getLineWidth(Json lineMap) {
    return EMU(int.parse(lineMap[eLine]?[eLineWidth] ??
        "${ConnectionShape.defaultWidth.value}"));
  }

  ConnectionShape _getConnectionShape(Json connectionShapeMap) {
    Transform transform =
        _getTransform(connectionShapeMap[eShapeProperty][eTransform]);

    Color lineColor = _getLineColor(connectionShapeMap[eShapeProperty]);

    EMU lineWidth = _getLineWidth(connectionShapeMap[eShapeProperty]);

    // Extracts the flipVertical attribute from the connection shape's transform properties.
    // set to true if attribute is "1", false otherwise
    bool isFlippedVertically = connectionShapeMap[eShapeProperty]?[eTransform]
                ?[flipVertical]
            ?.toString() ==
        "1";

    return ConnectionShape(
      transform: transform,
      isFlippedVertically: isFlippedVertically,
      color: lineColor,
      width: lineWidth,
    );
  }

  void _updateSlides() {
    List<Slide> slides = [];
    for (int i = 1; i <= _getSlideCount(); i++) {
      Slide slide = Slide();
      // add slide layout elements first.
      slide.shapes = _parseShapeTree(_pptxLoader.getJsonFromPptx(
              "ppt/slideLayouts/slideLayout${_getSlideLayoutIndex(i)}.xml")[
          eSlideLayoutData][eCommonSlideData][eShapeTree]);

      // add slide elements afterwards.
      slide.shapes?.addAll(_parseShapeTree(
          _pptxLoader.getJsonFromPptx("ppt/slides/slide$i.xml")[eSlide]
              [eCommonSlideData][eShapeTree]));
      slides.add(slide);
    }

    _pptxTree.slides = slides;
  }

  PptxTree getPptxTree() {
    _updateTitle();
    _updateAuthor();
    _updateWidth();
    _updateHeight();
    _updateSection();
    _updateSlides();

    return _pptxTree;
  }
}
