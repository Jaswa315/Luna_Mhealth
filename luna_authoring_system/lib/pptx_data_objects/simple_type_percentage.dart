/// This class represents the ST_Percentage value in the PowerPoint XML.
/// It is used to define a percentage value in the form of integer
/// in the range of 0 to 100,000 (inclusive), where 100,000 represents 100%.
/// See more information about the unit in this documentation:
/// https://c-rex.net/samples/ooxml/e1/Part4/OOXML_P4_DOCX_ST_Percentage_topic_ID0EY3XNB.html
/// https://www.datypic.com/sc/ooxml/t-a_ST_PositiveFixedPercentage.html

class SimpleTypePercentage {
  final int _value;
  static const int minSimpleTypePercentage = 0; // 0% inclusive.
  static const int maxSimpleTypePercentage = 100000; // 100% inclusive.

  SimpleTypePercentage(this._value) {
    // Check if the value is within the valid range
    if (_value < minSimpleTypePercentage || _value > maxSimpleTypePercentage) {
      throw ArgumentError(
        'Invalid SimpleTypePercentage value: $_value. It must be between $minSimpleTypePercentage and $maxSimpleTypePercentage (inclusive).',
      );
    }
  }
  int get value => _value;
}
