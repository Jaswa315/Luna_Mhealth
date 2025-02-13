import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/validator/validation_issue_renderer.dart';
import 'package:luna_authoring_system/validator/validation_issue.dart';

/// A dummy implementation of ValidationIssue for testing purposes.
class DummyValidationIssue extends ValidationIssue {
  final String _issueCode;

  DummyValidationIssue(this._issueCode);

  @override
  String get issueCode => _issueCode;
}

void main() {
  group('ValidationIssueRenderer Tests', () {
    test('Renders an empty set of issues as a single newline', () {
      final Set<ValidationIssue> issues = {};
      final renderer = ValidationIssueRenderer(issues);

      final Uint8List fileBytes = renderer.renderAsTextFileBytes();
      final String content = utf8.decode(fileBytes);

      expect(content, '\n');
    });

    test('Renders a single issue correctly', () {
      final Set<ValidationIssue> issues = {
        DummyValidationIssue('single_issue'),
      };
      final renderer = ValidationIssueRenderer(issues);

      final Uint8List fileBytes = renderer.renderAsTextFileBytes();
      final String content = utf8.decode(fileBytes);

      // The content should be "single_issue\n".
      expect(content, 'single_issue\n');
    });

    test('Renders multiple issues in any order', () {
      final Set<ValidationIssue> issues = {
        DummyValidationIssue('z_issue'),
        DummyValidationIssue('a_issue'),
        DummyValidationIssue('m_issue'),
      };
      final renderer = ValidationIssueRenderer(issues);

      final Uint8List fileBytes = renderer.renderAsTextFileBytes();
      final String content = utf8.decode(fileBytes);

      // Verify that the content contains each expected issue code.
      expect(content, contains('a_issue'));
      expect(content, contains('m_issue'));
      expect(content, contains('z_issue'));

      // Verify that there are exactly 3 non-empty lines.
      final List<String> lines =
          content.split('\n').where((line) => line.isNotEmpty).toList();
      expect(lines.length, 3);
    });
  });
}
