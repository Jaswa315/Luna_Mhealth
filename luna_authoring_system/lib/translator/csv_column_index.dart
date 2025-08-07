enum CsvColumn {
  slideNumber,
  Text,
  translation,
}

extension CsvColumnExtension on CsvColumn {
  String get header {
    switch (this) {
      case CsvColumn.slideNumber:
        return 'Slide';
      case CsvColumn.Text:
        return 'Text';
      case CsvColumn.translation:
        return 'Translation';
    }
  }
}