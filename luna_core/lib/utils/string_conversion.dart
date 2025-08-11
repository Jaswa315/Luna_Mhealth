/// A utility class for converting between String and Uint8List formats.
import 'dart:typed_data';

class StringConversion {
  /// Converts a String into Uint8List (bytes).
  static Uint8List stringToUint8List(String s) {
    return Uint8List.fromList(s.codeUnits);
  }

  /// Converts a [Uint8List] back into a [String].
  static String uint8ListToString(Uint8List bytes) {
    return String.fromCharCodes(bytes);
  }
}
