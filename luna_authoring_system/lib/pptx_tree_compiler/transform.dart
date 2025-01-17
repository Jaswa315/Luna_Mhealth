import 'package:built_value/built_value.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/point_2d.dart';

part 'transform.g.dart';

/// transform class is the representation of transform data of a shape.
/// it has the offset and size values as point2d object.
abstract class Transform implements Built<Transform, TransformBuilder> {
  Point2D get offset;
  Point2D get size;

  Transform._();

  factory Transform([updates(TransformBuilder b)]) = _$Transform;
}