import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/controllers/translation_validation_service.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_authoring_system/validator/issue/translator_issues/csv_row_count_mismatch.dart';

void main() {
  late TranslationValidationService svc;
  late ValidationIssuesStore store;

  setUp(() {
    svc = TranslationValidationService();
    store = ValidationIssuesStore();
  });

  test('flags when translated row count is less than expected', () {
    const csv = '''
Text,Translated text
Hello,Hola
World,
''';

    // Actual non-empty "Text" rows = 2; expect 3 to trigger the mismatch.
    final issues = svc.validateCsvText(
      csv,
      store,
      expectedSourceRowCount: 3,
    );

    expect(issues.any((i) => i is CsvRowCountMismatch), isTrue);
    expect(store.hasIssues, isTrue);
  });

  test('no row-count issue when counts match (empty rows ignored)', () {
    const csv = '''
Text,Translated text

Hello,Hola
World,Mundo

,   
''';

    // Actual non-empty "Text" rows = 2; expect 2 so no mismatch.
    final issues = svc.validateCsvText(
      csv,
      store,
      expectedSourceRowCount: 2,
    );

    expect(issues.whereType<CsvRowCountMismatch>(), isEmpty);
  });
}
