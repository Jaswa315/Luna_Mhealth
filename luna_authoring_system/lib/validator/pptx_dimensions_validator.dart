// ignore_for_file: non_constant_identifier_names, unused_local_variable
// We ignore these rules so we can catch LateInitializationError to validate if PptxTree width/height is initialized

import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/validator/issue/pptx_dimensions_issue.dart';
import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_core/validator/validation_issue.dart';

/// A validator that checks the validity of the dimensions of a `PptxTree`.
class PptxDimensionsValidator extends IValidator {
  final PptxTree _pptxTree;

  PptxDimensionsValidator(this._pptxTree);

  @override
  Set<ValidationIssue> validate() {
    final validationIssues = <ValidationIssue>{};

    try {
      // Simply accessing these properties will throw LateInitializationError if they are not initialized.
      var width = _pptxTree.width;
      var height = _pptxTree.height;
    } catch (LateInitializationError) {
      // Handle the error by adding a specific validation error.
      validationIssues.add(PPTXWidthAndHeightMustBothBeInitialized());

      return validationIssues;
    }

    if (_pptxTree.width.value <= 0) {
      validationIssues.add(PPTXWidthMustBePositive());
    }
    if (_pptxTree.height.value <= 0) {
      validationIssues.add(PPTXHeightMustBePositive());
    }

    return validationIssues;
  }
}
