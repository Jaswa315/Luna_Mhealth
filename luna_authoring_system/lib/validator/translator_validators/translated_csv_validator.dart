import 'dart:convert';

import 'package:luna_authoring_system/luna_constants.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/validator/i_validator.dart';
import 'package:luna_authoring_system/validator/issue/translator_issues/translated_cell_missing.dart';

/// Validates an uploaded translation CSV:
/// Requires headers: sourceHeader (default: "text") and translatedHeader (default: "Translated text")
class TranslatedCsvValidator implements IValidator {
  final String csvText;
  final String translatedHeader; // e.g. "Translated text"
  final String sourceHeader;     // e.g. "text"

  TranslatedCsvValidator(
    this.csvText, {
    this.translatedHeader = 'Translated text',
    this.sourceHeader = 'text',
  });

  @override
  Set<IValidationIssue> validate() {
    final issues = <IValidationIssue>{};

    // Split into raw lines
    final rawLines = const LineSplitter().convert(csvText);

    // Skip leading empty/whitespace-only lines so the first non-empty line is the header.
    final lines = <String>[];
    bool seenHeader = false;
    for (final l in rawLines) {
      if (!seenHeader) {
        if (l.trim().isEmpty) continue;
        seenHeader = true;
      }
      lines.add(l);
    }

    if (lines.isEmpty) {
      issues.add(_CsvFormatIssue('CSV is empty.'));
      return issues;
    }

    // Parse header
    final header = _split(lines.first).map((h) => h.trim()).toList();

    // Strip BOM if present on first header cell (common with Excel CSVs)
    if (header.isNotEmpty && header.first.startsWith('\uFEFF')) {
      header[0] = header.first.replaceFirst('\uFEFF', '');
    }

    final translatedIdx = _indexOfIgnoreCase(header, translatedHeader);
    final sourceIdx = _indexOfIgnoreCase(header, sourceHeader);

    if (translatedIdx == -1) {
      issues.add(_CsvFormatIssue('Missing header column "$translatedHeader".'));
      return issues;
    }
    if (sourceIdx == -1) {
      issues.add(_CsvFormatIssue('Missing header column "$sourceHeader".'));
      return issues;
    }

    // Data rows (note: i is 1-based from 'lines' so rowIndex = i + 1 includes header)
    for (int i = 1; i < lines.length; i++) {
      final row = _split(lines[i]);
      if (_rowIsEmpty(row)) continue;

      final translated = _safeGet(row, translatedIdx).trim();
      final source = _safeGet(row, sourceIdx).trim();

      if (translated.isEmpty) {
        issues.add(TranslatedCellMissing(rowIndex: i + 1, sourceText: source));
      }
    }

    return issues;
  }

  // --- helpers (simple CSV splitting; fine if no quoted commas) ---
  List<String> _split(String line) => line.split(',');

  int _indexOfIgnoreCase(List<String> cols, String name) {
    final target = name.toLowerCase();
    for (int i = 0; i < cols.length; i++) {
      if (cols[i].toLowerCase() == target) return i;
    }
    return -1;
  }

  bool _rowIsEmpty(List<String> row) =>
      row.isEmpty || row.every((c) => c.trim().isEmpty);

  String _safeGet(List<String> row, int idx) =>
      (idx >= 0 && idx < row.length) ? row[idx] : '';
}

class _CsvFormatIssue extends IValidationIssue {
  final String _msg;
  _CsvFormatIssue(this._msg);

  @override
  String toText() => _msg;

  @override
  ValidationSeverity get severity => ValidationSeverity.warning;
}
