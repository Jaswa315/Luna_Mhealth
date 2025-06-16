import 'package:luna_authoring_system/luna_constants.dart';

/// An abstract base class for all validation issues.
/// Validation Issues surface during validation checks.
/// Were not calling it an error message string due to potential language barriers.
abstract class IValidationIssue {
  /// This is textual representation of the validation issue.
  String toText();
  ValidationSeverity get severity;
  bool ignore = false;
}
