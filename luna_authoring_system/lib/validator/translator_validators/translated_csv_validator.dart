import 'dart:convert';

import 'package:luna_authoring_system/luna_constants.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/validator/i_validator.dart';
import 'package:luna_authoring_system/validator/issue/translator_issues/csv_row_count_mismatch.dart';
import 'package:luna_authoring_system/validator/issue/translator_issues/translated_cell_missing.dart';

class TranslatedCsvValidator implements IValidator {
  final String csvText;
  final String translatedHeader;
  final String sourceHeader;
  final int? expectedSourceRowCount;

  TranslatedCsvValidator(
    this.csvText, {
    this.translatedHeader = CsvHeaders.translated,
    this.sourceHeader = CsvHeaders.source,
    this.expectedSourceRowCount,
  });

  @override
  Set<IValidationIssue> validate() {
    final issues = <IValidationIssue>{};

    final lines = _normalizedLines(csvText);
    if (lines.isEmpty) {
      issues.add(_CsvFormatIssue('CSV is empty.'));
      return issues;
    }

    final header = _parseHeader(lines, issues);
    if (header == null) return issues;

    final indexes = _findColumnIndexes(header, issues);
    if (indexes == null) return issues;

    final nonEmptySourceCount =
        _validateRows(lines, indexes.translatedIdx, indexes.sourceIdx, issues);

    _checkRowCount(nonEmptySourceCount, issues);
    return issues;
  }

  //helpers 

  List<String> _normalizedLines(String text) {
    final rawLines = const LineSplitter().convert(text);
    final lines = <String>[];
    var seenHeader = false;

    for (final l in rawLines) {
      if (!seenHeader) {
        if (l.trim().isEmpty) continue; // skip leading empties
        seenHeader = true;
      }
      lines.add(l);
    }
    return lines;
  }

  List<String>? _parseHeader(List<String> lines, Set<IValidationIssue> issues) {
    if (lines.isEmpty) {
      issues.add(_CsvFormatIssue('CSV is empty.'));
      return null;
    }

    final header =
        _split(lines.first).map((h) => _stripQuotes(h.trim())).toList();

    // Strip BOM if present
    if (header.isNotEmpty && header.first.startsWith('\uFEFF')) {
      header[0] = header.first.replaceFirst('\uFEFF', '');
    }
    return header;
  }

  _ColumnIndexes? _findColumnIndexes(
      List<String> header, Set<IValidationIssue> issues) {
    final translatedIdx =
        _indexOfAnyIgnoreCase(header, [translatedHeader, 'Translation']);
    final sourceIdx = _indexOfIgnoreCase(header, sourceHeader);

    if (translatedIdx == -1) {
      issues.add(_CsvFormatIssue('Missing header column "$translatedHeader".'));
      return null;
    }
    if (sourceIdx == -1) {
      issues.add(_CsvFormatIssue('Missing header column "$sourceHeader".'));
      return null;
    }
    return _ColumnIndexes(translatedIdx, sourceIdx);
  }

  int _validateRows(
      List<String> lines, int translatedIdx, int sourceIdx, Set<IValidationIssue> issues) {
    var nonEmptySourceCount = 0;

    for (int i = 1; i < lines.length; i++) {
      final row = _split(lines[i]);
      if (_rowIsEmpty(row)) continue;

      final translated = _safeGet(row, translatedIdx).trim();
      final source = _safeGet(row, sourceIdx).trim();

      if (source.isNotEmpty) nonEmptySourceCount++;
      if (translated.isEmpty) {
        issues.add(TranslatedCellMissing(rowIndex: i + 1, sourceText: source));
      }
    }
    return nonEmptySourceCount;
  }

  void _checkRowCount(int nonEmptySourceCount, Set<IValidationIssue> issues) {
    if (expectedSourceRowCount != null &&
        nonEmptySourceCount < expectedSourceRowCount!) {
      issues.add(CsvRowCountMismatch(
        expected: expectedSourceRowCount!,
        actual: nonEmptySourceCount,
      ));
    }
  }

  // utilities

  List<String> _split(String line) => line.split(',');

  String _stripQuotes(String s) {
    if (s.length >= 2 &&
        ((s.startsWith('"') && s.endsWith('"')) ||
            (s.startsWith("'") && s.endsWith("'")))) {
      return s.substring(1, s.length - 1).trim();
    }
    return s;
  }

  int _indexOfIgnoreCase(List<String> cols, String name) {
    final target = _stripQuotes(name.trim()).toLowerCase();
    for (int i = 0; i < cols.length; i++) {
      if (_stripQuotes(cols[i].trim()).toLowerCase() == target) return i;
    }
    return -1;
  }

  int _indexOfAnyIgnoreCase(List<String> cols, List<String> names) {
    for (final n in names) {
      final idx = _indexOfIgnoreCase(cols, n);
      if (idx != -1) return idx;
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

class _ColumnIndexes {
  final int translatedIdx;
  final int sourceIdx;
  const _ColumnIndexes(this.translatedIdx, this.sourceIdx);
}
