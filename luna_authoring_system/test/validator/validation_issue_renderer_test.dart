import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/validator/validation_report_generator.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';

/// A dummy implementation of IValidationIssue for testing purposes.
class DummyValidationIssue extends IValidationIssue {
  DummyValidationIssue();

  String toText() {
    return 'dummy_validation_issue';
  }

  int get severity => 0;
}

void main() {
  group('ValidationReportGenerator Tests', () {
    test('Renders an empty set of issues as an empty string', () {
      final Set<IValidationIssue> issues = {};
      final renderer = ValidationReportGenerator(issues);

      expect(renderer.renderAsText(), '');
    });

    test('Renders a single issue as a string', () {
      final Set<IValidationIssue> issues = {
        DummyValidationIssue(),
      };
      final renderer = ValidationReportGenerator(issues);

      expect(renderer.renderAsText(), 'dummy_validation_issue');
    });
  });
}
