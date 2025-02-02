/// Converts Point, and Size values using EMU values from PPTX.
class SizeConverter {
  /// Converts the EMU size value to percent in x-axis
  /// [numerator] the value in EMU needs to be translated.
  /// [slideWidth] the slide width EMU value.
  static double getPointPercentX(int numerator, int slideWidth) {
    return numerator / slideWidth;
  }

  /// Converts the EMU size value to percent in y-axis
  /// [numerator] the value in EMU needs to be translated.
  /// [slideHeight] the slide width EMU value.
  static double getPointPercentY(int numerator, int slideHeight) {
    return numerator / slideHeight;
  }

  /// Converts the EMU size value to percent width-wise
  /// [numerator] the value in EMU needs to be translated.
  /// [slideWidth] the slide width EMU value.
  static double getSizePercentX(int numerator, int slideWidth) {
    int length = slideWidth;

    return numerator / length;
  }

  /// Converts the EMU size value to percent height-wise
  /// [numerator] the value in EMU needs to be translated.
  /// [slideHeight] the slide height EMU value.
  static double getSizePercentY(int numerator, int slideHeight) {
    int length = slideHeight;

    return numerator / length;
  }
}
