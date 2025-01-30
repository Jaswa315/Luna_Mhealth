// ignore_for_file: non_constant_identifier_names, unused_local_variable
// We are ignoring these rules so we can catch LateInitializationError to validate of pptxtree width/height is initialized

import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_core/validator/validator_error.dart';
import 'package:luna_core/validator/validator_error_type.dart';

/// A validator that checks the validity of the dimensions of a `PptxTree`.
class PptxDimensionsValidator extends IValidator {
  final PptxTree _pptxTree;

  PptxDimensionsValidator(this._pptxTree);

  @override
  Set<ValidatorError> validate() {
    Set<ValidatorError> errors = {};
  try {
    // Simply accessing these properties will throw LateInitializationError if they are not initialized
    // _pptxTree width and height can't be null checked, so we are catching LateInitializationError instead
    var width = _pptxTree.width;
    var height = _pptxTree.height;
  } catch (LateInitializationError) {
    // Handle the error by adding a specific validation error
    errors.add(ValidatorError(ValidatorErrorType.pptxWidthAndHeightMustBothBeInitialized));
   
    return errors;
  }
    if (_pptxTree.width.value <= 0) {
       errors.add(ValidatorError(ValidatorErrorType.pptxWidthMustBePositive));
    }
    if (_pptxTree.height.value <= 0) {
       errors.add(ValidatorError(ValidatorErrorType.pptxHeightMustBePositive));
    }

    return errors;
  }
}
