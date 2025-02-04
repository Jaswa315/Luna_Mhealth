import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/validator/pptx_dimensions_validator.dart';
import 'package:luna_authoring_system/validator/pptx_title_validator.dart';
import 'package:luna_core/validator/validator_manager.dart';

/// PptxValidations is our "collection" of every PPTX Validator we want to run
/// when we validate a pptxTree. If we create new PPTX validators and want to integrate them
/// into our validation check ran on every pptx tree created in authoring system's main, we'd
/// add it here.
class PptxValidations {
  /// Returns a [ValidatorManager] with all PPTX validators added.
  static ValidatorManager getPptxValidationsToRun(PptxTree pptxTree) {
    ValidatorManager validatorManager = ValidatorManager();
    validatorManager.addValidator(PptxTitleValidator(pptxTree));
    validatorManager.addValidator(PptxDimensionsValidator(pptxTree));
    // Add new PPTX Validators here 

    return validatorManager;
  }
}