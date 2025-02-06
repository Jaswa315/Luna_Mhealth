import 'package:luna_core/validator/validator_error.dart';

/// Base class for all Point2D validation errors.
abstract class Point2DValidationError extends ValidatorError {}

/// Error when the X percentage is less than zero.
class Point2DXLessThanZeroError extends Point2DValidationError {
  @override
  String get errorCode => 'point2DXPercentageLessThanZero';
}

/// Error when the X percentage is greater than one.
class Point2DXGreaterThanOneError extends Point2DValidationError {
  @override
  String get errorCode => 'point2DXPercentageGreaterThanOne';
}

/// Error when the Y percentage is less than zero.
class Point2DYLessThanZeroError extends Point2DValidationError {
  @override
  String get errorCode => 'point2DYPercentageLessThanZero';
}

/// Error when the Y percentage is greater than one.
class Point2DYGreaterThanOneError extends Point2DValidationError {
  @override
  String get errorCode => 'point2DYPercentageGreaterThanOne';
}
