/// Srgb class is the representation of a SRGB color (standrad RGB) in .pptx files.
/// check the documentation for the ST_SRGBColor type in the OpenXML SDK documentation.
/// https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.drawing.rgbcolormodelhex?view=openxml-3.0.1
class Srgb {
  final regex = RegExp(r'^[0-9A-Fa-f]{6}$');
  final String _value;

  Srgb(this._value) {
    // Check if the string is a valid 6-character hexadecimal string
    if (!regex.hasMatch(_value)) {
      throw ArgumentError('Invalid SRGB value: $_value. It must be a 6-character hexadecimal string.');
    }
  }
  
  String get value => _value;
}