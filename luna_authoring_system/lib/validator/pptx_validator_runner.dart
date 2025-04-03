import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/validator/pptx_validator.dart';

class PptxValidatorRunner {
  /// Runs all pptx_validators and throws an error if there are any issues.
  static void runValidatiors(PptxTree pptxTree) {
    Set<IValidationIssue> issueList = PptxValidator(pptxTree).validate();

    if (issueList.isNotEmpty) {
      for (var issue in issueList) {
        /// Print the issue to the console
        /// ignore: avoid_print
        print('Validation Issue Found: ${issue.toText()}');
      }

      throw ArgumentError(
        'Validation failed with ${issueList.length} issue(s).',
      );
    }
  }
}
