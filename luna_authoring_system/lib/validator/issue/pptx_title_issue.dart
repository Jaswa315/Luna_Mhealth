import 'package:luna_authoring_system/validator/i_validation_issue.dart';

/// Base class for PPTX title validation errors.
abstract class PPTXTitleIssue extends IValidationIssue {}

class PPTXTitleHasNoVisibleCharacters extends PPTXTitleIssue {
  String toText() {
    return 'pptx_title_has_no_visible_characters';
  }
}

class PPTXTitleIsTooLong extends PPTXTitleIssue {
  String toText() {
    return 'pptx_title_is_too_long';
  }
}
