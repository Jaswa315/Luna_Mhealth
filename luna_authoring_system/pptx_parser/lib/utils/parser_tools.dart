/// ParserTools has functions that are used in parser classes

class ParserTools {
  /// Helper function to retrive nullable value from Map<String, dynmaic>
  /// Some values are "" instead of null.
  /// We regard them as null.
  static dynamic getNullableValue(dynamic map, List<String> keys) {
    dynamic value = map;
    for (var key in keys) {
      if (value == null || value == "") {
        return null;
      }
      value = value[key];
    }

    return (value == null || value == "") ? null : value;
  }
}
