class TextChunk {
  final int slideNumber;
  final String originalText;

  TextChunk({required this.slideNumber, required this.originalText});

  @override
  String toString() => 'Slide $slideNumber: "$originalText"';
}