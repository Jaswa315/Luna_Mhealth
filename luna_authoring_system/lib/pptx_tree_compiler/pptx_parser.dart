library pptx_parser;

import 'dart:io';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/point_2d.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_loader.dart';
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

/// The XML element that indicates the vertical flip of connection shape.
const String flipVertical = '_flipV';

/// =================================================================================================
/// PPTX PARSER CLASS
/// =================================================================================================

/// The PptxParser takes a .pptx file and is capable of making a
/// PptxTree object that represents given PowerPoint file.
/// It will only parse the required info to form a luna module.
class PptxParser {
  late PptxLoader _pptxLoader;
  PptxTree _pptxTree = PptxTree();

  PptxParser(File pptxFile) {
    _pptxLoader = PptxLoader(pptxFile);
  }

  void _updateTitleAndAuthor() {
    Json coreMap = _pptxLoader.getJsonFromPptx("docProps/core.xml");
    String eCoreProperties = 'cp:coreProperties';
    _pptxTree.title = coreMap[eCoreProperties][eTitle];
    _pptxTree.author = coreMap[eCoreProperties][eAuthor];
  }

  void _updateWidthAndHeight() {
    Json presentationMap = _pptxLoader.getJsonFromPptx("ppt/presentation.xml");
    _pptxTree.width =
        EMU(int.parse(presentationMap[ePresentation][eSlideSize][eCX]));
    _pptxTree.height =
        EMU(int.parse(presentationMap[ePresentation][eSlideSize][eCY]));
  }

  int _getSlideCount() {
    Json appMap = _pptxLoader.getJsonFromPptx("docProps/app.xml");

    return int.parse(appMap[eProperties][eSlides]);
  }

  List<Shape> _parseShapeTree(Json shapeTree) {
    List<Shape> shapes = [];

    shapeTree.forEach((key, value) {
      switch (key) {
        case eConnectionShape:
          shapes.add(_getConnectionShape(shapeTree[key]));
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

  ConnectionShape _getConnectionShape(Json connectionShapeMap) {
    // TODO: Replace this with actual value from the .pptx archive instead of a default value.
    Transform transform =
        _getTransform(connectionShapeMap[eShapeProperty][eTransform]);

    // Extracts the flipVertical attribute from the connection shape's transform properties.
    // set to true if attribute is "1", false otherwise
    bool isFlippedVertically = connectionShapeMap[eShapeProperty]?[eTransform]
                ?[flipVertical]
            ?.toString() ==
        "1";

    return ConnectionShape(
      transform: transform,
      isFlippedVertically: isFlippedVertically,
    );
  }

  void _updateSlides() {
    List<Slide> slides = [];
    for (int i = 1; i <= _getSlideCount(); i++) {
      Slide slide = Slide();
      slide.shapes = _parseShapeTree(
        _pptxLoader.getJsonFromPptx("ppt/slides/slide$i.xml")[eSlide]
            [eCommonSlideData][eShapeTree],
      );
      slides.add(slide);
    }

    _pptxTree.slides = slides;
  }

  PptxTree getPptxTree() {
    _updateTitleAndAuthor();
    _updateWidthAndHeight();
    _updateSlides();

    return _pptxTree;
  }
}
