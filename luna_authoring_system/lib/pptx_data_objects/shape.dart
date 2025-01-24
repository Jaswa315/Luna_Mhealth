import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';

/// The shape is the abtract class of concrete picture,
/// connection, and textbox classes.
abstract class Shape {
  ShapeType get type;
  Transform get transform;
  set transform(Transform transform);
}
