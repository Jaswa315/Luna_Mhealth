library pptx_parser;

import 'package:luna_authoring_system/parser/presentation_parser.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/point_2d.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_loader.dart';
import 'package:luna_core/utils/emu.dart';
import 'package:luna_core/utils/types.dart';

part 'pptx_element.dart';

/// The PptxParser takes a .pptx file and is capable of making a
/// PptxTree object that represents given PowerPoint file.
/// It will only parse the required info to form a luna module.
class PptxParser {
  late PptxLoader _pptxLoader;
  PptxTree _pptxTree = PptxTree();

  PptxParser(String pptxFilePath) {
    _pptxLoader = PptxLoader(pptxFilePath);
  }

  void _updateTitleAndAuthor() {
    Json coreMap = _pptxLoader.getJsonFromPptx("docProps/core.xml");
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
        case keyConnectionShape:
          shapes.add(_parseConnectionShape(shapeTree[key]));
          break;
      }
    });

    return shapes;
  }

  Transform _parseTransform(Json transformMap) {
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

  ConnectionShape _parseConnectionShape(Json connectionShapeMap) {
    // TODO: Replace this with actual value from the .pptx archive instead of a default value.
    int cWidth =
        connectionShapeMap[eShapeProperty][eLine]?[eLineWidth] ?? 6350;
    Transform transform =
        _parseTransform(connectionShapeMap[eShapeProperty][eTransform]);

    return ConnectionShape(
      EMU(cWidth),
      transform,
    );
  }

  List<Slide> _parseSlides() {
    List<Slide> slides = [];
    for (int i = 1; i <= _getSlideCount(); i++) {
      Slide slide = Slide();
      slide.shapes = _parseShapeTree(
        _pptxLoader.getJsonFromPptx("ppt/slides/slide$i.xml")[eSlide]
            [eCommonSlideData][eShapeTree],
      );
      slides.add(slide);
    }

    return slides;
  }

  void _updateSlides() {
    _pptxTree.slides = _parseSlides();
  }

  PptxTree getPptxTree() {
    _updateTitleAndAuthor();
    _updateWidthAndHeight();
    _updateSlides();

    return _pptxTree;
  }
}
