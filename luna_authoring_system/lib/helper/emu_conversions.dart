import 'package:luna_core/units/emu.dart';

/// Converts EMU values to a percentage (0-1 scale) relative to the slide size.
/// This helps normalize positions and sizes for rendering.
class EmuConversions {
  /// Converts an EMU value to a percentage relative to a total reference EMU value.
  ///
  /// - [currentValue]: The EMU value to be converted.
  /// - [totalValue]: The total EMU reference value (width or height).
  /// - Returns: A double (0-1) representing the normalized percentage.
  /// - Throws: ArgumentError if `totalValue` is zero.
  static double updateEmuToPercentage(EMU currentValue, EMU totalValue) {
    if (totalValue.value == 0) {
      throw ArgumentError('Total EMU value cannot be zero.');
    }
    double percentage = currentValue.value / totalValue.value;

    return percentage;
  }

  static double updateThicknessToDisplayPixels(EMU currentValue) {
    double thickness = currentValue.value / 12700;

    return thickness;
  }
}
