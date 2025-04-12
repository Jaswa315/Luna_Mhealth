import 'dart:ui';

import 'package:luna_authoring_system/pptx_data_objects/alpha.dart';
import 'package:luna_authoring_system/pptx_data_objects/srgb_color.dart';

/// This class is responsible for converting colors from the .pptx's
/// scheme to Flutter's Color class.
class ColorConversions {
  static const int maxFlutterColorAlpha = 255;
  /// Converts a SrgbColor and Alpha to a Flutter Color.
  /// The SrgbColor is a hex string representing the color, and the Alpha
  /// is an integer representing the alpha value (opacity).
  /// The method parses the hex string to get the RGB values and combines
  /// them with the alpha value to create a Color object.
  ///
  /// Parameters:
  /// - [srgbColor]: The SrgbColor object containing the hex string.
  /// - [alpha]: The Alpha object containing the alpha value.
  ///            Alpha value from .pptx is ST_PositiveFixedPercentage.
  ///            The value is between 0 and 100000, where 0 is fully transparent
  ///            See the documentation here for more information.
  ///            https://www.datypic.com/sc/ooxml/e-a_alpha-1.html
  /// Returns:
  /// - a Color object representing the color in Flutter.
  /// Throws:
  /// - an ArgumentError if the hex string is not valid.
  static Color updateSrgbColorAndAlphaToFlutterColor(SrgbColor srgbColor, Alpha alpha) {
    // Convert the hex string to an integer
    int colorValue = int.parse(srgbColor.value, radix: 16);

    // Map the alpha value from 0-100000 to 0-255
    int convertedAlphaValue = ((alpha.value * maxFlutterColorAlpha) / Alpha.maxAlpha).round();

    return Color.fromARGB(
      convertedAlphaValue, // Alpha
      (colorValue >> 16) & 0xFF, // Red
      (colorValue >> 8) & 0xFF, // Green
      colorValue & 0xFF, // Blue
    );
  }
}
