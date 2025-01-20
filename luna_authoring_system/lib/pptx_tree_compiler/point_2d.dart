import 'package:built_value/built_value.dart';
import 'package:luna_core/utils/emu.dart';

part 'point_2d.g.dart';

/// Point2D class is the representation of a point in 2-dimensional space.
/// It is used to describe offset and size values of the shapes in the .pptx.
abstract class Point2D implements Built<Point2D, Point2DBuilder> {
  EMU get x;
  EMU get y;

  Point2D._();

  factory Point2D([updates(Point2DBuilder b)]) = _$Point2D;
}