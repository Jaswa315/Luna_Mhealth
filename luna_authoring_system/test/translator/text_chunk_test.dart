import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/translator/text_chunk.dart';

void main() {
  group('TextChunk Tests', () {
    test('TextChunk constructor sets values correctly', () {
      final chunk = TextChunk(
        slideNumber: 1,
        text: 'This is a test text chunk.',
      );

      expect(chunk.slideNumber, 1);
      expect(chunk.text, 'This is a test text chunk.');
    });

    test('TextChunk tostring testing', () {
      final chunk = TextChunk(
        slideNumber: 1,
        text: 'This is a test text chunk.',
      );
      expect(chunk.toString(), 'Slide 1: "This is a test text chunk."');
    });
  });
}