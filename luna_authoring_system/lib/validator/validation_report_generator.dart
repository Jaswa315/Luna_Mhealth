import 'package:luna_authoring_system/validator/i_validation_issue.dart';

/// This class takes in a set of validation issues to generate a report for the author
class ValidationReportGenerator {
  final Set<IValidationIssue> issues;

  ValidationReportGenerator(this.issues);

  /// Renders the validation issues as a text file.
  String renderAsText() {
    String contentString = "";
    for (var issue in issues) {
      contentString += issue.toText();
    }

    return contentString;
  }
}
