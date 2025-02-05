import 'package:luna_core/validator/validator_error.dart';

/// Base class for all PPTX dimensions validation errors.
abstract class PPTXDimensionsValidationError extends ValidatorError {}

/// Error when neither width nor height is initialized (i.e. accessing them throws a LateInitializationError).
class PPTXWidthAndHeightMustBothBeInitializedError extends PPTXDimensionsValidationError {
  @override
  String get errorCode => 'pptx_width_and_height_must_both_be_initialized';
}

/// Error when the PPTX width is not a positive value.
class PPTXWidthMustBePositiveError extends PPTXDimensionsValidationError {
  @override
  String get errorCode => 'pptx_width_must_be_positive';
}

/// Error when the PPTX height is not a positive value.
class PPTXHeightMustBePositiveError extends PPTXDimensionsValidationError {
  @override
  String get errorCode => 'pptx_height_must_be_positive';
}
