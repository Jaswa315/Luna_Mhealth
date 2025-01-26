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
class PptxParser {
  late PptxLoader _pptxLoader;
  PptxTree _pptxTree = PptxTree();

  PptxParser(String pptxFilePath) {
    _pptxLoader = PptxLoader(pptxFilePath);
  }

  void _updateTitleAndAuthor() {
    Json coreMap = _pptxLoader.getJsonFromPptx("docProps/core.xml");
    _pptxTree.title = coreMap['cp:coreProperties']['dc:title'];
    _pptxTree.author = coreMap['cp:coreProperties']['dc:creator'];
  }

  void _updateWidthAndHeight() {
    Json presentationMap = _pptxLoader.getJsonFromPptx("ppt/presentation.xml");
    _pptxTree.width =
        EMU(int.parse(presentationMap['p:presentation']['p:sldSz']['_cx']));
    _pptxTree.height =
        EMU(int.parse(presentationMap['p:presentation']['p:sldSz']['_cy']));
  }

  int _getSlideCount() {
    Json appMap = _pptxLoader.getJsonFromPptx("docProps/app.xml");

    return int.parse(appMap['Properties']['Slides']);
  }

  List<Shape> _parseShapes(Json shapeTree) {
    List<Shape> shapes = [];

    shapeTree.forEach((key, value) {
      switch (key) {
        case PptxElement.keyConnectionShape:
          shapes.add(_parseConnectionShape(shapeTree[key]));
          break;
      }
    });

    return shapes;
  }

  Transform _parseTransform(Json transformMap) {
    Point2D offset = Point2D(
      EMU(int.parse(transformMap['a:off']['_x'])),
      EMU(int.parse(transformMap['a:off']['_y'])),
    );

    Point2D size = Point2D(
      EMU(int.parse(transformMap['a:ext']['_cx'])),
      EMU(int.parse(transformMap['a:ext']['_cy'])),
    );

    return Transform(
      offset,
      size,
    );
    ;
  }

  ConnectionShape _parseConnectionShape(Json connectionShapeMap) {
    int cWeight = connectionShapeMap['p:spPr']['a:ln']?['_w'] ??
        ConnectionShape.defaultHalfLineWeight.value;
    Transform transform =
        _parseTransform(connectionShapeMap['p:spPr']['a:xfrm']);

    return ConnectionShape(
      EMU(cWeight),
      transform,
    );
  }

  List<Slide> _parseSlides() {
    List<Slide> slides = [];
    for (int i = 1; i <= _getSlideCount(); i++) {
      Slide slide = Slide();
      slide.shapes = _parseShapes(
        _pptxLoader.getJsonFromPptx("ppt/slides/slide$i.xml")['p:sld']['p:cSld']
            ['p:spTree'],
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
