import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/controllers/translation_validation_service.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_authoring_system/validator/issue/translator_issues/csv_row_count_mismatch.dart';
import 'package:luna_authoring_system/validator/issue/translator_issues/translated_cell_missing.dart';

void main() {
  late TranslationValidationService svc;
  late ValidationIssuesStore store;

  setUp(() {
    svc = TranslationValidationService();
    store = ValidationIssuesStore();
  });

  test('returns empty and leaves store empty when CSV is valid', () {
    const csv = '''
Text,Translated text
Hello,Hola
World,Mundo
''';

    final issues = svc.validateCsvText(csv, store);

    expect(issues, isEmpty);
    expect(store.hasIssues, isFalse);
  });

  test('adds missing-translation issues to the store and returns them', () {
    const csv = '''
Text,Translated text
Hello,
World,Mundo
''';

    final issues = svc.validateCsvText(csv, store);

    expect(issues.length, 1);
    expect(store.issues.length, 1);
    expect(issues.first.toText(), contains('Hello'));
  });

  test('clears previous issues before adding new ones', () {
    const badCsv = '''
Text,Translated text
Hi,
''';
    svc.validateCsvText(badCsv, store);
    expect(store.hasIssues, isTrue);

    const goodCsv = '''
Text,Translated text
Hi,Hola
''';
    final issues = svc.validateCsvText(goodCsv, store);
    expect(issues, isEmpty);
    expect(store.hasIssues, isFalse);
  });

  test('accepts legacy header "Translation"', () {
    const csv = '''
Text,Translation
Hello,
''';

    final issues = svc.validateCsvText(csv, store);

    expect(issues.whereType<TranslatedCellMissing>().length, 1);
    expect(store.hasIssues, isTrue);
  });

  test('flags when translated row count is less than expected', () {
    const csv = '''
Text,Translated text
Hello,Hola
World,
''';

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

    final issues = svc.validateCsvText(
      csv,
      store,
      expectedSourceRowCount: 2,
    );

    expect(issues.whereType<CsvRowCountMismatch>(), isEmpty);
  });

  test('flags fewer rows when sourceCsvText is provided', () {
    const original = '''
Text,Translated text
Hello,
World,
Greetings,
''';

    const translatedFewer = '''
Text,Translated text
Hello,Hola
World,Mundo
''';

    final issues = svc.validateCsvText(
      translatedFewer,
      store,
      sourceCsvText: original,
    );

    expect(issues.any((i) => i is CsvRowCountMismatch), isTrue);
  });

  test('flags empty translated cell when source has text', () {
    const csv = '''
Text,Translated text
Hello,
World,Mundo
''';

    final issues = svc.validateCsvText(csv, store);

    final missing = issues.whereType<TranslatedCellMissing>().toList();
    expect(missing.length, 1);
    expect(missing.first.sourceText, 'Hello');
  });

  test('does NOT flag missing translation when source is empty', () {
    const csv = '''
Text,Translated text
,   
Hello,Hola
''';

    final issues = svc.validateCsvText(csv, store);

    expect(issues.whereType<TranslatedCellMissing>(), isEmpty);
  });
}
