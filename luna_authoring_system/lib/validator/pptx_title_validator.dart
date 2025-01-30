import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_core/luna_constants.dart';
import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_core/validator/validator_error.dart';
import 'package:luna_core/validator/validator_error_type.dart';

/// A validator that checks the validity of the title of a `PptxTree`.
class PptxTitleValidator extends IValidator {
  final PptxTree _pptxTree;

  PptxTitleValidator(this._pptxTree);

  @override
  Set<ValidatorError> validate() {
    Set<ValidatorError> errors = {};
    if (_pptxTree.title.trim().isEmpty) {
       errors.add(ValidatorError(ValidatorErrorType.pptxTitleHasNoVisibleCharacters));
    }
    if (_pptxTree.title.length > LunaConstants.maximumPptxTitleLength) {
       errors.add(ValidatorError(ValidatorErrorType.pptxTitleIsTooLong));
    }

    return errors;
  }
}
