import 'package:test/test.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';
import 'package:luna_core/models/components/text_component/text_component.dart';
import 'package:luna_core/models/components/text_component/text_part.dart';
import 'package:luna_core/units/bounding_box.dart';
import 'package:luna_core/units/display_pixel.dart';
import 'package:luna_core/units/percent.dart';
import 'dart:ui';

import 'fake_module.dart';         // File with createFakeModule()
import 'package:luna_authoring_system/translator/text_chunk.dart'; // File with TextChunk model 
import 'package:luna_authoring_system/translator/text_chunk_utils.dart'; // File with extractTextChunks()   

void main() {
  group('TextChunk Extraction Tests', () {
    test('Extracts correct number of text chunks from fake module', () {
      final Module module = createFakeModule();
      final chunks = extractTextChunks(module);

      expect(chunks.length, 2); // we have 2 pages, each with 1 TextComponent
    });

    test('TextChunk content matches expected text', () {
      final chunks = extractTextChunks(createFakeModule());

      expect(chunks[0].slideNumber, 0);
      expect(chunks[0].originalText, 'Eat healthy during pregnancy');

      expect(chunks[1].slideNumber, 1);
      expect(chunks[1].originalText, 'Visit a clinic if you feel weak or dizzy');
    });

    test('No empty or whitespace-only chunks are included', () {
      final module = createFakeModule();
      final chunks = extractTextChunks(module);

      expect(chunks.any((c) => c.originalText.trim().isEmpty), isFalse);
    });

    test('Ignores empty or whitespace-only TextParts', () { // This test ensures empty and whitespace-only TextParts are skipped
      final emptyTextPart = TextPart(text: '');
      final whitespaceTextPart = TextPart(text: '   ');
      final validTextPart = TextPart(text: 'Valid text');

      final textComponent = TextComponent(
        textChildren: [emptyTextPart, whitespaceTextPart, validTextPart], // Only 'Valid text' should be included
        boundingBox: BoundingBox(
          topLeftCorner: const Offset(0, 0),
          width: DisplayPixel(0),
          height: Percent(0),
        ),
      );

      final page = Page(components: [textComponent]);
      final sequence = SequenceOfPages(sequenceOfPages: [page]);

      final module = Module(
        moduleId: 'testModule',
        title: 'Test Title',
        author: 'Test Author',
        authoringVersion: '1.0',
        setOfSequenceOfPages: {sequence},
        aspectRatio: 1.0,
        entryPage: page,
      );

      final chunks = extractTextChunks(module);

      expect(chunks.length, 1);
      expect(chunks[0].originalText, 'Valid text');
      expect(chunks[0].slideNumber, 0);
    });
  });
}
