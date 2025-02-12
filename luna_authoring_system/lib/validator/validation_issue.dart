/// An abstract base class for all validation issues.
/// Validation Issues surface during validation checks.
/// Each subclass should provide its own [issueCode]
/// Were not calling it an error message string due to potential language barriers.
abstract class ValidationIssue {
  String get issueCode;
}