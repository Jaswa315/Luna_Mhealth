import 'package:luna_authoring_system/validator/i_validation_issue.dart';

/// This class is responsible for rendering validation issues
class ValidationIssuesRenderer {
  final Set<IValidationIssue> issues;

  ValidationIssuesRenderer(this.issues);

  /// Renders the validation issues as a text file.
  /// Each issue's code is printed on a new line.
  String renderAsText() {
    String contentString = "";
    for (var issue in issues) {
      contentString += issue.toText();
    }

    return contentString;
  }
}
