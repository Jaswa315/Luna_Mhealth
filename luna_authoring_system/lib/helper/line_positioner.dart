import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_core/units/emu.dart';
import 'package:luna_core/units/percent.dart';
import 'package:luna_core/units/point.dart';

///[LinePositioner] is a helper class that computes the start and end points of a shape in percentage-based coordinates
/// relative to the slide dimensions. This class is initally created to handle lines specifically.
/// Purpose:
/// - Converts the absolute EMU (English Metric Units) values of a shape into percentage-based coordinates.
/// - Ensures the position remains proportional to the slide size.
/// - Handles vertical flipping transformations to correctly swap start and end points when necessary.
///
class LinePositioner {
  /// Computes the start and end points of a ConnectionShape in percentage-based coordinates.
  static Map<String, Point> getStartAndEndPoints(
    ConnectionShape cxn,
    int slideWidth,
    int slideHeight,
  ) {
    // Extract offset (starting position) and size (width & height) from the shape
    Point offset = cxn.transform.offset;
    Point size = cxn.transform.size;

    // Convert EMU values to percentage-based coordinates
    final startX = Percent((offset.x as EMU).value / slideWidth);
    final startY = Percent((offset.y as EMU).value / slideHeight);
    final endX =
        Percent(((offset.x as EMU).value + (size.x as EMU).value) / slideWidth);
    final endY = Percent(
        ((offset.y as EMU).value + (size.y as EMU).value) / slideHeight);

    // If the shape is flipped vertically, swap startY and endY
    final actualStartY = cxn.isFlippedVertically ? endY : startY;
    final actualEndY = cxn.isFlippedVertically ? startY : endY;

    return {
      'startPoint': Point(startX, actualStartY),
      'endPoint': Point(endX, actualEndY),
    };
  }
}
