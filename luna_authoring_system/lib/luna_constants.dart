/// This class contains global constants used across the Luna project.
class LunaConstants {
  static final int maximumPptxTitleLength = 100;
}

/// Severity levels enum for validation issues in Luna authoring system
enum ValidationSeverity {
  info, // Informational issues that do not require immediate attention
  warning, // Issues that should be addressed but do not block functionality
  error, // Issues that block functionality and need to be fixed
}
