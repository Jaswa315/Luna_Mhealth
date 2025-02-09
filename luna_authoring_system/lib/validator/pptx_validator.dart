import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/validator/pptx_dimensions_validator.dart';
import 'package:luna_authoring_system/validator/pptx_title_validator.dart';
import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_core/validator/validation_issue.dart';

/// A composite validator that runs all PPTX validators.
class PptxValidator implements IValidator {
  final PptxTree _pptxTree;

  /// Creates an instance of [PptxValidator] for the given [PptxTree].
  PptxValidator(this._pptxTree);

  @override
  Set<ValidationIssue> validate() {
    Set<ValidationIssue> allIssues = {};

    // Run all individual validators and aggregate issues.
    allIssues.addAll(PptxTitleValidator(_pptxTree).validate());
    allIssues.addAll(PptxDimensionsValidator(_pptxTree).validate());
    // Add more validators as needed.

    return allIssues;
  }
}
