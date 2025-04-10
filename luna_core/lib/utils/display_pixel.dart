/// Represents a display pixel value, must be >= 0.
class DisplayPixel {
  final double value;

  DisplayPixel(this.value) {
    if (value < 0) {
      throw ArgumentError('Pixel value must be >= 0: $value', 'value');
    }
  }

  @override
  String toString() => '${value}px';
}
