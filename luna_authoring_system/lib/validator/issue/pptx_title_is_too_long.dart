import 'package:luna_authoring_system/validator/i_validation_issue.dart';

class PptxTitleIsTooLong extends IValidationIssue {
  String toText() {
    return 'pptx_title_is_too_long';
  }
}