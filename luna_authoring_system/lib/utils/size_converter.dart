/// Converts Point, and Size values using EMU values from PPTX.
class SizeConverter {
  /// Converts the EMU size value to percent in x-axis
  /// [numerator] the value in EMU needs to be translated.
  /// [slideWidth] the slide width EMU value.
  /// [padding] the padding EMU value in the slide.
  static double getPointPercentX(
      double numerator, double slideWidth, Map<String, double> padding) {
    double length =
        slideWidth - (padding['left'] ?? 0) - (padding['right'] ?? 0);
    double subtrahend = padding['left'] ?? 0;
    return (numerator - subtrahend) / length;
  }

  /// Converts the EMU size value to percent in y-axis
  /// [numerator] the value in EMU needs to be translated.
  /// [slideHeight] the slide width EMU value.
  /// [padding] the padding EMU value in the slide.
  static double getPointPercentY(
      double numerator, double slideHeight, Map<String, double> padding) {
    double length =
        slideHeight - (padding['top'] ?? 0) - (padding['bottom'] ?? 0);
    double subtrahend = padding['top'] ?? 0;

    return (numerator - subtrahend) / length;
  }

  /// Converts the EMU size value to percent width-wise
  /// [numerator] the value in EMU needs to be translated.
  /// [slideWidth] the slide width EMU value.
  /// [padding] the padding EMU value in the slide.
  static double getSizePercentX(
      double numerator, double slideWidth, Map<String, double> padding) {
    double length =
        slideWidth - (padding['left'] ?? 0) - (padding['right'] ?? 0);

    return numerator / length;
  }

  /// Converts the EMU size value to percent height-wise
  /// [numerator] the value in EMU needs to be translated.
  /// [slideHeight] the slide height EMU value.
  /// [padding] the padding EMU value in the slide.
  static double getSizePercentY(
      double numerator, double slideHeight, Map<String, double> padding) {
    double length =
        slideHeight - (padding['top'] ?? 0) - (padding['bottom'] ?? 0);

    return numerator / length;
  }
}
