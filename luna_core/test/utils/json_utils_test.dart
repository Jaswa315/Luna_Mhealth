import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:pptx_parser/parser/presentation_parser.dart';
import 'package:pptx_parser/parser/presentation_tree.dart';
import 'package:luna_core/utils/json_data_extractor.dart';
import 'testassets/json_utils_test_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Map<String, String> jsonDataMap; 
  group('JSON Data Extractor Class Tests', () {
    setUpAll(() async {
      //LogManager.createInstance();
      jsonDataMap = JsonUtilsTestData.getJsonData();
    });

    test(
        'JSON Data Extractor: Generate CSV bytes, given JSON Data with zero elements. Check bytes exist and validate content.',
        () async {
      String data = jsonDataMap["Empty"] ?? '';

      JSONDataExtractor generator = JSONDataExtractor();

      Uint8List? csvBytes = await generator.extractTextDataFromJSONAsCSVBytes(data);

      expect(csvBytes, isNotNull, reason: "CSV bytes should not be null.");
      expect(csvBytes, isNotEmpty, reason: "CSV bytes should not be empty.");

      String csvContent = utf8.decode(csvBytes!);
      List<String> rows = csvContent.split('\n');
      expect(rows[0], equals('textID,originalText,translatedText'));
      expect(rows.length, 1);
    });

    test(
        'JSONDataExtractor: Generate CSV bytes, given JSON Data with one element. Check bytes exist and validate content.',
        () async {
      String data = jsonDataMap['HelloWorld'] ?? '';
      JSONDataExtractor generator = JSONDataExtractor();

      Uint8List? csvBytes = await generator.extractTextDataFromJSONAsCSVBytes(data);

      expect(csvBytes, isNotNull, reason: "CSV bytes should not be null.");
      expect(csvBytes, isNotEmpty, reason: "CSV bytes should not be empty.");

      String csvContent = utf8.decode(csvBytes!);
      List<String> rows = csvContent.split('\n');
      expect(rows[0], equals('textID,originalText,translatedText'));
      expect(rows[1], contains('Hello, World'));
    });

    test(
        'JSONDataExtractor: Generate CSV bytes, given JSON Data with three elements. Check bytes exist and validate content.',
        () async {
      
      String data = jsonDataMap["Textboxes"] ?? '';

      JSONDataExtractor generator = JSONDataExtractor();

      Uint8List? csvBytes = await generator.extractTextDataFromJSONAsCSVBytes(data);

      expect(csvBytes, isNotNull, reason: "CSV bytes should not be null.");
      expect(csvBytes, isNotEmpty, reason: "CSV bytes should not be empty.");

      String csvContent = utf8.decode(csvBytes!);
      List<String> rows = csvContent.split('\n');
      expect(rows[0], equals('textID,originalText,translatedText'));
      expect(rows[1], contains('Thing1'));
      expect(rows[2], contains('Thing2'));
      expect(rows[3], contains('Thing3'));
    });

    test(
        'JSON Data Extractor: Given JSON data, extract the presentation language locale string. Expected to be en-US',
        () async {
      String data = jsonDataMap["HelloWorld"] ?? '';
      JSONDataExtractor extractor = JSONDataExtractor();
      String fileName = extractor.extractLanguageFromJSON(data);
      expect(fileName, "en-US");
    });
  });
}
