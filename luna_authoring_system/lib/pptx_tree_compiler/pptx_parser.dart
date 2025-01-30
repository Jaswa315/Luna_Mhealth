import 'package:luna_authoring_system/parser/presentation_parser.dart';
import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/point_2d.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_element.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_loader.dart';
import 'package:luna_core/utils/emu.dart';
import 'package:luna_core/utils/types.dart';

/// The PptxParser takes a .pptx file and is capable of making a
/// PptxTree object that represents given PowerPoint file.
/// It will only parse the required info to form a luna module.
class PptxParser extends PptxElement {
  late PptxLoader _pptxLoader;
  PptxTree _pptxTree = PptxTree();

  PptxParser(String pptxFilePath) {
    _pptxLoader = PptxLoader(pptxFilePath);
  }

  void _getTitleAndAuthor() {
    Json coreMap = _pptxLoader.getJsonFromPptx("docProps/core.xml");
    _pptxTree.title = coreMap[eCoreProperties][eTitle];
    _pptxTree.author = coreMap[eCoreProperties][eAuthor];
  }

  void _getWidthAndHeight() {
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
    int cWeight = connectionShapeMap[eShapeProperty][eLine]?[eLineWidth] ??
        ConnectionShape.defaultHalfLineWeight.value;
    Transform transform =
        _getTransform(connectionShapeMap[eShapeProperty][eTransform]);

    return ConnectionShape(
      EMU(cWeight),
      transform,
    );
  }

  List<Slide> _getSlides() {
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

  void _getSlides() {
    _pptxTree.slides = _getSlides();
  }

  PptxTree getPptxTree() {
    _getTitleAndAuthor();
    _getWidthAndHeight();
    _getSlides();

    return _pptxTree;
  }
}
