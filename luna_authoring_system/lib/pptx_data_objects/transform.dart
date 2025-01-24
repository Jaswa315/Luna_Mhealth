import 'package:luna_authoring_system/pptx_data_objects/point_2d.dart';

/// transform class is the representation of transform data of a shape.
/// it has the offset and size values as point2d object.
class Transform {
  Point2D offset;
  Point2D size;

  Transform(this.offset, this.size);
}
