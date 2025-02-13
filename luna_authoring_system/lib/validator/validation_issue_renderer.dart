import 'dart:convert';
import 'dart:typed_data';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';

/// This class is responsible for rendering validation issues
/// into a text file (as UTF-8 encoded bytes).
class ValidationIssueRenderer {
  final Set<IValidationIssue> issues;

  ValidationIssueRenderer(this.issues);

  /// Renders the validation issues as a text file.
  /// Each issue's code is printed on a new line.
  Uint8List renderAsTextFileBytes() {
    final issueCodes = issues.map((issue) => issue.issueCode).toList()..sort();
    final content = '${issueCodes.join('\n')}\n';
    
    return Uint8List.fromList(utf8.encode(content));
  }
}
