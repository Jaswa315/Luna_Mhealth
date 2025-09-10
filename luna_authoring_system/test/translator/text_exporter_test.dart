import 'package:test/test.dart';
import 'package:luna_authoring_system/translator/text_chunk.dart';
import 'package:luna_authoring_system/translator/text_exporter.dart';

/// Tests for the TextExporter class which converts TextChunks to CSV format.
void main() {
  group('TextExporter Tests', () {
    test('Generates CSV with correct headers and rows', () {
      final chunks = [
        TextChunk(slideNumber: 0, text: 'Eat healthy during pregnancy'),
        TextChunk(slideNumber: 1, text: 'Visit a clinic if you feel weak or dizzy'),
      ];

      // Create an instance of TextExporter
      final exporter = TextExporter();

      // Call the method to generate CSV
      final csv = exporter.generateCsv(chunks);

      // Check if the CSV contains header row
      expect(csv, contains('Slide,Text,Translated text'));

      // Check if the CSV contains data rows
      expect(csv, contains('0,Eat healthy during pregnancy,'));
      expect(csv, contains('1,Visit a clinic if you feel weak or dizzy,'));
    });

    test('Handles empty list of TextChunks', () {
      final exporter = TextExporter();
      final csv = exporter.generateCsv([]);

      // Expect only the header row in the CSV output
      expect(csv, contains('Slide,Text,Translated text'));
      expect(csv.split('\n').length, 1); // header row
    });
  });
}