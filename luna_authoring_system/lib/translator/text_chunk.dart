/// This model represents a chunk of text extracted from a slide in a presentation.
/// It includes the slide number and the original text content.
class TextChunk {
  final int slideNumber;
  final String originalText;

  TextChunk({required this.slideNumber, required this.originalText});

  @override
  String toString() => 'Slide $slideNumber: "$originalText"';
}