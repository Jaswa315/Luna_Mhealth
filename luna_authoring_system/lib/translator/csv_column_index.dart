enum CsvColumn {
  slideNumber,
  originalText,
  translation,
}

extension CsvColumnExtension on CsvColumn {
  String get header {
    switch (this) {
      case CsvColumn.slideNumber:
        return 'Slide';
      case CsvColumn.originalText:
        return 'Text';
      case CsvColumn.translation:
        return 'Translation';
    }
  }
}