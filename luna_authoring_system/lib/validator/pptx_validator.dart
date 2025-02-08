import 'dart:convert';
import 'dart:typed_data';

import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/validator/pptx_dimensions_validator.dart';
import 'package:luna_authoring_system/validator/pptx_title_validator.dart';
import 'package:luna_core/validator/i_validator.dart';
import 'package:luna_core/validator/validation_issue.dart';

/// A composite validator that runs all PPTX validators.
///
/// This class implements [IValidator] and aggregates errors from all
/// individual PPTX validators, such as [PptxTitleValidator] and [PptxDimensionsValidator].
class PptxValidator implements IValidator {
  final PptxTree _pptxTree;

  /// Creates an instance of [PptxValidator] for the given [PptxTree].
  PptxValidator(this._pptxTree);

  @override
  Set<ValidationIssue> validate() {
    Set<ValidationIssue> allIssues = {};

    // Run all individual validators and aggregate errors
    allIssues.addAll(PptxTitleValidator(_pptxTree).validate());
    allIssues.addAll(PptxDimensionsValidator(_pptxTree).validate());
    // Add new PPTX Validators here

    return allIssues;
  }

    Uint8List validateAndGetIssuesAsTXTFileBytes() {
    final issues = validate();
    final issueCodes = issues.map((issue) => issue.issueCode).toList()..sort();
    final content = '${issueCodes.join('\n')}\n';
    // Convert to List<int> first, then create a Uint8List from it.
    final bytes = utf8.encode(content);
    
    return Uint8List.fromList(bytes);
  }
}