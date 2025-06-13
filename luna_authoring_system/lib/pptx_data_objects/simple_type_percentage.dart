/// This class represents the ST_Percentage value in the PowerPoint XML.
/// The value of SimpleTypePercentage is an integer that represents the percentage value multiplied by 1000.
/// For example, a value of 5000 represents 5.0%
/// See more information about the unit in this documentation:
/// https://c-rex.net/samples/ooxml/e1/Part4/OOXML_P4_DOCX_ST_Percentage_topic_ID0EY3XNB.html
/// https://www.datypic.com/sc/ooxml/t-a_ST_PositiveFixedPercentage.html
class SimpleTypePercentage {
  final int _value;

  SimpleTypePercentage(this._value);
  int get value => _value;
}
