import 'dart:convert';
import 'dart:typed_data';


// Handles localization tasks by managing a map of localized strings indexed by UIDs.
// This class is responsible for parsing CSV data into a map for efficient lookup of localized strings.
class ModuleTextStrings {
  final Map<int, String> _localizedStrings = {};

  // Parses CSV formatted data to populate the localization map
  // @Param csvBytes : A byte array representing CSV data. This data should be encoded in UTF-8 format.
  // This function updates the internal map [_localizedStrings] by mapping UIDs to their corresponding localized texts
  void parseCsvToMap(Uint8List csvBytes) {
    String csvString = utf8.decode(csvBytes);
    List<String> rows = csvString.split('\n');
    for (var row in rows.skip(1)) {
      var columns = row.split(',');
      if (columns.length >= 3) {
        // Parse the UID from the first column
        int uid = int.tryParse(columns[0].trim()) ?? 0;
        // Trim and store the localized text from the third column
        String localizedText = columns[2].trim();
        _localizedStrings[uid] = localizedText;
      }
    }
  }

  // Retrieves a localized string by its UID
  // Returns the localized string associated with the provided UID, if found.
  // "Text not found" if the UID does not exist in the localization map.
  String getString(int uid) {
    return _localizedStrings[uid] ?? "Text not found";
  }
}