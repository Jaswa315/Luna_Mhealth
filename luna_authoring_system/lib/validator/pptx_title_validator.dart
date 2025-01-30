import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_core/validator/validator_error.dart';
import 'package:luna_core/validator/validator_error_type.dart';

/// A validator that checks the validity of the title of a `PptxTree`.
class PptxTitleValidator implements IValidator {
  final PptxTree _pptxTree;

  /// Constructs a `PptxTitleValidator` with a [PptxTree].
  PptxTitleValidator(this._pptxTree);

  @override
  Set<ValidatorError> validate() {
    Set<ValidatorError> errors = {};
    if (_pptxTree.title.isEmpty) {
       errors.add(ValidatorError(ValidatorErrorType.pptxTitleIsEmpty));
    }

    return errors;
  }
}
