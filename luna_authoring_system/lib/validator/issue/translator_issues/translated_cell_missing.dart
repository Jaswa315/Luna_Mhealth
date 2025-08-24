import 'package:luna_authoring_system/luna_constants.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';

/// Raised when a CSV row has an empty translation cell.
class TranslatedCellMissing extends IValidationIssue {
  final int rowIndex;      
  final String sourceText;

  TranslatedCellMissing({
    required this.rowIndex,
    required this.sourceText,
  });

  @override
  String toText() => 'Row $rowIndex: No translation provided for "$sourceText".';

  @override
  ValidationSeverity get severity => ValidationSeverity.warning;
}
