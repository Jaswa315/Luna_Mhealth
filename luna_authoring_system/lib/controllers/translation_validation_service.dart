import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/validator/translator_validators/translated_csv_validator.dart';

/// Logic for validating a translated CSV
/// and reflecting results into the ValidationIssuesStore.
class TranslationValidationService {
  /// Runs the CSV validator and updates [store] with the results.
  Set<IValidationIssue> validateCsvText(
    String csvText,
    ValidationIssuesStore store,
  ) {
    final issues = TranslatedCsvValidator(csvText).validate();

    store.clear();
    for (final i in issues) {
      store.addIssue(i);
    }
    return issues;
  }
}
