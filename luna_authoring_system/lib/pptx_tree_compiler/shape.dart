import 'package:luna_authoring_system/pptx_tree_compiler/shape_type.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/transform.dart';

/// The shape is the abtract class of concrete picture,
/// connection, and textbox classes.
abstract class Shape {
  ShapeType get type;
  Transform? get transform;
}
