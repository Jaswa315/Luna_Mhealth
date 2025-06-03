import 'package:luna_authoring_system/luna_constants.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';

class PptxTitleHasNoVisibleCharacters extends IValidationIssue {
  String toText() {
    return 'pptx_title_has_no_visible_characters';
  }

  @override
  Severity get severity => Severity.warning;
}
