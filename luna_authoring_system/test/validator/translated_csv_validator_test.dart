import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/validator/translator_validators/translated_csv_validator.dart';

void main() {
  group('TranslatedCsvValidator', () {
    test('flags rows with empty translated cells', () {
      // header row + 3 data rows (1 & 3 missing translations)
      const csv = '''
Text,Translated text
Hello,
World,Hola
Thanks,
''';

      final v = TranslatedCsvValidator(csv);
      final Set<IValidationIssue> issues = v.validate();

      expect(issues.length, 2);

      // Convert to plain text for easy matching
      final descriptions = issues.map((e) => e.toText()).toList();

      // Header is row 1, so first data row is row 2
      expect(descriptions.any((d) => d.contains('Row 2')), isTrue);
      expect(descriptions.any((d) => d.contains('Hello')), isTrue);

      // Third data row is row 4
      expect(descriptions.any((d) => d.contains('Row 4')), isTrue);
      expect(descriptions.any((d) => d.contains('Thanks')), isTrue);
    });

    test('passes when all translated cells are filled', () {
      const csv = '''
Text,Translated text
Hello,Bonjour
World,Monde
Thanks,Merci
''';

      final v = TranslatedCsvValidator(csv);
      final issues = v.validate();

      expect(issues, isEmpty);
    });

    test('treats whitespace-only translated as missing', () {
      const csv = '''
Text,Translated text
Hello,   
''';

      final v = TranslatedCsvValidator(csv);
      final issues = v.validate();

      expect(issues.length, 1);
      expect(issues.first.toText(), contains('Hello'));
    });

    test('ignores completely empty rows', () {
      const csv = '''
Text,Translated text
Hello,Bonjour

World,Monde
''';

      final v = TranslatedCsvValidator(csv);
      final issues = v.validate();

      expect(issues, isEmpty);
    });

    test('is case-insensitive for header names', () {
      const csv = '''
TeXt,TrAnSlAtEd tExT
Hello,
''';

      final v = TranslatedCsvValidator(csv);
      final issues = v.validate();

      expect(issues.length, 1);
      expect(issues.first.toText(), contains('Hello'));
    });

    test('returns a CSV format issue if required headers are missing', () {
      const csv = '''
foo,bar
Hello,Hola
''';

      final v = TranslatedCsvValidator(csv);
      final issues = v.validate();

      expect(issues.length, 1);
      expect(issues.first.toText().toLowerCase(), contains('missing header'));
    });
  });
}
