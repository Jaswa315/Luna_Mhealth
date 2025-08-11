import 'package:csv/csv.dart';
import 'csv_column_index.dart';
import 'text_chunk.dart';

/// A utility class that converts a list of TextChunk objects into a CSV-formatted string.
class TextExporter {
  /// Converts TextChunks to CSV-formatted string with headers
  String generateCsv(List<TextChunk> chunks) {
    final List<List<String>> rows = [];

    // Add header row
    final List<String> headers = [];
    for (var col in CsvColumn.values) {
      headers.add(col.header);
    }
    rows.add(headers);

    // Add data rows
    for (var chunk in chunks) {
      rows.add(chunk.toCsvRow()); // Convert each TextChunk to a CSV row
    }

    // Return the final CSV string
    return const ListToCsvConverter().convert(rows);
  }
}
