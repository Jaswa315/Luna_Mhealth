import 'dart:convert';

import 'package:luna_authoring_system/luna_constants.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_authoring_system/validator/i_validation_issue.dart';
import 'package:luna_authoring_system/validator/translator_validators/translated_csv_validator.dart';

class TranslationValidationService {
  Set<IValidationIssue> validateCsvText(
    String translatedCsvText,
    ValidationIssuesStore store, {
    String? sourceCsvText,
    int? expectedSourceRowCount,
  }) {
    final derivedCount = expectedSourceRowCount ??
        (sourceCsvText != null ? _countNonEmptySourceRows(sourceCsvText) : null);

    final issues = TranslatedCsvValidator(
      translatedCsvText,
      translatedHeader: CsvHeaders.translated,
      sourceHeader: CsvHeaders.source,
      expectedSourceRowCount: derivedCount,
    ).validate();

    store.clear();
    for (final i in issues) {
      store.addIssue(i);
    }
    return issues;
  }

  int _countNonEmptySourceRows(String csvText) {
    final rawLines = const LineSplitter().convert(csvText);

    final lines = <String>[];
    bool seenHeader = false;
    for (final l in rawLines) {
      if (!seenHeader) {
        if (l.trim().isEmpty) continue;
        seenHeader = true;
      }
      lines.add(l);
    }
    if (lines.isEmpty) return 0;

    final header = _split(lines.first).map((h) => _stripQuotes(h.trim())).toList();
    if (header.isNotEmpty && header.first.startsWith('\u{FEFF}')) {
      header[0] = header.first.replaceFirst('\u{FEFF}', '');
    }

    final sourceIdx = _indexOfIgnoreCase(header, CsvHeaders.source);
    if (sourceIdx == -1) return 0;

    var nonEmpty = 0;
    for (int i = 1; i < lines.length; i++) {
      final row = _split(lines[i]);
      if (_rowIsEmpty(row)) continue;

      final source = _safeGet(row, sourceIdx).trim();
      if (source.isNotEmpty) nonEmpty++;
    }
    return nonEmpty;
  }

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

  bool _rowIsEmpty(List<String> row) =>
      row.isEmpty || row.every((c) => c.trim().isEmpty);

  String _safeGet(List<String> row, int idx) =>
      (idx >= 0 && idx < row.length) ? row[idx] : '';
}
