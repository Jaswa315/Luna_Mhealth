/// Provides utility functions to extract text from a Module.
/// Converts each TextPart into a TextChunk with slide number and content.
/// Useful for transforming module text data for export or analysis.
import 'package:luna_core/models/components/text_component/text_component.dart';
import 'package:luna_core/models/module.dart';
import 'package:luna_core/models/pages/page.dart';

import 'text_chunk.dart';

/// Extract all text components from a Module and convert them into TextChunks
List<TextChunk> extractTextChunks(Module module) {
  final List<TextChunk> chunks = [];
  int slideIndex = 0;

  for (final sequence in module.setOfSequenceOfPages) {
    for (final page in sequence.sequenceOfPages) {
      chunks.addAll(_extractChunksFromPage(page, slideIndex));
      slideIndex++;
    }
  }

  return chunks;
}

/// Helper to extract TextChunks from a single page
List<TextChunk> _extractChunksFromPage(Page page, int slideIndex) {
  final List<TextChunk> chunks = [];

  for (final component in page.components) {
    if (component is TextComponent) {
      for (final textPart in component.textChildren) {
        if (textPart.text.trim().isNotEmpty) {
          chunks.add(TextChunk(
            slideNumber: slideIndex,
            text: textPart.text,
          ));
        }
      }
    }
  }

  return chunks;
}
