import 'dart:convert';
import 'dart:typed_data';
import 'dart:collection';
import 'dart:io';
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppt_parser/localized_text.dart';

void main() {
  group('LocalizedText Tests', () {
    // Test initialization with default locale
    test('Initialization without specified locale uses default', () {
      var localizedText = LocalizedText();
      expect(localizedText.locale, equals(Locale('en', '')));
    });

    // Test initialization with a specific locale
    test('Initialization with specified locale', () {
      var locale = Locale('fr', '');
      var localizedText = LocalizedText(locale);
      expect(localizedText.locale, equals(locale));
    });

     // Test the getter for retrieving strings by UID
    test('Retrieves the correct string for a given UID', () {
      var localizedText = LocalizedText();
      var uid1 = localizedText.addString("Hello");
      var uid2 = localizedText.addString("World");
      expect(localizedText.getString(uid1), equals("Hello"));
      expect(localizedText.getString(uid2), equals("World"));
    });

    // Test the getter for non-existent UID returns the correct fallback message
    test('Returns fallback message for non-existent UID', () {
      var localizedText = LocalizedText();
      localizedText.addString("Hello");  // Adds one string, UID should be 1
      // Requesting a non-existent UID (UID 2)
      expect(localizedText.getString(2), equals("Text not found"));
    });

    // Test the setter for adding new strings and ensuring UIDs are incremented correctly
    test('Correctly adds strings and assigns incremental UIDs', () {
      var localizedText = LocalizedText();
      var uid1 = localizedText.addString("Hello");
      var uid2 = localizedText.addString("World");
      // Ensure UIDs start from 1 and are incremented correctly
      expect(uid1, equals(1));
      expect(uid2, equals(2));
      expect(localizedText.getString(uid1), equals("Hello"));
      expect(localizedText.getString(uid2), equals("World"));
    });

    // Test CSV parsing
    test('Correctly parses CSV data', () {
      var csvData = utf8.encode("UID,OriginalText,LocalizedText\n1,Hello,Hola\n2,World,Mundo");
      var localizedText = LocalizedText.fromCsv(Uint8List.fromList(csvData));
      expect(localizedText.getString(1), equals('Hola'));
      expect(localizedText.getString(2), equals('Mundo'));
    });

    // Test error handling for bad CSV data
    test('Throws FormatException for malformed CSV data', () {
      var csvData = utf8.encode("UID,OriginalText\n1,Hello");
      expect(() => LocalizedText.fromCsv(Uint8List.fromList(csvData)), throwsFormatException);
    });

    // Test generating CSV content
    test('Generates correct CSV format from internal data', () {
      var localizedText = LocalizedText();
      localizedText.addString('Hello');
      localizedText.addString('World');
      var csvContent = localizedText.generateCsvContent();
      var expected = 'UID,localizedText\n1,Hello\n2,World'; 
      expect(csvContent.trim(), equals(expected.trim()));
    });

    // Test CSV to bytes conversion
    test('Converts generated CSV content to bytes correctly', () {
      var localizedText = LocalizedText();
      localizedText.addString('Hello');
      localizedText.addString('World');
      var csvBytes = localizedText.getCsvBytes();
      var csvContent = utf8.decode(csvBytes);
      var expected = 'UID,localizedText\n1,Hello\n2,World';
      expect(csvContent.trim(), equals(expected.trim()));
    });

    // Test writing CSV to a file 
    test('Writes CSV data to file correctly', () async {
      var localizedText = LocalizedText();
      localizedText.addString('Test');
      var filePath = 'test_output.csv';
      await localizedText.writeCsvToFile(filePath);
      var fileContents = await File(filePath).readAsString();
      expect(fileContents.trim(), contains('Test'));
    });
  });
}

 