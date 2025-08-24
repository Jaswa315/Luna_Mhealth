import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_authoring_system/validator/translator_validators/translated_csv_validator.dart';
import 'package:luna_authoring_system/validator/validator_runner.dart';

/// Validates an uploaded translated CSV and populates the issues store.
/// Expects the CSV to have headers: text and Translation
void validateUploadedTranslationCsv({
  required String csvText,
  required ValidationIssuesStore store,
}) {
  
  final validator = TranslatedCsvValidator(
    csvText,
    translatedHeader: 'Translation',
    sourceHeader: 'text',
  );

  ValidatorRunner(validator).runValidators(store);
}
