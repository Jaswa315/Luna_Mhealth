import 'package:flutter/material.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/validator/issue/pptx_issues/i_pptx_validation_issues.dart';

/// This Widget [ValidationIssuesSummary] displays a summary of validation issues.
/// It takes a list of [IValidationIssue] and displays them in a formatted manner.
class ValidationIssuesSummary extends StatelessWidget {
  final List<IValidationIssue> _issues;
  final ValidationIssuesStore store;

  ValidationIssuesSummary({
    Key? key,
    required List<IValidationIssue> issues,
    required this.store,
  })  : _issues = issues,
        super(key: key);

  bool get hasIssues => _issues.isNotEmpty;

  Widget _buildPptxValidationIssueRow(IPptxValidationIssues issue) {
    return Row(
      children: [
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            issue.toText(),
            style: const TextStyle(color: Colors.red, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildIssueRow(IValidationIssue issue) {
    Widget widget;
    switch (issue.runtimeType) {
      case IPptxValidationIssues:
        widget = _buildPptxValidationIssueRow(issue as IPptxValidationIssues);
        break;
      default:
        widget = Row(
          children: [
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                "${issue.toText()} (${issue.severity.toString()})",
              ),
            ),
          ],
        );
    }

    return Row(
      children: [
        const SizedBox(width: 6),
        Expanded(child: widget),
        Checkbox(
          value: issue.ignore,
          onChanged: (bool? value) {
            store.toggleIgnore(issue, value ?? false);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!hasIssues) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          "Validation Issues Found: ${_issues.length}",
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        ..._issues.map((issue) => _buildIssueRow(issue)),
      ],
    );
  }
}
