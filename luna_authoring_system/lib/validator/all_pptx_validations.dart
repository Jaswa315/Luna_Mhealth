import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/validator/pptx_dimensions_validator.dart';
import 'package:luna_authoring_system/validator/pptx_title_validator.dart';
import 'package:luna_core/validator/validator_manager.dart';

class AllPptxValidations {
  /// Returns a [ValidatorManager] with all PPTX validators added.
  static ValidatorManager getPptxValidationsToRun(PptxTree pptxTree) {
    ValidatorManager validatorManager = ValidatorManager();
    validatorManager.addValidator(PptxTitleValidator(pptxTree));
    validatorManager.addValidator(PptxDimensionsValidator(pptxTree));
    // Add new PPTX Validators here 

    return validatorManager;
  }
}