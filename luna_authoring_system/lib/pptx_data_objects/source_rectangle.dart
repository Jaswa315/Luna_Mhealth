import 'package:luna_authoring_system/pptx_data_objects/simple_type_percentage.dart';

/// This class represents the a:srcRect element in the PowerPoint XML.
/// It specifies the portion of the image that is used for the fill.
/// a:srcRect is optional, and if not specified, the entire image is used.
/// The srcRect is defined by the l(left), t(top), r(right), and b(bottom) attributes,
/// denoted in a:ST_Percentage units, which is set to 0 by default if null.
/// Each offset value specifies how far the edge of the image (e.g., left)
/// is positioned relative to the opposite edge (e.g., right) of the bounding box,
/// based on the bounding box's width or height.
/// See more concrete example in the documentation: http://officeopenxml.com/drwPic-tile.php
/// The value of each attribute can be negative, if the edge of the image extends beyond the bounding box.
class SourceRectangle {
  final SimpleTypePercentage _left;
  final SimpleTypePercentage _top;
  final SimpleTypePercentage _right;
  final SimpleTypePercentage _bottom;
  static const int defaultValue = 0;

  SourceRectangle({
    SimpleTypePercentage? left,
    SimpleTypePercentage? top,
    SimpleTypePercentage? right,
    SimpleTypePercentage? bottom,
  })  : _left = left ?? SimpleTypePercentage(defaultValue),
        _top = top ?? SimpleTypePercentage(defaultValue),
        _right = right ?? SimpleTypePercentage(defaultValue),
        _bottom = bottom ?? SimpleTypePercentage(defaultValue);

  SimpleTypePercentage get left => _left;
  SimpleTypePercentage get top => _top;
  SimpleTypePercentage get right => _right;
  SimpleTypePercentage get bottom => _bottom;
}
