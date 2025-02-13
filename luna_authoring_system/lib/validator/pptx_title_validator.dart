import 'package:luna_authoring_system/luna_constants.dart';
import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/validator/i_validator.dart';
import 'package:luna_authoring_system/validator/issue/pptx_title_has_no_visible_characters.dart';
import 'package:luna_authoring_system/validator/issue/pptx_title_is_too_long.dart';

/// A validator that checks the validity of the title of a `PptxTree`.
class PptxTitleValidator extends IValidator {
  final PptxTree _pptxTree;

  PptxTitleValidator(this._pptxTree);

  @override
  Set<IValidationIssue> validate() {
    final validationIssues = <IValidationIssue>{};

    if (_pptxTree.title.trim().isEmpty) {
      validationIssues.add(PptxTitleHasNoVisibleCharacters());
    }
    if (_pptxTree.title.length > LunaConstants.maximumPptxTitleLength) {
      validationIssues.add(PptxTitleIsTooLong());
    }

    return validationIssues;
  }
}

