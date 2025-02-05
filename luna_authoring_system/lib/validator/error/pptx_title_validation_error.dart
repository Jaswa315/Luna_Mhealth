import 'package:luna_core/validator/validator_error.dart';

/// Base class for PPTX title validation errors.
abstract class PPTXTitleValidationError extends ValidatorError {}

class PPTXTitleHasNoVisibleCharactersError extends PPTXTitleValidationError {
  @override
  String get errorCode => 'pptx_title_has_no_visible_characters';
}

class PPTXTitleIsTooLongError extends PPTXTitleValidationError {
  @override
  String get errorCode => 'pptx_title_is_too_long';
}
