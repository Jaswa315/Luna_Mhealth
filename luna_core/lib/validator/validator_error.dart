/// An abstract base class for all validation errors.
/// Each subclass should provide its own [errorCode]
/// Were not calling it an error message string due to potential language barriers.
abstract class ValidatorError {
  String get errorCode;
}
