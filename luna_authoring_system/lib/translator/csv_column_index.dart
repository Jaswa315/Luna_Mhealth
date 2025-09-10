import 'package:luna_authoring_system/luna_constants.dart';

enum CsvColumn {
  slideNumber,
  text, translated
}

extension CsvColumnExtension on CsvColumn {
  String get header {
    switch (this) {
      case CsvColumn.slideNumber:
        return 'Slide';
      case CsvColumn.text:
        return CsvHeaders.source; //Text
      case CsvColumn.translated:
        return CsvHeaders.translated; // Translated text
    }
  }
}