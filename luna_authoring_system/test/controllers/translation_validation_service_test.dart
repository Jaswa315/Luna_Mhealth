import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/controllers/translation_validation_service.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';

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
    expect(issues.first.toText(), contains('Hello')); // row with empty translation
  });

  test('accepts legacy header "Translation"', () {
    const csv = '''
Text,Translation
Hello,
''';

    final issues = svc.validateCsvText(csv, store);

    expect(issues.length, 1);
    expect(store.hasIssues, isTrue);
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
}
