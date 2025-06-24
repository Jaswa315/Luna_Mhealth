/// Represents the text run element (a:r) of a textbody element in PowerPoint.
/// This class contains the run of text within the containing text body
/// and its properties such as language.
class Run {
  // Text
  String text;

  // Run properties - lang
  // For now, we will just use the language attribute for translation purposes
  // In the future, we will add more style properties like font size, color, etc.
  String lang;

  Run({
    required this.lang,
    required this.text,
  });
}