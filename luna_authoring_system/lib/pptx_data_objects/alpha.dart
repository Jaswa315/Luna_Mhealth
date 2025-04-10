/// alpha class is the representation of a alpha channel for the color (transparency) in .pptx files.
/// check the documentation for the ST_PositiveFixedPercentage type in the OpenXML SDK documentation.
/// https://www.datypic.com/sc/ooxml/t-a_ST_PositiveFixedPercentage.html
class Alpha {
  final int _value;
  static const int maxAlpha = 100000; // 100% opacity, inclusive.
  static const int minAlpha = 0; // 0% opacity, inclusive.

  Alpha(this._value) {
    // Check if the value is within the valid range
    if (_value < minAlpha || _value > maxAlpha) {
      throw ArgumentError('Invalid Alpha value: $value. It must be between $minAlpha and $maxAlpha.');
    }
  }

  int get value => _value;
}
