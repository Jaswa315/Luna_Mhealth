import 'dart:ui';

import 'package:test/test.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';
import 'package:luna_core/models/components/text_component/text_component.dart';
import 'package:luna_core/models/components/text_component/text_part.dart';
import 'package:luna_core/units/bounding_box.dart';
import 'package:luna_core/units/display_pixel.dart';
import 'package:luna_core/units/percent.dart';
import 'package:luna_core/utils/version_manager.dart';

import 'package:luna_authoring_system/helper/generate_module.dart';
import 'package:luna_authoring_system/translator/text_chunk.dart';
import 'package:luna_authoring_system/translator/text_chunk_utils.dart';

void main() {

  setUpAll(() {
    // Set a deterministic version for tests (no platform calls)
    VersionManager().setTestVersion('1.0.0-test');
  });

  tearDownAll(() {
    //clean up after tests
    VersionManager().resetVersion();
  });
  group('TextChunk Extraction Tests', () {
    test('Extracts correct number of text chunks from real pptx', () async {
      // Build a real Module from a test asset
      final module =
          await getModule('test/test_assets/A Textbox in Slide.pptx');

      // Extract text chunks
      final chunks = extractTextChunks(module);

      // Verify: this deck has a single textbox on the first (and only) slide
      expect(chunks.length, 1);
      expect(chunks[0].slideNumber, 0);
      expect(chunks[0].text, 'This is a textbox in slide');
    });

    test('TextChunk content matches expected text (real PPTX)', () async {
      // Build a real Module from a test asset with one textbox
      final module =
          await getModule('test/test_assets/A Textbox in Slide.pptx');

      // Extract
      final chunks = extractTextChunks(module);

      // Verify: 1 chunk, exact text match, slide index as produced by extractor (starts at 0)
      expect(chunks.length, 1);
      expect(chunks[0].slideNumber, 0);
      expect(chunks[0].text, 'This is a textbox in slide');
    });

    test('Ignores empty or whitespace-only TextParts', () {
      // Build a minimal page with one TextComponent that has empty/whitespace parts and one valid part
      final page = Page(
        components: [
          TextComponent(
            textChildren: [
              TextPart(text: ''), // empty
              TextPart(text: '   '), // whitespace
              TextPart(text: 'Valid text'),
            ],
            boundingBox: BoundingBox(
              topLeftCorner: const Offset(0, 0),
              width: DisplayPixel(0),
              height: Percent(0),
            ),
          ),
        ],
      );

      // Wrap in a SequenceOfPages and Module
      final sequence = SequenceOfPages(sequenceOfPages: [page]);
      final module = Module(
        moduleId: 'inlineModuleWithEmptyParts',
        title: 'Test Module',
        author: 'Lakshmi',
        authoringVersion: '1.0',
        setOfSequenceOfPages: {sequence},
        aspectRatio: 1.0,
        entryPage: page,
      );

      // Act
      final chunks = extractTextChunks(module);

      // Assert
      expect(chunks.length, 1);
      expect(chunks[0].text, 'Valid text');
      expect(chunks[0].slideNumber, 0); // first (and only) page → index 0
      expect(chunks.any((c) => c.text.trim().isEmpty), isFalse);
    });
  });
}
