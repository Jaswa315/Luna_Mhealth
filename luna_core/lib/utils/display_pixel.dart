import 'package:luna_core/utils/dimension.dart';

/// Represents a display pixel value, must be >= 0.
class DisplayPixel extends Dimension {
  final double value;

  DisplayPixel(this.value) {
    if (value < 0) {
      throw ArgumentError('Pixel value must be >= 0: $value', 'value');
    }
  }

  @override
  String toString() => '${value}px';

  @override
  Map<String, dynamic> toJson() => {
        'value': value,
        'unit': 'displayPixels',
      };
}
