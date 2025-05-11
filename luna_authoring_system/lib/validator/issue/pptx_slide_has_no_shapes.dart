import 'package:luna_authoring_system/validator/i_validation_issue.dart';

class PptxSlideHasNoShapes extends IValidationIssue {
  String toText() {
    return 'pptx_slide_has_no_shapes';
  }
}
