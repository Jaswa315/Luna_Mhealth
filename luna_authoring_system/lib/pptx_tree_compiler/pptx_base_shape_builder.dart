import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_core/utils/types.dart';

abstract class PptxBaseShapeBuilder<T extends Shape> {

  T buildShape(Json shapeMap);

  List<Shape> getShapes(dynamic shapeTree) {
    List<Shape> shapes = [];

    // handles if shapeTree input is a List that contains multiple
    // shapes of the same ShapeType (connection, picture, textbox)
    if (shapeTree is List) {
      for (Json shape in shapeTree) {
        shapes.add(buildShape(shape));
      }
    // handles if shapeTree input is a map that contains a single shape
    } else if (shapeTree is Map) {
      shapes.add(buildShape(shapeTree as Json));
    } else { // if shapeTree is neither a Map nor a List, throw an exception
      throw Exception("Invalid shape tree format: $shapeTree");
    }

    return shapes;
  }
}