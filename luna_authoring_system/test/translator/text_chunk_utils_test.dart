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
      expect(chunks[0].Text, 'Eat healthy during pregnancy');

      expect(chunks[1].slideNumber, 1);
      expect(chunks[1].Text, 'Visit a clinic if you feel weak or dizzy');
    });

    test('No empty or whitespace-only chunks are included', () {
      final module = createFakeModule();
      final chunks = extractTextChunks(module);

      expect(chunks.any((c) => c.Text.trim().isEmpty), isFalse);
    });

    test('Ignores empty or whitespace-only TextParts', () { // This test ensures empty and whitespace-only TextParts are skipped
      final module = createFakeModuleWithEmptyTextParts();
      final chunks = extractTextChunks(module);

      expect(chunks.length, 1);
      expect(chunks[0].Text, 'Valid text');
      expect(chunks[0].slideNumber, 0);
    });
  });
}
