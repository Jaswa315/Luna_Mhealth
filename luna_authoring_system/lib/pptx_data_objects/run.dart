import 'package:flutter/material.dart';

/// Represents the text run element (a:r) of a textbody element in PowerPoint.
/// This class contains the run of text within the containing text body
/// and its properties such as language.
class Run {
  /// Text
  final String text;

  /// In Microsoft PowerPoint, an ID called ST_TextLanguageID is used to specify 
  /// the language of a text run.
  /// See more information at:
  /// https://learn.microsoft.com/en-us/openspecs/office_standards/ms-oe376/b8cc7825-aa4b-49e1-98e7-a2ee5132ab86
  /// This ID consists of an ISO 639-1 language code followed by an ISO 3166-1 alpha-2 country code.
  /// The languageID property is represented as Flutter's Locale object because it already follows
  /// the same languageCode-countryCode format.
  final Locale languageID;

  Run({
    required this.languageID,
    required this.text,
  });

  /// Returns the language code as a string (e.g., "en-US").
  String get languageCode {
    return '${languageID.languageCode}-${languageID.countryCode}';
  }
}