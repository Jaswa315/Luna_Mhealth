enum CsvColumn {
  slideNumber,
  text,
  translation,
}

extension CsvColumnExtension on CsvColumn {
  String get header {
    switch (this) {
      case CsvColumn.slideNumber:
        return 'Slide';
      case CsvColumn.text:
        return 'Text';
      case CsvColumn.translation:
        return 'Translation';
    }
  }
}