import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_loader.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Tests for PptxLoader using A line.pptx', () {
    final pptxFile = File('test/test_assets/A line.pptx');
    PptxLoader pptxLoader = PptxLoader(pptxFile);

    test('PptxLoader initializes without errors.', () async {
      expect(pptxLoader, isNotNull);
    });

    test('PptxLoader extracts files only once.', () async {
      pptxLoader.getJsonFromPptx("docProps/core.xml"); // Triggers extraction

      // Verify an extracted file exists
      var extractedFilePath =
          p.join(pptxLoader.getTempPath(), "docProps/core.xml");
      expect(File(extractedFilePath).existsSync(), isTrue);
    });

    test('PptxLoader loads and converts XML to JSON.', () async {
      var jsonData = pptxLoader.getJsonFromPptx("docProps/core.xml");
      expect(jsonData, isNotNull);
      expect(jsonData, isA<Map>()); // JSON should be a Map
    });

    test('PptxLoader throws exception for missing XML file.', () async {
      expect(
          () => pptxLoader.getJsonFromPptx("nonexistent.xml"), throwsException);
    });

    test('PptxLoader cleans up extracted files after dispose.', () async {
      pptxLoader.getJsonFromPptx("docProps/core.xml");
      // File should exist before cleanup
      var extractedFilePath =
          p.join(pptxLoader.getTempPath(), "docProps/core.xml");
      expect(File(extractedFilePath).existsSync(), isTrue);

      // File should be deleted after cleanup
      pptxLoader.dispose();
      expect(File(extractedFilePath).existsSync(), isFalse);
    });
  });
}
