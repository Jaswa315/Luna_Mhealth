import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/validator/i_validator.dart';
import 'package:luna_authoring_system/validator/issue/pptx_slide_has_no_shapes.dart';

/// A validator that checks the PPTX tree for slides that have no shapes.
class PptxSlideHasNoShapesValidator extends IValidator {
  final PptxTree _pptxTree;

  PptxSlideHasNoShapesValidator(this._pptxTree);

  @override
  Set<IValidationIssue> validate() {
    final validationIssues = <IValidationIssue>{};

    if (_pptxTree.slides == null || _pptxTree.slides!.isEmpty) {
      return validationIssues;
    }

    /// Loop through each slide in the PPTX tree and check if it has shapes.
    for (var i = 0; i < _pptxTree.slides!.length; i++) {
      /// If a slide has no shapes, add a validation issue.
      if (_pptxTree.slides![i].shapes?.isEmpty ?? true) {
        validationIssues.add(PptxSlideHasNoShapes());
      }
    }

    return validationIssues;
  }
}
