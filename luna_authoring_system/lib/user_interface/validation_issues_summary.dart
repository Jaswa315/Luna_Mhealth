import 'package:flutter/material.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/validator/issue/pptx_issues/i_pptx_validation_issues.dart';

class ValidationIssuesSummary extends StatelessWidget {
  final List<IValidationIssue> issues;

  const ValidationIssuesSummary({Key? key, required this.issues})
      : super(key: key);

  bool get hasIssues => issues.isNotEmpty;

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
    switch (issue.runtimeType) {
      case IPptxValidationIssues:
        return _buildPptxValidationIssueRow(issue as IPptxValidationIssues);
      default:
        return Row(
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
  }

  @override
  Widget build(BuildContext context) {
    if (!hasIssues) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          "Validation Issues Found: ${issues.length}",
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        ...issues.map((issue) => _buildIssueRow(issue)),
      ],
    );
  }
}
