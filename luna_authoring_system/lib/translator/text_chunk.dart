/// This model represents a chunk of text extracted from a slide in a presentation.
/// It includes the slide number and the original text content.
class TextChunk {
  final int slideNumber;
  final String originalText;

  // Constructor to create a TextChunk with required slide number and text
  TextChunk({required this.slideNumber, required this.originalText});

  /// Converts this TextChunk to a CSV row
  List<String> toCsvRow() => [slideNumber.toString(), originalText, '']; /// Adds an empty third column for "Translation text"

  /// Factory constructor to create a TextChunk from a CSV row
  /// Expects the row to have at least two elements: slide number and original text
  factory TextChunk.fromCsvRow(List<String> row) {
    return TextChunk(
      slideNumber: int.tryParse(row[0]) ?? 0,
      originalText: row[1],
    );
  }
  @override
  String toString() => 'Slide $slideNumber: "$originalText"';
}