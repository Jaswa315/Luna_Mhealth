import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppt_parser/module_text_strings.dart';

void main() {
  group('ModuleTextStrings Tests', () {
    // Test to verify that the parseCsvToMap method correctly interprets and maps CSV data
    test('parseCsvToMap correctly parses CSV data', () {
      ModuleTextStrings textStrings = ModuleTextStrings();
      // Defining a CSV data string with headers and two rows of data
      String csvData = 'text_ID,originalText,localizedText\n001,LUNA,LeggUNeggA\n002,Health for the whole family,Heggeggalth feggor thegge wheggolegg feggameggeleggy';
      Uint8List csvBytes = Uint8List.fromList(utf8.encode(csvData));
      // Parsing the CSV byte data into the textStrings instance
      textStrings.parseCsvToMap(csvBytes);
      expect(textStrings.getString(001), 'LeggUNeggA');
      expect(textStrings.getString(002), 'Heggeggalth feggor thegge wheggolegg feggameggeleggy');
    });
    
    // Test to ensure getString method returns a default message for UIDs that are not found in the map
    test('getString returns "Text not found" for unknown UID', () {
      ModuleTextStrings textStrings = ModuleTextStrings();
      String csvData = 'text_ID,originalText,localizedText\n001,LUNA,LeggUNeggA';
      Uint8List csvBytes = Uint8List.fromList(utf8.encode(csvData));
      textStrings.parseCsvToMap(csvBytes);
      expect(textStrings.getString(999), 'Text not found');
    });
  });
}
