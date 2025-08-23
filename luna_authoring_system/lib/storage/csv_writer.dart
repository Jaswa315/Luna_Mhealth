import 'dart:io';
import 'dart:typed_data';
import 'package:luna_core/storage/local_storage_provider.dart';
import 'package:luna_core/utils/string_conversion.dart';

/// Handles saving CSV content as a file.
class CsvWriter {
  final LocalStorageProvider _localStorage;

  CsvWriter({LocalStorageProvider? storage})
      : _localStorage = storage ?? LocalStorageProvider();

  /// Saves the CSV to filePath.
  /// Uses dart:io for absolute paths, otherwise delegates to LocalStorageProvider.
  Future<bool> saveCsvToFile(String filePath, String csvText) async {
    try {
      final Uint8List bytes = StringConversion.stringToUint8List(csvText);

      final bool isAbsolutePath =
          filePath.startsWith('/') ||
          RegExp(r'^[A-Za-z]:\\').hasMatch(filePath);

      if (isAbsolutePath) {
        final file = File(filePath);
        await file.parent.create(recursive: true);
        await file.writeAsBytes(bytes, flush: true);
        return true;
      } else {
        return await _localStorage.saveFile(filePath, bytes);
      }
    } catch (_) {
      return false;
    }
  }
}
