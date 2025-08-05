/// This class represents the ST_TextUnderlineType value in the PowerPoint XML.
/// This type specifies the text underline types that will be used.
/// The following are possible enumeration values for this type:
/// See more information about the unit in this documentation:
/// https://c-rex.net/samples/ooxml/e1/Part4/OOXML_P4_DOCX_ST_TextUnderlineType_topic_ID0EE2UOB.html#topic_ID0EE2UOB
enum SimpleTypeTextUnderlineType {
  /// Underline the text with a single, dashed line of normal thickness
  dash('dash'),

  /// Underline the text with a single, dashed, thick line
  dashHeavy('dashHeavy'),

  /// Underline the text with a single line consisting of long dashes of normal thickness
  dashLong('dashLong'),

  /// Underline the text with a single line consisting of long, thick dashes
  dashLongHeavy('dashLongHeavy'),

  /// Underline the text with two lines of normal thickness
  dbl('dbl'),

  /// Underline the text with a single line of normal thickness consisting of repeating dots and dashes
  dotDash('dotDash'),

  /// Underline the text with a single, thick line consisting of repeating dots and dashes
  dotDashHeavy('dotDashHeavy'),

  /// Underline the text with a single line of normal thickness consisting of repeating two dots and dashes
  dotDotDash('dotDotDash'),

  /// Underline the text with a single, thick line consisting of repeating two dots and dashes
  dotDotDashHeavy('dotDotDashHeavy'),

  /// Underline the text with a single, dotted line of normal thickness
  dotted('dotted'),

  /// Underline the text with a single, thick, dotted line
  dottedHeavy('dottedHeavy'),

  /// Underline the text with a single, thick line
  heavy('heavy'),

  /// No underline (explicitly set to none)
  none('none'),

  /// Underline the text with a single line of normal thickness
  sng('sng'),

  /// Underline the text with a single wavy line of normal thickness
  wavy('wavy'),

  /// Underline the text with two wavy lines of normal thickness
  wavyDbl('wavyDbl'),

  /// Underline the text with a single, thick wavy line
  wavyHeavy('wavyHeavy'),

  /// Underline just the words and not the spaces between them
  words('words');

  final String xmlValue;
  const SimpleTypeTextUnderlineType(this.xmlValue);

  /// Creates a TextUnderlineType from the XML string value
  static SimpleTypeTextUnderlineType fromXml(String xmlValue) {
    try {
      return SimpleTypeTextUnderlineType.values.firstWhere(
        (type) => type.xmlValue == xmlValue,
      );
    } on StateError {
      throw ArgumentError('Unknown TextUnderlineType value: "$xmlValue"');
    }
  }
}