import 'dart:typed_data';
import 'package:luna_core/storage/local_storage_provider.dart';
import 'package:luna_core/utils/string_conversion.dart';

/// A utility class to handle saving CSV content as a file.
class CsvWriter {
  final LocalStorageProvider _localStorage = LocalStorageProvider();

  /// Saves the CSV to a file with the given file path.
  Future<bool> saveCsvToFile(String filePath, String csvText) async {
    Uint8List bytes = StringConversion.stringToUint8List(csvText);
    return await _localStorage.saveFile(filePath, bytes);
  }
}
