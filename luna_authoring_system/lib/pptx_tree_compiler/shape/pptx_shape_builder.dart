import 'package:luna_authoring_system/pptx_data_objects/pptx_hierarchy.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/connection_shape/pptx_connection_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/picture_shape/pptx_picture_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/shape/pptx_shape_constants.dart';
import 'package:luna_core/utils/types.dart';

/// This class is responsible for building shapes from the PPTX shape tree.
class PptxShapeBuilder {
  final PptxConnectionShapeBuilder _pptxConnectionShapeBuilder;
  final PptxPictureShapeBuilder _pptxPictureShapeBuilder;

  PptxShapeBuilder(
    this._pptxConnectionShapeBuilder,
    this._pptxPictureShapeBuilder,
  );

  /// Parses the shape tree and returns a list of shapes.
  List<Shape> getShapes(Json shapeTree, int slideIndex, PptxHierarchy hierarchy) {
    List<Shape> shapes = [];

    shapeTree.forEach((key, value) {
      switch (key) {
        case eConnectionShape:
          shapes.addAll(
            _pptxConnectionShapeBuilder.getConnectionShapes(shapeTree[key]),
          );
          break;
        case ePictureShape:
          _pptxPictureShapeBuilder.slideIndex = slideIndex;
          _pptxPictureShapeBuilder.hierarchy = hierarchy;
          shapes.addAll(
            _pptxPictureShapeBuilder.getPictureShapes(shapeTree[key]),
          );
          break;
      }
    });

    return shapes;
  }
}
