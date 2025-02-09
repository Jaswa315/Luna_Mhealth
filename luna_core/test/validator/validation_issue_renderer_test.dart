import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/validator/validation_issue_renderer.dart';
import 'package:luna_core/validator/validation_issue.dart';

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

    test('renders a single issue correctly', () {
      final Set<ValidationIssue> issues = {
        DummyValidationIssue('single_error'),
      };
      final renderer = ValidationIssueRenderer(issues);

      final Uint8List fileBytes = renderer.renderAsTextFileBytes();
      final String content = utf8.decode(fileBytes);

      // Assert: The content should be "single_error\n".
      expect(content, 'single_error\n');
    });

    test('renders multiple issues in sorted order', () {
      final Set<ValidationIssue> issues = {
        DummyValidationIssue('z_error'),
        DummyValidationIssue('a_error'),
        DummyValidationIssue('m_error'),
      };
      final renderer = ValidationIssueRenderer(issues);

      final Uint8List fileBytes = renderer.renderAsTextFileBytes();
      final String content = utf8.decode(fileBytes);

      final String expectedContent = 'a_error\nm_error\nz_error\n';
      expect(content, expectedContent);
    });
  });
}
