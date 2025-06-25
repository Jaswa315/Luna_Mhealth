import 'package:flutter/material.dart';

/// Represents the text run element (a:r) of a textbody element in PowerPoint.
/// This class contains the run of text within the containing text body
/// and its properties such as language.
class Run {
  /// Text
  final String text;

  /// Run properties - lang
  /// For now, we will just use the language attribute for translation purposes
  /// In the future, we will add more style properties like font size, color, etc.
  final Locale lang;

  Run({
    required this.lang,
    required this.text,
  });

  /// Returns the language code as a string (e.g., "en-US" or "zh-Hans-CN").
  String get languageCode {
    if (lang.scriptCode != null && lang.countryCode != null) {
      return '${lang.languageCode}-${lang.scriptCode}-${lang.countryCode}';
    } else if (lang.scriptCode != null) {
      return '${lang.languageCode}-${lang.scriptCode}';
    } else if (lang.countryCode != null) {
      return '${lang.languageCode}-${lang.countryCode}';
    }

    return lang.languageCode;
  }
}