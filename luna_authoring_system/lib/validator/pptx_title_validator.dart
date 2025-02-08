import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/validator/issue/pptx_title_issue.dart';
import 'package:luna_core/luna_constants.dart';
import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_core/validator/validation_issue.dart';

/// A validator that checks the validity of the title of a `PptxTree`.
class PptxTitleValidator extends IValidator {
  final PptxTree _pptxTree;

  PptxTitleValidator(this._pptxTree);

  @override
  Set<ValidationIssue> validate() {
    final validationIssues = <ValidationIssue>{};

    if (_pptxTree.title.trim().isEmpty) {
      validationIssues.add(PPTXTitleHasNoVisibleCharacters());
    }
    if (_pptxTree.title.length > LunaConstants.maximumPptxTitleLength) {
      validationIssues.add(PPTXTitleIsTooLong());
    }

    return validationIssues;
  }
}

