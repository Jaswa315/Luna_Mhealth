import 'package:luna_authoring_system/luna_constants.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';

class CsvRowCountMismatch extends IValidationIssue {
  final int expected;
  final int actual;

  CsvRowCountMismatch({required this.expected, required this.actual});

  @override
  String toText() =>
      'CSV row count mismatch: expected $expected source texts, found $actual translated rows.';

  @override
  ValidationSeverity get severity => ValidationSeverity.warning;
}
