import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/validator/i_validator.dart';
import 'package:luna_authoring_system/validator/pptx_title_validator.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';

/// A composite validator that runs all PPTX validators.
class PptxValidator implements IValidator {
  final PptxTree _pptxTree;

  /// Creates an instance of [PptxValidator] for the given [PptxTree].
  PptxValidator(this._pptxTree);

  @override
  Set<IValidationIssue> validate() {
    Set<IValidationIssue> allIssues = {};

    // Run all individual validators and aggregate issues.
    allIssues.addAll(PptxTitleValidator(_pptxTree).validate());

    // Add more validators as needed.

    return allIssues;
  }
}
