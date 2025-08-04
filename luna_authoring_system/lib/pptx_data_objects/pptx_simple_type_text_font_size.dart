/// This class represents the ST_TextFontSize value in the PowerPoint XML.
/// The value of SimpleTypeTextFontSize is an integer that 
/// represents the font size in hundredths of a point. 
/// For example, a value of 1200 represents a font size of 12.
/// Its minimum value is 100 and maximum value is 400000.
/// See more information about the unit in this documentation:
/// https://c-rex.net/samples/ooxml/e1/Part4/OOXML_P4_DOCX_ST_TextFontSize_topic_ID0EPPQOB.html#topic_ID0EPPQOB
class PptxSimpleTypeTextFontSize {
  final int _value;

  PptxSimpleTypeTextFontSize(this._value) {
    if (_value < 100 || _value > 400000) {
      throw ArgumentError('Font size must be between 100 and 400000.');
    }
  }

  int get value => _value;
}