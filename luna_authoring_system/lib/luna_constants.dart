/// This class contains global constants used across the Luna project.
class LunaConstants {
  static final int maximumPptxTitleLength = 100;
}

/// Use these everywhere to avoid hard-coded strings.
class CsvHeaders {
  static const String source = 'Text';
  static const String translated = 'Translated text'; // default header for translated text
}

/// Severity levels enum for validation issues in Luna authoring system
enum ValidationSeverity { info, warning, error }
