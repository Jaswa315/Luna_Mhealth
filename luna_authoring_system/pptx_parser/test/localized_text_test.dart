import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/localization/localized_text.dart';

void main() {
  group('LocalizedText', () {
    // Sample CSV data
    final sampleCsv = Uint8List.fromList(utf8.encode(
        "UID,originalText,localizedText\n1,Hello,Hello\n2,Hello,Bonjour\n3,Hello,Hola"));

    // Test fallback to English (US)
    test('Fallback to English (US)', () {
      final localizedText = LocalizedText(sampleCsv, const Locale('de'));
      expect(localizedText.locale, const Locale('en', 'US'));
      expect(localizedText.getString(1), 'Hello');
    });

    // Test addString method
    test('Add string and get UID', () {
      final localizedText = LocalizedText(sampleCsv);
      int newUid = localizedText.addString('Test String');
      expect(localizedText.getString(newUid), 'Test String');
    });

    // Test generateCsvContent method
    test('Generate CSV content', () {
      final localizedText = LocalizedText(sampleCsv);
      localizedText.addString('New String');
      String csvContent = localizedText.generateCsvContent();
      expect(csvContent, contains('UID,localizedText'));
      expect(csvContent, contains(',New String'));
    });

    // Test getCsvBytes method
    test('Get CSV bytes', () {
      final localizedText = LocalizedText(sampleCsv);
      Uint8List csvBytes = localizedText.getCsvBytes();
      expect(utf8.decode(csvBytes), contains('UID,localizedText'));
    });

    // Test iterator
    test('Iterator', () {
      final localizedText = LocalizedText(sampleCsv);
      List<String> strings = localizedText.toList();
      expect(strings, contains('Hello'));
      expect(strings, contains('Bonjour'));
      expect(strings, contains('Hola'));
    });
  });
}