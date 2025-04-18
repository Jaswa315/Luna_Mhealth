import 'package:luna_core/units/point.dart';

/// transform class is the representation of transform data of a shape.
/// it has the offset and size values as point object.
class Transform {
  Point offset;
  Point size;

  Transform(this.offset, this.size);
}
