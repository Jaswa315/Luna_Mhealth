import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/connection_shape/pptx_connection_shape_builder.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/shape/pptx_shape_constants.dart';
import 'package:luna_core/utils/types.dart';

class PptxShapeBuilder {
  final PptxConnectionShapeBuilder _pptxConnectionShapeBuilder = PptxConnectionShapeBuilder();

  List<Shape> getShapes(Json shapeTree) {
    List<Shape> shapes = [];

    shapeTree.forEach((key, value) {
      switch (key) {
        case eConnectionShape:
          shapes.addAll(
            _pptxConnectionShapeBuilder.getConnectionShapes(shapeTree[key]),
          );
          break;
      }
    });

    return shapes;
  }
}
