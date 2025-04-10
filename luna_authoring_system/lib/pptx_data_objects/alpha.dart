/// alpha class is the representation of a alpha channel for the color (transparency) in .pptx files.
/// check the documentation for the ST_PositiveFixedPercentage type in the OpenXML SDK documentation.
/// https://www.datypic.com/sc/ooxml/t-a_ST_PositiveFixedPercentage.html
class Alpha {
  late final int? value;
  static const int maxAlpha = 100000; // 100% opacity, inclusive.
  static const int minAlpha = 0; // 0% opacity, inclusive.

  Alpha(int? value) {
    // if the value is null, use maxAlpha by default.
    if (value == null) {
      this.value = maxAlpha;
    }
    // Check if the value is within the valid range
    else if (value < minAlpha || value > maxAlpha) {
      throw ArgumentError('Invalid Alpha value: $value. It must be between $minAlpha and $maxAlpha.');
    } else {
      this.value = value;
    }
  }
}
