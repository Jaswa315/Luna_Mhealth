class ParserTools {
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
