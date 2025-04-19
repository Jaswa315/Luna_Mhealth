import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Tests for OdpXmlToJsonConverter using A horizontal line.odp', () {
    final odpFile = File('test/test_assets/A horizontal line.odp');
    PptxXmlToJsonConverter odpXmlToJsonConverter =
        PptxXmlToJsonConverter(odpFile);

    test('OdpXmlToJsonConverter initializes without errors.', () async {
      expect(odpXmlToJsonConverter, isNotNull);
    });

    test('OdpXmlToJsonConverter extracts files only once.', () async {
      odpXmlToJsonConverter
          .getJsonFromPptx("content.xml"); // Triggers extraction

      // Verify an extracted file exists
      var extractedFilePath =
          p.join(odpXmlToJsonConverter.getTempPath(), "content.xml");
      expect(File(extractedFilePath).existsSync(), isTrue);
    });

    test('OdpXmlToJsonConverter loads and converts XML to JSON.', () async {
      var jsonData = odpXmlToJsonConverter.getJsonFromPptx("content.xml");
      expect(jsonData, isNotNull);
      expect(jsonData, isA<Map>()); // JSON should be a Map
    });

    test('OdpXmlToJsonConverter throws exception for missing XML file.',
        () async {
      expect(() => odpXmlToJsonConverter.getJsonFromPptx("nonexistent.xml"),
          throwsException);
    });

    test('OdpXmlToJsonConverter cleans up extracted files after dispose.',
        () async {
      odpXmlToJsonConverter.getJsonFromPptx("content.xml");
      // File should exist before cleanup
      var extractedFilePath =
          p.join(odpXmlToJsonConverter.getTempPath(), "content.xml");
      expect(File(extractedFilePath).existsSync(), isTrue);

      // File should be deleted after cleanup
      odpXmlToJsonConverter.dispose();
      expect(File(extractedFilePath).existsSync(), isFalse);
    });
  });
}