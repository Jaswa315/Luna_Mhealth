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
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_core/utils/emu.dart';
import 'package:luna_core/utils/types.dart';

/// =================================================================================================
/// XML ELEMENTS CONSTANTS
/// =================================================================================================
/// The XML element for the core properties.
const String eCoreProperties = 'cp:coreProperties';

/// The XML element for the title of the PowerPoint.
const String eTitle = 'dc:title';

/// The XML element for the author of the PowerPoint.
const String eAuthor = 'dc:creator';

/// The XML element for the presentation meta data.
const String ePresentation = 'p:presentation';

/// The XML element for the size of the presentation.
const String eSlideSize = 'p:sldSz';

/// The XML element for the properties within the application map.
const String eProperties = 'Properties';

/// The XML element for the Slides meta data.
const String eSlides = 'Slides';

/// The XML element for the slide within a PowerPoint slide.
const String eSlide = 'p:sld';

/// The XML element for the common slide data in the slide.
const String eCommonSlideData = 'p:cSld';

/// The XML element for the common slide data in the slide.
const String eSlideLayoutData = 'p:sldLayout';

/// The XML element for the shape tree in the common slide data.
const String eShapeTree = 'p:spTree';

/// The XML element for the picture element in a PowerPoint presentation.
const String ePicture = 'p:pic';

/// The XML element for the shape element in a PowerPoint presentation.
const String eShape = 'p:sp';

/// The XML element for the connection shape element in a PowerPoint presentation.
const String eConnectionShape = 'p:cxnSp';

/// The XML element for the shape properties within a shape.
const String eShapeProperty = 'p:spPr';

/// The XML element for the transform information.
/// http://officeopenxml.com/drwSp-location.php#:~:text=The%20is,specified%20by%20the%20y%20attribute.
const String eTransform = 'a:xfrm';

/// The XML element for the offset in the bounding box location.
const String eOffset = 'a:off';

/// The XML element for the extents which specifies the size of the bounding box.
const String eSize = 'a:ext';

/// The XML element for the coordinate along the x-axis.
const String eX = '_x';

/// The XML element for the coordinate along the y-axis.
const String eY = '_y';

/// The XML element for the width in EMUs.
const String eCX = '_cx';

/// The XML element for the height in EMUs.
const String eCY = '_cy';

/// The XML element for the line element in PowerPoint.
const String eLine = 'a:ln';

/// The XML element for the width of connection shape.
const String eLineWidth = '_w';

/// The XML element for the solid fill style in PowerPoint.
/// See more information in this documentation.
/// https://www.datypic.com/sc/ooxml/t-a_CT_FillStyleList.html
const String eSolidFill = 'a:solidFill';

/// The XML element for the srgbColor element in PowerPoint.
const String eSrgbColor = 'a:srgbClr';

/// The XML element for the alpha element in PowerPoint.
const String eAlpha = 'a:alpha';

/// The XML element that indicates the vertical flip of connection shape.
const String flipVertical = '_flipV';

/// The XML element for the Relationships in the slide.
const String eRelationships = 'Relationships';

/// The XML element for the Relationship in the slide.
const String eRelationship = 'Relationship';

/// The XML element for the Type of an relationship.
const String eType = '_Type';

/// The XML element for the Target of an relationships.
const String eTarget = '_Target';

/// The XML element for the value of an pptx element.
const String eValue = '_val';


/// The XML element for the slideLayout type for the slide.
const String eSlideLayoutKey =
    'http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout';

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

  int _getSlideCount() {
    Json appMap = _pptxLoader.getJsonFromPptx("docProps/app.xml");

    return int.parse(appMap[eProperties][eSlides]);
  }

  int _getSlideLayoutIndex(int slideIndex) {
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
          }
          else {
            throw Exception("Invalid connection shape format: ${shapeTree[key]}");
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

  Color _getLineColor(Json lineMap){
    SrgbColor color = SrgbColor(lineMap[eLine]?[eSrgbColor]?[eValue] ?? SrgbColor.defaultColor);
    Alpha alpha = Alpha(int.parse(lineMap[eLine]?[eAlpha] ?? "${Alpha.maxAlpha}"));
    Color lineColor = ColorConversions.updateSrgbColorAndAlphaToFlutterColor(color, alpha);

    return lineColor;
  }

  ConnectionShape _getConnectionShape(Json connectionShapeMap) {
    Transform transform =
        _getTransform(connectionShapeMap[eShapeProperty][eTransform]);

    Color lineColor = _getLineColor(connectionShapeMap[eShapeProperty]);    

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
    );
  }

  void _updateSlides() {
    List<Slide> slides = [];
    for (int i = 1; i <= _getSlideCount(); i++) {
      Slide slide = Slide();
      // add slide layout elements first.
      slide.shapes = _parseShapeTree(_pptxLoader.getJsonFromPptx("ppt/slideLayouts/slideLayout${_getSlideLayoutIndex(i)}.xml")[eSlideLayoutData][eCommonSlideData][eShapeTree]);
      
      // add slide elements afterwards.
      slide.shapes?.addAll(_parseShapeTree(_pptxLoader.getJsonFromPptx("ppt/slides/slide$i.xml")[eSlide][eCommonSlideData][eShapeTree]));
      slides.add(slide);
    }

    _pptxTree.slides = slides;
  }

  PptxTree getPptxTree() {
    _updateTitle();
    _updateAuthor();
    _updateWidth();
    _updateHeight();
    _updateSlides();

    return _pptxTree;
  }
}
