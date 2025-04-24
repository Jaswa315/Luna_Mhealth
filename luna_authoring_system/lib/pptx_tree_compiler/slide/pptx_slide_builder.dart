import 'package:luna_authoring_system/pptx_data_objects/pptx_hierarchy.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/slide.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/relationship/pptx_relationship_parser.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/shape/pptx_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide/pptx_slide_constants.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/slide_count/pptx_slide_count_parser.dart';
import 'package:luna_core/utils/types.dart';

/// This class is responsible for building a slide object from a PPTX file,
/// aggregating shape tree hierarchy.
class PptxSlideBuilder {
  final PptxXmlToJsonConverter _pptxLoader;
  final PptxSlideCountParser _pptxSlideCountParser;
  final PptxShapeBuilder _pptxShapeBuilder = PptxShapeBuilder();
  final PptxHierarchy _pptxHierarchy = PptxHierarchy.slide;
  late final PptxRelationshipParser _pptxRelationshipParser;

  PptxSlideBuilder(this._pptxLoader, this._pptxSlideCountParser) {
    _pptxRelationshipParser = PptxRelationshipParser(_pptxLoader);
  }

  /// Merge the shapes from the parent and child shape lists.
  List<Shape> _mergeShapeLists(List<Shape> parentShapes, List<Shape> childShapes) {
    List<Shape> mergedShapeList = [];
    mergedShapeList.addAll(parentShapes);
    mergedShapeList.addAll(childShapes);

    return mergedShapeList;
  }

  /// Get shapes from shape builder.
  /// This method is responsible for extracting shapes from the shape tree.
  List<Shape> _getShapes(Json shapeTree) {
    return _pptxShapeBuilder.getShapes(shapeTree);
  }

  /// Recursively get shapes starting from the top parent level.
  List<Shape> _aggregateShapesFromHierarchy(int slideIndex, PptxHierarchy hierarchy) {
    // Base case: If there is no parent, get the shapes from the current hierarchy level.
    if (hierarchy.parent == null) {
      return _getShapes(
        _pptxLoader.getJsonFromPptx(
          "ppt/${hierarchy.name}s/${hierarchy.name}$slideIndex.xml",
        )[hierarchy.xmlKey][eCommonSlideData][eShapeTree],
      );
    }

    // Recursive case: Get shapes from the parent level first.
    int parentIndex = _pptxRelationshipParser.getParentIndex(slideIndex, hierarchy);
    List<Shape> parentShapes =
        _aggregateShapesFromHierarchy(parentIndex, hierarchy.parent!);

    // Get shapes from the current hierarchy level.
    List<Shape> currentShapes = _getShapes(
      _pptxLoader.getJsonFromPptx(
        "ppt/${hierarchy.name}s/${hierarchy.name}$slideIndex.xml",
      )[hierarchy.xmlKey][eCommonSlideData][eShapeTree],
    );

    // Merge parent shapes and current shapes.
    return _mergeShapeLists(parentShapes, currentShapes);
  }

  /// Get the slide object for a specific slide index, populated with shapes.
  Slide _getSlide(int slideIndex) {
    Slide slide = Slide();
    slide.shapes = _aggregateShapesFromHierarchy(slideIndex, _pptxHierarchy);

    return slide;
  }

  /// Get all slide objects from the PPTX file.
  List<Slide> getSlides() {
    List<Slide> slides = [];
    for (int i = 1; i <= _pptxSlideCountParser.slideCount; i++) {
      slides.add(_getSlide(i));
    }

    return slides;
  }
}
