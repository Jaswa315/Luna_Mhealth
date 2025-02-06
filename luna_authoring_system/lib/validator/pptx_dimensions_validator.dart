// ignore_for_file: non_constant_identifier_names, unused_local_variable
// We ignore these rules so we can catch LateInitializationError to validate if PptxTree width/height is initialized

import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/validator/error/pptx_dimensions_validation_error.dart';
import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_core/validator/validator_error.dart';

/// A validator that checks the validity of the dimensions of a `PptxTree`.
class PptxDimensionsValidator extends IValidator {
  final PptxTree _pptxTree;

  PptxDimensionsValidator(this._pptxTree);

  @override
  Set<ValidatorError> validate() {
    final errors = <ValidatorError>{};

    try {
      // Simply accessing these properties will throw LateInitializationError if they are not initialized.
      var width = _pptxTree.width;
      var height = _pptxTree.height;
    } catch (LateInitializationError) {
      // Handle the error by adding a specific validation error.
      errors.add(PPTXWidthAndHeightMustBothBeInitializedError());

      return errors;
    }

    if (_pptxTree.width.value <= 0) {
      errors.add(PPTXWidthMustBePositiveError());
    }
    if (_pptxTree.height.value <= 0) {
      errors.add(PPTXHeightMustBePositiveError());
    }

    return errors;
  }
}
