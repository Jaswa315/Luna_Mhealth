import 'package:luna_authoring_system/pptx_data_objects/connection_shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/point_2d.dart';
import 'package:luna_core/units/point_2d_percentage.dart';

///[LinePositioner] is a helper class that computes the start and end points of a shape in percentage-based coordinates
/// relative to the slide dimensions. This class is initally created to handle lines specifically.
/// Purpose:
/// - Converts the absolute EMU (English Metric Units) values of a shape into percentage-based coordinates.
/// - Ensures the position remains proportional to the slide size.
/// - Handles vertical flipping transformations to correctly swap start and end points when necessary.
///
class LinePositioner {
  /// Computes the start and end points of a ConnectionShape in percentage-based coordinates.
  static Map<String, Point2DPercentage> getStartAndEndPoints(
    ConnectionShape cxn,
    int slideWidth,
    int slideHeight,
  ) {
    // Extract offset (starting position) and size (width & height) from the shape
    Point2D offset = cxn.transform.offset;
    Point2D size = cxn.transform.size;

    // Convert EMU values to percentage-based coordinates
    double startX = offset.x.value / slideWidth;
    double startY = offset.y.value / slideHeight;
    double endX = (size.x.value + offset.x.value) /
        slideWidth; // Add the offset to startX
    double endY = (size.y.value + offset.y.value) /
        slideHeight; // Add the offset to startY
    // If the shape is flipped vertically, swap startY and endY
    if (cxn.isFlippedVertically) {
      double temp = startY;
      startY = endY;
      endY = temp;
    }

    return {
      'startPoint': Point2DPercentage(startX, startY),
      'endPoint': Point2DPercentage(endX, endY),
    };
  }
}
