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