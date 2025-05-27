import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/validator/pptx_validator.dart';

class PptxValidatorRunner {
  /// Runs all pptx_validators and throws an error if there are any issues.

  void runValidatiors(PptxTree pptxTree, ValidationIssuesStore store) {
    Set<IValidationIssue> issueList = PptxValidator(pptxTree).validate();

    if (issueList.isNotEmpty) {
      for (var issue in issueList) {
        // Add the issue to the store
        store.addIssue(issue);
      }
    }
  }
}
