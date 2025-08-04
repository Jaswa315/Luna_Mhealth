import 'package:flutter/material.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_simple_type_text_font_size.dart';
import 'package:luna_authoring_system/pptx_data_objects/simple_type_text_underline_type.dart';

/// Represents the text run element (a:r) of a textbody element in PowerPoint.
/// This class contains the run of text within the containing text body
/// and its properties such as language, font size, italics, bold, and underline.
class Run {
  final String text;
  final Locale languageID;
  final PptxSimpleTypeTextFontSize fontSize;
  final bool bold;
  final bool italics;
  final SimpleTypeTextUnderlineType underlineType; // change to LunaTextUnderlineType

  Run({
    required this.languageID,
    required this.text,
    required this.fontSize,
    required this.bold,
    required this.italics,
    required this.underlineType,
  });

  /// Returns the languageID as a string (e.g., "en-US").
  String get languageCode {
    return languageID.toLanguageTag();
  }
}