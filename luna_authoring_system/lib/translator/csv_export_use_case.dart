import 'package:luna_authoring_system/storage/csv_writer.dart';
import 'package:luna_authoring_system/translator/text_chunk_utils.dart';
import 'package:luna_authoring_system/translator/text_exporter.dart';
import 'package:luna_core/models/module.dart';


/// Use case for exporting Module text data to CSV format.
/// Handles the extraction of text chunks and writing them to a CSV file.
class CsvExportUseCase {
  final TextExporter _exporter;
  final CsvWriter _writer;

  /// Constructor: uses provided exporter/writer if given,
  /// otherwise creates default ones.
  CsvExportUseCase({TextExporter? exporter, CsvWriter? writer})
      : _exporter = exporter != null ? exporter : TextExporter(),
        _writer = writer != null ? writer : CsvWriter();

  /// Returns true if a file was written, false if there was nothing to export.
  Future<bool> exportModuleToCsv({
    required Module module,
    required String outputFilePath,
  }) async {
    
    // Extract text chunks from the Module.
    final chunks = extractTextChunks(module);
    if (chunks.isEmpty) return false;

    // Build CSV and save to Documents via CsvWriter.
    final csv = _exporter.generateCsv(chunks);
    return _writer.saveCsvToFile(outputFilePath, csv);
  }
}

