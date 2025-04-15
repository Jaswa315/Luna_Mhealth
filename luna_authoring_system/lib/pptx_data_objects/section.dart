/// Section class represents a section in a PowerPoint presentation.
class Section {
  final Map<String, List<int>> _value;
  static const String defaultSectionName = "Default Section";
  static const int minIndex = 1; // 1-based index

  Section(this._value) {
    for (var entry in _value.entries) {
      for (int index in entry.value) {
        if (index < minIndex) {
          throw ArgumentError("Section index must be greater than or equal to $minIndex, Found: $index");
        }
      }
    }
  }

  Map<String, List<int>> get value => _value;
}
