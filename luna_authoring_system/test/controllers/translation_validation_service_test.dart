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
text,Translation
Hello,Hola
World,Mundo
''';

    final issues = svc.validateCsvText(csv, store);

    expect(issues, isEmpty);
    expect(store.hasIssues, isFalse);
  });

  test('adds missing-translation issues to the store and returns them', () {
    const csv = '''
text,Translation
Hello,
World,Mundo
''';

    final issues = svc.validateCsvText(csv, store);

    expect(issues.length, 1);
    expect(store.issues.length, 1);
    expect(issues.first.toText(), contains('Hello')); // row with empty translation
  });

  test('accepts legacy header "Translated text"', () {
    const csv = '''
text,Translated text
Hello,
''';

    final issues = svc.validateCsvText(csv, store);

    expect(issues.length, 1);
    expect(store.hasIssues, isTrue);
  });

  test('clears previous issues before adding new ones', () {
    const badCsv = '''
text,Translation
Hi,
''';
    svc.validateCsvText(badCsv, store);
    expect(store.hasIssues, isTrue);

    const goodCsv = '''
text,Translation
Hi,Hola
''';
    final issues = svc.validateCsvText(goodCsv, store);
    expect(issues, isEmpty);
    expect(store.hasIssues, isFalse);
  });
}
