import 'dart:ui' show Color;

/// As the PowerPoint has 6 different ways to represent a color,
/// This abstract IColor class allows concrete color classes to have
/// their own way to transform their color representation to dart color object.
abstract class IColor {
  Color get color;
  set color(Color color);

  Color toColor();
}
