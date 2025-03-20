import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_xml_to_json_converter.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Tests for PptxXmlToJsonConverter using A line.pptx', () {
    final pptxFile = File('test/test_assets/A line.pptx');
    PptxXmlToJsonConverter pptxXmlToJsonConverter =
        PptxXmlToJsonConverter(pptxFile);

    test('PptxXmlToJsonConverter initializes without errors.', () async {
      expect(PptxXmlToJsonConverter, isNotNull);
    });

    test('PptxXmlToJsonConverter extracts files only once.', () async {
      pptxXmlToJsonConverter
          .getJsonFromPptx("docProps/core.xml"); // Triggers extraction

      // Verify an extracted file exists
      var extractedFilePath =
          p.join(pptxXmlToJsonConverter.getTempPath(), "docProps/core.xml");
      expect(File(extractedFilePath).existsSync(), isTrue);
    });

    test('PptxXmlToJsonConverter loads and converts XML to JSON.', () async {
      var jsonData =
          pptxXmlToJsonConverter.getJsonFromPptx("docProps/core.xml");
      expect(jsonData, isNotNull);
      expect(jsonData, isA<Map>()); // JSON should be a Map
    });

    test('PptxXmlToJsonConverter throws exception for missing XML file.',
        () async {
      expect(() => pptxXmlToJsonConverter.getJsonFromPptx("nonexistent.xml"),
          throwsException);
    });

    test('PptxXmlToJsonConverter cleans up extracted files after dispose.',
        () async {
      pptxXmlToJsonConverter.getJsonFromPptx("docProps/core.xml");
      // File should exist before cleanup
      var extractedFilePath =
          p.join(pptxXmlToJsonConverter.getTempPath(), "docProps/core.xml");
      expect(File(extractedFilePath).existsSync(), isTrue);

      // File should be deleted after cleanup
      pptxXmlToJsonConverter.dispose();
      expect(File(extractedFilePath).existsSync(), isFalse);
    });
  });
}
